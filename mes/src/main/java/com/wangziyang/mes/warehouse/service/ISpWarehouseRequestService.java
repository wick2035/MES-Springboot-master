package com.wangziyang.mes.warehouse.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.warehouse.entity.SpWarehouseRequest;
import com.wangziyang.mes.warehouse.entity.SpWarehouseRequestItem;
import com.wangziyang.mes.warehouse.request.SpWarehouseApplyReq;
import com.wangziyang.mes.warehouse.request.SpWarehouseConfirmReq;
import com.wangziyang.mes.warehouse.request.SpWarehouseRequestReq;

import java.util.List;
import java.util.Map;

public interface ISpWarehouseRequestService extends IService<SpWarehouseRequest> {

    IPage<SpWarehouseRequest> pageList(SpWarehouseRequestReq req);

    IPage<SpWarehouseRequestItem> pageItems(SpWarehouseRequestReq req);

    Result apply(SpWarehouseApplyReq req, SysUser user);

    Result confirmItem(SpWarehouseConfirmReq req, SysUser user);

    Result syncPlanInboundRequests();

    Result syncPlanInboundRequest(String sourceRequestId);

    Result syncKittingOutboundRequests();

    Result applyKittingOutboundRequest(List<String> planIds, SysUser user);

    Result generateKittingOutboundRequest(List<String> planIds, SysUser user);

    Result precheckKittingOutboundRequest(String requestId);

    Result planInboundForKittingShortage(String requestId, SysUser user);

    Result confirmKittingOutboundRequest(String requestId, SysUser user);

    List<Map<String, Object>> availableLocations(String warehouseId, String materialId, String locationCodeLike,
                                                 String direction);

    IPage<Map<String, Object>> availableMaterials(SpWarehouseRequestReq req);

    List<Map<String, Object>> ledger(SpWarehouseRequestReq req);
}
