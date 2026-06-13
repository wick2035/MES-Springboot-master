package com.wangziyang.mes.productionorder.controller;

import com.alibaba.excel.EasyExcel;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.wangziyang.mes.basedata.entity.SpEquipment;
import com.wangziyang.mes.basedata.entity.SpProcessingUnit;
import com.wangziyang.mes.basedata.service.ISpEquipmentService;
import com.wangziyang.mes.basedata.service.ISpProcessingUnitService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.entity.SpOrderOperAssign;
import com.wangziyang.mes.order.service.ISpOrderOperAssignService;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.productionorder.entity.SpOrderOperEquipmentAssign;
import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderOperPlan;
import com.wangziyang.mes.productionorder.entity.SpWorkOrderChange;
import com.wangziyang.mes.productionorder.request.SpProductionDispatchReq;
import com.wangziyang.mes.productionorder.request.SpProductionOrderImportDTO;
import com.wangziyang.mes.productionorder.request.SpProductionOrderReq;
import com.wangziyang.mes.productionorder.request.WorkOrderChangeReq;
import com.wangziyang.mes.productionorder.service.ISpOrderOperEquipmentAssignService;
import com.wangziyang.mes.productionorder.service.ISpMaterialRequirementPlanService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderItemService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderOperPlanService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderService;
import com.wangziyang.mes.productionorder.service.ISpWorkOrderChangeService;
import com.wangziyang.mes.productionorder.service.impl.SpProductionOrderServiceImpl;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.technology.entity.SpFlow;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.service.ISpFlowService;
import com.wangziyang.mes.technology.service.ISpOperService;
import com.wangziyang.mes.workflow.entity.SpWorkflowInstance;
import com.wangziyang.mes.workflow.entity.SpWorkflowTask;
import com.wangziyang.mes.workflow.service.ISpWorkflowInstanceService;
import com.wangziyang.mes.workflow.service.ISpWorkflowTaskService;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Production plan center pages and assignment APIs.
 */
@Controller
@RequestMapping("/production-order")
public class SpProductionPlanCenterController extends BaseController {

    private static final String EQUIPMENT_WAIT = "WAIT";
    private static final String EQUIPMENT_ASSIGNED = "ASSIGNED";
    private static final String EMPLOYEE_WAIT = "0";
    private static final String WORK_STATUS_STARTED = "STARTED";
    private static final int WORK_ORDER_APPROVED = 2;
    private static final int WORK_ORDER_DISPATCHED = 5;

    @Autowired
    private ISpProductionOrderService productionOrderService;

    @Autowired
    private ISpMaterialRequirementPlanService materialPlanService;

    @Autowired
    private ISpProductionOrderItemService itemService;

    @Autowired
    private ISpProductionOrderOperPlanService operPlanService;

    @Autowired
    private ISpOrderService workOrderService;

    @Autowired
    private ISpEquipmentService equipmentService;

    @Autowired
    private ISpProcessingUnitService unitService;

    @Autowired
    private ISpOrderOperEquipmentAssignService equipmentAssignService;

    @Autowired
    private ISpOrderOperAssignService employeeAssignService;

    @Autowired
    private ISpWorkflowTaskService workflowTaskService;

    @Autowired
    private ISpWorkflowInstanceService workflowInstanceService;

    @Autowired
    private ISpFlowService flowService;

    @Autowired
    private ISpOperService operService;

    @Autowired
    private ISpWorkOrderChangeService workOrderChangeService;

    @ApiOperation("生产计划下发页面")
    @GetMapping("/dispatch/list-ui")
    public String dispatchListUI() {
        return "productionorder/dispatch/list";
    }

    @ApiOperation("生产工单查询页面")
    @GetMapping("/work-order/list-ui")
    public String workOrderListUI() {
        return "productionorder/workorder/list";
    }

    @ApiOperation("已下达工单修改页面")
    @GetMapping("/work-order/edit-ui")
    public String workOrderEditUI(org.springframework.ui.Model model, @RequestParam String id) {
        WorkOrderTarget target = resolveWorkOrderTarget(id);
        if (target.error != null) {
            model.addAttribute("errorMsg", target.error);
        } else {
            boolean started = isWorkOrderStarted(target.workOrder);
            model.addAttribute("workOrder", target.workOrder);
            model.addAttribute("productionOrder", target.productionOrder);
            model.addAttribute("orderItem", target.item);
            model.addAttribute("started", started);
            model.addAttribute("directEditable", !started);
        }
        model.addAttribute("flows", flowService.list(new QueryWrapper<SpFlow>().orderByAsc("flow")));
        return "productionorder/workorder/edit";
    }

    @ApiOperation("设备作业派工页面")
    @GetMapping("/equipment-dispatch/list-ui")
    public String equipmentDispatchListUI() {
        return "productionorder/equipment-dispatch/list";
    }

    @ApiOperation("员工作业派工页面")
    @GetMapping("/employee-dispatch/list-ui")
    public String employeeDispatchListUI() {
        return "productionorder/employee-dispatch/list";
    }

    @ApiOperation("待下发生产计划分页")
    @PostMapping("/dispatch/page")
    @ResponseBody
    public Result dispatchPage(SpProductionDispatchReq req) {
        if (req == null) {
            req = new SpProductionDispatchReq();
        }
        syncReadyProductionOrdersForDispatch();
        return Result.success(paginate(buildDispatchRows(req), req));
    }

    @ApiOperation("生产工单查询分页")
    @PostMapping("/work-order/page")
    @ResponseBody
    public Result workOrderPage(SpProductionDispatchReq req) {
        return Result.success(paginate(buildWorkOrderRows(req), req));
    }

    @ApiOperation("修改已下达工单")
    @PostMapping("/work-order/update")
    @ResponseBody
    @Transactional(rollbackFor = Exception.class)
    public Result updateDispatchedWorkOrder(@RequestBody WorkOrderChangeReq req) {
        Result validate = validateWorkOrderChangeReq(req);
        if (validate != null) {
            return validate;
        }
        WorkOrderTarget target = resolveWorkOrderTarget(req.getId());
        if (target.error != null) {
            return Result.failure(target.error);
        }
        if (isWorkOrderStarted(target.workOrder)) {
            if (workOrderChangeService.hasApprovingChange(target.workOrder.getId())) {
                return Result.failure("该工单已有变更审批处理中");
            }
            SpWorkOrderChange change = workOrderChangeService.buildApprovingChange(
                    target.workOrder, target.productionOrder, target.item, req);
            workOrderChangeService.save(change);
            SpWorkflowInstance instance = workflowInstanceService.startWorkOrderChangeApproval(change, currentUser());
            change.setWorkflowInstanceId(instance.getId());
            workOrderChangeService.updateById(change);
            return Result.success(change.getId(), "已提交审批");
        }
        return workOrderChangeService.updateUnstarted(target.workOrder, target.item, req);
    }

    @ApiOperation("设备作业派工分页")
    @PostMapping("/equipment-dispatch/page")
    @ResponseBody
    public Result equipmentDispatchPage(SpProductionDispatchReq req) {
        return Result.success(paginate(buildTaskRows(req, true), req));
    }

    @ApiOperation("员工作业派工分页")
    @PostMapping("/employee-dispatch/page")
    @ResponseBody
    public Result employeeDispatchPage(SpProductionDispatchReq req) {
        return Result.success(paginate(buildTaskRows(req, false), req));
    }

    @ApiOperation("保存设备作业派工")
    @PostMapping("/equipment-dispatch/save")
    @ResponseBody
    @Transactional(rollbackFor = Exception.class)
    public Result saveEquipmentDispatch(@RequestParam String operPlanId,
                                        @RequestParam String equipmentId,
                                        @RequestParam(required = false) String remark) {
        SpProductionOrderOperPlan plan = operPlanService.getById(operPlanId);
        if (plan == null || "1".equals(plan.getDeleted())) {
            return Result.failure("工序任务不存在");
        }
        SpProductionOrder order = productionOrderService.getById(plan.getOrderId());
        if (!canAssign(order)) {
            return Result.failure("只有工单已审批且尚未下发的生产订单可以进行设备派工");
        }
        SpEquipment equipment = equipmentService.getById(equipmentId);
        if (equipment == null || "1".equals(equipment.getDeleted())) {
            return Result.failure("设备不存在或已删除");
        }
        SpProductionOrderItem item = itemService.getById(plan.getOrderItemId());
        SpOrder workOrder = item == null || StringUtils.isBlank(item.getWorkOrderId())
                ? null : workOrderService.getById(item.getWorkOrderId());

        SpOrderOperEquipmentAssign assign = equipmentAssignService.getOne(
                new QueryWrapper<SpOrderOperEquipmentAssign>()
                        .eq("oper_plan_id", operPlanId)
                        .eq("is_deleted", "0")
                        .last("limit 1"), false);
        if (assign == null) {
            assign = new SpOrderOperEquipmentAssign();
            assign.setOperPlanId(operPlanId);
            assign.setDeleted("0");
        }
        assign.setProductionOrderId(plan.getOrderId());
        assign.setOrderItemId(plan.getOrderItemId());
        assign.setOrderId(workOrder == null ? null : workOrder.getId());
        assign.setOrderCode(workOrder == null ? null : workOrder.getOrderCode());
        assign.setOperId(plan.getOperId());
        assign.setOper(plan.getOper());
        assign.setOperDesc(plan.getOperDesc());
        assign.setSortNum(plan.getSortNum());
        assign.setUnitId(resolvePlanUnitId(plan));
        assign.setEquipmentId(equipment.getId());
        assign.setEquipmentCode(equipment.getEquipmentCode());
        assign.setEquipmentName(equipment.getEquipmentName());
        assign.setStatus(EQUIPMENT_ASSIGNED);
        assign.setRemark(StringUtils.trimToEmpty(remark));
        equipmentAssignService.saveOrUpdate(assign);
        refreshAssignmentStatus(plan.getOrderId());
        return Result.success(assign.getId(), "设备派工已保存");
    }

    @ApiOperation("保存员工作业派工")
    @PostMapping("/employee-dispatch/save")
    @ResponseBody
    @Transactional(rollbackFor = Exception.class)
    public Result saveEmployeeDispatch(@RequestParam String operPlanId,
                                       @RequestParam String userId,
                                       @RequestParam(required = false) String userName,
                                       @RequestParam(required = false) String teamId,
                                       @RequestParam(required = false) String teamName,
                                       @RequestParam(required = false) String remark) {
        SpProductionOrderOperPlan plan = operPlanService.getById(operPlanId);
        if (plan == null || "1".equals(plan.getDeleted())) {
            return Result.failure("工序任务不存在");
        }
        SpProductionOrder order = productionOrderService.getById(plan.getOrderId());
        if (!canAssign(order)) {
            return Result.failure("只有工单已审批且尚未下发的生产订单可以进行员工派工");
        }
        SpProductionOrderItem item = itemService.getById(plan.getOrderItemId());
        if (item == null || StringUtils.isBlank(item.getWorkOrderId())) {
            return Result.failure("该任务尚未生成生产工单");
        }
        SpOrder workOrder = workOrderService.getById(item.getWorkOrderId());
        if (workOrder == null) {
            return Result.failure("生产工单不存在");
        }
        SpOrderOperEquipmentAssign equipmentAssign = equipmentAssignService.getOne(
                new QueryWrapper<SpOrderOperEquipmentAssign>()
                        .eq("oper_plan_id", operPlanId)
                        .eq("is_deleted", "0")
                        .last("limit 1"), false);
        if (equipmentAssign == null || StringUtils.isBlank(equipmentAssign.getEquipmentId())) {
            return Result.failure("请先完成该工序的设备作业派工");
        }

        String[] userIds = StringUtils.splitPreserveAllTokens(userId, ',');
        String[] userNames = StringUtils.splitPreserveAllTokens(StringUtils.defaultString(userName), ',');
        String[] teamIds = StringUtils.splitPreserveAllTokens(StringUtils.defaultString(teamId), ',');
        String[] teamNames = StringUtils.splitPreserveAllTokens(StringUtils.defaultString(teamName), ',');
        if (userIds == null || userIds.length == 0) {
            return Result.failure("请选择员工");
        }

        employeeAssignService.remove(new QueryWrapper<SpOrderOperAssign>()
                .eq("order_id", workOrder.getId())
                .eq("oper_id", plan.getOperId())
                .eq("is_deleted", "0"));

        List<SpOrderOperAssign> assigns = new ArrayList<>();
        List<String> seenUserIds = new ArrayList<>();
        for (int i = 0; i < userIds.length; i++) {
            String uid = StringUtils.trimToEmpty(userIds[i]);
            if (StringUtils.isBlank(uid) || seenUserIds.contains(uid)) {
                continue;
            }
            seenUserIds.add(uid);
            SpOrderOperAssign assign = new SpOrderOperAssign();
            assign.setOrderId(workOrder.getId());
            assign.setOrderCode(workOrder.getOrderCode());
            assign.setFlowId(plan.getFlowId());
            assign.setOperId(plan.getOperId());
            assign.setOper(plan.getOper());
            assign.setOperDesc(plan.getOperDesc());
            assign.setSortNum(plan.getSortNum());
            assign.setUnitId(resolvePlanUnitId(plan));
            assign.setDeleted("0");
            assign.setStatus(EMPLOYEE_WAIT);
            assign.setTeamId(valueAt(teamIds, i));
            assign.setTeamName(valueAt(teamNames, i));
            assign.setUserId(uid);
            assign.setUserName(StringUtils.defaultIfBlank(valueAt(userNames, i), uid));
            assign.setRemark(StringUtils.trimToEmpty(remark));
            assigns.add(assign);
        }
        if (assigns.isEmpty()) {
            return Result.failure("请选择员工");
        }
        employeeAssignService.saveBatch(assigns);
        refreshAssignmentStatus(plan.getOrderId());
        return Result.success(assigns.get(0).getId(), "员工作业派工已保存，共 " + assigns.size() + " 人");
    }

    @ApiOperation("加工单元候选员工")
    @PostMapping("/employee-dispatch/candidates")
    @ResponseBody
    public Result employeeCandidates(@RequestParam String unitId) {
        return Result.success(employeeAssignService.pickCandidatesByUnit(unitId));
    }

    @ApiOperation("生产订单导出")
    @GetMapping("/plan/export")
    public void exportPlan(HttpServletResponse response, SpProductionOrderReq req) throws IOException {
        List<SpProductionOrderImportDTO> rows = new ArrayList<>();
        IPage<SpProductionOrder> page = productionOrderService.pageWithSummary(req == null ? new SpProductionOrderReq() : req);
        for (SpProductionOrder order : page.getRecords()) {
            for (SpProductionOrderItem item : productionOrderService.listItems(order.getId())) {
                SpProductionOrderImportDTO row = new SpProductionOrderImportDTO();
                row.setSourceType(sourceName(order.getSourceType()));
                row.setExternalNo(order.getExternalNo());
                row.setCustomerName(order.getCustomerName());
                row.setSalesContractNo(order.getSalesContractNo());
                row.setBomCode(item.getBomCode());
                row.setProductMateriel(item.getProductMateriel());
                row.setQty(item.getQty());
                row.setSchedulingMethod(scheduleName(order.getSchedulingMethod()));
                row.setPlanDeliveryDate(item.getPlanDeliveryDate());
                row.setPlanStartDate(item.getPlanStartDate());
                row.setLeadTimeDays(item.getLeadTimeDays());
                row.setTargetCapacity(item.getTargetCapacity());
                row.setConfiguration(item.getConfiguration());
                row.setRemark(order.getRemark());
                rows.add(row);
            }
        }
        String fileName = URLEncoder.encode("生产订单录入导出", "UTF-8").replaceAll("\\+", "%20");
        response.setCharacterEncoding("utf-8");
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment;filename*=utf-8''" + fileName + ".xlsx");
        EasyExcel.write(response.getOutputStream(), SpProductionOrderImportDTO.class)
                .sheet("生产订单")
                .doWrite(rows);
    }

    @ApiOperation("生产订单审批轨迹")
    @PostMapping("/plan/workflow-trace")
    @ResponseBody
    public Result workflowTrace(@RequestParam String id) {
        Map<String, Object> data = new HashMap<>();
        List<Map<String, Object>> workOrders = new ArrayList<>();
        for (SpProductionOrderItem item : productionOrderService.listItems(id)) {
            Map<String, Object> row = new HashMap<>();
            row.put("workOrderCode", item.getWorkOrderCode());
            row.put("productName", item.getProductName());
            row.put("planStartTime", item.getComputedStartDate());
            row.put("planEndTime", item.getComputedDeliveryDate());
            List<SpWorkflowTask> tasks = StringUtils.isBlank(item.getWorkOrderId())
                    ? new ArrayList<SpWorkflowTask>()
                    : workflowTaskService.list(new QueryWrapper<SpWorkflowTask>()
                    .eq("business_id", item.getWorkOrderId())
                    .orderByAsc("create_time"));
            row.put("tasks", tasks);
            workOrders.add(row);
        }
        data.put("workOrders", workOrders);
        return Result.success(data);
    }

    private List<Map<String, Object>> buildWorkOrderRows(SpProductionDispatchReq req) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, SpOrderOperEquipmentAssign> equipmentMap = equipmentAssignMap();
        Map<String, List<SpOrderOperAssign>> employeeMap = employeeAssignMap();
        for (SpProductionOrder order : productionOrders(req, null)) {
            for (SpProductionOrderItem item : productionOrderService.listItems(order.getId())) {
                if (!matchesProduct(req, item.getProductMateriel(), item.getProductName())) {
                    continue;
                }
                SpOrder workOrder = StringUtils.isBlank(item.getWorkOrderId()) ? null : workOrderService.getById(item.getWorkOrderId());
                if (workOrder == null) {
                    continue;
                }
                Map<String, Object> row = new HashMap<>();
                row.put("orderNo", order.getOrderNo());
                row.put("workOrderId", workOrder.getId());
                row.put("workOrderCode", workOrder.getOrderCode());
                row.put("productMateriel", item.getProductMateriel());
                row.put("productName", item.getProductName());
                row.put("qty", item.getQty());
                row.put("flowId", workOrder.getFlowId());
                row.put("planStartTime", workOrder.getPlanStartTime());
                row.put("planEndTime", workOrder.getPlanEndTime());
                row.put("workOrderStatus", workOrder.getStatue());
                row.put("approvalStatusName", workOrderStatusName(workOrder.getStatue()));
                fillAssignmentStatus(row, order, item, equipmentMap, employeeMap);
                row.put("operationStatusName", operationName(order.getOperationStatus()));
                row.put("mainStatusName", workOrderStatusName(workOrder.getStatue()));
                row.put("started", isWorkOrderStarted(workOrder));
                row.put("canChange", WORK_ORDER_DISPATCHED == (workOrder.getStatue() == null ? -1 : workOrder.getStatue())
                        && SpProductionOrderServiceImpl.OP_DISPATCHED.equals(order.getOperationStatus()));
                rows.add(row);
            }
        }
        return rows;
    }

    private void fillAssignmentStatus(Map<String, Object> row,
                                      SpProductionOrder order,
                                      SpProductionOrderItem item,
                                      Map<String, SpOrderOperEquipmentAssign> equipmentMap,
                                      Map<String, List<SpOrderOperAssign>> employeeMap) {
        List<SpProductionOrderOperPlan> plans = productionOrderService.listOperationPlans(order.getId(), item.getId());
        int total = plans.size();
        int equipmentDone = 0;
        int employeeDone = 0;
        for (SpProductionOrderOperPlan plan : plans) {
            SpOrderOperEquipmentAssign equipmentAssign = equipmentMap.get(plan.getId());
            if (equipmentAssign != null && StringUtils.isNotBlank(equipmentAssign.getEquipmentId())) {
                equipmentDone++;
            }
            if (hasEmployeeAssignments(employeeMap.get(employeeKey(item.getWorkOrderId(), plan.getOperId())))) {
                employeeDone++;
            }
        }
        row.put("taskCount", total);
        row.put("equipmentAssignStatusName", total > 0 && equipmentDone == total
                ? "设备已派工" : "设备待派工 " + equipmentDone + "/" + total);
        row.put("employeeAssignStatusName", total > 0 && employeeDone == total
                ? "员工已派工" : "员工待派工 " + employeeDone + "/" + total);
        row.put("dispatchStatusName", SpProductionOrderServiceImpl.OP_DISPATCHED.equals(order.getOperationStatus())
                ? "已下发" : "待下发");
    }

    private List<Map<String, Object>> buildDispatchRows(SpProductionDispatchReq req) {
        List<Map<String, Object>> rows = new ArrayList<>();
        for (SpProductionOrder order : productionOrders(req, SpProductionOrderServiceImpl.OP_ASSIGNED)) {
            if (!SpProductionOrderServiceImpl.APPROVAL_APPROVED.equals(order.getApprovalStatus())) {
                continue;
            }
            if (!materialPlanService.isProductionOrderMrpCompleted(order.getId())) {
                continue;
            }
            List<SpProductionOrderItem> items = productionOrderService.listItems(order.getId());
            SpProductionOrderItem first = null;
            int totalQty = 0;
            for (SpProductionOrderItem item : items) {
                if (item.getQty() != null) {
                    totalQty += item.getQty();
                }
                if (!matchesProduct(req, item.getProductMateriel(), item.getProductName())) {
                    continue;
                }
                if (!hasMatchingOper(order.getId(), item.getId(), req == null ? null : req.getOperLike())) {
                    continue;
                }
                if (first == null) {
                    first = item;
                }
            }
            if (first == null) {
                continue;
            }
            Map<String, Object> row = new HashMap<>();
            row.put("id", order.getId());
            row.put("orderNo", order.getOrderNo());
            row.put("schedulingMethod", order.getSchedulingMethod());
            row.put("approvalStatus", order.getApprovalStatus());
            row.put("operationStatus", order.getOperationStatus());
            row.put("totalQty", totalQty);
            row.put("itemCount", items.size());
            row.put("firstProductName", first.getProductName());
            row.put("firstProductMateriel", first.getProductMateriel());
            row.put("firstBomCode", first.getBomCode());
            row.put("firstBomVersion", first.getBomVersion());
            row.put("firstPlanStartDate", first.getPlanStartDate());
            row.put("firstPlanDeliveryDate", first.getPlanDeliveryDate());
            rows.add(row);
        }
        return rows;
    }

    private List<Map<String, Object>> buildTaskRows(SpProductionDispatchReq req, boolean equipmentMode) {
        List<Map<String, Object>> rows = new ArrayList<>();
        Map<String, SpProductionOrderItem> itemMap = itemMap();
        Map<String, SpOrderOperEquipmentAssign> equipmentMap = equipmentAssignMap();
        Map<String, List<SpOrderOperAssign>> employeeMap = employeeAssignMap();

        QueryWrapper<SpProductionOrderOperPlan> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0").orderByDesc("update_time");
        List<String> assignableIds = productionOrderIdsForAssignment(req);
        if (assignableIds.isEmpty()) {
            return rows;
        }
        qw.in("order_id", assignableIds);
        if (StringUtils.isNotBlank(req.getOperLike())) {
            qw.and(w -> w.like("oper", req.getOperLike()).or().like("oper_desc", req.getOperLike()));
        }
        List<SpProductionOrderOperPlan> plans = operPlanService.list(qw);
        for (SpProductionOrderOperPlan plan : plans) {
            SpProductionOrderItem item = itemMap.get(plan.getOrderItemId());
            if (item == null || !matchesProduct(req, item.getProductMateriel(), item.getProductName())) {
                continue;
            }
            SpOrder workOrder = StringUtils.isBlank(item.getWorkOrderId()) ? null : workOrderService.getById(item.getWorkOrderId());
            String employeeKey = employeeKey(item.getWorkOrderId(), plan.getOperId());
            SpOrderOperEquipmentAssign equipmentAssign = equipmentMap.get(plan.getId());
            List<SpOrderOperAssign> employeeAssigns = employeeMap.get(employeeKey);
            if (equipmentMode && StringUtils.isNotBlank(req.getAssignStatus())) {
                boolean assigned = equipmentAssign != null && StringUtils.isNotBlank(equipmentAssign.getEquipmentId());
                if ("ASSIGNED".equals(req.getAssignStatus()) != assigned) {
                    continue;
                }
            }
            if (!equipmentMode && StringUtils.isNotBlank(req.getAssignStatus())) {
                boolean assigned = hasEmployeeAssignments(employeeAssigns);
                if ("ASSIGNED".equals(req.getAssignStatus()) != assigned) {
                    continue;
                }
            }
            Map<String, Object> row = new HashMap<>();
            row.put("operPlanId", plan.getId());
            row.put("orderNo", plan.getOrderNo());
            row.put("workOrderCode", workOrder == null ? item.getWorkOrderCode() : workOrder.getOrderCode());
            row.put("productMateriel", item.getProductMateriel());
            row.put("productName", item.getProductName());
            row.put("qty", item.getQty());
            row.put("operId", plan.getOperId());
            row.put("oper", plan.getOper());
            row.put("operDesc", plan.getOperDesc());
            row.put("sortNum", plan.getSortNum());
            String unitId = resolvePlanUnitId(plan);
            row.put("unitId", unitId);
            row.put("unitName", unitName(unitId));
            row.put("planStartTime", plan.getPlanStartTime());
            row.put("planEndTime", plan.getPlanEndTime());
            row.put("durationHours", plan.getDurationHours());
            row.put("equipmentId", equipmentAssign == null ? "" : equipmentAssign.getEquipmentId());
            row.put("equipmentCode", equipmentAssign == null ? "" : equipmentAssign.getEquipmentCode());
            row.put("equipmentName", equipmentAssign == null ? "" : equipmentAssign.getEquipmentName());
            row.put("equipmentStatus", equipmentAssign == null ? EQUIPMENT_WAIT : equipmentAssign.getStatus());
            row.put("teamId", joinAssignField(employeeAssigns, "teamId"));
            row.put("teamName", joinAssignField(employeeAssigns, "teamName"));
            row.put("userId", joinAssignField(employeeAssigns, "userId"));
            row.put("userName", joinAssignField(employeeAssigns, "userName"));
            row.put("employeeStatus", EMPLOYEE_WAIT);
            rows.add(row);
        }
        return rows;
    }

    private String resolvePlanUnitId(SpProductionOrderOperPlan plan) {
        if (plan == null) {
            return "";
        }
        if (StringUtils.isNotBlank(plan.getUnitId())) {
            return plan.getUnitId();
        }
        if (StringUtils.isBlank(plan.getOperId())) {
            return "";
        }
        SpOper oper = operService.getById(plan.getOperId());
        if (oper == null || StringUtils.isBlank(oper.getUnitId())) {
            return "";
        }
        plan.setUnitId(oper.getUnitId());
        operPlanService.updateById(plan);
        return oper.getUnitId();
    }

    private String unitName(String unitId) {
        if (StringUtils.isBlank(unitId)) {
            return "";
        }
        SpProcessingUnit unit = unitService.getById(unitId);
        if (unit == null) {
            return unitId;
        }
        return StringUtils.defaultIfBlank(unit.getUnitName(), unitId);
    }

    private List<SpProductionOrder> productionOrders(SpProductionDispatchReq req, String operationStatus) {
        QueryWrapper<SpProductionOrder> qw = new QueryWrapper<>();
        qw.ne("is_deleted", "1");
        if (StringUtils.isNotBlank(operationStatus)) {
            qw.eq("operation_status", operationStatus);
        }
        if (req != null && StringUtils.isNotBlank(req.getOrderNoLike())) {
            qw.like("order_no", req.getOrderNoLike());
        }
        qw.orderByDesc("update_time");
        return productionOrderService.list(qw);
    }

    private void syncReadyProductionOrdersForDispatch() {
        QueryWrapper<SpProductionOrder> qw = new QueryWrapper<>();
        qw.ne("is_deleted", "1")
                .eq("approval_status", SpProductionOrderServiceImpl.APPROVAL_APPROVED)
                .and(w -> w.ne("operation_status", SpProductionOrderServiceImpl.OP_DISPATCHED)
                        .or().isNull("operation_status")
                        .or().eq("operation_status", "")
                        .or().eq("operation_status", SpProductionOrderServiceImpl.OP_WAIT_CALC)
                        .or().eq("operation_status", SpProductionOrderServiceImpl.OP_WAIT_ASSIGN)
                        .or().eq("operation_status", SpProductionOrderServiceImpl.OP_ASSIGNED));
        List<SpProductionOrder> orders = productionOrderService.list(qw);
        for (SpProductionOrder order : orders) {
            if (!allWorkOrdersApproved(order.getId())) {
                continue;
            }
            refreshAssignmentStatus(order.getId());
        }
    }

    private boolean allWorkOrdersApproved(String productionOrderId) {
        List<SpProductionOrderItem> items = productionOrderService.listItems(productionOrderId);
        if (items == null || items.isEmpty()) {
            return false;
        }
        for (SpProductionOrderItem item : items) {
            if (StringUtils.isBlank(item.getWorkOrderId())) {
                return false;
            }
            SpOrder workOrder = workOrderService.getById(item.getWorkOrderId());
            if (workOrder == null || workOrder.getStatue() == null || workOrder.getStatue() < WORK_ORDER_APPROVED) {
                return false;
            }
        }
        return true;
    }

    private boolean canAssign(SpProductionOrder order) {
        return order != null
                && SpProductionOrderServiceImpl.APPROVAL_APPROVED.equals(order.getApprovalStatus())
                && !SpProductionOrderServiceImpl.OP_DISPATCHED.equals(order.getOperationStatus())
                && allWorkOrdersApproved(order.getId());
    }

    private void refreshAssignmentStatus(String productionOrderId) {
        SpProductionOrder update = new SpProductionOrder();
        update.setId(productionOrderId);
        update.setStatus(SpProductionOrderServiceImpl.STATUS_CONFIRMED);
        update.setApprovalStatus(SpProductionOrderServiceImpl.APPROVAL_APPROVED);
        update.setOperationStatus(allOperationAssignmentsCompleted(productionOrderId)
                ? SpProductionOrderServiceImpl.OP_ASSIGNED
                : SpProductionOrderServiceImpl.OP_WAIT_ASSIGN);
        productionOrderService.updateById(update);
    }

    private boolean allOperationAssignmentsCompleted(String productionOrderId) {
        List<SpProductionOrderOperPlan> plans = productionOrderService.listOperationPlans(productionOrderId, null);
        if (plans == null || plans.isEmpty()) {
            return false;
        }
        Map<String, SpProductionOrderItem> itemById = new HashMap<>();
        for (SpProductionOrderItem item : productionOrderService.listItems(productionOrderId)) {
            itemById.put(item.getId(), item);
        }
        for (SpProductionOrderOperPlan plan : plans) {
            SpOrderOperEquipmentAssign equipmentAssign = equipmentAssignService.getOne(
                    new QueryWrapper<SpOrderOperEquipmentAssign>()
                            .eq("oper_plan_id", plan.getId())
                            .eq("is_deleted", "0")
                            .last("limit 1"), false);
            if (equipmentAssign == null || StringUtils.isBlank(equipmentAssign.getEquipmentId())) {
                return false;
            }
            SpProductionOrderItem item = itemById.get(plan.getOrderItemId());
            if (item == null || StringUtils.isBlank(item.getWorkOrderId())) {
                return false;
            }
            SpOrderOperAssign employeeAssign = employeeAssignService.getOne(
                    new QueryWrapper<SpOrderOperAssign>()
                            .eq("order_id", item.getWorkOrderId())
                            .eq("oper_id", plan.getOperId())
                            .eq("is_deleted", "0")
                            .last("limit 1"), false);
            if (employeeAssign == null || StringUtils.isBlank(employeeAssign.getUserId())) {
                return false;
            }
        }
        return true;
    }

    private List<String> productionOrderIds(SpProductionDispatchReq req, String operationStatus) {
        List<String> ids = new ArrayList<>();
        for (SpProductionOrder order : productionOrders(req, operationStatus)) {
            ids.add(order.getId());
        }
        return ids;
    }

    private List<String> productionOrderIdsForAssignment(SpProductionDispatchReq req) {
        List<String> ids = new ArrayList<>();
        for (SpProductionOrder order : productionOrders(req, null)) {
            if (canAssign(order)) {
                ids.add(order.getId());
            }
        }
        return ids;
    }

    private Map<String, SpProductionOrderItem> itemMap() {
        Map<String, SpProductionOrderItem> map = new HashMap<>();
        for (SpProductionOrderItem item : itemService.list()) {
            map.put(item.getId(), item);
        }
        return map;
    }

    private Map<String, SpOrderOperEquipmentAssign> equipmentAssignMap() {
        Map<String, SpOrderOperEquipmentAssign> map = new HashMap<>();
        for (SpOrderOperEquipmentAssign assign : equipmentAssignService.list(
                new QueryWrapper<SpOrderOperEquipmentAssign>().eq("is_deleted", "0"))) {
            map.put(assign.getOperPlanId(), assign);
        }
        return map;
    }

    private Map<String, List<SpOrderOperAssign>> employeeAssignMap() {
        Map<String, List<SpOrderOperAssign>> map = new HashMap<>();
        for (SpOrderOperAssign assign : employeeAssignService.list(
                new QueryWrapper<SpOrderOperAssign>().eq("is_deleted", "0"))) {
            String key = employeeKey(assign.getOrderId(), assign.getOperId());
            if (!map.containsKey(key)) {
                map.put(key, new ArrayList<SpOrderOperAssign>());
            }
            map.get(key).add(assign);
        }
        return map;
    }

    private boolean hasEmployeeAssignments(List<SpOrderOperAssign> assigns) {
        if (assigns == null || assigns.isEmpty()) {
            return false;
        }
        for (SpOrderOperAssign assign : assigns) {
            if (assign != null && StringUtils.isNotBlank(assign.getUserId())) {
                return true;
            }
        }
        return false;
    }

    private String joinAssignField(List<SpOrderOperAssign> assigns, String field) {
        if (assigns == null || assigns.isEmpty()) {
            return "";
        }
        List<String> values = new ArrayList<>();
        for (SpOrderOperAssign assign : assigns) {
            String value = "";
            if ("teamId".equals(field)) {
                value = assign.getTeamId();
            } else if ("teamName".equals(field)) {
                value = assign.getTeamName();
            } else if ("userId".equals(field)) {
                value = assign.getUserId();
            } else if ("userName".equals(field)) {
                value = assign.getUserName();
            }
            value = StringUtils.trimToEmpty(value);
            if (StringUtils.isNotBlank(value) && !values.contains(value)) {
                values.add(value);
            }
        }
        return StringUtils.join(values, ",");
    }

    private String valueAt(String[] values, int index) {
        if (values == null || index < 0 || index >= values.length) {
            return "";
        }
        return StringUtils.trimToEmpty(values[index]);
    }

    private IPage<Map<String, Object>> paginate(List<Map<String, Object>> rows, SpProductionDispatchReq req) {
        long current = req == null || req.getCurrent() <= 0 ? 1 : req.getCurrent();
        long size = req == null || req.getSize() <= 0 ? 10 : req.getSize();
        int from = (int) Math.min(rows.size(), (current - 1) * size);
        int to = (int) Math.min(rows.size(), from + size);
        Page<Map<String, Object>> page = new Page<>(current, size);
        page.setTotal(rows.size());
        page.setRecords(rows.subList(from, to));
        return page;
    }

    private boolean matchesProduct(SpProductionDispatchReq req, String materiel, String name) {
        if (req == null || StringUtils.isBlank(req.getProductLike())) {
            return true;
        }
        String key = req.getProductLike();
        return StringUtils.containsIgnoreCase(StringUtils.defaultString(materiel), key)
                || StringUtils.containsIgnoreCase(StringUtils.defaultString(name), key);
    }

    private boolean hasMatchingOper(String orderId, String itemId, String operLike) {
        if (StringUtils.isBlank(operLike)) {
            return true;
        }
        return operPlanService.count(new QueryWrapper<SpProductionOrderOperPlan>()
                .eq("order_id", orderId)
                .eq("order_item_id", itemId)
                .eq("is_deleted", "0")
                .and(w -> w.like("oper", operLike).or().like("oper_desc", operLike))) > 0;
    }

    private String employeeKey(String workOrderId, String operId) {
        return StringUtils.defaultString(workOrderId) + "::" + StringUtils.defaultString(operId);
    }

    private String workOrderStatusName(Integer status) {
        if (status == null) return "未生成";
        switch (status) {
            case 1: return "待审批";
            case 2: return "已审批";
            case 3: return "已完成";
            case 4: return "已终止";
            case 5: return "已下发";
            default: return "未知";
        }
    }

    private String operationName(String status) {
        if (SpProductionOrderServiceImpl.OP_DISPATCHED.equals(status)) return "已下发";
        if (SpProductionOrderServiceImpl.OP_ASSIGNED.equals(status)) return "待下发";
        if (SpProductionOrderServiceImpl.OP_WAIT_ASSIGN.equals(status)) return "待派工";
        if (SpProductionOrderServiceImpl.OP_WAIT_CALC.equals(status)) return "待派工";
        return "未运算";
    }

    private boolean isWorkOrderStarted(SpOrder workOrder) {
        return workOrder != null
                && (WORK_STATUS_STARTED.equals(workOrder.getWorkStatus())
                || workOrderChangeService.hasStarted(workOrder.getId()));
    }

    private Result validateWorkOrderChangeReq(WorkOrderChangeReq req) {
        if (req == null || StringUtils.isBlank(req.getId())) {
            return Result.failure("请选择要修改的工单");
        }
        req.setFlowId(StringUtils.trimToEmpty(req.getFlowId()));
        req.setPlanStartTime(StringUtils.trimToEmpty(req.getPlanStartTime()));
        req.setPlanEndTime(StringUtils.trimToEmpty(req.getPlanEndTime()));
        req.setRemark(StringUtils.trimToEmpty(req.getRemark()));
        if (StringUtils.isBlank(req.getFlowId()) || flowService.getById(req.getFlowId()) == null) {
            return Result.failure("请选择有效的工艺路线");
        }
        if (req.getQty() == null || req.getQty() <= 0) {
            return Result.failure("计划数量必须大于 0");
        }
        Date start = parsePlanTime(req.getPlanStartTime());
        Date end = parsePlanTime(req.getPlanEndTime());
        if (start == null || end == null) {
            return Result.failure("请填写有效的计划开始和计划结束时间");
        }
        if (end.before(start)) {
            return Result.failure("计划结束时间不能早于计划开始时间");
        }
        return null;
    }

    private WorkOrderTarget resolveWorkOrderTarget(String workOrderId) {
        WorkOrderTarget target = new WorkOrderTarget();
        if (StringUtils.isBlank(workOrderId)) {
            target.error = "请选择要修改的工单";
            return target;
        }
        SpOrder workOrder = workOrderService.getById(workOrderId);
        if (workOrder == null) {
            target.error = "工单不存在";
            return target;
        }
        if (workOrder.getStatue() == null || workOrder.getStatue() != WORK_ORDER_DISPATCHED) {
            target.error = "只有已下发工单允许修改";
            return target;
        }
        SpProductionOrderItem item = itemService.getOne(new QueryWrapper<SpProductionOrderItem>()
                .eq("work_order_id", workOrderId)
                .last("limit 1"), false);
        if (item == null || StringUtils.isBlank(item.getOrderId())) {
            target.error = "该工单不是生产计划下发生成的工单";
            return target;
        }
        SpProductionOrder order = productionOrderService.getById(item.getOrderId());
        if (order == null || "1".equals(order.getDeleted())) {
            target.error = "来源生产计划不存在";
            return target;
        }
        if (!SpProductionOrderServiceImpl.OP_DISPATCHED.equals(order.getOperationStatus())) {
            target.error = "只有已下发生产计划中的工单允许修改";
            return target;
        }
        target.workOrder = workOrder;
        target.item = item;
        target.productionOrder = order;
        return target;
    }

    private Date parsePlanTime(String value) {
        if (StringUtils.isBlank(value)) {
            return null;
        }
        List<String> patterns = Arrays.asList("yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "yyyy-MM-dd");
        for (String pattern : patterns) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                sdf.setLenient(false);
                return sdf.parse(value);
            } catch (ParseException ignore) {
            }
        }
        return null;
    }

    private SysUser currentUser() {
        try {
            return getSysUser();
        } catch (Exception ignore) {
            return null;
        }
    }

    private static class WorkOrderTarget {
        private String error;
        private SpOrder workOrder;
        private SpProductionOrder productionOrder;
        private SpProductionOrderItem item;
    }

    private String sourceName(String sourceType) {
        return SpProductionOrderServiceImpl.SOURCE_FORECAST.equals(sourceType) ? "预测订单" : "需求订单";
    }

    private String scheduleName(String schedule) {
        return SpProductionOrderServiceImpl.SCHEDULE_FORWARD.equals(schedule) ? "正向排产" : "逆向排产";
    }
}
