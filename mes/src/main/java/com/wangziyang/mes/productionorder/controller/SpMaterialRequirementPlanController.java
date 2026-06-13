package com.wangziyang.mes.productionorder.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.productionorder.entity.SpMaterialInboundRequestItem;
import com.wangziyang.mes.productionorder.request.SpMaterialInboundRequestReq;
import com.wangziyang.mes.productionorder.request.SpMaterialPlanBatchReq;
import com.wangziyang.mes.productionorder.request.SpMaterialRequirementPlanReq;
import com.wangziyang.mes.productionorder.service.ISpMaterialInboundRequestItemService;
import com.wangziyang.mes.productionorder.service.ISpMaterialInboundRequestService;
import com.wangziyang.mes.productionorder.service.ISpMaterialRequirementPlanService;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.warehouse.service.ISpWarehouseRequestService;
import io.swagger.annotations.ApiOperation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Material requirement planning pages and APIs.
 */
@Controller
@RequestMapping("/production-order/material-plan")
public class SpMaterialRequirementPlanController extends BaseController {

    @Autowired
    private ISpMaterialRequirementPlanService materialPlanService;

    @Autowired
    private ISpMaterialInboundRequestService inboundRequestService;

    @Autowired
    private ISpMaterialInboundRequestItemService inboundRequestItemService;

    @Autowired
    private ISpWarehouseRequestService warehouseRequestService;

    @ApiOperation("物料需求计划明细页面")
    @GetMapping("/list-ui")
    public String listUI() {
        return "productionorder/materialplan/list";
    }

    @ApiOperation("物料需求计划周汇总页面")
    @GetMapping("/week-ui")
    public String weekUI() {
        return "productionorder/materialplan/week";
    }

    @ApiOperation("入库申请单页面")
    @GetMapping("/inbound-request/list-ui")
    public String inboundRequestListUI() {
        return "productionorder/materialplan/inboundRequest";
    }

    @ApiOperation("执行MRP运算")
    @PostMapping("/calculate")
    @ResponseBody
    public Result calculate(@RequestParam String id) {
        return materialPlanService.calculate(id, currentUser());
    }

    @ApiOperation("物料需求计划分页")
    @PostMapping("/page")
    @ResponseBody
    public Result page(SpMaterialRequirementPlanReq req) {
        return Result.success(materialPlanService.pageList(req));
    }

    @ApiOperation("物料需求计划周汇总")
    @PostMapping("/week-summary")
    @ResponseBody
    public Result weekSummary(SpMaterialRequirementPlanReq req) {
        return Result.success(materialPlanService.weekSummary(req));
    }

    @ApiOperation("物料需求计划指标")
    @PostMapping("/dashboard")
    @ResponseBody
    public Result dashboard(SpMaterialRequirementPlanReq req) {
        return Result.success(materialPlanService.dashboard(req));
    }

    @ApiOperation("物料需求计划下发")
    @PostMapping("/release")
    @ResponseBody
    public Result release(@RequestBody SpMaterialPlanBatchReq req) {
        return materialPlanService.release(req == null ? null : req.getIds());
    }

    @ApiOperation("生成入库申请单")
    @PostMapping("/generate-inbound-request")
    @ResponseBody
    public Result generateInboundRequest(@RequestBody SpMaterialPlanBatchReq req) {
        Result result = materialPlanService.generateInboundRequest(req == null ? null : req.getIds(), currentUser());
        Object code = result.get("code");
        if (code instanceof Integer && ((Integer) code) == 0) {
            warehouseRequestService.syncPlanInboundRequests();
        }
        return result;
    }

    @ApiOperation("申请配套出库")
    @PostMapping("/apply-kitting-outbound-request")
    @ResponseBody
    public Result applyKittingOutboundRequest(@RequestBody SpMaterialPlanBatchReq req) {
        return warehouseRequestService.applyKittingOutboundRequest(req == null ? null : req.getIds(), currentUser());
    }

    @ApiOperation("生成配套出库单")
    @PostMapping("/generate-kitting-outbound-request")
    @ResponseBody
    public Result generateKittingOutboundRequest(@RequestBody SpMaterialPlanBatchReq req) {
        return warehouseRequestService.generateKittingOutboundRequest(req == null ? null : req.getIds(), currentUser());
    }

    @PostMapping("/inbound-request/page")
    @ResponseBody
    public Result inboundRequestPage(SpMaterialInboundRequestReq req) {
        return Result.success(inboundRequestService.pageList(req));
    }

    @ApiOperation("入库申请单明细")
    @PostMapping("/inbound-request/items")
    @ResponseBody
    public Result inboundRequestItems(@RequestParam String requestId) {
        if (StringUtils.isBlank(requestId)) {
            return Result.failure("鍏ュ簱鐢宠鍗旾D涓嶈兘涓虹┖");
        }
        return Result.success(inboundRequestItemService.list(new QueryWrapper<SpMaterialInboundRequestItem>()
                .eq("request_id", requestId)
                .eq("is_deleted", "0")
                .orderByAsc("material_code")));
    }

    private SysUser currentUser() {
        try {
            return getSysUser();
        } catch (Exception ignore) {
            return null;
        }
    }
}
