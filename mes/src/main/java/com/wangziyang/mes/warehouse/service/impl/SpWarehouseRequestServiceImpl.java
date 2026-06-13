package com.wangziyang.mes.warehouse.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.wangziyang.mes.basedata.entity.SpInventory;
import com.wangziyang.mes.basedata.entity.SpMaterile;
import com.wangziyang.mes.basedata.entity.SpWarehouse;
import com.wangziyang.mes.basedata.entity.SpWarehouseLocation;
import com.wangziyang.mes.basedata.service.ISpInventoryService;
import com.wangziyang.mes.basedata.service.ISpMaterileService;
import com.wangziyang.mes.basedata.service.ISpWarehouseLocationService;
import com.wangziyang.mes.basedata.service.ISpWarehouseService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.productionorder.entity.SpMaterialInboundRequest;
import com.wangziyang.mes.productionorder.entity.SpMaterialInboundRequestItem;
import com.wangziyang.mes.productionorder.entity.SpMaterialRequirementPlan;
import com.wangziyang.mes.productionorder.service.ISpMaterialInboundRequestItemService;
import com.wangziyang.mes.productionorder.service.ISpMaterialInboundRequestService;
import com.wangziyang.mes.productionorder.service.ISpMaterialRequirementPlanService;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.warehouse.WarehouseConstants;
import com.wangziyang.mes.warehouse.entity.SpWarehouseRequest;
import com.wangziyang.mes.warehouse.entity.SpWarehouseRequestAllocation;
import com.wangziyang.mes.warehouse.entity.SpWarehouseRequestItem;
import com.wangziyang.mes.warehouse.entity.SpWarehouseTransaction;
import com.wangziyang.mes.warehouse.mapper.SpWarehouseRequestAllocationMapper;
import com.wangziyang.mes.warehouse.mapper.SpWarehouseRequestMapper;
import com.wangziyang.mes.warehouse.mapper.SpWarehouseRequestItemMapper;
import com.wangziyang.mes.warehouse.request.SpWarehouseApplyReq;
import com.wangziyang.mes.warehouse.request.SpWarehouseConfirmReq;
import com.wangziyang.mes.warehouse.request.SpWarehouseRequestReq;
import com.wangziyang.mes.warehouse.service.ISpWarehouseRequestItemService;
import com.wangziyang.mes.warehouse.service.ISpWarehouseRequestService;
import com.wangziyang.mes.warehouse.service.ISpWarehouseTransactionService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class SpWarehouseRequestServiceImpl
        extends ServiceImpl<SpWarehouseRequestMapper, SpWarehouseRequest>
        implements ISpWarehouseRequestService {

    private static final DateTimeFormatter DAY_FMT = DateTimeFormatter.ofPattern("yyyyMMdd");
    private static final DateTimeFormatter TIME_FMT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Autowired
    private ISpWarehouseRequestItemService itemService;
    @Autowired
    private SpWarehouseRequestItemMapper itemMapper;
    @Autowired
    private SpWarehouseRequestAllocationMapper allocationMapper;
    @Autowired
    private ISpWarehouseTransactionService transactionService;
    @Autowired
    private ISpInventoryService inventoryService;
    @Autowired
    private ISpMaterileService materileService;
    @Autowired
    private ISpWarehouseService warehouseService;
    @Autowired
    private ISpWarehouseLocationService locationService;
    @Autowired
    private ISpMaterialInboundRequestService planInboundService;
    @Autowired
    private ISpMaterialInboundRequestItemService planInboundItemService;
    @Autowired
    private ISpMaterialRequirementPlanService materialPlanService;

    @Override
    public IPage<SpWarehouseRequest> pageList(SpWarehouseRequestReq req) {
        if (req == null) {
            req = new SpWarehouseRequestReq();
        }
        if (WarehouseConstants.BUSINESS_PLAN_IN.equals(req.getBusinessType())) {
            syncPlanInboundRequests();
        }
        return baseMapper.pageList(new Page<SpWarehouseRequest>(req.getCurrent(), req.getSize()), req);
    }

    @Override
    public IPage<SpWarehouseRequestItem> pageItems(SpWarehouseRequestReq req) {
        if (req == null) {
            req = new SpWarehouseRequestReq();
        }
        return itemMapper.pageItems(new Page<SpWarehouseRequestItem>(req.getCurrent(), req.getSize()), req);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result apply(SpWarehouseApplyReq req, SysUser user) {
        if (req == null) {
            return Result.failure("鐢宠鍙傛暟涓嶈兘涓虹┖");
        }
        if (!WarehouseConstants.BUSINESS_MANUAL_IN.equals(req.getBusinessType())
                && !WarehouseConstants.BUSINESS_MANUAL_OUT.equals(req.getBusinessType())) {
            return Result.failure("鎵嬪伐鐢宠鍙敮鎸佹墜宸ュ叆搴撴垨鎵嬪伐鍑哄簱");
        }
        Result check = validateLocation(req.getWarehouseId(), req.getLocationId());
        if (!ok(check)) {
            return check;
        }
        SpMaterile material = materileService.getById(req.getMaterialId());
        if (material == null || "1".equals(material.getDeleted()) || "00".equals(material.getDeleted())) {
            return Result.failure("请选择有效物料");
        }
        BigDecimal qty = nvl(req.getQty());
        if (qty.compareTo(BigDecimal.ZERO) <= 0) {
            return Result.failure("鐢宠鏁伴噺蹇呴』澶т簬0");
        }
        if (WarehouseConstants.BUSINESS_MANUAL_IN.equals(req.getBusinessType())) {
            Result compatible = ensureInboundLocationCompatible(req.getLocationId(), req.getMaterialId());
            if (!ok(compatible)) {
                return compatible;
            }
        } else {
            SpInventory stock = findStockForOutbound(req.getLocationId(), req.getMaterialId(), req.getBatchNo(), false);
            if (stock == null || nvl(stock.getQty()).compareTo(qty) < 0) {
                return Result.failure("当前库位库存不足，不能提交出库申请");
            }
        }

        SpWarehouseRequest request = new SpWarehouseRequest();
        request.setRequestNo(nextNo(WarehouseConstants.BUSINESS_MANUAL_IN.equals(req.getBusinessType()) ? "MI" : "MO"));
        request.setBusinessType(req.getBusinessType());
        request.setSourceType(WarehouseConstants.SOURCE_MANUAL);
        request.setWarehouseId(req.getWarehouseId());
        request.setStatus(WarehouseConstants.STATUS_WAIT_CONFIRM);
        request.setItemCount(1);
        request.setTotalQty(qty);
        request.setApplyUsername(username(user));
        request.setApplyTime(now());
        request.setRemark(req.getRemark());
        request.setDeleted("0");
        save(request);

        SpWarehouseRequestItem item = new SpWarehouseRequestItem();
        item.setRequestId(request.getId());
        item.setMaterialId(material.getId());
        item.setMaterialCode(material.getMateriel());
        item.setMaterialName(material.getMaterielDesc());
        item.setWarehouseId(req.getWarehouseId());
        item.setLocationId(req.getLocationId());
        item.setBatchNo(req.getBatchNo());
        item.setRequestQty(qty);
        item.setConfirmedQty(BigDecimal.ZERO);
        item.setUnit(material.getUnit());
        item.setStatus(WarehouseConstants.STATUS_WAIT_CONFIRM);
        item.setRemark(req.getRemark());
        item.setDeleted("0");
        itemService.save(item);
        return Result.success(request.getRequestNo(), "申请已提交到库房确认");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result confirmItem(SpWarehouseConfirmReq req, SysUser user) {
        if (req == null || StringUtils.isBlank(req.getItemId())) {
            return Result.failure("请选择要确认的明细");
        }
        SpWarehouseRequestItem item = itemService.getById(req.getItemId());
        if (item == null || "1".equals(item.getDeleted())) {
            return Result.failure("单据明细不存在");
        }
        if (WarehouseConstants.STATUS_CONFIRMED.equals(item.getStatus())) {
            return Result.failure("该明细已确认，不能重复登账");
        }
        SpWarehouseRequest request = getById(item.getRequestId());
        if (request == null || "1".equals(request.getDeleted())) {
            return Result.failure("单据不存在");
        }
        if (!WarehouseConstants.STATUS_WAIT_CONFIRM.equals(request.getStatus())) {
            return Result.failure("当前单据状态不能确认");
        }

        String warehouseId = StringUtils.defaultIfBlank(req.getWarehouseId(), item.getWarehouseId());
        String locationId = StringUtils.defaultIfBlank(req.getLocationId(), item.getLocationId());
        BigDecimal qty = req.getQty() == null ? nvl(item.getRequestQty()) : req.getQty();
        if (qty.compareTo(BigDecimal.ZERO) <= 0) {
            return Result.failure("纭鏁伴噺蹇呴』澶т簬0");
        }
        Result check = validateLocation(warehouseId, locationId);
        if (!ok(check)) {
            return check;
        }
        item.setWarehouseId(warehouseId);
        item.setLocationId(locationId);
        String direction = direction(request.getBusinessType());
        if (WarehouseConstants.DIRECTION_IN.equals(direction)) {
            Result compatible = ensureInboundLocationCompatible(locationId, item.getMaterialId());
            if (!ok(compatible)) {
                return compatible;
            }
            moveIn(request, item, qty, user);
        } else {
            moveOut(request, item, qty, user);
        }
        item.setConfirmedQty(qty);
        item.setStatus(WarehouseConstants.STATUS_CONFIRMED);
        itemService.updateById(item);
        refreshRequestStatus(request, user);
        return Result.success(null, "库房登账完成");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result syncPlanInboundRequests() {
        List<SpMaterialInboundRequest> rows = planInboundService.list(new QueryWrapper<SpMaterialInboundRequest>()
                .eq("is_deleted", "0"));
        int count = 0;
        for (SpMaterialInboundRequest row : rows) {
            Result synced = syncPlanInboundRequest(row.getId());
            Object code = synced.get("code");
            if (code instanceof Integer && ((Integer) code) == 0) {
                Object data = synced.get("data");
                if (Boolean.TRUE.equals(data)) {
                    count++;
                }
            }
        }
        return Result.success(count, "计划入库单已同步到库房管理中心");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result syncPlanInboundRequest(String sourceRequestId) {
        if (StringUtils.isBlank(sourceRequestId)) {
            return Result.failure("鏉ユ簮鍏ュ簱鐢宠鍗旾D涓嶈兘涓虹┖");
        }
        SpMaterialInboundRequest source = planInboundService.getById(sourceRequestId);
        if (source == null || "1".equals(source.getDeleted())) {
            return Result.failure("来源入库申请单不存在");
        }
        SpWarehouseRequest exists = getOne(new QueryWrapper<SpWarehouseRequest>()
                .eq("source_type", WarehouseConstants.SOURCE_PLAN_INBOUND)
                .eq("source_id", sourceRequestId)
                .eq("is_deleted", "0")
                .last("limit 1"), false);
        if (exists != null) {
            return Result.success(false, "已同步");
        }
        List<SpMaterialInboundRequestItem> sourceItems = planInboundItemService.list(
                new QueryWrapper<SpMaterialInboundRequestItem>()
                        .eq("request_id", sourceRequestId)
                        .eq("is_deleted", "0")
                        .orderByAsc("material_code"));
        for (SpMaterialInboundRequestItem sourceItem : sourceItems) {
            SpMaterile material = resolveMaterial(sourceItem.getMaterialId(), sourceItem.getMaterialCode());
            if (material == null) {
                return Result.failure("material_id missing or invalid: " + sourceItem.getMaterialCode());
            }
        }
        if (sourceItems.isEmpty()) {
            return Result.failure("来源入库申请单明细为空");
        }
        SpWarehouseRequest request = new SpWarehouseRequest();
        request.setRequestNo(source.getRequestNo());
        request.setBusinessType(WarehouseConstants.BUSINESS_PLAN_IN);
        request.setSourceType(WarehouseConstants.SOURCE_PLAN_INBOUND);
        request.setSourceId(source.getId());
        request.setSourceNo(source.getRequestNo());
        request.setStatus(WarehouseConstants.STATUS_WAIT_CONFIRM);
        request.setItemCount(sourceItems.size());
        request.setTotalQty(nvl(source.getTotalNetQty()));
        request.setApplyUsername(source.getCreateUsername());
        request.setApplyTime(source.getCreateTime() == null ? null : source.getCreateTime().format(TIME_FMT));
        request.setRemark("计划入库同步生成");
        request.setDeleted("0");
        save(request);
        for (SpMaterialInboundRequestItem sourceItem : sourceItems) {
            SpMaterile material = resolveMaterial(sourceItem.getMaterialId(), sourceItem.getMaterialCode());
            SpWarehouseRequestItem item = new SpWarehouseRequestItem();
            item.setRequestId(request.getId());
            item.setMaterialId(material.getId());
            item.setMaterialCode(StringUtils.defaultIfBlank(sourceItem.getMaterialCode(), material.getMateriel()));
            item.setMaterialName(StringUtils.defaultIfBlank(sourceItem.getMaterialName(), material.getMaterielDesc()));
            item.setBatchNo(source.getRequestNo());
            item.setRequestQty(nvl(sourceItem.getRequestQty()));
            item.setConfirmedQty(BigDecimal.ZERO);
            item.setUnit(StringUtils.defaultIfBlank(sourceItem.getUnit(), material.getUnit()));
            item.setStatus(WarehouseConstants.STATUS_WAIT_CONFIRM);
            item.setSourceItemId(sourceItem.getId());
            item.setDeleted("0");
            itemService.save(item);
        }
        return Result.success(true, "计划入库单已同步");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result syncKittingOutboundRequests() {
        return Result.success(0, "\u8bf7\u5728\u7269\u6599\u9700\u6c42\u8ba1\u5212\u4e2d\u751f\u6210\u914d\u5957\u51fa\u5e93\u5355");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result applyKittingOutboundRequest(List<String> planIds, SysUser user) {
        return createKittingOutboundRequest(planIds, user, false);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result generateKittingOutboundRequest(List<String> planIds, SysUser user) {
        return createKittingOutboundRequest(planIds, user, true);
    }

    private Result createKittingOutboundRequest(List<String> planIds, SysUser user, boolean useNetRequirement) {
        if (planIds == null || planIds.isEmpty()) {
            return Result.failure(useNetRequirement ? "请选择要生成配套出库单的物料计划" : "请选择要申请配套出库的物料计划");
        }
        materialPlanService.refreshInventorySnapshot(planIds);
        List<SpMaterialRequirementPlan> plans = materialPlanService.list(new QueryWrapper<SpMaterialRequirementPlan>()
                .eq("is_deleted", "0")
                .in("id", planIds)
                .orderByAsc("production_order_no")
                .orderByAsc("material_code"));
        if (plans.isEmpty()) {
            return Result.failure("未找到有效的物料计划");
        }
        Map<String, List<SpMaterialRequirementPlan>> groups = new LinkedHashMap<String, List<SpMaterialRequirementPlan>>();
        Map<String, BigDecimal> requestQtyMap = new HashMap<String, BigDecimal>();
        for (SpMaterialRequirementPlan plan : plans) {
            BigDecimal requestQty = kittingRequestQty(plan, useNetRequirement);
            if (requestQty.compareTo(BigDecimal.ZERO) <= 0) {
                continue;
            }
            if (StringUtils.isNotBlank(plan.getOutboundRequestId())
                    || "GENERATED".equals(plan.getOutboundStatus())
                    || "CONFIRMED".equals(plan.getOutboundStatus())) {
                return Result.failure(useNetRequirement ? "已生成配套出库单，不能重复生成：" + plan.getMaterialCode()
                        : "已申请配套出库，不能重复申请：" + plan.getMaterialCode());
            }
            SpMaterile material = resolveMaterial(plan.getMaterialId(), plan.getMaterialCode());
            if (material == null) {
                return Result.failure("物料不存在或已停用：" + plan.getMaterialCode());
            }
            String key = StringUtils.defaultString(plan.getProductionOrderId()) + "::"
                    + StringUtils.defaultString(plan.getCalcBatchNo());
            if (!groups.containsKey(key)) {
                groups.put(key, new ArrayList<SpMaterialRequirementPlan>());
            }
            groups.get(key).add(plan);
            requestQtyMap.put(plan.getId(), requestQty);
        }
        if (groups.isEmpty()) {
            return Result.failure(useNetRequirement ? "所选计划净需求为0，无需生成配套出库单" : "所选计划毛需求为0，无法申请配套出库");
        }

        List<String> requestNos = new ArrayList<String>();
        int itemCount = 0;
        for (List<SpMaterialRequirementPlan> group : groups.values()) {
            SpMaterialRequirementPlan first = group.get(0);
            SpWarehouseRequest request = new SpWarehouseRequest();
            request.setRequestNo(nextNo("KO"));
            request.setBusinessType(WarehouseConstants.BUSINESS_KITTING_OUT);
            request.setSourceType(WarehouseConstants.SOURCE_MRP);
            request.setSourceId(first.getProductionOrderId());
            request.setSourceNo(first.getProductionOrderNo());
            request.setStatus(WarehouseConstants.STATUS_WAIT_CONFIRM);
            request.setItemCount(group.size());
            BigDecimal total = BigDecimal.ZERO;
            for (SpMaterialRequirementPlan plan : group) {
                total = total.add(nvl(requestQtyMap.get(plan.getId())));
            }
            request.setTotalQty(total);
            request.setApplyUsername(username(user));
            request.setApplyTime(now());
            request.setRemark(useNetRequirement ? "物料需求计划生成配套出库单" : "物料需求计划申请配套出库");
            request.setDeleted("0");
            save(request);
            requestNos.add(request.getRequestNo());

            for (SpMaterialRequirementPlan plan : group) {
                SpMaterile material = resolveMaterial(plan.getMaterialId(), plan.getMaterialCode());
                SpWarehouseRequestItem item = new SpWarehouseRequestItem();
                item.setRequestId(request.getId());
                item.setMaterialId(material.getId());
                item.setMaterialCode(StringUtils.defaultIfBlank(plan.getMaterialCode(), material.getMateriel()));
                item.setMaterialName(StringUtils.defaultIfBlank(plan.getMaterialName(), material.getMaterielDesc()));
                item.setRequestQty(nvl(requestQtyMap.get(plan.getId())));
                item.setConfirmedQty(BigDecimal.ZERO);
                item.setUnit(StringUtils.defaultIfBlank(plan.getUnit(), material.getUnit()));
                item.setStatus(WarehouseConstants.STATUS_WAIT_CONFIRM);
                item.setSourceItemId(plan.getId());
                item.setDeleted("0");
                itemService.save(item);

                plan.setOutboundStatus("GENERATED");
                plan.setOutboundRequestId(request.getId());
                plan.setOutboundRequestNo(request.getRequestNo());
                materialPlanService.updateById(plan);
                itemCount++;
            }
        }
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("requestNos", requestNos);
        data.put("itemCount", itemCount);
        return Result.success(data, useNetRequirement ? "配套出库单已生成" : "配套出库申请已提交，请到配套出库确认中处理");
    }

    private BigDecimal kittingRequestQty(SpMaterialRequirementPlan plan, boolean useNetRequirement) {
        if (plan == null) {
            return BigDecimal.ZERO;
        }
        return nvl(useNetRequirement ? plan.getNetRequirement() : plan.getGrossRequirement());
    }

    @Override
    public Result precheckKittingOutboundRequest(String requestId) {
        KittingPlan plan = buildKittingPlan(requestId);
        return Result.success(plan.toMap(), plan.ready ? "库存满足，可整单出库" : "库存不足，不能整单出库");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result planInboundForKittingShortage(String requestId, SysUser user) {
        KittingPlan plan = buildKittingPlan(requestId);
        if (plan.ready || plan.shortages.isEmpty()) {
            return Result.failure(plan.toMap(), "库存满足，无需生成计划入库单");
        }

        SpMaterialInboundRequest exists = planInboundService.getOne(new QueryWrapper<SpMaterialInboundRequest>()
                .eq("source_batch_no", plan.request.getRequestNo())
                .eq("is_deleted", "0")
                .like("remark", "配套出库库存预检缺料")
                .orderByDesc("create_time")
                .last("limit 1"), false);
        if (exists != null) {
            syncPlanInboundRequest(exists.getId());
            return Result.success(shortageInboundData(exists, false), "已存在缺料计划入库单，已同步到计划入库确认");
        }

        SpMaterialInboundRequest request = new SpMaterialInboundRequest();
        request.setRequestNo(nextPlanInboundRequestNo());
        request.setProductionOrderId(plan.request.getSourceId());
        request.setProductionOrderNo(plan.request.getSourceNo());
        request.setSourceBatchNo(plan.request.getRequestNo());
        request.setStatus("GENERATED");
        request.setItemCount(plan.shortages.size());
        request.setDeleted("0");
        request.setCreateUsername(username(user));
        request.setUpdateUsername(username(user));
        BigDecimal total = BigDecimal.ZERO;
        for (Map<String, Object> shortage : plan.shortages) {
            total = total.add(asBigDecimal(shortage.get("shortageQty")));
        }
        request.setTotalNetQty(total);
        request.setRemark("配套出库库存预检缺料生成，来源出库单：" + plan.request.getRequestNo());
        planInboundService.save(request);

        for (Map<String, Object> shortage : plan.shortages) {
            String sourceItemId = stringValue(shortage.get("sourceItemId"));
            SpMaterialRequirementPlan materialPlan = StringUtils.isBlank(sourceItemId)
                    ? null : materialPlanService.getById(sourceItemId);
            SpMaterialInboundRequestItem item = new SpMaterialInboundRequestItem();
            item.setRequestId(request.getId());
            item.setRequestNo(request.getRequestNo());
            item.setPlanId(sourceItemId);
            item.setProductionOrderId(plan.request.getSourceId());
            item.setProductionOrderNo(plan.request.getSourceNo());
            item.setMaterialId(stringValue(shortage.get("materialId")));
            item.setMaterialCode(stringValue(shortage.get("materialCode")));
            item.setMaterialName(stringValue(shortage.get("materialName")));
            item.setUnit(stringValue(shortage.get("unit")));
            item.setRequestQty(asBigDecimal(shortage.get("shortageQty")));
            if (materialPlan != null) {
                item.setRequirementDate(materialPlan.getRequirementDate());
                item.setReleaseDate(materialPlan.getReleaseDate());
            }
            item.setRemark("配套出库缺料自动计划入库");
            item.setDeleted("0");
            item.setCreateUsername(username(user));
            item.setUpdateUsername(username(user));
            planInboundItemService.save(item);
        }

        Result synced = syncPlanInboundRequest(request.getId());
        if (!ok(synced)) {
            return Result.failure(shortageInboundData(request, true), "缺料计划入库单已生成，但同步到计划入库确认失败：" + synced.get("msg"));
        }
        return Result.success(shortageInboundData(request, true), "缺料计划入库单已生成，请到计划入库确认中处理");
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Result confirmKittingOutboundRequest(String requestId, SysUser user) {
        KittingPlan plan = buildKittingPlan(requestId);
        if (!plan.ready) {
            return Result.failure(plan.toMap(), "库存不足，不能整单出库");
        }
        for (AllocationDraft allocation : plan.allocations) {
            SpInventory stock = inventoryService.getById(allocation.inventoryId);
            if (stock == null
                    || !WarehouseConstants.STOCK_AVAILABLE.equals(stock.getStockStatus())
                    || nvl(stock.getQty()).compareTo(allocation.qty) < 0) {
                return Result.failure(buildKittingPlan(requestId).toMap(), "库存已变化，请刷新后重新预检");
            }
        }

        allocationMapper.delete(new QueryWrapper<SpWarehouseRequestAllocation>().eq("request_id", requestId));
        Map<String, SpWarehouseRequestItem> itemById = new HashMap<String, SpWarehouseRequestItem>();
        Map<String, AllocationDraft> firstAllocation = new HashMap<String, AllocationDraft>();
        for (SpWarehouseRequestItem item : plan.items) {
            itemById.put(item.getId(), item);
        }

        for (AllocationDraft allocation : plan.allocations) {
            SpInventory stock = inventoryService.getById(allocation.inventoryId);
            BigDecimal beforeQty = nvl(stock.getQty());
            BigDecimal afterQty = beforeQty.subtract(allocation.qty);
            stock.setQty(afterQty);
            stock.setStockStatus(WarehouseConstants.STOCK_AVAILABLE);
            inventoryService.updateById(stock);

            SpWarehouseRequestItem item = itemById.get(allocation.requestItemId);
            SpWarehouseRequestAllocation record = new SpWarehouseRequestAllocation();
            record.setRequestId(plan.request.getId());
            record.setRequestItemId(allocation.requestItemId);
            record.setInventoryId(allocation.inventoryId);
            record.setWarehouseId(allocation.warehouseId);
            record.setLocationId(allocation.locationId);
            record.setMaterialId(allocation.materialId);
            record.setBatchNo(allocation.batchNo);
            record.setQty(allocation.qty);
            record.setBeforeQty(beforeQty);
            record.setAfterQty(afterQty);
            record.setAllocationRule("FIFO");
            record.setStatus(WarehouseConstants.STATUS_CONFIRMED);
            record.setDeleted("0");
            allocationMapper.insert(record);

            writeTransaction(plan.request, item, WarehouseConstants.DIRECTION_OUT, allocation.qty,
                    beforeQty, afterQty, user, allocation.warehouseId, allocation.locationId, allocation.batchNo);
            if (!firstAllocation.containsKey(allocation.requestItemId)) {
                firstAllocation.put(allocation.requestItemId, allocation);
            }
        }

        for (SpWarehouseRequestItem item : plan.items) {
            AllocationDraft first = firstAllocation.get(item.getId());
            if (first != null) {
                item.setWarehouseId(first.warehouseId);
                item.setLocationId(first.locationId);
                item.setBatchNo(first.batchNo);
            }
            item.setConfirmedQty(nvl(item.getRequestQty()));
            item.setStatus(WarehouseConstants.STATUS_CONFIRMED);
            itemService.updateById(item);

            if (StringUtils.isNotBlank(item.getSourceItemId())) {
                SpMaterialRequirementPlan materialPlan = new SpMaterialRequirementPlan();
                materialPlan.setId(item.getSourceItemId());
                materialPlan.setOutboundStatus("CONFIRMED");
                materialPlan.setOutboundRequestId(plan.request.getId());
                materialPlan.setOutboundRequestNo(plan.request.getRequestNo());
                materialPlanService.updateById(materialPlan);
            }
        }
        plan.request.setStatus(WarehouseConstants.STATUS_CONFIRMED);
        plan.request.setConfirmUsername(username(user));
        plan.request.setConfirmTime(now());
        updateById(plan.request);
        return Result.success(plan.toMap(), "配套出库整单登账完成");
    }

    @Override
    public List<Map<String, Object>> availableLocations(String warehouseId, String materialId, String locationCodeLike,
                                                        String direction) {
        List<Map<String, Object>> data = new ArrayList<Map<String, Object>>();
        if (StringUtils.isBlank(warehouseId)) {
            return data;
        }
        boolean outbound = WarehouseConstants.DIRECTION_OUT.equalsIgnoreCase(direction)
                || StringUtils.equalsIgnoreCase("OUT", direction);
        if (outbound && StringUtils.isBlank(materialId)) {
            return data;
        }
        List<SpWarehouseLocation> locations = locationService.list(new QueryWrapper<SpWarehouseLocation>()
                .eq("warehouse_id", warehouseId)
                .eq("is_deleted", "0")
                .ne("status", "2")
                .orderByAsc("group_no", "row_no", "layer_no", "column_no"));
        for (SpWarehouseLocation loc : locations) {
            if (StringUtils.isNotBlank(locationCodeLike)
                    && !StringUtils.containsIgnoreCase(loc.getLocationCode(), locationCodeLike)) {
                continue;
            }
            List<SpInventory> stocks = inventoryService.list(new QueryWrapper<SpInventory>()
                    .eq("location_id", loc.getId())
                    .eq("is_deleted", "0")
                    .gt("qty", BigDecimal.ZERO));
            boolean empty = stocks.isEmpty();
            boolean compatible = !outbound && empty;
            BigDecimal qty = BigDecimal.ZERO;
            String materialCode = "";
            for (SpInventory stock : stocks) {
                if (StringUtils.equals(stock.getMaterielId(), materialId)) {
                    compatible = true;
                    qty = qty.add(nvl(stock.getQty()));
                } else {
                    if (!outbound) {
                        compatible = false;
                    }
                    SpMaterile m = materileService.getById(stock.getMaterielId());
                    materialCode = m == null ? stock.getMaterielId() : m.getMateriel();
                    if (!outbound) {
                        break;
                    }
                }
            }
            if (!compatible) {
                continue;
            }
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("id", loc.getId());
            row.put("warehouseId", loc.getWarehouseId());
            row.put("locationCode", loc.getLocationCode());
            row.put("empty", empty);
            row.put("qty", qty);
            row.put("materialCode", materialCode);
            data.add(row);
        }
        return data;
    }

    @Override
    public IPage<Map<String, Object>> availableMaterials(SpWarehouseRequestReq req) {
        if (req == null) {
            req = new SpWarehouseRequestReq();
        }
        Page<Map<String, Object>> page = new Page<Map<String, Object>>(req.getCurrent(), req.getSize());
        List<Map<String, Object>> records = new ArrayList<Map<String, Object>>();
        if (StringUtils.isBlank(req.getWarehouseId())) {
            page.setTotal(0);
            page.setRecords(records);
            return page;
        }
        List<SpInventory> stocks = inventoryService.list(new QueryWrapper<SpInventory>()
                .eq("warehouse_id", req.getWarehouseId())
                .eq("is_deleted", "0")
                .gt("qty", BigDecimal.ZERO)
                .orderByAsc("materiel_id"));
        Map<String, Map<String, Object>> grouped = new LinkedHashMap<String, Map<String, Object>>();
        for (SpInventory stock : stocks) {
            if (StringUtils.isBlank(stock.getMaterielId())) {
                continue;
            }
            SpMaterile material = materileService.getById(stock.getMaterielId());
            if (!isValidMaterial(material)) {
                continue;
            }
            if (StringUtils.isNotBlank(req.getMaterialLike())
                    && !StringUtils.containsIgnoreCase(material.getMateriel(), req.getMaterialLike())
                    && !StringUtils.containsIgnoreCase(material.getMaterielDesc(), req.getMaterialLike())) {
                continue;
            }
            Map<String, Object> row = grouped.get(material.getId());
            if (row == null) {
                row = new HashMap<String, Object>();
                row.put("id", material.getId());
                row.put("materiel", material.getMateriel());
                row.put("materielDesc", material.getMaterielDesc());
                row.put("unit", material.getUnit());
                row.put("qty", BigDecimal.ZERO);
                grouped.put(material.getId(), row);
            }
            row.put("qty", ((BigDecimal) row.get("qty")).add(nvl(stock.getQty())));
        }
        records.addAll(grouped.values());
        int total = records.size();
        int size = req.getSize() <= 0 ? 10 : (int) Math.min(req.getSize(), Integer.MAX_VALUE);
        int current = req.getCurrent() <= 0 ? 1 : (int) Math.min(req.getCurrent(), Integer.MAX_VALUE);
        int from = (int) Math.min(((long) current - 1) * size, (long) total);
        int to = (int) Math.min((long) from + size, (long) total);
        page.setTotal(total);
        page.setRecords(new ArrayList<Map<String, Object>>(records.subList(from, to)));
        return page;
    }

    @Override
    public List<Map<String, Object>> ledger(SpWarehouseRequestReq req) {
        if (req == null) {
            req = new SpWarehouseRequestReq();
        }
        return baseMapper.ledger(req);
    }

    private void moveIn(SpWarehouseRequest request, SpWarehouseRequestItem item, BigDecimal qty, SysUser user) {
        SpInventory before = findStock(item.getLocationId(), item.getMaterialId(), item.getBatchNo());
        BigDecimal beforeQty = before == null ? BigDecimal.ZERO : nvl(before.getQty());
        SpInventory record = new SpInventory();
        record.setWarehouseId(item.getWarehouseId());
        record.setLocationId(item.getLocationId());
        record.setMaterielId(item.getMaterialId());
        record.setBatchNo(item.getBatchNo());
        record.setQty(qty);
        record.setUnit(item.getUnit());
        record.setStockStatus(WarehouseConstants.STOCK_AVAILABLE);
        inventoryService.inbound(record);
        writeTransaction(request, item, WarehouseConstants.DIRECTION_IN, qty, beforeQty, beforeQty.add(qty), user);
    }

    private void moveOut(SpWarehouseRequest request, SpWarehouseRequestItem item, BigDecimal qty, SysUser user) {
        SpInventory stock = findStockForOutbound(item.getLocationId(), item.getMaterialId(), item.getBatchNo(),
                WarehouseConstants.BUSINESS_KITTING_OUT.equals(request.getBusinessType()));
        if (stock == null || nvl(stock.getQty()).compareTo(qty) < 0) {
            throw new IllegalArgumentException("库存不足，不能确认出库");
        }
        BigDecimal beforeQty = nvl(stock.getQty());
        BigDecimal afterQty = beforeQty.subtract(qty);
        stock.setQty(afterQty);
        stock.setStockStatus(WarehouseConstants.STOCK_AVAILABLE);
        inventoryService.updateById(stock);
        item.setBatchNo(stock.getBatchNo());
        writeTransaction(request, item, WarehouseConstants.DIRECTION_OUT, qty, beforeQty, afterQty, user);
    }

    private void writeTransaction(SpWarehouseRequest request, SpWarehouseRequestItem item, String direction,
                                  BigDecimal qty, BigDecimal beforeQty, BigDecimal afterQty, SysUser user) {
        writeTransaction(request, item, direction, qty, beforeQty, afterQty, user,
                item.getWarehouseId(), item.getLocationId(), item.getBatchNo());
    }

    private void writeTransaction(SpWarehouseRequest request, SpWarehouseRequestItem item, String direction,
                                  BigDecimal qty, BigDecimal beforeQty, BigDecimal afterQty, SysUser user,
                                  String warehouseId, String locationId, String batchNo) {
        SpWarehouseTransaction tx = new SpWarehouseTransaction();
        tx.setTransactionNo(nextNo(WarehouseConstants.DIRECTION_IN.equals(direction) ? "WI" : "WO"));
        tx.setRequestId(request.getId());
        tx.setRequestNo(request.getRequestNo());
        tx.setRequestItemId(item.getId());
        tx.setDirection(direction);
        tx.setBusinessType(request.getBusinessType());
        tx.setWarehouseId(warehouseId);
        tx.setLocationId(locationId);
        tx.setMaterialId(item.getMaterialId());
        tx.setBatchNo(batchNo);
        tx.setQty(qty);
        tx.setBeforeQty(beforeQty);
        tx.setAfterQty(afterQty);
        tx.setOperatorUsername(username(user));
        tx.setOperateTime(now());
        tx.setRemark(request.getRemark());
        transactionService.save(tx);
    }

    private void refreshRequestStatus(SpWarehouseRequest request, SysUser user) {
        List<SpWarehouseRequestItem> rows = itemService.list(new QueryWrapper<SpWarehouseRequestItem>()
                .eq("request_id", request.getId())
                .eq("is_deleted", "0"));
        int confirmed = 0;
        for (SpWarehouseRequestItem row : rows) {
            if (WarehouseConstants.STATUS_CONFIRMED.equals(row.getStatus())) {
                confirmed++;
            }
        }
        if (!rows.isEmpty() && confirmed == rows.size()) {
            request.setStatus(WarehouseConstants.STATUS_CONFIRMED);
            request.setConfirmUsername(username(user));
            request.setConfirmTime(now());
            updateById(request);
            if (WarehouseConstants.BUSINESS_PLAN_IN.equals(request.getBusinessType())
                    && WarehouseConstants.SOURCE_PLAN_INBOUND.equals(request.getSourceType())) {
                SpMaterialInboundRequest source = new SpMaterialInboundRequest();
                source.setId(request.getSourceId());
                source.setStatus("CONFIRMED");
                planInboundService.updateById(source);
            }
        } else {
            updateById(request);
        }
    }

    private KittingPlan buildKittingPlan(String requestId) {
        if (StringUtils.isBlank(requestId)) {
            throw new IllegalArgumentException("请选择配套出库单");
        }
        SpWarehouseRequest request = getById(requestId);
        if (request == null || "1".equals(request.getDeleted())) {
            throw new IllegalArgumentException("配套出库单不存在");
        }
        if (!WarehouseConstants.BUSINESS_KITTING_OUT.equals(request.getBusinessType())) {
            throw new IllegalArgumentException("当前单据不是配套出库单");
        }
        if (WarehouseConstants.STATUS_CONFIRMED.equals(request.getStatus())) {
            throw new IllegalArgumentException("配套出库单已登账，不能重复确认");
        }
        List<SpWarehouseRequestItem> items = itemService.list(new QueryWrapper<SpWarehouseRequestItem>()
                .eq("request_id", requestId)
                .eq("is_deleted", "0")
                .orderByAsc("material_code"));
        if (items.isEmpty()) {
            throw new IllegalArgumentException("配套出库单明细为空");
        }

        KittingPlan plan = new KittingPlan();
        plan.request = request;
        plan.items = items;
        plan.ready = true;
        for (SpWarehouseRequestItem item : items) {
            BigDecimal requiredQty = nvl(item.getRequestQty());
            List<StockCandidate> stocks = fifoStocks(item.getMaterialId());
            BigDecimal availableQty = BigDecimal.ZERO;
            for (StockCandidate stock : stocks) {
                availableQty = availableQty.add(nvl(stock.inventory.getQty()));
            }
            Map<String, Object> itemRow = new HashMap<String, Object>();
            itemRow.put("itemId", item.getId());
            itemRow.put("materialId", item.getMaterialId());
            itemRow.put("materialCode", item.getMaterialCode());
            itemRow.put("materialName", item.getMaterialName());
            itemRow.put("sourceItemId", item.getSourceItemId());
            itemRow.put("requestQty", requiredQty);
            itemRow.put("availableQty", availableQty);
            itemRow.put("unit", item.getUnit());
            if (availableQty.compareTo(requiredQty) < 0) {
                plan.ready = false;
                itemRow.put("status", "SHORTAGE");
                itemRow.put("shortageQty", requiredQty.subtract(availableQty));
                plan.shortages.add(itemRow);
            } else {
                itemRow.put("status", "READY");
                itemRow.put("shortageQty", BigDecimal.ZERO);
            }
            plan.itemRows.add(itemRow);

            BigDecimal left = requiredQty;
            for (StockCandidate stock : stocks) {
                if (left.compareTo(BigDecimal.ZERO) <= 0) {
                    break;
                }
                BigDecimal canUse = nvl(stock.inventory.getQty()).min(left);
                if (canUse.compareTo(BigDecimal.ZERO) <= 0) {
                    continue;
                }
                AllocationDraft allocation = new AllocationDraft();
                allocation.requestItemId = item.getId();
                allocation.inventoryId = stock.inventory.getId();
                allocation.warehouseId = stock.inventory.getWarehouseId();
                allocation.warehouseCode = stock.warehouse == null ? "" : stock.warehouse.getWarehouseCode();
                allocation.warehouseName = stock.warehouse == null ? "" : stock.warehouse.getWarehouseName();
                allocation.locationId = stock.inventory.getLocationId();
                allocation.locationCode = stock.location == null ? "" : stock.location.getLocationCode();
                allocation.materialId = item.getMaterialId();
                allocation.materialCode = item.getMaterialCode();
                allocation.materialName = item.getMaterialName();
                allocation.batchNo = stock.inventory.getBatchNo();
                allocation.qty = canUse;
                allocation.beforeQty = nvl(stock.inventory.getQty());
                allocation.afterQty = allocation.beforeQty.subtract(canUse);
                allocation.unit = item.getUnit();
                plan.allocations.add(allocation);
                left = left.subtract(canUse);
            }
        }
        return plan;
    }

    private List<StockCandidate> fifoStocks(String materialId) {
        List<SpInventory> rows = inventoryService.list(new QueryWrapper<SpInventory>()
                .eq("materiel_id", materialId)
                .eq("is_deleted", "0")
                .eq("stock_status", WarehouseConstants.STOCK_AVAILABLE)
                .gt("qty", BigDecimal.ZERO));
        List<StockCandidate> candidates = new ArrayList<StockCandidate>();
        for (SpInventory row : rows) {
            SpWarehouse warehouse = warehouseService.getById(row.getWarehouseId());
            if (warehouse == null || "1".equals(warehouse.getDeleted()) || "2".equals(warehouse.getDeleted())) {
                continue;
            }
            SpWarehouseLocation location = locationService.getById(row.getLocationId());
            if (location == null || "1".equals(location.getDeleted()) || "2".equals(location.getStatus())) {
                continue;
            }
            StockCandidate candidate = new StockCandidate();
            candidate.inventory = row;
            candidate.warehouse = warehouse;
            candidate.location = location;
            candidates.add(candidate);
        }
        Collections.sort(candidates, new Comparator<StockCandidate>() {
            @Override
            public int compare(StockCandidate a, StockCandidate b) {
                int c = compareTime(a.inventory, b.inventory);
                if (c != 0) {
                    return c;
                }
                c = StringUtils.defaultString(a.inventory.getBatchNo())
                        .compareTo(StringUtils.defaultString(b.inventory.getBatchNo()));
                if (c != 0) {
                    return c;
                }
                return StringUtils.defaultString(a.location == null ? "" : a.location.getLocationCode())
                        .compareTo(StringUtils.defaultString(b.location == null ? "" : b.location.getLocationCode()));
            }
        });
        return candidates;
    }

    private int compareTime(SpInventory a, SpInventory b) {
        if (a.getCreateTime() == null && b.getCreateTime() == null) {
            return 0;
        }
        if (a.getCreateTime() == null) {
            return 1;
        }
        if (b.getCreateTime() == null) {
            return -1;
        }
        return a.getCreateTime().compareTo(b.getCreateTime());
    }

    private Result validateLocation(String warehouseId, String locationId) {
        if (StringUtils.isBlank(warehouseId)) {
            return Result.failure("璇烽€夋嫨搴撴埧");
        }
        if (StringUtils.isBlank(locationId)) {
            return Result.failure("璇烽€夋嫨搴撲綅");
        }
        SpWarehouse warehouse = warehouseService.getById(warehouseId);
        if (warehouse == null || "1".equals(warehouse.getDeleted()) || "2".equals(warehouse.getDeleted())) {
            return Result.failure("库房不存在或已停用");
        }
        SpWarehouseLocation location = locationService.getById(locationId);
        if (location == null || "1".equals(location.getDeleted()) || "2".equals(location.getStatus())) {
            return Result.failure("库位不存在或已停用");
        }
        if (!StringUtils.equals(warehouseId, location.getWarehouseId())) {
            return Result.failure("库位不属于所选库房");
        }
        return Result.success();
    }

    private Result ensureInboundLocationCompatible(String locationId, String materialId) {
        List<SpInventory> stocks = inventoryService.list(new QueryWrapper<SpInventory>()
                .eq("location_id", locationId)
                .eq("is_deleted", "0")
                .gt("qty", BigDecimal.ZERO));
        for (SpInventory stock : stocks) {
            if (!StringUtils.equals(stock.getMaterielId(), materialId)) {
                return Result.failure("该库位已有其他物料，不能混放");
            }
        }
        return Result.success();
    }

    private SpInventory findStock(String locationId, String materialId, String batchNo) {
        QueryWrapper<SpInventory> qw = new QueryWrapper<SpInventory>()
                .eq("location_id", locationId)
                .eq("materiel_id", materialId)
                .eq("is_deleted", "0");
        if (StringUtils.isBlank(batchNo)) {
            qw.and(w -> w.isNull("batch_no").or().eq("batch_no", ""));
        } else {
            qw.eq("batch_no", batchNo);
        }
        return inventoryService.getOne(qw.last("limit 1"), false);
    }

    private SpInventory findStockForOutbound(String locationId, String materialId, String batchNo, boolean allowAnyBatchFallback) {
        QueryWrapper<SpInventory> qw = new QueryWrapper<SpInventory>()
                .eq("location_id", locationId)
                .eq("materiel_id", materialId)
                .eq("is_deleted", "0")
                .gt("qty", BigDecimal.ZERO);
        if (StringUtils.isNotBlank(batchNo)) {
            qw.eq("batch_no", batchNo);
            SpInventory exact = inventoryService.getOne(qw.orderByAsc("create_time").last("limit 1"), false);
            if (exact != null || !allowAnyBatchFallback) {
                return exact;
            }
            qw = new QueryWrapper<SpInventory>()
                    .eq("location_id", locationId)
                    .eq("materiel_id", materialId)
                    .eq("is_deleted", "0")
                    .gt("qty", BigDecimal.ZERO);
        }
        return inventoryService.getOne(qw.orderByAsc("create_time").last("limit 1"), false);
    }

    private String direction(String businessType) {
        if (WarehouseConstants.BUSINESS_MANUAL_IN.equals(businessType)
                || WarehouseConstants.BUSINESS_PLAN_IN.equals(businessType)) {
            return WarehouseConstants.DIRECTION_IN;
        }
        return WarehouseConstants.DIRECTION_OUT;
    }

    private boolean ok(Result result) {
        Object code = result == null ? null : result.get("code");
        return code instanceof Integer && ((Integer) code) == 0;
    }

    private String username(SysUser user) {
        if (user == null) {
            return "system";
        }
        return StringUtils.defaultIfBlank(user.getUsername(), StringUtils.defaultIfBlank(user.getName(), "system"));
    }

    private String now() {
        return LocalDateTime.now().format(TIME_FMT);
    }

    private SpMaterile resolveMaterial(String materialId, String materialCode) {
        if (StringUtils.isNotBlank(materialId)) {
            SpMaterile material = materileService.getById(materialId);
            if (isValidMaterial(material)) {
                return material;
            }
        }
        if (StringUtils.isBlank(materialCode)) {
            return null;
        }
        return materileService.getOne(new QueryWrapper<SpMaterile>()
                .eq("materiel", materialCode)
                .and(w -> w.isNull("is_deleted")
                        .or().notIn("is_deleted", "1", "00", "2", "02"))
                .last("limit 1"), false);
    }

    private boolean isValidMaterial(SpMaterile material) {
        if (material == null) {
            return false;
        }
        return !"1".equals(material.getDeleted())
                && !"00".equals(material.getDeleted())
                && !"2".equals(material.getDeleted())
                && !"02".equals(material.getDeleted());
    }

    private BigDecimal nvl(BigDecimal value) {
        return value == null ? BigDecimal.ZERO : value;
    }

    private BigDecimal asBigDecimal(Object value) {
        if (value instanceof BigDecimal) {
            return (BigDecimal) value;
        }
        if (value == null) {
            return BigDecimal.ZERO;
        }
        return new BigDecimal(String.valueOf(value));
    }

    private String stringValue(Object value) {
        return value == null ? "" : String.valueOf(value);
    }

    private Map<String, Object> shortageInboundData(SpMaterialInboundRequest request, boolean created) {
        Map<String, Object> data = new HashMap<String, Object>();
        data.put("created", created);
        data.put("requestId", request == null ? "" : request.getId());
        data.put("requestNo", request == null ? "" : request.getRequestNo());
        data.put("itemCount", request == null ? 0 : request.getItemCount());
        data.put("totalQty", request == null ? BigDecimal.ZERO : nvl(request.getTotalNetQty()));
        return data;
    }

    private String nextPlanInboundRequestNo() {
        return "IR" + LocalDate.now().format(DAY_FMT) + String.format("%05d", System.currentTimeMillis() % 100000);
    }

    private String nextNo(String prefix) {
        return prefix + LocalDate.now().format(DAY_FMT) + "-" + String.format("%08d", Math.abs(System.nanoTime()) % 100000000);
    }

    private static class StockCandidate {
        private SpInventory inventory;
        private SpWarehouse warehouse;
        private SpWarehouseLocation location;
    }

    private static class KittingPlan {
        private SpWarehouseRequest request;
        private List<SpWarehouseRequestItem> items = new ArrayList<SpWarehouseRequestItem>();
        private List<Map<String, Object>> itemRows = new ArrayList<Map<String, Object>>();
        private List<Map<String, Object>> shortages = new ArrayList<Map<String, Object>>();
        private List<AllocationDraft> allocations = new ArrayList<AllocationDraft>();
        private boolean ready;

        private Map<String, Object> toMap() {
            Map<String, Object> data = new HashMap<String, Object>();
            data.put("requestId", request == null ? "" : request.getId());
            data.put("requestNo", request == null ? "" : request.getRequestNo());
            data.put("sourceNo", request == null ? "" : request.getSourceNo());
            data.put("status", request == null ? "" : request.getStatus());
            data.put("ready", ready);
            data.put("itemCount", items.size());
            data.put("shortageCount", shortages.size());
            data.put("items", itemRows);
            data.put("shortages", shortages);
            List<Map<String, Object>> allocationRows = new ArrayList<Map<String, Object>>();
            for (AllocationDraft allocation : allocations) {
                allocationRows.add(allocation.toMap());
            }
            data.put("allocations", allocationRows);
            return data;
        }
    }

    private static class AllocationDraft {
        private String requestItemId;
        private String inventoryId;
        private String warehouseId;
        private String warehouseCode;
        private String warehouseName;
        private String locationId;
        private String locationCode;
        private String materialId;
        private String materialCode;
        private String materialName;
        private String batchNo;
        private BigDecimal qty;
        private BigDecimal beforeQty;
        private BigDecimal afterQty;
        private String unit;

        private Map<String, Object> toMap() {
            Map<String, Object> row = new HashMap<String, Object>();
            row.put("requestItemId", requestItemId);
            row.put("inventoryId", inventoryId);
            row.put("warehouseId", warehouseId);
            row.put("warehouseCode", warehouseCode);
            row.put("warehouseName", warehouseName);
            row.put("locationId", locationId);
            row.put("locationCode", locationCode);
            row.put("materialId", materialId);
            row.put("materialCode", materialCode);
            row.put("materialName", materialName);
            row.put("batchNo", batchNo);
            row.put("qty", qty);
            row.put("beforeQty", beforeQty);
            row.put("afterQty", afterQty);
            row.put("unit", unit);
            return row;
        }
    }
}
