package com.wangziyang.mes.productionorder.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderItem;
import com.wangziyang.mes.productionorder.entity.SpProductionOrderOperPlan;
import com.wangziyang.mes.productionorder.request.SpProductionOrderErpSyncReq;
import com.wangziyang.mes.productionorder.request.SpProductionOrderForecastReq;
import com.wangziyang.mes.productionorder.request.SpProductionOrderImportDTO;
import com.wangziyang.mes.productionorder.request.SpProductionOrderReq;
import com.wangziyang.mes.productionorder.request.SpProductionOrderSaveReq;
import com.wangziyang.mes.system.entity.SysUser;

import java.util.List;
import java.util.Map;

/**
 * Production order service.
 */
public interface ISpProductionOrderService extends IService<SpProductionOrder> {

    String nextOrderNo(String sourceType);

    IPage<SpProductionOrder> pageWithSummary(SpProductionOrderReq req);

    List<SpProductionOrderItem> listItems(String orderId);

    Result saveOrder(SpProductionOrderSaveReq req);

    Result submitOrder(SpProductionOrderSaveReq req, SysUser user);

    Result confirm(String id);

    Result deleteOrder(String id);

    Result createWorkOrder(String id, SysUser user);

    Result dispatch(String id);

    Result importOrders(List<SpProductionOrderImportDTO> rows, SysUser user);

    Result syncFromErp(SpProductionOrderErpSyncReq req, SysUser user);

    List<SpProductionOrderOperPlan> listOperationPlans(String orderId, String itemId);

    List<SpProductionOrderItem> generateForecastItems(SpProductionOrderForecastReq req);

    Map<String, Object> dashboard();
}
