package com.wangziyang.mes.order.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.entity.SpOrderOperAssign;
import com.wangziyang.mes.order.request.SpOrderReq;
import com.wangziyang.mes.order.service.ISpOrderOperAssignService;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.productionorder.entity.SpOrderOperEquipmentAssign;
import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderOperPlan;
import com.wangziyang.mes.productionorder.service.ISpOrderOperEquipmentAssignService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderItemService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderOperPlanService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderService;
import com.wangziyang.mes.productionorder.service.impl.SpProductionOrderServiceImpl;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.technology.entity.SpFlow;
import com.wangziyang.mes.technology.service.ISpFlowService;
import com.wangziyang.mes.workflow.WorkflowPermissionUtil;
import com.wangziyang.mes.workflow.service.ISpWorkflowInstanceService;
import com.wangziyang.mes.workflow.service.ISpWorkflowTaskService;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * Production order release controller.
 */
@Controller
@RequestMapping("/order/release")
public class SpOrderController extends BaseController {

    private static final int STATUE_CREATED_PENDING_APPROVAL = 1;

    private static final int STATUE_APPROVED = 2;

    private static final int STATUE_DISPATCHED = 5;

    private static final String WORK_STATUS_NOT_STARTED = "NOT_STARTED";

    private static final String WORK_STATUS_STARTED = "STARTED";

    private static final String COMPLETE_STATUS_WAIT = "WAIT";

    private static final String COMPLETE_STATUS_COMPLETED = "COMPLETED";

    private static final String DELIVERY_STATUS_WAIT = "WAIT";

    private static final String DELIVERY_STATUS_DELIVERED = "DELIVERED";

    @Autowired
    private ISpOrderService orderService;

    @Autowired
    private ISpFlowService flowService;

    @Autowired
    private ISpWorkflowInstanceService workflowInstanceService;

    @Autowired
    private ISpWorkflowTaskService workflowTaskService;

    @Autowired
    private ISpProductionOrderItemService productionOrderItemService;

    @Autowired
    private ISpProductionOrderService productionOrderService;

    @Autowired
    private ISpProductionOrderOperPlanService productionOrderOperPlanService;

    @Autowired
    private ISpOrderOperEquipmentAssignService equipmentAssignService;

    @Autowired
    private ISpOrderOperAssignService employeeAssignService;

    @ApiOperation("Production order release page")
    @GetMapping("/list-ui")
    public String listUI(Model model) {
        model.addAttribute("canApprove", canApproveOrder());
        return "/order/production/list";
    }

    @ApiOperation("Production order add/update page")
    @GetMapping("/add-or-update-ui")
    public String addOrUpdateUI(Model model, SpOrder record) {
        SpOrder result;
        if (StringUtils.isNotEmpty(record.getId())) {
            result = orderService.getById(record.getId());
        } else {
            result = new SpOrder();
            result.setOrderCode(nextOrderCode());
            result.setOrderType("P");
            result.setStatue(STATUE_CREATED_PENDING_APPROVAL);
            result.setWorkStatus(WORK_STATUS_NOT_STARTED);
            fillDesigner(result, currentUser());
        }
        QueryWrapper<SpFlow> flowQw = new QueryWrapper<>();
        flowQw.orderByAsc("flow");
        model.addAttribute("result", result);
        model.addAttribute("flows", flowService.list(flowQw));
        return "/order/production/addOrUpdate";
    }

    @ApiOperation("Production order page query")
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpOrderReq req) {
        QueryWrapper<SpOrder> queryWrapper = buildQuery(req);
        queryWrapper.orderByDesc("update_time");
        IPage<SpOrder> result = orderService.page(req, queryWrapper);
        enrichOrders(result.getRecords());
        return Result.success(result);
    }

    @ApiOperation("Production order add/update")
    @PostMapping("/add-or-update")
    @ResponseBody
    public Result addOrUpdate(SpOrder record) {
        if (record == null || StringUtils.isEmpty(record.getId())) {
            return Result.failure("工单下达中不能新增工单，请从上方生产订单下发后接收工单");
        }
        SpOrder db = null;
        if (record != null && StringUtils.isNotEmpty(record.getId())) {
            db = orderService.getById(record.getId());
            if (db == null) {
                return Result.failure("工单不存在");
            }
            if (db.getStatue() != null && db.getStatue() != STATUE_CREATED_PENDING_APPROVAL) {
                return Result.failure("只有待审批工单可以编辑");
            }
        }
        Result validateResult = validate(record);
        if (validateResult != null) {
            return validateResult;
        }
        record.setDesignerId(db.getDesignerId());
        record.setDesignerName(db.getDesignerName());
        record.setStatue(db.getStatue());
        record.setWorkStatus(StringUtils.defaultIfBlank(db.getWorkStatus(), WORK_STATUS_NOT_STARTED));
        record.setWorkStartTime(db.getWorkStartTime());
        record.setCompleteStatus(StringUtils.defaultIfBlank(db.getCompleteStatus(), COMPLETE_STATUS_WAIT));
        record.setCompleteTime(db.getCompleteTime());
        record.setCompleteUsername(db.getCompleteUsername());
        record.setDeliveryStatus(StringUtils.defaultIfBlank(db.getDeliveryStatus(), DELIVERY_STATUS_WAIT));
        record.setDeliveryTime(db.getDeliveryTime());
        record.setDeliveryUsername(db.getDeliveryUsername());
        record.setApproveUserId(db.getApproveUserId());
        record.setApproveUsername(db.getApproveUsername());
        record.setApproveTime(db.getApproveTime());
        orderService.saveOrUpdate(record);
        return Result.success();
    }

    @ApiOperation("Approve production order")
    @PostMapping("/approve")
    @ResponseBody
    public Result approve(SpOrder req) {
        if (!canApproveOrder()) {
            return Result.failure("当前用户没有工单审批权限");
        }
        if (req == null || StringUtils.isEmpty(req.getId())) {
            return Result.failure("请选择要审批的工单");
        }
        SpOrder order = orderService.getById(req.getId());
        if (order == null) {
            return Result.failure("工单不存在");
        }
        if (order.getStatue() == null || order.getStatue() != STATUE_CREATED_PENDING_APPROVAL) {
            return Result.failure("只有待审批工单可以审批通过");
        }

        Result result = workflowTaskService.completeOrderApprovalByBusinessId(order.getId(), "订单审批通过", currentUser());
        if ((Integer) result.get("code") == 0) {
            return result;
        }
        workflowInstanceService.startOrderApproval(order, currentUser());
        return workflowTaskService.completeOrderApprovalByBusinessId(order.getId(), "订单审批通过", currentUser());
    }

    @ApiOperation("Start dispatched production order")
    @PostMapping("/start-work")
    @ResponseBody
    public Result startWork(SpOrder req) {
        if (req == null || StringUtils.isEmpty(req.getId())) {
            return Result.failure("请选择要动工的工单");
        }
        SpOrder order = orderService.getById(req.getId());
        if (order == null) {
            return Result.failure("工单不存在");
        }
        if (WORK_STATUS_STARTED.equals(order.getWorkStatus())) {
            return Result.success(null, "工单已动工");
        }
        SpOrder update = new SpOrder();
        update.setId(order.getId());
        update.setWorkStatus(WORK_STATUS_STARTED);
        update.setWorkStartTime(now());
        orderService.updateById(update);
        return Result.success(null, "工单已动工");
    }

    @ApiOperation("Complete started production order")
    @PostMapping("/complete")
    @ResponseBody
    public Result complete(SpOrder req) {
        if (req == null || StringUtils.isEmpty(req.getId())) {
            return Result.failure("请选择要完工的工单");
        }
        SpOrder order = orderService.getById(req.getId());
        if (order == null) {
            return Result.failure("工单不存在");
        }
        String blockReason = completeBlockReason(order);
        if (StringUtils.isNotBlank(blockReason)) {
            return Result.failure(blockReason);
        }
        SpOrder update = new SpOrder();
        update.setCompleteStatus(COMPLETE_STATUS_COMPLETED);
        update.setCompleteTime(now());
        update.setCompleteUsername(displayUsername(currentUser()));
        if (!WORK_STATUS_STARTED.equals(order.getWorkStatus())) {
            update.setWorkStatus(WORK_STATUS_STARTED);
            update.setWorkStartTime(StringUtils.defaultIfBlank(order.getWorkStartTime(), now()));
        }
        boolean updated = orderService.update(update, new UpdateWrapper<SpOrder>()
                .eq("id", order.getId())
                .and(w -> w.ne("complete_status", COMPLETE_STATUS_COMPLETED)
                        .or().isNull("complete_status")
                        .or().eq("complete_status", ""))
                .and(w -> w.ne("delivery_status", DELIVERY_STATUS_DELIVERED)
                        .or().isNull("delivery_status")
                        .or().eq("delivery_status", "")));
        return updated ? Result.success(null, "工单已完工") : Result.failure("工单状态已变化，请刷新后重试");
    }

    @ApiOperation("Deliver completed production order")
    @PostMapping("/deliver")
    @ResponseBody
    public Result deliver(SpOrder req) {
        if (req == null || StringUtils.isEmpty(req.getId())) {
            return Result.failure("请选择要交付的工单");
        }
        SpOrder order = orderService.getById(req.getId());
        if (order == null) {
            return Result.failure("工单不存在");
        }
        String blockReason = deliveryBlockReason(order);
        if (StringUtils.isNotBlank(blockReason)) {
            return Result.failure(blockReason);
        }
        SpOrder update = new SpOrder();
        update.setDeliveryStatus(DELIVERY_STATUS_DELIVERED);
        update.setDeliveryTime(now());
        update.setDeliveryUsername(displayUsername(currentUser()));
        boolean updated = orderService.update(update, new UpdateWrapper<SpOrder>()
                .eq("id", order.getId())
                .eq("complete_status", COMPLETE_STATUS_COMPLETED)
                .and(w -> w.ne("delivery_status", DELIVERY_STATUS_DELIVERED)
                        .or().isNull("delivery_status")
                        .or().eq("delivery_status", "")));
        return updated ? Result.success(null, "工单已交付") : Result.failure("工单状态已变化，请刷新后重试");
    }

    @ApiOperation("Delete production order")
    @PostMapping("/delete")
    @ResponseBody
    public Result delete(SpOrder req) {
        if (StringUtils.isEmpty(req.getId())) {
            return Result.failure("请选择要删除的工单");
        }
        SpOrder order = orderService.getById(req.getId());
        if (order == null) {
            return Result.failure("工单不存在");
        }
        if (order.getStatue() != null && order.getStatue() != STATUE_CREATED_PENDING_APPROVAL) {
            return Result.failure("只有待审批工单可以删除");
        }
        orderService.removeById(req.getId());
        return Result.success();
    }

    @ApiOperation("Production order Gantt data")
    @ResponseBody
    @RequestMapping(value = "/gantt/list", method = RequestMethod.POST, produces = "application/json")
    public Result getListGantt(SpOrderReq req) {
        QueryWrapper<SpOrder> queryWrapper = buildQuery(req);
        queryWrapper.orderByAsc("plan_start_time");
        List<Map<String, Object>> result = new ArrayList<>();
        for (SpOrder order : orderService.list(queryWrapper)) {
            Date start = parsePlanTime(order.getPlanStartTime());
            Date end = parsePlanTime(order.getPlanEndTime());
            if (start == null || end == null || end.before(start)) {
                continue;
            }

            Map<String, Object> row = new HashMap<>(8);
            row.put("id", order.getId());
            row.put("name", StringUtils.defaultIfBlank(order.getMateriel(), order.getOrderCode()));
            row.put("desc", StringUtils.defaultString(order.getOrderDescription()));
            row.put("cssClass", cssClass(order.getStatue()));

            Map<String, Object> value = new HashMap<>(8);
            value.put("from", "/Date(" + start.getTime() + ")/");
            value.put("to", "/Date(" + end.getTime() + ")/");
            value.put("label", StringUtils.defaultIfBlank(order.getOrderCode(), "WO"));
            value.put("desc", "数量: " + (order.getQty() == null ? 0 : order.getQty()) + " / " + statueName(order.getStatue()));
            value.put("customClass", customClass(order.getStatue()));
            Map<String, Object> dataObj = new HashMap<>(4);
            dataObj.put("id", order.getId());
            dataObj.put("statue", order.getStatue());
            value.put("dataObj", dataObj);

            row.put("values", Collections.singletonList(value));
            result.add(row);
        }
        return Result.success(result);
    }

    private QueryWrapper<SpOrder> buildQuery(SpOrderReq req) {
        QueryWrapper<SpOrder> queryWrapper = new QueryWrapper<>();
        if (req == null) {
            queryWrapper.and(w -> w.ne("delivery_status", DELIVERY_STATUS_DELIVERED)
                    .or().isNull("delivery_status")
                    .or().eq("delivery_status", ""));
            return queryWrapper;
        }
        if (StringUtils.isNotEmpty(req.getOrderCodeLike())) {
            queryWrapper.like("order_code", req.getOrderCodeLike());
        }
        if (StringUtils.isNotEmpty(req.getOrderDescriptionLike())) {
            queryWrapper.like("order_description", req.getOrderDescriptionLike());
        }
        if (StringUtils.isNotEmpty(req.getMaterielLike())) {
            queryWrapper.like("materiel", req.getMaterielLike());
        }
        if (StringUtils.isNotEmpty(req.getMaterielDescLike())) {
            queryWrapper.like("materiel_desc", req.getMaterielDescLike());
        }
        if (req.getStatue() != null) {
            queryWrapper.eq("statue", req.getStatue());
        }
        if (StringUtils.isNotEmpty(req.getWorkStatus())) {
            queryWrapper.eq("work_status", req.getWorkStatus());
        }
        if (StringUtils.isNotEmpty(req.getCompleteStatus())) {
            queryWrapper.eq("complete_status", req.getCompleteStatus());
        }
        if (StringUtils.isNotEmpty(req.getDeliveryStatus())) {
            queryWrapper.eq("delivery_status", req.getDeliveryStatus());
        } else {
            queryWrapper.and(w -> w.ne("delivery_status", DELIVERY_STATUS_DELIVERED)
                    .or().isNull("delivery_status")
                    .or().eq("delivery_status", ""));
        }
        return queryWrapper;
    }

    private void enrichOrders(List<SpOrder> orders) {
        if (orders == null || orders.isEmpty()) {
            return;
        }
        for (SpOrder order : orders) {
            order.setApprovalStatusName(statueName(order.getStatue()));
            order.setMainStatusName(statueName(order.getStatue()));
            normalizeWorkStatus(order);
            normalizeLifecycleStatus(order);
            order.setDispatchStatusName(order.getStatue() != null && order.getStatue() == STATUE_DISPATCHED ? "已下发" : "待下发");
            SpProductionOrderItem item = productionOrderItemService.getOne(new QueryWrapper<SpProductionOrderItem>()
                    .eq("work_order_id", order.getId())
                    .last("limit 1"), false);
            if (item == null) {
                order.setSourceOrderNo("异常/手工工单");
                order.setEquipmentAssignStatusName("无来源计划");
                order.setEmployeeAssignStatusName("无来源计划");
                continue;
            }
            order.setSourceOrderItemId(item.getId());
            order.setSourceBomCode(item.getBomCode());
            order.setSourceBomVersion(item.getBomVersion());
            SpProductionOrder productionOrder = productionOrderService.getById(item.getOrderId());
            if (productionOrder != null) {
                order.setSourceOrderNo(productionOrder.getOrderNo());
                order.setDispatchStatusName(SpProductionOrderServiceImpl.OP_DISPATCHED.equals(productionOrder.getOperationStatus())
                        ? "已下发" : "待下发");
            }
            List<SpProductionOrderOperPlan> plans = productionOrderOperPlanService.list(new QueryWrapper<SpProductionOrderOperPlan>()
                    .eq("order_id", item.getOrderId())
                    .eq("order_item_id", item.getId())
                    .eq("is_deleted", "0"));
            int total = plans.size();
            int equipmentDone = 0;
            int employeeDone = 0;
            for (SpProductionOrderOperPlan plan : plans) {
                if (equipmentAssignService.count(new QueryWrapper<SpOrderOperEquipmentAssign>()
                        .eq("oper_plan_id", plan.getId())
                        .eq("is_deleted", "0")
                        .isNotNull("equipment_id")
                        .ne("equipment_id", "")) > 0) {
                    equipmentDone++;
                }
                if (employeeAssignService.count(new QueryWrapper<SpOrderOperAssign>()
                        .eq("order_id", order.getId())
                        .eq("oper_id", plan.getOperId())
                        .eq("is_deleted", "0")
                        .isNotNull("user_id")
                        .ne("user_id", "")) > 0) {
                    employeeDone++;
                }
            }
            order.setEquipmentAssignStatusName(total > 0 && equipmentDone == total
                    ? "设备已派工" : "设备待派工 " + equipmentDone + "/" + total);
            order.setEmployeeAssignStatusName(total > 0 && employeeDone == total
                    ? "员工已派工" : "员工待派工 " + employeeDone + "/" + total);
        }
    }

    private void normalizeLifecycleStatus(SpOrder order) {
        if (order == null) {
            return;
        }
        if (StringUtils.isBlank(order.getCompleteStatus())) {
            order.setCompleteStatus(COMPLETE_STATUS_WAIT);
        }
        if (StringUtils.isBlank(order.getDeliveryStatus())) {
            order.setDeliveryStatus(DELIVERY_STATUS_WAIT);
        }
        order.setCompleteStatusName(COMPLETE_STATUS_COMPLETED.equals(order.getCompleteStatus()) ? "已完工" : "待完工");
        order.setDeliveryStatusName(DELIVERY_STATUS_DELIVERED.equals(order.getDeliveryStatus()) ? "已交付" : "待交付");
        String completeReason = completeBlockReason(order);
        String deliverReason = deliveryBlockReason(order);
        order.setCanComplete(StringUtils.isBlank(completeReason));
        order.setCanDeliver(StringUtils.isBlank(deliverReason));
        order.setCompleteBlockReason(completeReason);
        order.setDeliveryBlockReason(deliverReason);
    }

    private String completeBlockReason(SpOrder order) {
        if (order == null) {
            return "工单不存在";
        }
        if (DELIVERY_STATUS_DELIVERED.equals(order.getDeliveryStatus())) {
            return "工单已交付";
        }
        if (COMPLETE_STATUS_COMPLETED.equals(order.getCompleteStatus())) {
            return "工单已完工";
        }
        return "";
    }

    private String deliveryBlockReason(SpOrder order) {
        if (order == null) {
            return "工单不存在";
        }
        if (DELIVERY_STATUS_DELIVERED.equals(order.getDeliveryStatus())) {
            return "工单已交付";
        }
        if (!COMPLETE_STATUS_COMPLETED.equals(order.getCompleteStatus())) {
            return "工单未完工";
        }
        return "";
    }

    private Result validate(SpOrder record) {
        if (record == null) {
            return Result.failure("工单信息不能为空");
        }
        record.setOrderCode(StringUtils.trimToEmpty(record.getOrderCode()));
        record.setOrderDescription(StringUtils.trimToEmpty(record.getOrderDescription()));
        record.setMateriel(StringUtils.trimToEmpty(record.getMateriel()));
        record.setMaterielDesc(StringUtils.trimToEmpty(record.getMaterielDesc()));
        record.setFlowId(StringUtils.trimToEmpty(record.getFlowId()));
        record.setOrderType(StringUtils.defaultIfBlank(record.getOrderType(), "P"));
        if (record.getStatue() == null) {
            record.setStatue(STATUE_CREATED_PENDING_APPROVAL);
        }

        if (StringUtils.isEmpty(record.getOrderCode())) {
            return Result.failure("请填写工单编号");
        }
        if (record.getQty() == null || record.getQty() <= 0) {
            return Result.failure("工单数量必须大于 0");
        }
        if (StringUtils.isEmpty(record.getMateriel()) || StringUtils.isEmpty(record.getMaterielDesc())) {
            return Result.failure("请选择工单物料");
        }
        if (StringUtils.isEmpty(record.getFlowId()) || flowService.getById(record.getFlowId()) == null) {
            return Result.failure("请选择有效的工艺路线");
        }

        Date start = parsePlanTime(record.getPlanStartTime());
        Date end = parsePlanTime(record.getPlanEndTime());
        if (start == null || end == null) {
            return Result.failure("请填写有效的计划开始和结束时间");
        }
        if (end.before(start)) {
            return Result.failure("计划结束时间不能早于计划开始时间");
        }

        QueryWrapper<SpOrder> duplicateQw = new QueryWrapper<>();
        duplicateQw.eq("order_code", record.getOrderCode());
        if (StringUtils.isNotEmpty(record.getId())) {
            duplicateQw.ne("id", record.getId());
        }
        if (orderService.count(duplicateQw) > 0) {
            return Result.failure("工单编号已存在");
        }
        return null;
    }

    private String nextOrderCode() {
        return "WO" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }

    private String now() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
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

    private String statueName(Integer statue) {
        if (statue == null) return "未设置";
        switch (statue) {
            case 1:
                return "已创建/待审批";
            case 2:
                return "已审批";
            case 3:
                return "已结束";
            case 4:
                return "已终结";
            case 5:
                return "已下发";
            default:
                return "未知";
        }
    }

    private String customClass(Integer statue) {
        if (statue != null && statue == 3) return "ganttGreen";
        if (statue != null && statue == 4) return "ganttRed";
        return "ganttOrange";
    }

    private String cssClass(Integer statue) {
        return statue != null && statue == 4 ? "redLabel" : "";
    }

    private void normalizeWorkStatus(SpOrder order) {
        if (order == null) {
            return;
        }
        if (StringUtils.isBlank(order.getWorkStatus())) {
            order.setWorkStatus(WORK_STATUS_NOT_STARTED);
        }
        order.setWorkStatusName(WORK_STATUS_STARTED.equals(order.getWorkStatus()) ? "已动工" : "未动工");
    }

    private void fillDesigner(SpOrder order, SysUser user) {
        if (order == null || user == null) {
            return;
        }
        order.setDesignerId(user.getId());
        order.setDesignerName(displayUsername(user));
    }

    private SysUser currentUser() {
        try {
            return getSysUser();
        } catch (Exception ignore) {
            return null;
        }
    }

    private String displayUsername(SysUser user) {
        if (user == null) {
            return "";
        }
        return StringUtils.defaultIfBlank(user.getName(), user.getUsername());
    }

    private boolean canApproveOrder() {
        return WorkflowPermissionUtil.canApproveProduction(currentUser());
    }
}
