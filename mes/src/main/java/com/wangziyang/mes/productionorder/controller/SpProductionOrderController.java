package com.wangziyang.mes.productionorder.controller;

import com.alibaba.excel.EasyExcel;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderOperPlan;
import com.wangziyang.mes.productionorder.request.SpProductionOrderErpSyncReq;
import com.wangziyang.mes.productionorder.request.SpProductionOrderForecastReq;
import com.wangziyang.mes.productionorder.request.SpProductionOrderImportDTO;
import com.wangziyang.mes.productionorder.request.SpProductionOrderReq;
import com.wangziyang.mes.productionorder.request.SpProductionOrderSaveReq;
import com.wangziyang.mes.productionorder.service.ISpMaterialRequirementPlanService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderService;
import com.wangziyang.mes.productionorder.service.impl.SpProductionOrderServiceImpl;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.wip.entity.SpSnProcessRecord;
import com.wangziyang.mes.wip.service.ISpSnProcessRecordService;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Production order entry controller.
 */
@Controller
@RequestMapping("/production-order/plan")
public class SpProductionOrderController extends BaseController {

    @Autowired
    private ISpProductionOrderService productionOrderService;

    @Autowired
    private ISpMaterialRequirementPlanService materialPlanService;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private ISpOrderService workOrderService;

    @Autowired
    private ISpSnProcessRecordService snProcessRecordService;

    @ApiOperation("生产订单录入页面")
    @GetMapping("/list-ui")
    public String listUI() {
        return "productionorder/plan/list";
    }

    @ApiOperation("生产订单新增/编辑页面")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model,
                                @RequestParam(required = false) String id,
                                @RequestParam(required = false) String sourceType) {
        SpProductionOrder order;
        List<SpProductionOrderItem> items;
        if (StringUtils.isNotBlank(id)) {
            order = productionOrderService.getById(id);
            items = productionOrderService.listItems(id);
        } else {
            order = new SpProductionOrder();
            order.setSourceType(StringUtils.defaultIfBlank(sourceType, SpProductionOrderServiceImpl.SOURCE_DEMAND));
            order.setOrderNo(productionOrderService.nextOrderNo(order.getSourceType()));
            order.setBusinessType("普通销售");
            order.setOrderDate(LocalDate.now().toString());
            order.setSettlementCurrency("人民币");
            order.setTaxRate("不含税");
            order.setStatus(SpProductionOrderServiceImpl.STATUS_DRAFT);
            order.setApprovalStatus(SpProductionOrderServiceImpl.APPROVAL_DRAFT);
            order.setOperationStatus(SpProductionOrderServiceImpl.OP_NONE);
            order.setCreationMethod(SpProductionOrderServiceImpl.METHOD_MANUAL);
            order.setSchedulingMethod(SpProductionOrderServiceImpl.SOURCE_FORECAST.equals(order.getSourceType())
                    ? SpProductionOrderServiceImpl.SCHEDULE_FORWARD
                    : SpProductionOrderServiceImpl.SCHEDULE_REVERSE);
            items = new ArrayList<>();
        }
        model.addAttribute("result", order);
        model.addAttribute("itemsJson", toJson(items));
        return "productionorder/plan/addOrUpdate";
    }

    @ApiOperation("预测订单生成页面")
    @GetMapping("/forecast-ui")
    public String forecastUI() {
        return "productionorder/plan/forecast";
    }

    @ApiOperation("生产订单分页")
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpProductionOrderReq req) {
        IPage<SpProductionOrder> page = productionOrderService.pageWithSummary(req);
        materialPlanService.enrichProductionOrders(page.getRecords());
        return Result.success(page);
    }

    @ApiOperation("生产订单明细")
    @PostMapping("/items")
    @ResponseBody
    public Result items(@RequestParam String id) {
        return Result.success(productionOrderService.listItems(id));
    }

    @ApiOperation("保存生产订单草稿")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(@RequestBody SpProductionOrderSaveReq req) {
        return productionOrderService.saveOrder(req);
    }

    @ApiOperation("保存并提交生产主管审批")
    @PostMapping("/submit")
    @ResponseBody
    public Result submit(@RequestBody SpProductionOrderSaveReq req) {
        return productionOrderService.submitOrder(req, currentUser());
    }

    @ApiOperation("生产订单删除")
    @PostMapping("/delete")
    @ResponseBody
    public Result delete(@RequestParam String id) {
        return productionOrderService.deleteOrder(id);
    }

    @ApiOperation("生产订单确认")
    @PostMapping("/confirm")
    @ResponseBody
    public Result confirm(@RequestParam String id) {
        return productionOrderService.confirm(id);
    }

    @ApiOperation("预测订单生成")
    @PostMapping("/forecast/generate")
    @ResponseBody
    public Result forecastGenerate(@RequestBody SpProductionOrderForecastReq req) {
        return Result.success(productionOrderService.generateForecastItems(req));
    }

    @ApiOperation("提交生产主管审批并生成生产工单")
    @PostMapping("/create-work-order")
    @ResponseBody
    public Result createWorkOrder(@RequestParam String id) {
        return productionOrderService.createWorkOrder(id, currentUser());
    }

    @ApiOperation("Excel导入生产订单")
    @PostMapping("/import")
    @ResponseBody
    public Result importOrders(@RequestParam("file") MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return Result.failure("请选择要导入的 Excel 文件");
        }
        List<SpProductionOrderImportDTO> rows = EasyExcel.read(file.getInputStream())
                .head(SpProductionOrderImportDTO.class)
                .sheet()
                .doReadSync();
        return productionOrderService.importOrders(rows, currentUser());
    }

    @ApiOperation("下载生产订单导入模板")
    @GetMapping("/import-template")
    public void importTemplate(HttpServletResponse response) throws IOException {
        String fileName = URLEncoder.encode("生产订单导入模板", "UTF-8").replaceAll("\\+", "%20");
        response.setCharacterEncoding("utf-8");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");
        EasyExcel.write(response.getOutputStream(), SpProductionOrderImportDTO.class)
                .sheet("生产订单")
                .doWrite(templateRows());
    }

    @ApiOperation("下载生产订单导入模板")
    @GetMapping({"/download-template", "/template"})
    public void downloadTemplate(HttpServletResponse response) throws IOException {
        importTemplate(response);
    }

    @ApiOperation("ERP标准订单同步")
    @PostMapping("/erp/sync")
    @ResponseBody
    public Result erpSync(@RequestBody SpProductionOrderErpSyncReq req) {
        return productionOrderService.syncFromErp(req, currentUser());
    }

    @ApiOperation("生产计划下发")
    @PostMapping("/dispatch")
    @ResponseBody
    public Result dispatch(@RequestParam String id) {
        return productionOrderService.dispatch(id);
    }

    @ApiOperation("查看工序排产结果")
    @PostMapping("/operation-plan")
    @ResponseBody
    public Result operationPlan(@RequestParam(required = false) String orderId,
                                @RequestParam(required = false) String itemId) {
        return Result.success(productionOrderService.listOperationPlans(orderId, itemId));
    }

    @ApiOperation("生产计划中心指标")
    @PostMapping("/dashboard")
    @ResponseBody
    public Result dashboard() {
        return Result.success(productionOrderService.dashboard());
    }

    @ApiOperation("计划下发后的批序与条码跟踪详情")
    @PostMapping("/dispatch-detail")
    @ResponseBody
    public Result dispatchDetail(@RequestParam String id) {
        SpProductionOrder order = productionOrderService.getById(id);
        if (order == null || "1".equals(order.getDeleted())) {
            return Result.failure("生产订单不存在");
        }
        Map<String, Object> data = new HashMap<>();
        List<Map<String, Object>> itemRows = new ArrayList<>();
        List<Map<String, Object>> taskRows = new ArrayList<>();
        List<SpProductionOrderItem> items = productionOrderService.listItems(id);
        int totalTasks = 0;
        int scannedCount = 0;
        for (int i = 0; i < items.size(); i++) {
            SpProductionOrderItem item = items.get(i);
            SpOrder workOrder = StringUtils.isBlank(item.getWorkOrderId()) ? null : workOrderService.getById(item.getWorkOrderId());
            List<SpProductionOrderOperPlan> plans = productionOrderService.listOperationPlans(id, item.getId());
            int okSteps = countOkSteps(item.getWorkOrderId());
            scannedCount += okSteps;

            Map<String, Object> itemRow = new HashMap<>();
            itemRow.put("item", item);
            itemRow.put("itemSeq", i + 1);
            itemRow.put("workOrder", workOrder);
            itemRow.put("workOrderStatusName", workOrderStatusName(workOrder));
            itemRow.put("taskCount", plans.size());
            itemRow.put("okStepCount", okSteps);
            itemRow.put("progress", plans.isEmpty() ? 0 : Math.min(100, okSteps * 100 / plans.size()));
            itemRows.add(itemRow);

            for (SpProductionOrderOperPlan plan : plans) {
                totalTasks++;
                Map<String, Object> taskRow = new HashMap<>();
                String serialNo = serialNo(order.getOrderNo(), i + 1, plan.getSortNum());
                taskRow.put("orderNo", order.getOrderNo());
                taskRow.put("productSerialNo", productSerialNo(order.getOrderNo(), i + 1));
                taskRow.put("taskSerialNo", serialNo);
                taskRow.put("barcode", "BC-" + serialNo);
                taskRow.put("qrPayload", "MES|" + order.getOrderNo() + "|" + item.getProductMateriel() + "|" + serialNo);
                taskRow.put("productMateriel", item.getProductMateriel());
                taskRow.put("productName", item.getProductName());
                taskRow.put("qty", item.getQty());
                taskRow.put("workOrderCode", item.getWorkOrderCode());
                taskRow.put("oper", plan.getOper());
                taskRow.put("operDesc", plan.getOperDesc());
                taskRow.put("sortNum", plan.getSortNum());
                taskRow.put("planStartTime", plan.getPlanStartTime());
                taskRow.put("planEndTime", plan.getPlanEndTime());
                taskRow.put("durationHours", plan.getDurationHours());
                taskRows.add(taskRow);
            }
        }
        data.put("order", order);
        data.put("items", itemRows);
        data.put("tasks", taskRows);
        data.put("totalTasks", totalTasks);
        data.put("scannedCount", scannedCount);
        data.put("dispatchReady", SpProductionOrderServiceImpl.OP_DISPATCHED.equals(order.getOperationStatus()));
        return Result.success(data);
    }

    private SysUser currentUser() {
        try {
            return getSysUser();
        } catch (Exception ignore) {
            return null;
        }
    }

    private String toJson(Object value) {
        try {
            return objectMapper.writeValueAsString(value);
        } catch (JsonProcessingException e) {
            return "[]";
        }
    }

    private List<SpProductionOrderImportDTO> templateRows() {
        List<SpProductionOrderImportDTO> rows = new ArrayList<>();
        SpProductionOrderImportDTO row = new SpProductionOrderImportDTO();
        row.setSourceType("需求订单");
        row.setExternalNo("SO-DEMO-001");
        row.setCustomerName("示例客户");
        row.setSalesContractNo("HT-DEMO-001");
        row.setBomCode("请填写最新定版BOM编码");
        row.setProductMateriel("或填写产品物料编码");
        row.setQty(10);
        row.setSchedulingMethod("逆向排产");
        row.setPlanDeliveryDate(LocalDate.now().plusDays(5).toString());
        row.setLeadTimeDays(1);
        row.setTargetCapacity(new BigDecimal("5"));
        row.setConfiguration("标准配置");
        row.setRemark("示例行，可删除");
        rows.add(row);
        return rows;
    }

    private int countOkSteps(String workOrderId) {
        if (StringUtils.isBlank(workOrderId)) {
            return 0;
        }
        return snProcessRecordService.count(new QueryWrapper<SpSnProcessRecord>()
                .eq("order_id", workOrderId)
                .eq("status", "OK"));
    }

    private String workOrderStatusName(SpOrder workOrder) {
        if (workOrder == null || workOrder.getStatue() == null) {
            return "未生成";
        }
        switch (workOrder.getStatue()) {
            case 1: return "待审批";
            case 2: return "已审批";
            case 3: return "已完成";
            case 4: return "已终止";
            case 5: return "已下发";
            default: return "未知";
        }
    }

    private String productSerialNo(String orderNo, int itemSeq) {
        return StringUtils.defaultString(orderNo, "PO") + "-SN" + String.format("%03d", itemSeq);
    }

    private String serialNo(String orderNo, int itemSeq, Integer sortNum) {
        int step = sortNum == null ? 1 : sortNum;
        return productSerialNo(orderNo, itemSeq) + "-" + String.format("%02d", step);
    }
}
