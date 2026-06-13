package com.wangziyang.mes.warehouse.controller;

import com.wangziyang.mes.basedata.request.SpInventoryReq;
import com.wangziyang.mes.basedata.service.ISpInventoryService;
import com.wangziyang.mes.common.BaseController;
import com.wangziyang.mes.common.Result;
import com.wangziyang.mes.system.entity.SysUser;
import com.wangziyang.mes.warehouse.WarehouseConstants;
import com.wangziyang.mes.warehouse.request.SpWarehouseApplyReq;
import com.wangziyang.mes.warehouse.request.SpWarehouseConfirmReq;
import com.wangziyang.mes.warehouse.request.SpWarehouseRequestReq;
import com.wangziyang.mes.warehouse.service.ISpWarehouseRequestService;
import com.wangziyang.mes.warehouse.service.ISpWarehouseTransactionService;
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

@Controller
@RequestMapping("/warehouse")
public class SpWarehouseCenterController extends BaseController {

    @Autowired
    private ISpWarehouseRequestService warehouseRequestService;
    @Autowired
    private ISpWarehouseTransactionService transactionService;
    @Autowired
    private ISpInventoryService inventoryService;

    @GetMapping("/manual-inbound/apply/list-ui")
    public String manualInboundApply(Model model) {
        applyModel(model, WarehouseConstants.BUSINESS_MANUAL_IN, "手工入库申请", "IN");
        return "warehouse/requestApply";
    }

    @GetMapping("/manual-outbound/apply/list-ui")
    public String manualOutboundApply(Model model) {
        applyModel(model, WarehouseConstants.BUSINESS_MANUAL_OUT, "手工出库申请", "OUT");
        return "warehouse/requestApply";
    }

    @GetMapping("/manual-inbound/confirm/list-ui")
    public String manualInboundConfirm(Model model) {
        confirmModel(model, WarehouseConstants.BUSINESS_MANUAL_IN, "手工入库确认", "IN");
        return "warehouse/requestConfirm";
    }

    @GetMapping("/plan-inbound/confirm/list-ui")
    public String planInboundConfirm(Model model) {
        confirmModel(model, WarehouseConstants.BUSINESS_PLAN_IN, "计划入库确认", "IN");
        return "warehouse/requestConfirm";
    }

    @GetMapping("/manual-outbound/confirm/list-ui")
    public String manualOutboundConfirm(Model model) {
        confirmModel(model, WarehouseConstants.BUSINESS_MANUAL_OUT, "手工出库确认", "OUT");
        return "warehouse/requestConfirm";
    }

    @GetMapping("/kitting-outbound/confirm/list-ui")
    public String kittingOutboundConfirm(Model model) {
        confirmModel(model, WarehouseConstants.BUSINESS_KITTING_OUT, "配套出库确认", "OUT");
        model.addAttribute("syncKitting", "Y");
        return "warehouse/requestConfirm";
    }

    @GetMapping("/inventory/detail/list-ui")
    public String inventoryDetail() {
        return "warehouse/inventoryDetail";
    }

    @GetMapping("/ledger/list-ui")
    public String ledger() {
        return "warehouse/ledger";
    }

    @GetMapping("/transaction/list-ui")
    public String transaction() {
        return "warehouse/transaction";
    }

    @PostMapping("/request/page")
    @ResponseBody
    public Result requestPage(SpWarehouseRequestReq req) {
        return Result.success(warehouseRequestService.pageList(req));
    }

    @PostMapping("/request/items")
    @ResponseBody
    public Result requestItems(SpWarehouseRequestReq req) {
        return Result.success(warehouseRequestService.pageItems(req));
    }

    @PostMapping("/request/apply")
    @ResponseBody
    public Result apply(SpWarehouseApplyReq req) {
        return warehouseRequestService.apply(req, currentUser());
    }

    @PostMapping("/request/confirm-item")
    @ResponseBody
    public Result confirmItem(@RequestBody SpWarehouseConfirmReq req) {
        try {
            return warehouseRequestService.confirmItem(req, currentUser());
        } catch (IllegalArgumentException ex) {
            return Result.failure(ex.getMessage());
        }
    }

    @PostMapping("/plan-inbound/sync")
    @ResponseBody
    public Result syncPlanInbound() {
        return warehouseRequestService.syncPlanInboundRequests();
    }

    @PostMapping("/kitting-outbound/sync")
    @ResponseBody
    public Result syncKittingOutbound() {
        return warehouseRequestService.syncKittingOutboundRequests();
    }

    @PostMapping("/kitting-outbound/precheck")
    @ResponseBody
    public Result precheckKittingOutbound(@RequestParam String requestId) {
        return warehouseRequestService.precheckKittingOutboundRequest(requestId);
    }

    @PostMapping("/kitting-outbound/plan-inbound-shortage")
    @ResponseBody
    public Result planInboundForKittingShortage(@RequestParam String requestId) {
        try {
            return warehouseRequestService.planInboundForKittingShortage(requestId, currentUser());
        } catch (IllegalArgumentException ex) {
            return Result.failure(ex.getMessage());
        }
    }

    @PostMapping("/kitting-outbound/confirm-request")
    @ResponseBody
    public Result confirmKittingOutbound(@RequestParam String requestId) {
        try {
            return warehouseRequestService.confirmKittingOutboundRequest(requestId, currentUser());
        } catch (IllegalArgumentException ex) {
            return Result.failure(ex.getMessage());
        }
    }

    @PostMapping("/common/available-locations")
    @ResponseBody
    public Result availableLocations(@RequestParam String warehouseId,
                                     @RequestParam(required = false) String materialId,
                                     @RequestParam(required = false) String locationCodeLike,
                                     @RequestParam(required = false) String direction) {
        return Result.success(warehouseRequestService.availableLocations(warehouseId, materialId, locationCodeLike, direction));
    }

    @GetMapping("/common/stock-material-select-ui")
    public String stockMaterialSelect(@RequestParam String warehouseId, Model model) {
        model.addAttribute("warehouseId", warehouseId);
        return "warehouse/stockMaterialSelect";
    }

    @PostMapping("/common/available-materials")
    @ResponseBody
    public Result availableMaterials(SpWarehouseRequestReq req) {
        return Result.success(warehouseRequestService.availableMaterials(req));
    }

    @PostMapping("/inventory/detail/page")
    @ResponseBody
    public Result inventoryDetailPage(SpInventoryReq req) {
        if (StringUtils.isBlank(req.getStockStatus())) {
            req.setStockStatus(WarehouseConstants.STOCK_AVAILABLE);
        }
        return Result.success(inventoryService.pageList(req));
    }

    @PostMapping("/ledger/list")
    @ResponseBody
    public Result ledgerList(SpWarehouseRequestReq req) {
        return Result.success(warehouseRequestService.ledger(req));
    }

    @PostMapping("/transaction/page")
    @ResponseBody
    public Result transactionPage(SpWarehouseRequestReq req) {
        return Result.success(transactionService.pageList(req));
    }

    private void applyModel(Model model, String businessType, String title, String direction) {
        model.addAttribute("businessType", businessType);
        model.addAttribute("pageTitle", title);
        model.addAttribute("direction", direction);
    }

    private void confirmModel(Model model, String businessType, String title, String direction) {
        model.addAttribute("businessType", businessType);
        model.addAttribute("pageTitle", title);
        model.addAttribute("direction", direction);
    }

    private SysUser currentUser() {
        try {
            return getSysUser();
        } catch (Exception ignore) {
            return null;
        }
    }
}
