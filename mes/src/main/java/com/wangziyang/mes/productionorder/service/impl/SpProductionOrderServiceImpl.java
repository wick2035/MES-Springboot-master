package com.wangziyang.mes.productionorder.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.order.entity.SpOrder;
import com.wangziyang.mes.order.entity.SpOrderOperAssign;
import com.wangziyang.mes.order.service.ISpOrderOperAssignService;
import com.wangziyang.mes.order.service.ISpOrderService;
import com.wangziyang.mes.productionorder.entity.SpOrderOperEquipmentAssign;
import com.wangziyang.mes.productionorder.entity.SpMaterialRequirementPlan;
import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderOperPlan;
import com.wangziyang.mes.productionorder.mapper.SpMaterialRequirementPlanMapper;
import com.wangziyang.mes.productionorder.mapper.SpProductionOrderMapper;
import com.wangziyang.mes.productionorder.request.SpProductionOrderErpSyncReq;
import com.wangziyang.mes.productionorder.request.SpProductionOrderForecastReq;
import com.wangziyang.mes.productionorder.request.SpProductionOrderImportDTO;
import com.wangziyang.mes.productionorder.request.SpProductionOrderReq;
import com.wangziyang.mes.productionorder.request.SpProductionOrderSaveReq;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderItemService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderOperPlanService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderService;
import com.wangziyang.mes.productionorder.service.ISpOrderOperEquipmentAssignService;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.entity.SpFlowOperRelation;
import com.wangziyang.mes.technology.entity.SpOper;
import com.wangziyang.mes.technology.entity.SpProcessRoute;
import com.wangziyang.mes.technology.service.ISpBomService;
import com.wangziyang.mes.technology.service.ISpFlowOperRelationService;
import com.wangziyang.mes.technology.service.ISpOperService;
import com.wangziyang.mes.technology.service.ISpProcessRouteService;
import com.wangziyang.mes.workflow.service.ISpWorkflowInstanceService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Production order service implementation.
 */
@Service
public class SpProductionOrderServiceImpl extends ServiceImpl<SpProductionOrderMapper, SpProductionOrder>
        implements ISpProductionOrderService {

    public static final String SOURCE_DEMAND = "DEMAND";
    public static final String SOURCE_FORECAST = "FORECAST";

    public static final String STATUS_DRAFT = "DRAFT";
    public static final String STATUS_CONFIRMED = "CONFIRMED";
    public static final String STATUS_WORK_ORDER_CREATED = "WORK_ORDER_CREATED";
    public static final String STATUS_CANCELLED = "CANCELLED";

    public static final String APPROVAL_DRAFT = "DRAFT";
    public static final String APPROVAL_APPROVING = "APPROVING";
    public static final String APPROVAL_APPROVED = "APPROVED";
    public static final String APPROVAL_REJECTED = "REJECTED";
    public static final String APPROVAL_CANCELLED = "CANCELLED";

    public static final String OP_NONE = "NONE";
    public static final String OP_WAIT_CALC = "WAIT_CALC";
    public static final String OP_WAIT_ASSIGN = "WAIT_ASSIGN";
    public static final String OP_ASSIGNED = "ASSIGNED";
    public static final String OP_DISPATCHED = "DISPATCHED";

    public static final String METHOD_MANUAL = "MANUAL";
    public static final String METHOD_EXCEL = "EXCEL";
    public static final String METHOD_ERP = "ERP";

    public static final String SCHEDULE_FORWARD = "FORWARD";
    public static final String SCHEDULE_REVERSE = "REVERSE";

    private static final BigDecimal DEFAULT_CAPACITY = new BigDecimal("5");
    private static final int DEFAULT_LEAD_TIME = 1;
    private static final int WORK_HOURS_PER_DAY = 8;
    private static final LocalTime SHIFT_START = LocalTime.of(8, 0);
    private static final LocalTime SHIFT_END = LocalTime.of(16, 0);
    private static final int WORK_ORDER_PENDING_APPROVAL = 1;
    private static final int WORK_ORDER_APPROVED = 2;
    private static final int WORK_ORDER_DISPATCHED = 5;
    private static final String WORK_STATUS_NOT_STARTED = "NOT_STARTED";
    private static final DateTimeFormatter DT_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    private ISpProductionOrderItemService itemService;

    @Autowired
    private ISpProductionOrderOperPlanService operPlanService;

    @Autowired
    private ISpMaterileService materileService;

    @Autowired
    private ISpBomService bomService;

    @Autowired
    private ISpFlowOperRelationService flowOperRelationService;

    @Autowired
    private ISpOperService operService;

    @Autowired
    private ISpProcessRouteService processRouteService;

    @Autowired
    private ISpOrderService workOrderService;

    @Autowired
    private ISpWorkflowInstanceService workflowInstanceService;

    @Autowired
    private ISpOrderOperEquipmentAssignService equipmentAssignService;

    @Autowired
    private ISpOrderOperAssignService employeeAssignService;

    @Autowired
    private SpMaterialRequirementPlanMapper materialRequirementPlanMapper;

    @Override
    public String nextOrderNo(String sourceType) {
        String prefix = SOURCE_FORECAST.equals(sourceType) ? "FC" : "SO";
        return prefix + LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE) + System.currentTimeMillis() % 100000;
    }

    @Override
    public IPage<SpProductionOrder> pageWithSummary(SpProductionOrderReq req) {
        QueryWrapper<SpProductionOrder> qw = buildQuery(req);
        qw.orderByDesc("update_time");
        IPage<SpProductionOrder> page = page(req, qw);
        enrichSummary(page.getRecords());
        return page;
    }

    @Override
    public List<SpProductionOrderItem> listItems(String orderId) {
        if (StringUtils.isBlank(orderId)) {
            return new ArrayList<>();
        }
        QueryWrapper<SpProductionOrderItem> qw = new QueryWrapper<>();
        qw.eq("order_id", orderId).orderByAsc("create_time");
        return itemService.list(qw);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result saveOrder(SpProductionOrderSaveReq req) {
        Result validate = validateSave(req);
        if (validate != null) {
            return validate;
        }
        String orderId = saveOrderInternal(req);
        return Result.success(orderId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result submitOrder(SpProductionOrderSaveReq req, SysUser user) {
        Result saved = saveOrder(req);
        if ((Integer) saved.get("code") != 0) {
            return saved;
        }
        return createWorkOrder(String.valueOf(saved.get("data")), user);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result confirm(String id) {
        SpProductionOrder order = getActiveOrder(id);
        if (order == null) {
            return Result.failure("生产订单不存在");
        }
        if (APPROVAL_APPROVING.equals(order.getApprovalStatus())) {
            return Result.failure("审核中的订单不能重复确认");
        }
        if (STATUS_WORK_ORDER_CREATED.equals(order.getStatus())) {
            return Result.failure("订单已提交审批或生成生产工单");
        }
        order.setApprovalStatus(APPROVAL_APPROVED);
        order.setOperationStatus(OP_WAIT_ASSIGN);
        order.setStatus(STATUS_CONFIRMED);
        updateById(order);
        return Result.success();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result deleteOrder(String id) {
        SpProductionOrder order = getActiveOrder(id);
        if (order == null) {
            return Result.failure("生产订单不存在");
        }
        if (APPROVAL_APPROVING.equals(order.getApprovalStatus())) {
            return Result.failure("审核中的订单不能删除");
        }
        if (STATUS_WORK_ORDER_CREATED.equals(order.getStatus())) {
            return Result.failure("已生成生产工单的订单不能删除");
        }
        order.setDeleted("1");
        order.setStatus(STATUS_CANCELLED);
        order.setApprovalStatus(APPROVAL_CANCELLED);
        updateById(order);
        return Result.success();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result createWorkOrder(String id, SysUser user) {
        SpProductionOrder order = getActiveOrder(id);
        if (order == null) {
            return Result.failure("生产订单不存在");
        }
        if (APPROVAL_APPROVING.equals(order.getApprovalStatus())) {
            return Result.failure("生产订单已在审核中");
        }
        if (OP_DISPATCHED.equals(order.getOperationStatus())) {
            return Result.failure("已下发的订单不能重复提交");
        }
        List<SpProductionOrderItem> items = listItems(id);
        if (items.isEmpty()) {
            return Result.failure("生产订单明细为空");
        }

        Map<String, RouteBinding> routeMap = new HashMap<>();
        for (SpProductionOrderItem item : items) {
            Result itemCheck = validateLatestBom(item);
            if (itemCheck != null) {
                return itemCheck;
            }
            SpMaterile materile = findMaterile(item.getProductMateriel());
            if (materile == null) {
                return Result.failure("产品物料不存在：" + item.getProductMateriel());
            }
            RouteBinding route = resolveRouteBinding(item, materile);
            if (route.steps.isEmpty()) {
                return Result.failure("产品物料未维护工艺路线：" + item.getProductMateriel());
            }
            routeMap.put(item.getProductMateriel(), route);
        }

        int created = 0;
        for (SpProductionOrderItem item : items) {
            if (StringUtils.isNotBlank(item.getWorkOrderId())) {
                continue;
            }
            RouteBinding route = routeMap.get(item.getProductMateriel());
            SpOrder workOrder = new SpOrder();
            workOrder.setOrderCode(nextWorkOrderCode());
            workOrder.setOrderDescription(order.getOrderNo() + " / " + item.getProductName());
            workOrder.setQty(item.getQty());
            workOrder.setOrderType("P");
            workOrder.setFlowId(route.flowId);
            workOrder.setMateriel(item.getProductMateriel());
            workOrder.setMaterielDesc(item.getProductName());
            workOrder.setPlanStartTime(toDateTime(StringUtils.defaultIfBlank(item.getComputedStartDate(), item.getPlanStartDate())));
            workOrder.setPlanEndTime(toDateTime(StringUtils.defaultIfBlank(item.getComputedDeliveryDate(), item.getPlanDeliveryDate())));
            workOrder.setStatue(WORK_ORDER_PENDING_APPROVAL);
            workOrder.setWorkStatus(WORK_STATUS_NOT_STARTED);
            if (user != null) {
                workOrder.setDesignerId(user.getId());
                workOrder.setDesignerName(displayUsername(user));
            }
            workOrderService.save(workOrder);
            workflowInstanceService.startOrderApproval(workOrder, user);

            item.setWorkOrderId(workOrder.getId());
            item.setWorkOrderCode(workOrder.getOrderCode());
            itemService.updateById(item);
            created++;
        }

        order.setStatus(STATUS_WORK_ORDER_CREATED);
        order.setApprovalStatus(APPROVAL_APPROVING);
        order.setOperationStatus(OP_NONE);
        updateById(order);
        Map<String, Object> data = new HashMap<>();
        data.put("created", created);
        return Result.success(data, "已提交生产主管审批");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result dispatch(String id) {
        SpProductionOrder order = getActiveOrder(id);
        if (order == null) {
            return Result.failure("生产订单不存在");
        }
        if (!APPROVAL_APPROVED.equals(order.getApprovalStatus())) {
            return Result.failure("只有审批完成的生产订单可以计划下发");
        }
        if (!OP_ASSIGNED.equals(order.getOperationStatus())) {
            return Result.failure("设备和员工作业派工全部完成后才能下发");
        }
        if (!allWorkOrdersApproved(id)) {
            return Result.failure("该生产订单存在未审批通过的工单");
        }
        if (!allOperationAssignmentsCompleted(id)) {
            return Result.failure("该生产订单存在未完成设备或员工派工的工序");
        }
        if (!mrpCompletedForDispatch(id)) {
            return Result.failure("配套出库确认完成后才能进行生产计划下发");
        }
        order.setOperationStatus(OP_DISPATCHED);
        updateById(order);
        markWorkOrdersDispatched(id);
        return Result.success();
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result importOrders(List<SpProductionOrderImportDTO> rows, SysUser user) {
        if (rows == null || rows.isEmpty()) {
            return Result.failure("Excel中没有可导入的数据");
        }
        List<SpProductionOrderSaveReq> reqs = new ArrayList<>();
        List<String> errors = new ArrayList<>();
        Map<String, SpProductionOrderSaveReq> grouped = new LinkedHashMap<>();
        for (int i = 0; i < rows.size(); i++) {
            SpProductionOrderImportDTO row = rows.get(i);
            int rowNum = i + 2;
            try {
                String key = StringUtils.defaultIfBlank(StringUtils.trimToEmpty(row.getExternalNo()), "__row_" + rowNum);
                SpProductionOrderSaveReq req = grouped.get(key);
                if (req == null) {
                    req = new SpProductionOrderSaveReq();
                    SpProductionOrder order = new SpProductionOrder();
                    order.setSourceType(normalizeSourceType(row.getSourceType()));
                    order.setCustomerName(row.getCustomerName());
                    order.setExternalNo(StringUtils.trimToEmpty(row.getExternalNo()));
                    order.setSalesContractNo(row.getSalesContractNo());
                    order.setSchedulingMethod(normalizeScheduling(row.getSchedulingMethod(), order.getSourceType()));
                    order.setCreationMethod(METHOD_EXCEL);
                    order.setRemark(row.getRemark());
                    req.setOrder(order);
                    grouped.put(key, req);
                    reqs.add(req);
                }
                req.getItems().add(importRowToItem(row));
            } catch (Exception e) {
                errors.add("第" + rowNum + "行：" + e.getMessage());
            }
        }
        return saveBatchImport(reqs, errors, "Excel导入完成");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result syncFromErp(SpProductionOrderErpSyncReq req, SysUser user) {
        if (req == null || req.getOrders() == null || req.getOrders().isEmpty()) {
            return Result.failure("ERP同步数据不能为空");
        }
        List<SpProductionOrderSaveReq> reqs = new ArrayList<>();
        List<String> errors = new ArrayList<>();
        int skipped = 0;
        for (int i = 0; i < req.getOrders().size(); i++) {
            SpProductionOrderErpSyncReq.Order erpOrder = req.getOrders().get(i);
            String erpNo = StringUtils.trimToEmpty(erpOrder.getErpSourceNo());
            if (StringUtils.isBlank(erpNo)) {
                errors.add("第" + (i + 1) + "个ERP订单：erpSourceNo不能为空");
                continue;
            }
            if (existsErpOrder(erpNo)) {
                skipped++;
                continue;
            }
            SpProductionOrderSaveReq saveReq = new SpProductionOrderSaveReq();
            SpProductionOrder order = new SpProductionOrder();
            order.setSourceType(normalizeSourceType(erpOrder.getSourceType()));
            order.setCustomerName(erpOrder.getCustomerName());
            order.setCustomerGroup(erpOrder.getCustomerGroup());
            order.setExternalNo(erpNo);
            order.setErpSourceNo(erpNo);
            order.setSalesContractNo(erpOrder.getSalesContractNo());
            order.setBusinessType(erpOrder.getBusinessType());
            order.setOrderDate(erpOrder.getOrderDate());
            order.setSchedulingMethod(normalizeScheduling(erpOrder.getSchedulingMethod(), order.getSourceType()));
            order.setCreationMethod(METHOD_ERP);
            order.setErpSyncTime(now());
            order.setRemark(erpOrder.getRemark());
            saveReq.setOrder(order);
            if (erpOrder.getItems() != null) {
                for (SpProductionOrderErpSyncReq.Item item : erpOrder.getItems()) {
                    SpProductionOrderItem orderItem = new SpProductionOrderItem();
                    orderItem.setBomCode(item.getBomCode());
                    orderItem.setProductMateriel(item.getProductMateriel());
                    orderItem.setQty(item.getQty());
                    orderItem.setPlanDeliveryDate(item.getPlanDeliveryDate());
                    orderItem.setPlanStartDate(item.getPlanStartDate());
                    orderItem.setLeadTimeDays(item.getLeadTimeDays());
                    orderItem.setTargetCapacity(item.getTargetCapacity());
                    orderItem.setConfiguration(item.getConfiguration());
                    saveReq.getItems().add(orderItem);
                }
            }
            reqs.add(saveReq);
        }
        Result result = saveBatchImport(reqs, errors, "ERP同步完成");
        if ((Integer) result.get("code") == 0) {
            Map<String, Object> data = new HashMap<>();
            data.put("created", reqs.size());
            data.put("skipped", skipped);
            result.put("data", data);
        }
        return result;
    }

    @Override
    public List<SpProductionOrderOperPlan> listOperationPlans(String orderId, String itemId) {
        QueryWrapper<SpProductionOrderOperPlan> qw = new QueryWrapper<>();
        qw.eq("is_deleted", "0");
        if (StringUtils.isNotBlank(orderId)) {
            qw.eq("order_id", orderId);
        }
        if (StringUtils.isNotBlank(itemId)) {
            qw.eq("order_item_id", itemId);
        }
        qw.orderByAsc("order_item_id").orderByAsc("sort_num");
        return operPlanService.list(qw);
    }

    @Override
    public List<SpProductionOrderItem> generateForecastItems(SpProductionOrderForecastReq req) {
        int months = req.getMonths() == null ? 6 : req.getMonths();
        if (months != 3 && months != 6 && months != 12) {
            months = 6;
        }
        BigDecimal trend = positive(req.getTrendFactor(), BigDecimal.ONE);
        BigDecimal season = positive(req.getSeasonFactor(), BigDecimal.ONE);
        BigDecimal capacity = positive(req.getTargetCapacity(), DEFAULT_CAPACITY);
        int leadTime = req.getLeadTimeDays() == null || req.getLeadTimeDays() < 1 ? readLeadTime(req.getProductMateriel()) : req.getLeadTimeDays();
        LocalDate start = parseDate(req.getFirstPlanStartDate(), LocalDate.now());

        BigDecimal base = historicalMonthlyAverage(req.getProductMateriel(), req.getCustomerName());
        if (base.compareTo(BigDecimal.ZERO) <= 0) {
            base = new BigDecimal("10");
        }

        List<SpProductionOrderItem> result = new ArrayList<>();
        for (int i = 0; i < months; i++) {
            BigDecimal qtyDecimal = base.multiply(season).multiply(pow(trend, i));
            int qty = Math.max(1, qtyDecimal.setScale(0, RoundingMode.CEILING).intValue());
            SpProductionOrderItem item = new SpProductionOrderItem();
            item.setProductMateriel(StringUtils.trimToEmpty(req.getProductMateriel()));
            item.setProductName(StringUtils.defaultIfBlank(req.getProductName(), productName(req.getProductMateriel())));
            item.setQty(qty);
            item.setPlanStartDate(start.plusMonths(i).toString());
            item.setLeadTimeDays(leadTime);
            item.setTargetCapacity(capacity);
            item.setConfiguration("规则预测：" + months + "个月，近6月均值" + base.setScale(2, RoundingMode.HALF_UP));
            normalizeForecastDate(item);
            fillBomInfo(item);
            result.add(item);
        }
        return result;
    }

    @Override
    public Map<String, Object> dashboard() {
        Map<String, Object> data = new HashMap<>();
        QueryWrapper<SpProductionOrder> active = new QueryWrapper<>();
        active.ne("is_deleted", "1");
        data.put("total", count(active));

        QueryWrapper<SpProductionOrder> demand = new QueryWrapper<>();
        demand.ne("is_deleted", "1").eq("source_type", SOURCE_DEMAND);
        data.put("demand", count(demand));

        QueryWrapper<SpProductionOrder> forecast = new QueryWrapper<>();
        forecast.ne("is_deleted", "1").eq("source_type", SOURCE_FORECAST);
        data.put("forecast", count(forecast));

        QueryWrapper<SpProductionOrder> approving = new QueryWrapper<>();
        approving.ne("is_deleted", "1").eq("approval_status", APPROVAL_APPROVING);
        data.put("approving", count(approving));

        QueryWrapper<SpProductionOrder> waitAssign = new QueryWrapper<>();
        waitAssign.ne("is_deleted", "1").eq("operation_status", OP_WAIT_ASSIGN);
        data.put("waitCalc", count(waitAssign));
        data.put("waitAssign", count(waitAssign));

        QueryWrapper<SpProductionOrder> assigned = new QueryWrapper<>();
        assigned.ne("is_deleted", "1").eq("operation_status", OP_ASSIGNED);
        data.put("assigned", count(assigned));

        QueryWrapper<SpProductionOrder> dispatched = new QueryWrapper<>();
        dispatched.ne("is_deleted", "1").eq("operation_status", OP_DISPATCHED);
        data.put("dispatched", count(dispatched));
        return data;
    }

    private String saveOrderInternal(SpProductionOrderSaveReq req) {
        SpProductionOrder order = req.getOrder();
        boolean create = StringUtils.isBlank(order.getId());
        if (create) {
            order.setOrderNo(nextOrderNo(order.getSourceType()));
            order.setStatus(STATUS_DRAFT);
            order.setApprovalStatus(APPROVAL_DRAFT);
            order.setOperationStatus(OP_NONE);
            order.setDeleted("0");
        } else {
            SpProductionOrder db = getById(order.getId());
            if (db == null || "1".equals(db.getDeleted())) {
                throw new RuntimeException("生产订单不存在");
            }
            if (APPROVAL_APPROVING.equals(db.getApprovalStatus()) || APPROVAL_APPROVED.equals(db.getApprovalStatus())) {
                throw new RuntimeException("审核中或已完成审批的订单不能再编辑");
            }
            order.setOrderNo(db.getOrderNo());
            order.setStatus(StringUtils.defaultIfBlank(db.getStatus(), STATUS_DRAFT));
            order.setApprovalStatus(StringUtils.defaultIfBlank(db.getApprovalStatus(), APPROVAL_DRAFT));
            order.setOperationStatus(StringUtils.defaultIfBlank(db.getOperationStatus(), OP_NONE));
            order.setCreationMethod(StringUtils.defaultIfBlank(order.getCreationMethod(), db.getCreationMethod()));
            order.setErpSourceNo(StringUtils.defaultIfBlank(order.getErpSourceNo(), db.getErpSourceNo()));
            order.setErpSyncTime(StringUtils.defaultIfBlank(order.getErpSyncTime(), db.getErpSyncTime()));
            order.setDeleted(db.getDeleted());
        }
        trimOrder(order);
        saveOrUpdate(order);

        itemService.remove(new QueryWrapper<SpProductionOrderItem>().eq("order_id", order.getId()));
        operPlanService.remove(new QueryWrapper<SpProductionOrderOperPlan>().eq("order_id", order.getId()));

        List<SpProductionOrderItem> savedItems = new ArrayList<>();
        for (SpProductionOrderItem item : req.getItems()) {
            normalizeItem(order, item);
            itemService.save(item);
            savedItems.add(item);
        }
        rebuildOperationPlans(order, savedItems);
        return order.getId();
    }

    private Result saveBatchImport(List<SpProductionOrderSaveReq> reqs, List<String> errors, String successMsg) {
        if (reqs.isEmpty() && errors.isEmpty()) {
            return Result.failure("没有可导入的数据");
        }
        for (SpProductionOrderSaveReq req : reqs) {
            Result validate = validateSave(req);
            if (validate != null) {
                errors.add(String.valueOf(validate.get("msg")));
            }
        }
        if (!errors.isEmpty()) {
            return Result.failure(String.join("；", errors));
        }
        for (SpProductionOrderSaveReq req : reqs) {
            saveOrderInternal(req);
        }
        return Result.success(null, successMsg + "，成功创建 " + reqs.size() + " 张生产订单");
    }

    private QueryWrapper<SpProductionOrder> buildQuery(SpProductionOrderReq req) {
        QueryWrapper<SpProductionOrder> qw = new QueryWrapper<>();
        qw.ne("is_deleted", "1");
        if (req == null) {
            return qw;
        }
        if (StringUtils.isNotBlank(req.getKeyword())) {
            String keyword = req.getKeyword();
            List<String> orderIds = orderIdsByProduct(keyword);
            qw.and(w -> {
                w.like("order_no", keyword)
                        .or().like("customer_name", keyword)
                        .or().like("external_no", keyword)
                        .or().like("sales_contract_no", keyword);
                if (!orderIds.isEmpty()) {
                    w.or().in("id", orderIds);
                }
            });
        }
        if (StringUtils.isNotBlank(req.getOrderNoLike())) {
            qw.like("order_no", req.getOrderNoLike());
        }
        if (StringUtils.isNotBlank(req.getSourceType())) {
            qw.eq("source_type", req.getSourceType());
        }
        if (StringUtils.isNotBlank(req.getCustomerNameLike())) {
            qw.like("customer_name", req.getCustomerNameLike());
        }
        if (StringUtils.isNotBlank(req.getStatus())) {
            qw.eq("status", req.getStatus());
        }
        if (StringUtils.isNotBlank(req.getApprovalStatus())) {
            qw.eq("approval_status", req.getApprovalStatus());
        }
        if (StringUtils.isNotBlank(req.getOperationStatus())) {
            qw.eq("operation_status", req.getOperationStatus());
        }
        if (StringUtils.isNotBlank(req.getProductLike())) {
            List<String> orderIds = orderIdsByProduct(req.getProductLike());
            if (orderIds.isEmpty()) {
                qw.eq("id", "__none__");
            } else {
                qw.in("id", orderIds);
            }
        }
        return qw;
    }

    private void enrichSummary(List<SpProductionOrder> records) {
        if (records == null || records.isEmpty()) {
            return;
        }
        for (SpProductionOrder order : records) {
            normalizeStatusForView(order);
            List<SpProductionOrderItem> items = listItems(order.getId());
            order.setItemCount(items.size());
            int totalQty = 0;
            for (int i = 0; i < items.size(); i++) {
                SpProductionOrderItem item = items.get(i);
                totalQty += item.getQty() == null ? 0 : item.getQty();
                if (i == 0) {
                    order.setFirstProductMateriel(item.getProductMateriel());
                    order.setFirstProductName(item.getProductName());
                    order.setFirstBomCode(item.getBomCode());
                    order.setFirstBomVersion(item.getBomVersion());
                    order.setFirstPlanDeliveryDate(StringUtils.defaultIfBlank(item.getComputedDeliveryDate(), item.getPlanDeliveryDate()));
                    order.setFirstPlanStartDate(StringUtils.defaultIfBlank(item.getComputedStartDate(), item.getPlanStartDate()));
                }
            }
            order.setTotalQty(totalQty);
        }
    }

    private void normalizeStatusForView(SpProductionOrder order) {
        if (StringUtils.isBlank(order.getApprovalStatus())) {
            if (STATUS_WORK_ORDER_CREATED.equals(order.getStatus())) {
                order.setApprovalStatus(APPROVAL_APPROVING);
            } else if (STATUS_CONFIRMED.equals(order.getStatus())) {
                order.setApprovalStatus(APPROVAL_APPROVED);
            } else if (STATUS_CANCELLED.equals(order.getStatus())) {
                order.setApprovalStatus(APPROVAL_CANCELLED);
            } else {
                order.setApprovalStatus(APPROVAL_DRAFT);
            }
        }
        if (StringUtils.isBlank(order.getOperationStatus())) {
            order.setOperationStatus(APPROVAL_APPROVED.equals(order.getApprovalStatus()) ? OP_WAIT_ASSIGN : OP_NONE);
        }
    }

    private boolean allWorkOrdersApproved(String productionOrderId) {
        List<SpProductionOrderItem> items = listItems(productionOrderId);
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

    private boolean allOperationAssignmentsCompleted(String productionOrderId) {
        List<SpProductionOrderOperPlan> plans = listOperationPlans(productionOrderId, null);
        if (plans == null || plans.isEmpty()) {
            return false;
        }
        Map<String, SpProductionOrderItem> itemById = new HashMap<>();
        for (SpProductionOrderItem item : listItems(productionOrderId)) {
            itemById.put(item.getId(), item);
        }
        for (SpProductionOrderOperPlan plan : plans) {
            if (!hasEquipmentAssign(plan.getId())) {
                return false;
            }
            SpProductionOrderItem item = itemById.get(plan.getOrderItemId());
            if (item == null || StringUtils.isBlank(item.getWorkOrderId())
                    || !hasEmployeeAssign(item.getWorkOrderId(), plan.getOperId())) {
                return false;
            }
        }
        return true;
    }

    private boolean mrpCompletedForDispatch(String productionOrderId) {
        if (StringUtils.isBlank(productionOrderId)) {
            return false;
        }
        QueryWrapper<SpMaterialRequirementPlan> qw = new QueryWrapper<SpMaterialRequirementPlan>()
                .eq("production_order_id", productionOrderId)
                .eq("is_deleted", "0")
                .isNotNull("material_id")
                .ne("material_id", "");
        List<SpMaterialRequirementPlan> rows = materialRequirementPlanMapper.selectList(qw);
        if (rows == null || rows.isEmpty()) {
            return false;
        }
        for (SpMaterialRequirementPlan row : rows) {
            BigDecimal net = row.getNetRequirement() == null ? BigDecimal.ZERO : row.getNetRequirement();
            if (net.compareTo(BigDecimal.ZERO) > 0
                    && !"CONFIRMED".equals(row.getOutboundStatus())) {
                return false;
            }
        }
        return true;
    }

    private boolean hasEquipmentAssign(String operPlanId) {
        return equipmentAssignService.count(new QueryWrapper<SpOrderOperEquipmentAssign>()
                .eq("oper_plan_id", operPlanId)
                .eq("is_deleted", "0")
                .isNotNull("equipment_id")
                .ne("equipment_id", "")) > 0;
    }

    private boolean hasEmployeeAssign(String workOrderId, String operId) {
        return employeeAssignService.count(new QueryWrapper<SpOrderOperAssign>()
                .eq("order_id", workOrderId)
                .eq("oper_id", operId)
                .eq("is_deleted", "0")
                .isNotNull("user_id")
                .ne("user_id", "")) > 0;
    }

    private void markWorkOrdersDispatched(String productionOrderId) {
        for (SpProductionOrderItem item : listItems(productionOrderId)) {
            if (StringUtils.isBlank(item.getWorkOrderId())) {
                continue;
            }
            SpOrder update = new SpOrder();
            update.setId(item.getWorkOrderId());
            update.setStatue(WORK_ORDER_DISPATCHED);
            workOrderService.updateById(update);
        }
    }

    private List<String> orderIdsByProduct(String productLike) {
        QueryWrapper<SpProductionOrderItem> itemQw = new QueryWrapper<>();
        itemQw.like("product_materiel", productLike)
                .or().like("product_name", productLike)
                .or().like("bom_code", productLike);
        List<SpProductionOrderItem> items = itemService.list(itemQw);
        Set<String> ids = new HashSet<>();
        for (SpProductionOrderItem item : items) {
            ids.add(item.getOrderId());
        }
        return new ArrayList<>(ids);
    }

    private Result validateSave(SpProductionOrderSaveReq req) {
        if (req == null || req.getOrder() == null) {
            return Result.failure("生产订单不能为空");
        }
        SpProductionOrder order = req.getOrder();
        order.setSourceType(normalizeSourceType(order.getSourceType()));
        order.setSchedulingMethod(normalizeScheduling(order.getSchedulingMethod(), order.getSourceType()));
        if (SOURCE_DEMAND.equals(order.getSourceType()) && StringUtils.isBlank(order.getCustomerName())) {
            return Result.failure("需求订单必须填写客户名称");
        }
        if (req.getItems() == null || req.getItems().isEmpty()) {
            return Result.failure("请至少维护一条产品明细");
        }
        for (SpProductionOrderItem item : req.getItems()) {
            Result bomCheck = validateLatestBom(item);
            if (bomCheck != null) {
                return bomCheck;
            }
            if (item.getQty() == null || item.getQty() <= 0) {
                return Result.failure("订单数量必须大于0");
            }
            if (SCHEDULE_REVERSE.equals(order.getSchedulingMethod()) && StringUtils.isBlank(item.getPlanDeliveryDate())) {
                return Result.failure("逆向排产必须填写计划交付日期");
            }
            if (SCHEDULE_FORWARD.equals(order.getSchedulingMethod()) && StringUtils.isBlank(item.getPlanStartDate())) {
                return Result.failure("正向排产必须填写计划开工日期");
            }
        }
        return null;
    }

    private void trimOrder(SpProductionOrder order) {
        order.setCustomerName(StringUtils.trimToEmpty(order.getCustomerName()));
        order.setCustomerGroup(StringUtils.trimToEmpty(order.getCustomerGroup()));
        order.setExternalNo(StringUtils.trimToEmpty(order.getExternalNo()));
        order.setSalesContractNo(StringUtils.trimToEmpty(order.getSalesContractNo()));
        order.setBusinessType(StringUtils.defaultIfBlank(order.getBusinessType(), "普通销售"));
        order.setOrderDate(StringUtils.defaultIfBlank(order.getOrderDate(), LocalDate.now().toString()));
        order.setSettlementCurrency(StringUtils.defaultIfBlank(order.getSettlementCurrency(), "人民币"));
        order.setTransportMode(StringUtils.trimToEmpty(order.getTransportMode()));
        order.setPaymentTerms(StringUtils.trimToEmpty(order.getPaymentTerms()));
        order.setTaxRate(StringUtils.defaultIfBlank(order.getTaxRate(), "不含税"));
        order.setReceiverName(StringUtils.trimToEmpty(order.getReceiverName()));
        order.setReceiverPhone(StringUtils.trimToEmpty(order.getReceiverPhone()));
        order.setReceiverAddress(StringUtils.trimToEmpty(order.getReceiverAddress()));
        order.setRemark(StringUtils.trimToEmpty(order.getRemark()));
        order.setCreationMethod(StringUtils.defaultIfBlank(order.getCreationMethod(), METHOD_MANUAL));
        order.setSchedulingMethod(normalizeScheduling(order.getSchedulingMethod(), order.getSourceType()));
        order.setApprovalStatus(StringUtils.defaultIfBlank(order.getApprovalStatus(), APPROVAL_DRAFT));
        order.setOperationStatus(StringUtils.defaultIfBlank(order.getOperationStatus(), OP_NONE));
    }

    private void normalizeItem(SpProductionOrder order, SpProductionOrderItem item) {
        item.setId(null);
        item.setOrderId(order.getId());
        item.setProductMateriel(StringUtils.trimToEmpty(item.getProductMateriel()));
        item.setProductName(StringUtils.trimToEmpty(item.getProductName()));
        item.setModel(StringUtils.trimToEmpty(item.getModel()));
        item.setSpecification(StringUtils.trimToEmpty(item.getSpecification()));
        item.setConfiguration(StringUtils.trimToEmpty(item.getConfiguration()));
        item.setAdjustNote(StringUtils.trimToEmpty(item.getAdjustNote()));
        fillBomInfo(item);
        if (item.getLeadTimeDays() == null || item.getLeadTimeDays() < 1) {
            item.setLeadTimeDays(readLeadTime(item.getProductMateriel()));
        }
        item.setTargetCapacity(positive(item.getTargetCapacity(), DEFAULT_CAPACITY));
        if (SCHEDULE_FORWARD.equals(order.getSchedulingMethod())) {
            normalizeForecastDate(item);
        } else {
            normalizeDemandDate(item);
        }
    }

    private void rebuildOperationPlans(SpProductionOrder order, List<SpProductionOrderItem> items) {
        // 明细级日期（建议开工/预计交付/建议备料）已由 normalizeItem 按产能/日口径算定，
        // 此处仅在该区间内铺排工序级时间线，不再回写覆盖明细日期，保证前端预览=入库值。
        for (SpProductionOrderItem item : items) {
            List<SpProductionOrderOperPlan> plans = buildOperationPlans(order, item);
            if (!plans.isEmpty()) {
                operPlanService.saveBatch(plans);
            }
        }
    }

    private List<SpProductionOrderOperPlan> buildOperationPlans(SpProductionOrder order, SpProductionOrderItem item) {
        List<SpProductionOrderOperPlan> plans = new ArrayList<>();
        SpMaterile materile = findMaterile(item.getProductMateriel());
        if (materile == null) {
            return plans;
        }
        RouteBinding route = resolveRouteBinding(item, materile);
        List<RouteStep> steps = route.steps;
        if (steps.isEmpty()) {
            return plans;
        }

        // 唯一基准=产能/日：整单生产总工时 = productionDays × 班次工时，
        // 再按各工序权重（制造周期/工序工时，缺省均分）分摊到每道工序——故工序时长随数量缩放。
        BigDecimal totalHours = new BigDecimal(productionDays(item) * WORK_HOURS_PER_DAY);
        List<SpOper> opers = new ArrayList<>();
        List<BigDecimal> weights = new ArrayList<>();
        BigDecimal totalWeight = BigDecimal.ZERO;
        for (RouteStep step : steps) {
            SpOper oper = StringUtils.isBlank(step.operId) ? null : operService.getById(step.operId);
            BigDecimal weight = stepWeight(oper);
            opers.add(oper);
            weights.add(weight);
            totalWeight = totalWeight.add(weight);
        }
        if (totalWeight.compareTo(BigDecimal.ZERO) <= 0) {
            totalWeight = new BigDecimal(steps.size());
            Collections.fill(weights, BigDecimal.ONE);
        }

        LocalDate start = parseDate(StringUtils.defaultIfBlank(item.getComputedStartDate(), item.getPlanStartDate()), LocalDate.now());
        LocalDateTime cursor = atShiftStart(start);
        for (int i = 0; i < steps.size(); i++) {
            BigDecimal duration = totalHours.multiply(weights.get(i)).divide(totalWeight, 2, RoundingMode.HALF_UP);
            if (duration.compareTo(BigDecimal.ZERO) <= 0) {
                duration = new BigDecimal("0.10");
            }
            SpProductionOrderOperPlan plan = newPlan(order, item, route.flowId, steps.get(i), opers.get(i), duration);
            plan.setPlanStartTime(cursor.format(DT_FMT));
            cursor = advanceShiftHours(cursor, duration);
            plan.setPlanEndTime(cursor.format(DT_FMT));
            plans.add(plan);
        }
        return plans;
    }

    private BigDecimal stepWeight(SpOper oper) {
        if (oper != null && oper.getManuCycle() != null && oper.getManuCycle().compareTo(BigDecimal.ZERO) > 0) {
            return oper.getManuCycle();
        }
        if (oper != null && oper.getOperHours() != null && oper.getOperHours().compareTo(BigDecimal.ZERO) > 0) {
            return oper.getOperHours();
        }
        return BigDecimal.ONE;
    }

    private SpProductionOrderOperPlan newPlan(SpProductionOrder order, SpProductionOrderItem item,
                                              String flowId, RouteStep step, SpOper oper,
                                              BigDecimal duration) {
        String source;
        if (oper != null && oper.getManuCycle() != null && oper.getManuCycle().compareTo(BigDecimal.ZERO) > 0) {
            source = "MANU_CYCLE";
        } else if (oper != null && oper.getOperHours() != null && oper.getOperHours().compareTo(BigDecimal.ZERO) > 0) {
            source = "OPER_HOURS";
        } else {
            source = "AVERAGE";
        }
        SpProductionOrderOperPlan plan = new SpProductionOrderOperPlan();
        plan.setOrderId(order.getId());
        plan.setOrderItemId(item.getId());
        plan.setOrderNo(order.getOrderNo());
        plan.setProductMateriel(item.getProductMateriel());
        plan.setProductName(item.getProductName());
        plan.setFlowId(flowId);
        plan.setOperId(step.operId);
        plan.setOper(step.oper);
        plan.setOperDesc(oper == null ? step.oper : oper.getOperDesc());
        plan.setSortNum(step.sortNum);
        plan.setUnitId(oper == null ? null : oper.getUnitId());
        plan.setDurationHours(duration.setScale(2, RoundingMode.HALF_UP));
        plan.setDurationSource(source);
        plan.setScheduleMethod(order.getSchedulingMethod());
        plan.setCalcRemark("按" + scheduleName(order.getSchedulingMethod()) + "生成，数量" + item.getQty()
                + "，生产" + productionDays(item) + "工作日"
                + (StringUtils.isBlank(item.getMaterialReadyDate()) ? "" : "，备料日" + item.getMaterialReadyDate()));
        plan.setDeleted("0");
        return plan;
    }

    /** 取离 date 最近（含当日）的工作日 08:00 作为班次起点。 */
    private LocalDateTime atShiftStart(LocalDate date) {
        LocalDate d = date;
        while (!isWorkDay(d)) {
            d = d.plusDays(1);
        }
        return d.atTime(SHIFT_START);
    }

    /** 从 cursor 起按 8h/工作日班次窗口（08:00-16:00，跳周末）推进指定工时后的时刻。 */
    private LocalDateTime advanceShiftHours(LocalDateTime cursor, BigDecimal hours) {
        long remaining = hours.multiply(new BigDecimal("60")).setScale(0, RoundingMode.CEILING).longValue();
        LocalDateTime c = normalizeToShift(cursor);
        while (remaining > 0) {
            LocalDateTime dayEnd = c.toLocalDate().atTime(SHIFT_END);
            long minutesLeft = Duration.between(c, dayEnd).toMinutes();
            if (minutesLeft <= 0) {
                c = atShiftStart(c.toLocalDate().plusDays(1));
                continue;
            }
            long take = Math.min(remaining, minutesLeft);
            c = c.plusMinutes(take);
            remaining -= take;
            if (remaining > 0) {
                c = atShiftStart(c.toLocalDate().plusDays(1));
            }
        }
        return c;
    }

    private LocalDateTime normalizeToShift(LocalDateTime c) {
        if (!isWorkDay(c.toLocalDate()) || c.toLocalTime().isBefore(SHIFT_START)) {
            return atShiftStart(c.toLocalDate());
        }
        if (!c.toLocalTime().isBefore(SHIFT_END)) {
            return atShiftStart(c.toLocalDate().plusDays(1));
        }
        return c;
    }

    private RouteBinding resolveRouteBinding(SpProductionOrderItem item, SpMaterile materile) {
        if (materile != null && StringUtils.isNotBlank(materile.getFlowId())) {
            List<SpFlowOperRelation> relations = flowOperRelationService.list(new QueryWrapper<SpFlowOperRelation>()
                    .eq("flow_id", materile.getFlowId()).orderByAsc("sort_num"));
            if (relations != null && !relations.isEmpty()) {
                List<RouteStep> steps = new ArrayList<>();
                for (SpFlowOperRelation rel : relations) {
                    if (StringUtils.isBlank(rel.getOperId())) {
                        continue;
                    }
                    steps.add(new RouteStep(rel.getOperId(), rel.getOper(), rel.getSortNum()));
                }
                if (!steps.isEmpty()) {
                    return new RouteBinding(materile.getFlowId(), steps);
                }
            }
        }

        if (item == null || StringUtils.isBlank(item.getBomId())) {
            return new RouteBinding("", Collections.emptyList());
        }
        List<SpProcessRoute> routes = processRouteService.list(new QueryWrapper<SpProcessRoute>()
                .eq("bom_id", item.getBomId())
                .eq("is_deleted", "0")
                .eq("lock_status", "locked")
                .isNotNull("oper_id")
                .ne("oper_id", "")
                .orderByAsc("route_code"));
        if (routes == null || routes.isEmpty()) {
            return new RouteBinding("", Collections.emptyList());
        }
        List<RouteStep> steps = new ArrayList<>();
        int sort = 1;
        for (SpProcessRoute route : routes) {
            SpOper oper = operService.getById(route.getOperId());
            steps.add(new RouteStep(route.getOperId(), oper == null ? route.getOperId() : oper.getOper(), sort++));
        }
        return new RouteBinding(item.getBomId(), steps);
    }

    private Result validateLatestBom(SpProductionOrderItem item) {
        SpBom selected = resolveSelectedBom(item);
        if (selected == null) {
            return Result.failure("请为产品物料选择已定版且有效的最新产品BOM：" + StringUtils.defaultString(item.getProductMateriel()));
        }
        SpBom latest = latestBom(selected.getMaterielCode());
        if (latest == null) {
            return Result.failure("产品物料没有已定版且有效的BOM：" + selected.getMaterielCode());
        }
        if (!StringUtils.equals(latest.getId(), selected.getId())) {
            return Result.failure("产品BOM不是最新定版版本：" + selected.getBomCode() + "，最新版本为 " + latest.getBomCode());
        }
        item.setBomId(selected.getId());
        item.setBomCode(selected.getBomCode());
        item.setBomVersion(selected.getVersionNumber());
        item.setProductMateriel(selected.getMaterielCode());
        item.setProductName(selected.getMaterielDesc());
        return null;
    }

    private void fillBomInfo(SpProductionOrderItem item) {
        SpBom bom = resolveSelectedBom(item);
        if (bom == null) {
            return;
        }
        item.setBomId(bom.getId());
        item.setBomCode(bom.getBomCode());
        item.setBomVersion(bom.getVersionNumber());
        item.setProductMateriel(bom.getMaterielCode());
        item.setProductName(bom.getMaterielDesc());
        SpMaterile materile = findMaterile(bom.getMaterielCode());
        if (materile != null) {
            if (StringUtils.isBlank(item.getModel())) {
                item.setModel(materile.getModel());
            }
            if (StringUtils.isBlank(item.getSpecification())) {
                item.setSpecification(materile.getSize());
            }
        }
    }

    private SpBom resolveSelectedBom(SpProductionOrderItem item) {
        if (item == null) {
            return null;
        }
        if (StringUtils.isNotBlank(item.getBomId())) {
            SpBom bom = bomService.getById(item.getBomId());
            return validBom(bom) ? bom : null;
        }
        if (StringUtils.isNotBlank(item.getBomCode())) {
            SpBom bom = bomService.getOne(new QueryWrapper<SpBom>()
                    .eq("bom_code", item.getBomCode()).last("limit 1"), false);
            return validBom(bom) ? bom : null;
        }
        if (StringUtils.isNotBlank(item.getProductMateriel())) {
            return latestBom(item.getProductMateriel());
        }
        return null;
    }

    private SpBom latestBom(String materielCode) {
        if (StringUtils.isBlank(materielCode)) {
            return null;
        }
        return bomService.getOne(new QueryWrapper<SpBom>()
                .eq("materiel_code", materielCode)
                .eq("bom_level", 0)
                .ne("is_deleted", "1")
                .eq("lock_status", "locked")
                .eq("state", "pass")
                .eq("validity", "有效")
                .orderByDesc("version_number")
                .orderByDesc("update_time")
                .last("limit 1"), false);
    }

    private boolean validBom(SpBom bom) {
        return bom != null
                && !"1".equals(bom.getDeleted())
                && Integer.valueOf(0).equals(bom.getBomLevel())
                && "locked".equals(bom.getLockStatus())
                && "pass".equals(bom.getState())
                && "有效".equals(bom.getValidity());
    }

    private SpProductionOrderItem importRowToItem(SpProductionOrderImportDTO row) {
        SpProductionOrderItem item = new SpProductionOrderItem();
        item.setBomCode(StringUtils.trimToEmpty(row.getBomCode()));
        item.setProductMateriel(StringUtils.trimToEmpty(row.getProductMateriel()));
        item.setQty(row.getQty());
        item.setPlanDeliveryDate(trimDate(row.getPlanDeliveryDate()));
        item.setPlanStartDate(trimDate(row.getPlanStartDate()));
        item.setLeadTimeDays(row.getLeadTimeDays());
        item.setTargetCapacity(row.getTargetCapacity());
        item.setConfiguration(row.getConfiguration());
        return item;
    }

    private void normalizeDemandDate(SpProductionOrderItem item) {
        // 逆向：交付日给定，生产跨度=productionDays（不含备料），倒推生产开工日；
        // 备料提前期在开工日之前，得到建议备料日。computedStart 保持=生产开工日，避免 MRP 重复扣提前期。
        LocalDate delivery = parseDate(item.getPlanDeliveryDate(), null);
        if (delivery == null) {
            return;
        }
        LocalDate start = subtractWorkDays(delivery, productionDays(item));
        item.setComputedStartDate(start.toString());
        item.setComputedDeliveryDate(delivery.toString());
        item.setMaterialReadyDate(subtractWorkDays(start, leadDays(item)).toString());
        if (StringUtils.isBlank(item.getPlanStartDate())) {
            item.setPlanStartDate(start.toString());
        }
    }

    private void normalizeForecastDate(SpProductionOrderItem item) {
        // 正向：开工日给定，生产跨度=productionDays（不含备料）顺推完工/交付日；备料提前期在开工日之前。
        LocalDate start = parseDate(item.getPlanStartDate(), LocalDate.now());
        LocalDate delivery = addWorkDays(start, productionDays(item));
        item.setComputedStartDate(start.toString());
        item.setComputedDeliveryDate(delivery.toString());
        item.setMaterialReadyDate(subtractWorkDays(start, leadDays(item)).toString());
        if (StringUtils.isBlank(item.getPlanDeliveryDate())) {
            item.setPlanDeliveryDate(delivery.toString());
        }
    }

    private int leadDays(SpProductionOrderItem item) {
        return item.getLeadTimeDays() == null ? 0 : Math.max(0, item.getLeadTimeDays());
    }

    private int productionDays(SpProductionOrderItem item) {
        BigDecimal capacity = positive(item.getTargetCapacity(), DEFAULT_CAPACITY);
        BigDecimal qty = new BigDecimal(item.getQty() == null ? 0 : item.getQty());
        int days = qty.divide(capacity, 0, RoundingMode.CEILING).intValue();
        return Math.max(1, days);
    }

    private int readLeadTime(String materielCode) {
        SpMaterile materile = findMaterile(materielCode);
        if (materile != null && materile.getLeadTime() != null && materile.getLeadTime() > 0) {
            return materile.getLeadTime();
        }
        return DEFAULT_LEAD_TIME;
    }

    private SpMaterile findMaterile(String materielCode) {
        if (StringUtils.isBlank(materielCode)) {
            return null;
        }
        QueryWrapper<SpMaterile> qw = new QueryWrapper<>();
        qw.eq("materiel", materielCode).ne("is_deleted", "1");
        return materileService.getOne(qw, false);
    }

    private String productName(String materielCode) {
        SpMaterile materile = findMaterile(materielCode);
        return materile == null ? "" : materile.getMaterielDesc();
    }

    private BigDecimal historicalMonthlyAverage(String productMateriel, String customerName) {
        LocalDate begin = LocalDate.now().minusMonths(6).withDayOfMonth(1);
        QueryWrapper<SpProductionOrder> orderQw = new QueryWrapper<>();
        orderQw.eq("source_type", SOURCE_DEMAND)
                .ne("is_deleted", "1")
                .ge("order_date", begin.toString());
        if (StringUtils.isNotBlank(customerName)) {
            orderQw.eq("customer_name", customerName);
        }
        List<SpProductionOrder> orders = list(orderQw);
        if (orders.isEmpty()) {
            return BigDecimal.ZERO;
        }
        Set<String> ids = new HashSet<>();
        for (SpProductionOrder order : orders) {
            ids.add(order.getId());
        }
        QueryWrapper<SpProductionOrderItem> itemQw = new QueryWrapper<>();
        itemQw.in("order_id", ids);
        if (StringUtils.isNotBlank(productMateriel)) {
            itemQw.eq("product_materiel", productMateriel);
        }
        List<SpProductionOrderItem> items = itemService.list(itemQw);

        Map<YearMonth, Integer> qtyByMonth = new LinkedHashMap<>();
        for (int i = 5; i >= 0; i--) {
            qtyByMonth.put(YearMonth.now().minusMonths(i), 0);
        }
        Map<String, SpProductionOrder> orderById = new HashMap<>();
        for (SpProductionOrder order : orders) {
            orderById.put(order.getId(), order);
        }
        for (SpProductionOrderItem item : items) {
            SpProductionOrder order = orderById.get(item.getOrderId());
            LocalDate date = order == null ? null : parseDate(order.getOrderDate(), null);
            if (date == null) {
                continue;
            }
            YearMonth ym = YearMonth.from(date);
            if (qtyByMonth.containsKey(ym)) {
                qtyByMonth.put(ym, qtyByMonth.get(ym) + (item.getQty() == null ? 0 : item.getQty()));
            }
        }
        int total = 0;
        for (Integer qty : qtyByMonth.values()) {
            total += qty == null ? 0 : qty;
        }
        return new BigDecimal(total).divide(new BigDecimal("6"), 2, RoundingMode.HALF_UP);
    }

    private SpProductionOrder getActiveOrder(String id) {
        if (StringUtils.isBlank(id)) {
            return null;
        }
        SpProductionOrder order = getById(id);
        if (order == null || "1".equals(order.getDeleted())) {
            return null;
        }
        normalizeStatusForView(order);
        return order;
    }

    private boolean existsErpOrder(String erpNo) {
        return count(new QueryWrapper<SpProductionOrder>()
                .eq("erp_source_no", erpNo)
                .ne("is_deleted", "1")) > 0;
    }

    private String normalizeSourceType(String value) {
        String v = StringUtils.trimToEmpty(value).toUpperCase();
        if ("FORECAST".equals(v) || "预测订单".equals(value)) {
            return SOURCE_FORECAST;
        }
        return SOURCE_DEMAND;
    }

    private String normalizeScheduling(String value, String sourceType) {
        String v = StringUtils.trimToEmpty(value).toUpperCase();
        if ("FORWARD".equals(v) || "正向排产".equals(value)) {
            return SCHEDULE_FORWARD;
        }
        if ("REVERSE".equals(v) || "逆向排产".equals(value)) {
            return SCHEDULE_REVERSE;
        }
        return SOURCE_FORECAST.equals(sourceType) ? SCHEDULE_FORWARD : SCHEDULE_REVERSE;
    }

    private String scheduleName(String value) {
        return SCHEDULE_FORWARD.equals(value) ? "正向排产" : "逆向排产";
    }

    private String nextWorkOrderCode() {
        return "WO" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
                + (System.currentTimeMillis() % 1000);
    }

    private String toDateTime(String date) {
        if (StringUtils.isBlank(date)) {
            return LocalDate.now().toString() + " 00:00:00";
        }
        return date.length() <= 10 ? date + " 00:00:00" : date;
    }

    private LocalDate parseDate(String value, LocalDate fallback) {
        if (StringUtils.isBlank(value)) {
            return fallback;
        }
        String v = value.trim();
        if (v.length() > 10) {
            v = v.substring(0, 10);
        }
        try {
            return LocalDate.parse(v);
        } catch (Exception ignore) {
            return fallback;
        }
    }

    private String trimDate(String value) {
        if (StringUtils.isBlank(value)) {
            return "";
        }
        String v = value.trim();
        return v.length() > 10 ? v.substring(0, 10) : v;
    }

    private LocalDate addWorkDays(LocalDate date, int days) {
        LocalDate result = date;
        int left = Math.max(0, days);
        while (left > 0) {
            result = result.plusDays(1);
            if (isWorkDay(result)) {
                left--;
            }
        }
        return result;
    }

    private LocalDate subtractWorkDays(LocalDate date, int days) {
        LocalDate result = date;
        int left = Math.max(0, days);
        while (left > 0) {
            result = result.minusDays(1);
            if (isWorkDay(result)) {
                left--;
            }
        }
        return result;
    }

    private boolean isWorkDay(LocalDate date) {
        return date.getDayOfWeek().getValue() < 6;
    }

    private BigDecimal positive(BigDecimal value, BigDecimal fallback) {
        if (value == null || value.compareTo(BigDecimal.ZERO) <= 0) {
            return fallback;
        }
        return value;
    }

    private BigDecimal pow(BigDecimal base, int exponent) {
        BigDecimal result = BigDecimal.ONE;
        for (int i = 0; i < exponent; i++) {
            result = result.multiply(base);
        }
        return result;
    }

    private String displayUsername(SysUser user) {
        if (user == null) {
            return "";
        }
        return StringUtils.defaultIfBlank(user.getName(), user.getUsername());
    }

    private String now() {
        return LocalDateTime.now().format(DT_FMT);
    }

    private static class RouteBinding {
        private final String flowId;
        private final List<RouteStep> steps;

        private RouteBinding(String flowId, List<RouteStep> steps) {
            this.flowId = flowId;
            this.steps = steps == null ? Collections.emptyList() : steps;
        }
    }

    private static class RouteStep {
        private final String operId;
        private final String oper;
        private final Integer sortNum;

        private RouteStep(String operId, String oper, Integer sortNum) {
            this.operId = operId;
            this.oper = oper;
            this.sortNum = sortNum;
        }
    }
}
