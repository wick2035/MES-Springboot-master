package com.wangziyang.mes.productionorder.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.service.IService;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.productionorder.entity.SpMaterialRequirementPlan;
import com.wangziyang.mes.productionorder.entity.SpProductionOrder;
import com.wangziyang.mes.productionorder.request.SpMaterialRequirementPlanReq;
import com.wangziyang.mes.system.entity.SysUser;

import java.util.List;
import java.util.Map;

/**
 * Material requirement planning service.
 */
public interface ISpMaterialRequirementPlanService extends IService<SpMaterialRequirementPlan> {

    Result calculate(String productionOrderId, SysUser user);

    IPage<SpMaterialRequirementPlan> pageList(SpMaterialRequirementPlanReq req);

    IPage<Map<String, Object>> weekSummary(SpMaterialRequirementPlanReq req);

    Map<String, Object> dashboard(SpMaterialRequirementPlanReq req);

    Result release(List<String> ids);

    Result generateInboundRequest(List<String> ids, SysUser user);

    void refreshInventorySnapshot(List<String> ids);

    void enrichProductionOrders(List<SpProductionOrder> orders);

    boolean isProductionOrderMrpCompleted(String productionOrderId);
}
