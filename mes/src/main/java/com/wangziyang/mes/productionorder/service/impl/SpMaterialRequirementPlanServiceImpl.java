package com.wangziyang.mes.productionorder.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpInventory;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.service.ISpInventoryService;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.productionorder.entity.SpMaterialInboundRequest;
import com.wangziyang.mes.productionorder.entity.SpMaterialInboundRequestItem;
import com.wangziyang.mes.productionorder.entity.SpMaterialRequirementPlan;
import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;
import com.wangziyang.mes.productionorder.mapper.SpMaterialRequirementPlanMapper;
import com.wangziyang.mes.productionorder.request.SpMaterialRequirementPlanReq;
import com.wangziyang.mes.productionorder.service.ISpMaterialInboundRequestItemService;
import com.wangziyang.mes.productionorder.service.ISpMaterialInboundRequestService;
import com.wangziyang.mes.productionorder.service.ISpMaterialRequirementPlanService;
import com.wangziyang.mes.productionorder.service.ISpProductionOrderService;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.technology.entity.SpBom;
import com.wangziyang.mes.technology.entity.SpBomItem;
import com.wangziyang.mes.technology.service.ISpBomItemService;
import com.wangziyang.mes.technology.service.ISpBomService;
import com.wangziyang.mes.warehouse.WarehouseConstants;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Material requirement planning service implementation.
 */
@Service
public class SpMaterialRequirementPlanServiceImpl
        extends ServiceImpl<SpMaterialRequirementPlanMapper, SpMaterialRequirementPlan>
        implements ISpMaterialRequirementPlanService {

    public static final String DELIVERY_WAIT = "WAIT";
    public static final String DELIVERY_RELEASED = "RELEASED";
    public static final String INBOUND_NONE = "NONE";
    public static final String INBOUND_GENERATED = "GENERATED";
    public static final String OUTBOUND_NONE = "NONE";
    public static final String OUTBOUND_GENERATED = "GENERATED";
    public static final String OUTBOUND_CONFIRMED = "CONFIRMED";
    public static final String MRP_NONE = "NONE";
    public static final String MRP_CALCULATED = "CALCULATED";
    public static final String MRP_COMPLETED = "COMPLETED";
    public static final String REQUEST_GENERATED = "GENERATED";
    public static final String REQUEST_CONFIRMED = "CONFIRMED";

    private static final int DEFAULT_LEAD_TIME = 1;
    private static final DateTimeFormatter DT_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter DAY_FMT = DateTimeFormatter.ofPattern("yyyyMMdd");

    @Autowired
    private ISpProductionOrderService productionOrderService;

    @Autowired
    private ISpBomService bomService;

    @Autowired
    private ISpBomItemService bomItemService;

    @Autowired
    private ISpMaterileService materileService;

    @Autowired
    private ISpInventoryService inventoryService;

    @Autowired
    private ISpMaterialInboundRequestService inboundRequestService;

    @Autowired
    private ISpMaterialInboundRequestItemService inboundRequestItemService;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result calculate(String productionOrderId, SysUser user) {
        SpProductionOrder order = productionOrderService.getById(productionOrderId);
        if (order == null || "1".equals(order.getDeleted())) {
            return Result.failure("生产订单不存在");
        }
        if (!SpProductionOrderServiceImpl.APPROVAL_APPROVED.equals(order.getApprovalStatus())) {
            return Result.failure("只有审批完成的生产订单可以执行MRP运算");
        }
        if (!SpProductionOrderServiceImpl.OP_ASSIGNED.equals(order.getOperationStatus())) {
            return Result.failure("设备和员工作业派工全部完成后才能执行MRP运算");
        }
        boolean dispatched = SpProductionOrderServiceImpl.OP_DISPATCHED.equals(order.getOperationStatus());
        long activePlanCount = count(activePlanQuery().eq("production_order_id", productionOrderId));
        if (dispatched && activePlanCount > 0) {
            return Result.failure("已正式下发的生产订单不能重新执行MRP运算");
        }
        List<SpProductionOrderItem> items = productionOrderService.listItems(productionOrderId);
        if (items == null || items.isEmpty()) {
            return Result.failure("生产订单明细为空");
        }

        String batchNo = "MRP" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"))
                + (System.currentTimeMillis() % 1000);
        String calcTime = LocalDateTime.now().format(DT_FMT);
        Map<String, RequirementDraft> drafts = new LinkedHashMap<>();
        for (int i = 0; i < items.size(); i++) {
            SpProductionOrderItem item = items.get(i);
            SpBom bom = resolveSelectedBom(item);
            if (bom == null) {
                return Result.failure("产品物料没有已定版且有效的BOM：" + StringUtils.defaultString(item.getProductMateriel()));
            }
            LocalDate requirementDate = readRequirementDate(item);
            BigDecimal qty = new BigDecimal(item.getQty() == null ? 0 : item.getQty());
            String serialNo = productSerialNo(order.getOrderNo(), i + 1);
            String rootPath = bom.getBomCode() + "(" + bom.getMaterielCode() + ")";
            expandBom(order, item, serialNo, bom, qty, requirementDate, 1, rootPath, drafts, new HashSet<String>());
        }
        if (drafts.isEmpty()) {
            return Result.failure("BOM中没有可生成物料需求计划的子项");
        }

        UpdateWrapper<SpMaterialRequirementPlan> uw = new UpdateWrapper<>();
        uw.eq("production_order_id", productionOrderId)
                .eq("is_deleted", "0")
                .set("is_deleted", "1")
                .set("remark", "MRP重新运算作废");
        update(uw);

        List<SpMaterialRequirementPlan> plans = new ArrayList<>();
        for (RequirementDraft draft : drafts.values()) {
            SpMaterialRequirementPlan plan = toPlan(draft, batchNo, calcTime);
            plans.add(plan);
        }
        saveBatch(plans);

        Map<String, Object> data = new HashMap<>();
        data.put("batchNo", batchNo);
        data.put("lineCount", plans.size());
        return Result.success(data, "MRP运算完成，已生成物料需求计划");
    }

    @Override
    public IPage<SpMaterialRequirementPlan> pageList(SpMaterialRequirementPlanReq req) {
        if (req == null) {
            req = new SpMaterialRequirementPlanReq();
        }
        return baseMapper.pageList(new Page<SpMaterialRequirementPlan>(req.getCurrent(), req.getSize()), req);
    }

    @Override
    public IPage<Map<String, Object>> weekSummary(SpMaterialRequirementPlanReq req) {
        if (req == null) {
            req = new SpMaterialRequirementPlanReq();
        }
        List<Map<String, Object>> rows = baseMapper.weekSummary(req);
        long current = req.getCurrent() <= 0 ? 1 : req.getCurrent();
        long size = req.getSize() <= 0 ? 10 : req.getSize();
        int from = (int) Math.min(rows.size(), (current - 1) * size);
        int to = (int) Math.min(rows.size(), from + size);
        Page<Map<String, Object>> page = new Page<Map<String, Object>>(current, size);
        page.setTotal(rows.size());
        page.setRecords(rows.subList(from, to));
        return page;
    }

    @Override
    public Map<String, Object> dashboard(SpMaterialRequirementPlanReq req) {
        QueryWrapper<SpMaterialRequirementPlan> qw = filteredMaterialPlanQuery(req);
        List<SpMaterialRequirementPlan> rows = list(qw);
        Map<String, Object> data = new HashMap<>();
        BigDecimal gross = BigDecimal.ZERO;
        BigDecimal net = BigDecimal.ZERO;
        int wait = 0;
        int released = 0;
        int inbound = 0;
        int outboundPending = 0;
        int outboundGenerated = 0;
        int outboundConfirmed = 0;
        Set<String> orders = new HashSet<>();
        for (SpMaterialRequirementPlan row : rows) {
            gross = gross.add(nvl(row.getGrossRequirement()));
            net = net.add(currentNetRequirement(row));
            if (DELIVERY_RELEASED.equals(row.getDeliveryStatus())) {
                released++;
            } else {
                wait++;
            }
            if (INBOUND_GENERATED.equals(row.getInboundStatus())) {
                inbound++;
            }
            if (OUTBOUND_CONFIRMED.equals(row.getOutboundStatus())) {
                outboundConfirmed++;
            } else if (OUTBOUND_GENERATED.equals(row.getOutboundStatus())) {
                outboundGenerated++;
            } else {
                outboundPending++;
            }
            if (StringUtils.isNotBlank(row.getProductionOrderId())) {
                orders.add(row.getProductionOrderId());
            }
        }
        data.put("lineCount", rows.size());
        data.put("orderCount", orders.size());
        data.put("grossRequirement", gross);
        data.put("netRequirement", net);
        data.put("waitRelease", wait);
        data.put("released", released);
        data.put("inboundGenerated", inbound);
        data.put("outboundPending", outboundPending);
        data.put("outboundGenerated", outboundGenerated);
        data.put("outboundConfirmed", outboundConfirmed);
        return data;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result release(List<String> ids) {
        List<SpMaterialRequirementPlan> rows = selectedRows(ids);
        if (rows.isEmpty()) {
            return Result.failure("请选择要下发的物料需求计划");
        }
        int count = 0;
        for (SpMaterialRequirementPlan row : rows) {
            if (DELIVERY_RELEASED.equals(row.getDeliveryStatus())) {
                continue;
            }
            row.setDeliveryStatus(DELIVERY_RELEASED);
            updateById(row);
            count++;
        }
        if (count == 0) {
            return Result.failure("所选物料需求计划均已下发");
        }
        return Result.success(count, "物料需求计划已下发");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result generateInboundRequest(List<String> ids, SysUser user) {
        refreshInventorySnapshot(ids);
        List<SpMaterialRequirementPlan> rows = selectedRows(ids);
        if (rows.isEmpty()) {
            return Result.failure("请选择要生成入库申请单的物料需求计划");
        }
        Map<String, List<SpMaterialRequirementPlan>> group = new LinkedHashMap<>();
        for (SpMaterialRequirementPlan row : rows) {
            if (!DELIVERY_RELEASED.equals(row.getDeliveryStatus())) {
                return Result.failure("请先下发物料需求计划：" + row.getMaterialCode());
            }
            if (INBOUND_GENERATED.equals(row.getInboundStatus())) {
                return Result.failure("已生成入库申请单，不能重复生成：" + row.getMaterialCode());
            }
            String key = row.getProductionOrderId() + "::" + row.getCalcBatchNo();
            if (!group.containsKey(key)) {
                group.put(key, new ArrayList<SpMaterialRequirementPlan>());
            }
            group.get(key).add(row);
        }

        List<String> requestNos = new ArrayList<>();
        int itemCount = 0;
        for (List<SpMaterialRequirementPlan> groupRows : group.values()) {
            SpMaterialRequirementPlan first = groupRows.get(0);
            SpMaterialInboundRequest request = new SpMaterialInboundRequest();
            request.setRequestNo(nextInboundRequestNo());
            request.setProductionOrderId(first.getProductionOrderId());
            request.setProductionOrderNo(first.getProductionOrderNo());
            request.setSourceBatchNo(first.getCalcBatchNo());
            request.setStatus(REQUEST_GENERATED);
            request.setItemCount(groupRows.size());
            request.setDeleted("0");
            BigDecimal total = BigDecimal.ZERO;
            for (SpMaterialRequirementPlan row : groupRows) {
                total = total.add(nvl(row.getNetRequirement()));
            }
            request.setTotalNetQty(total);
            request.setRemark("由MRP物料需求计划生成");
            inboundRequestService.save(request);
            requestNos.add(request.getRequestNo());

            for (SpMaterialRequirementPlan row : groupRows) {
                SpMaterialInboundRequestItem item = new SpMaterialInboundRequestItem();
                item.setRequestId(request.getId());
                item.setRequestNo(request.getRequestNo());
                item.setPlanId(row.getId());
                item.setProductionOrderId(row.getProductionOrderId());
                item.setProductionOrderNo(row.getProductionOrderNo());
                item.setMaterialId(row.getMaterialId());
                item.setMaterialCode(row.getMaterialCode());
                item.setMaterialName(row.getMaterialName());
                item.setUnit(row.getUnit());
                item.setRequestQty(row.getNetRequirement());
                item.setRequirementDate(row.getRequirementDate());
                item.setReleaseDate(row.getReleaseDate());
                item.setDeleted("0");
                inboundRequestItemService.save(item);

                row.setInboundStatus(INBOUND_GENERATED);
                row.setInboundRequestId(request.getId());
                row.setInboundRequestNo(request.getRequestNo());
                updateById(row);
                itemCount++;
            }
        }

        Map<String, Object> data = new HashMap<>();
        data.put("requestNos", requestNos);
        data.put("itemCount", itemCount);
        return Result.success(data, "入库申请单已生成");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void refreshInventorySnapshot(List<String> ids) {
        if (ids == null || ids.isEmpty()) {
            return;
        }
        List<SpMaterialRequirementPlan> rows = list(activePlanQuery().in("id", ids));
        for (SpMaterialRequirementPlan row : rows) {
            refreshInventorySnapshot(row);
            updateById(row);
        }
    }

    @Override
    public void enrichProductionOrders(List<SpProductionOrder> orders) {
        if (orders == null || orders.isEmpty()) {
            return;
        }
        for (SpProductionOrder order : orders) {
            QueryWrapper<SpMaterialRequirementPlan> qw = activePlanQuery()
                    .eq("production_order_id", order.getId());
            qw.isNotNull("material_id").ne("material_id", "");
            List<SpMaterialRequirementPlan> rows = list(qw);
            order.setMrpPlanCount(rows.size());
            if (rows.isEmpty()) {
                order.setMrpStatus(MRP_NONE);
                order.setMrpCalcTime("");
                continue;
            }
            String calcTime = "";
            boolean allOutboundDone = true;
            for (SpMaterialRequirementPlan row : rows) {
                if (StringUtils.compare(StringUtils.defaultString(row.getCalcTime()), calcTime) > 0) {
                    calcTime = row.getCalcTime();
                }
                if (nvl(row.getNetRequirement()).compareTo(BigDecimal.ZERO) > 0
                        && !OUTBOUND_CONFIRMED.equals(row.getOutboundStatus())) {
                    allOutboundDone = false;
                }
            }
            order.setMrpCalcTime(calcTime);
            order.setMrpStatus(allOutboundDone ? MRP_COMPLETED : MRP_CALCULATED);
        }
    }

    @Override
    public boolean isProductionOrderMrpCompleted(String productionOrderId) {
        if (StringUtils.isBlank(productionOrderId)) {
            return false;
        }
        List<SpMaterialRequirementPlan> rows = list(activeMaterialPlanQuery().eq("production_order_id", productionOrderId));
        if (rows.isEmpty()) {
            return false;
        }
        for (SpMaterialRequirementPlan row : rows) {
            if (nvl(row.getNetRequirement()).compareTo(BigDecimal.ZERO) > 0
                    && !OUTBOUND_CONFIRMED.equals(row.getOutboundStatus())) {
                return false;
            }
        }
        return true;
    }

    private void expandBom(SpProductionOrder order,
                           SpProductionOrderItem orderItem,
                           String serialNo,
                           SpBom bom,
                           BigDecimal factor,
                           LocalDate requirementDate,
                           int level,
                           String path,
                           Map<String, RequirementDraft> drafts,
                           Set<String> bomStack) {
        if (bom == null || StringUtils.isBlank(bom.getId()) || bomStack.contains(bom.getId())) {
            return;
        }
        bomStack.add(bom.getId());
        List<SpBomItem> items = bomItemService.list(new QueryWrapper<SpBomItem>()
                .eq("bom_head_id", bom.getId())
                .orderByAsc("line_no"));
        for (SpBomItem item : items) {
            if (StringUtils.isBlank(item.getMaterielItemCode())) {
                continue;
            }
            BigDecimal usage = item.getItemNum() == null ? BigDecimal.ZERO : item.getItemNum();
            BigDecimal gross = factor.multiply(usage);
            String materialCode = item.getMaterielItemCode();
            String nextPath = path + " > " + materialCode;
            SpBom childBom = resolveChildBom(item);
            if (childBom != null) {
                expandBom(order, orderItem, serialNo, childBom, gross, requirementDate,
                        level + 1, nextPath, drafts, new HashSet<String>(bomStack));
                continue;
            }
            String key = order.getId() + "::" + materialCode + "::" + requirementDate;
            RequirementDraft draft = drafts.get(key);
            if (draft == null) {
                draft = new RequirementDraft();
                draft.order = order;
                draft.orderItem = orderItem;
                draft.productSerialNo = serialNo;
                draft.materialCode = materialCode;
                draft.materialName = item.getMaterielItemDesc();
                draft.unit = item.getItemUnit();
                draft.requirementDate = requirementDate;
                draft.bomLevel = level;
                draft.bomPath = nextPath;
                drafts.put(key, draft);
            } else {
                draft.bomLevel = Math.min(draft.bomLevel, level);
                if (StringUtils.length(draft.bomPath) < 900 && !StringUtils.contains(draft.bomPath, nextPath)) {
                    draft.bomPath = draft.bomPath + " | " + nextPath;
                }
            }
            draft.grossRequirement = draft.grossRequirement.add(gross);
        }
    }

    private SpMaterialRequirementPlan toPlan(RequirementDraft draft, String batchNo, String calcTime) {
        SpMaterile material = findMaterile(draft.materialCode);
        BigDecimal available = availableStock(material);
        BigDecimal safety = material == null || material.getSafetyStock() == null
                ? BigDecimal.ZERO : new BigDecimal(material.getSafetyStock());
        int leadTime = material == null || material.getLeadTime() == null || material.getLeadTime() < 1
                ? DEFAULT_LEAD_TIME : material.getLeadTime();
        BigDecimal net = draft.grossRequirement.subtract(available).add(safety);
        if (net.compareTo(BigDecimal.ZERO) < 0) {
            net = BigDecimal.ZERO;
        }

        SpMaterialRequirementPlan plan = new SpMaterialRequirementPlan();
        plan.setProductionOrderId(draft.order.getId());
        plan.setProductionOrderNo(draft.order.getOrderNo());
        plan.setOrderItemId(draft.orderItem.getId());
        plan.setProductSerialNo(draft.productSerialNo);
        plan.setProductMateriel(draft.orderItem.getProductMateriel());
        plan.setProductName(draft.orderItem.getProductName());
        plan.setMaterialId(material == null ? null : material.getId());
        plan.setMaterialCode(draft.materialCode);
        plan.setMaterialName(StringUtils.defaultIfBlank(material == null ? null : material.getMaterielDesc(), draft.materialName));
        plan.setMaterialType(material == null ? null : material.getMatType());
        plan.setMaterialSource(material == null ? null : material.getMatSource());
        plan.setUnit(StringUtils.defaultIfBlank(material == null ? null : material.getUnit(), draft.unit));
        plan.setBomLevel(draft.bomLevel);
        plan.setBomPath(StringUtils.abbreviate(draft.bomPath, 1000));
        plan.setGrossRequirement(draft.grossRequirement.setScale(2, BigDecimal.ROUND_HALF_UP));
        plan.setAvailableStock(available.setScale(2, BigDecimal.ROUND_HALF_UP));
        plan.setSafetyStock(safety.setScale(2, BigDecimal.ROUND_HALF_UP));
        plan.setNetRequirement(net.setScale(2, BigDecimal.ROUND_HALF_UP));
        plan.setRequirementDate(draft.requirementDate.toString());
        plan.setLeadTimeDays(leadTime);
        plan.setReleaseDate(subtractWorkDays(draft.requirementDate, leadTime).toString());
        plan.setDeliveryStatus(DELIVERY_WAIT);
        plan.setInboundStatus(INBOUND_NONE);
        plan.setOutboundStatus(OUTBOUND_NONE);
        plan.setCalcBatchNo(batchNo);
        plan.setCalcTime(calcTime);
        plan.setDeleted("0");
        return plan;
    }

    private List<SpMaterialRequirementPlan> selectedRows(List<String> ids) {
        if (ids == null || ids.isEmpty()) {
            return new ArrayList<SpMaterialRequirementPlan>();
        }
        return list(activeMaterialPlanQuery().in("id", ids));
    }

    private QueryWrapper<SpMaterialRequirementPlan> activePlanQuery() {
        return new QueryWrapper<SpMaterialRequirementPlan>().eq("is_deleted", "0");
    }

    private QueryWrapper<SpMaterialRequirementPlan> activeMaterialPlanQuery() {
        return activePlanQuery().isNotNull("material_id").ne("material_id", "");
    }

    private QueryWrapper<SpMaterialRequirementPlan> filteredMaterialPlanQuery(SpMaterialRequirementPlanReq req) {
        QueryWrapper<SpMaterialRequirementPlan> qw = activeMaterialPlanQuery();
        if (req == null) {
            return qw;
        }
        if (StringUtils.isNotBlank(req.getProductionOrderNoLike())) {
            qw.like("production_order_no", req.getProductionOrderNoLike());
        }
        if (StringUtils.isNotBlank(req.getProductLike())) {
            qw.and(w -> w.like("product_materiel", req.getProductLike())
                    .or().like("product_name", req.getProductLike())
                    .or().like("product_serial_no", req.getProductLike()));
        }
        if (StringUtils.isNotBlank(req.getMaterialLike())) {
            qw.and(w -> w.like("material_code", req.getMaterialLike())
                    .or().like("material_name", req.getMaterialLike()));
        }
        if (StringUtils.isNotBlank(req.getDeliveryStatus())) {
            qw.eq("delivery_status", req.getDeliveryStatus());
        }
        if (StringUtils.isNotBlank(req.getInboundStatus())) {
            qw.eq("inbound_status", req.getInboundStatus());
        }
        if (StringUtils.isNotBlank(req.getOutboundStatus())) {
            qw.eq("outbound_status", req.getOutboundStatus());
        }
        if (StringUtils.isNotBlank(req.getMaterialSource())) {
            qw.eq("material_source", req.getMaterialSource());
        }
        if (StringUtils.isNotBlank(req.getRequirementDateBegin())) {
            qw.ge("requirement_date", req.getRequirementDateBegin());
        }
        if (StringUtils.isNotBlank(req.getRequirementDateEnd())) {
            qw.le("requirement_date", req.getRequirementDateEnd());
        }
        return qw;
    }

    private SpBom resolveSelectedBom(SpProductionOrderItem item) {
        if (item == null) {
            return null;
        }
        SpBom bom = null;
        if (StringUtils.isNotBlank(item.getBomId())) {
            bom = bomService.getById(item.getBomId());
        }
        if (!validBom(bom) && StringUtils.isNotBlank(item.getBomCode())) {
            bom = bomService.getOne(new QueryWrapper<SpBom>()
                    .eq("bom_code", item.getBomCode())
                    .last("limit 1"), false);
        }
        if (!validBom(bom)) {
            bom = latestBom(item.getProductMateriel());
        }
        return validBom(bom) ? bom : null;
    }

    private SpBom resolveChildBom(SpBomItem item) {
        SpBom bom = null;
        if (StringUtils.isNotBlank(item.getChildBomId())) {
            bom = bomService.getById(item.getChildBomId());
        }
        if (!validBom(bom)) {
            bom = latestBom(item.getMaterielItemCode());
        }
        return validBom(bom) ? bom : null;
    }

    private SpBom latestBom(String materialCode) {
        if (StringUtils.isBlank(materialCode)) {
            return null;
        }
        return bomService.getOne(new QueryWrapper<SpBom>()
                .eq("materiel_code", materialCode)
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
                && "locked".equals(bom.getLockStatus())
                && "pass".equals(bom.getState())
                && "有效".equals(bom.getValidity());
    }

    private SpMaterile findMaterile(String materialCode) {
        if (StringUtils.isBlank(materialCode)) {
            return null;
        }
        return materileService.getOne(new QueryWrapper<SpMaterile>()
                .eq("materiel", materialCode)
                .ne("is_deleted", "1")
                .last("limit 1"), false);
    }

    private BigDecimal availableStock(SpMaterile material) {
        if (material == null || StringUtils.isBlank(material.getId())) {
            return BigDecimal.ZERO;
        }
        List<SpInventory> rows = inventoryService.list(new QueryWrapper<SpInventory>()
                .eq("materiel_id", material.getId())
                .eq("is_deleted", "0")
                .eq("stock_status", WarehouseConstants.STOCK_AVAILABLE)
                .gt("qty", BigDecimal.ZERO));
        BigDecimal total = BigDecimal.ZERO;
        for (SpInventory row : rows) {
            total = total.add(nvl(row.getQty()));
        }
        return total;
    }

    private void refreshInventorySnapshot(SpMaterialRequirementPlan row) {
        if (row == null) {
            return;
        }
        SpMaterile material = resolvePlanMaterial(row);
        BigDecimal available = availableStock(material);
        row.setAvailableStock(available.setScale(2, BigDecimal.ROUND_HALF_UP));
        row.setNetRequirement(calculateNetRequirement(row, available).setScale(2, BigDecimal.ROUND_HALF_UP));
        if (material != null && StringUtils.isBlank(row.getMaterialId())) {
            row.setMaterialId(material.getId());
        }
    }

    private BigDecimal currentNetRequirement(SpMaterialRequirementPlan row) {
        if (row == null) {
            return BigDecimal.ZERO;
        }
        return calculateNetRequirement(row, availableStock(resolvePlanMaterial(row)));
    }

    private BigDecimal calculateNetRequirement(SpMaterialRequirementPlan row, BigDecimal available) {
        BigDecimal net = nvl(row.getGrossRequirement()).add(nvl(row.getSafetyStock())).subtract(nvl(available));
        return net.compareTo(BigDecimal.ZERO) < 0 ? BigDecimal.ZERO : net;
    }

    private SpMaterile resolvePlanMaterial(SpMaterialRequirementPlan row) {
        if (row == null) {
            return null;
        }
        if (StringUtils.isNotBlank(row.getMaterialId())) {
            SpMaterile material = materileService.getById(row.getMaterialId());
            if (material != null
                    && !"1".equals(material.getDeleted())
                    && !"00".equals(material.getDeleted())
                    && !"2".equals(material.getDeleted())
                    && !"02".equals(material.getDeleted())) {
                return material;
            }
        }
        return findMaterile(row.getMaterialCode());
    }

    private LocalDate readRequirementDate(SpProductionOrderItem item) {
        LocalDate date = parseDate(item.getComputedStartDate(), null);
        if (date != null) {
            return date;
        }
        date = parseDate(item.getPlanStartDate(), null);
        if (date != null) {
            return date;
        }
        date = parseDate(item.getPlanDeliveryDate(), null);
        return date == null ? LocalDate.now() : date;
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

    private LocalDate subtractWorkDays(LocalDate date, int days) {
        LocalDate result = date;
        int left = Math.max(0, days);
        while (left > 0) {
            result = result.minusDays(1);
            if (result.getDayOfWeek().getValue() < 6) {
                left--;
            }
        }
        return result;
    }

    private BigDecimal nvl(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }

    private String productSerialNo(String orderNo, int seq) {
        return StringUtils.defaultString(orderNo, "PO") + "-SN" + String.format("%03d", seq);
    }

    private String nextInboundRequestNo() {
        return "IR" + LocalDate.now().format(DAY_FMT) + System.currentTimeMillis() % 100000;
    }

    private static class RequirementDraft {
        private SpProductionOrder order;
        private SpProductionOrderItem orderItem;
        private String productSerialNo;
        private String materialCode;
        private String materialName;
        private String unit;
        private Integer bomLevel;
        private String bomPath;
        private BigDecimal grossRequirement = BigDecimal.ZERO;
        private LocalDate requirementDate;
    }
}
