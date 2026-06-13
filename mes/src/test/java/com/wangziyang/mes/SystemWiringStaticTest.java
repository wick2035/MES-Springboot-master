package com.wangziyang.mes;

import org.junit.Test;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

public class SystemWiringStaticTest {

    @Test
    public void menuAndOrderFormsPostToTheirOwnControllers() throws Exception {
        String menuForm = read("src/main/resources/templates/admin/system/menu/addOrUpdate.ftl");
        String orderForm = read("src/main/resources/templates/order/production/addOrUpdate.ftl");
        String orderList = read("src/main/resources/templates/order/production/list.ftl");
        String orderController = read("src/main/java/com/wangziyang/mes/order/controller/SpOrderController.java");

        assertTrue(menuForm.contains("/admin/sys/menu/add-or-update"));
        assertFalse(menuForm.contains("/admin/sys/user/add-or-update"));
        assertTrue(orderForm.contains("/order/release/add-or-update"));
        assertFalse(orderForm.contains("/technology/bom/add-or-update"));
        assertTrue(orderList.contains("/order/release/approve"));
        assertTrue(orderController.contains("@PostMapping(\"/approve\")"));
    }

    @Test
    public void snProcessUpgradeReplacesPlaceholderMenu() throws Exception {
        String upgrade = read("../scripts/sql/sn-process-collect-upgrade-20260608.sql");

        assertTrue(upgrade.contains("/wip/sn-process/list-ui"));
        assertFalse(upgrade.contains("'/rrr'"));
    }

    @Test
    public void orderApprovalUpgradeAddsDesignerAndProductionManagerApproval() throws Exception {
        String upgrade = read("../scripts/sql/order-approval-upgrade-20260608.sql");
        String readme = read("../README.md");

        assertTrue(upgrade.contains("designer_id"));
        assertTrue(upgrade.contains("approve_username"));
        assertTrue(upgrade.contains("productionManagerRole"));
        assertTrue(readme.contains("order-approval-upgrade-20260608.sql"));
    }

    @Test
    public void roleAuthMenuWorksWithSpLayerConfirmButton() throws Exception {
        String authMenu = read("src/main/resources/templates/admin/system/role/authMenu.ftl");

        assertTrue(authMenu.contains("id=\"js-submit\""));
        assertTrue(authMenu.contains("saveAuth(false)"));
        assertTrue(authMenu.contains("traditional: true"));
        assertTrue(authMenu.contains("/admin/sys/role/auth-menu"));
    }

    @Test
    public void productionOrderPlanUpgradeKeepsRequiredWorkflowEntrypoints() throws Exception {
        String controller = read("src/main/java/com/wangziyang/mes/productionorder/controller/SpProductionOrderController.java");
        String service = read("src/main/java/com/wangziyang/mes/productionorder/service/impl/SpProductionOrderServiceImpl.java");
        String list = read("src/main/resources/templates/productionorder/plan/list.ftl");
        String form = read("src/main/resources/templates/productionorder/plan/addOrUpdate.ftl");
        String forecast = read("src/main/resources/templates/productionorder/plan/forecast.ftl");
        String workflowEvent = read("src/main/java/com/wangziyang/mes/workflow/service/impl/SpWorkflowEventServiceImpl.java");
        String upgrade = read("../scripts/sql/production-order-center-upgrade-20260611.sql");

        assertTrue(controller.contains("@PostMapping(\"/submit\")"));
        assertTrue(controller.contains("@PostMapping(\"/import\")"));
        assertTrue(controller.contains("@GetMapping(\"/import-template\")"));
        assertTrue(controller.contains("@PostMapping(\"/erp/sync\")"));
        assertTrue(controller.contains("@PostMapping(\"/dispatch\")"));
        assertTrue(controller.contains("@PostMapping(\"/operation-plan\")"));
        assertTrue(service.contains("SCHEDULE_FORWARD"));
        assertTrue(service.contains("SCHEDULE_REVERSE"));
        assertTrue(workflowEvent.contains("OP_WAIT_CALC"));
        assertTrue(list.contains("/production-order/plan/erp/sync"));
        assertTrue(list.contains("WAIT_CALC"));
        assertTrue(form.contains("js-plan-preview"));
        assertTrue(form.contains("select-bom-panel-ui"));
        assertTrue(forecast.contains("/production-order/plan/forecast/generate"));
        assertTrue(forecast.contains("js-preview-body"));
        assertTrue(upgrade.contains("sp_production_order_oper_plan"));
        assertTrue(upgrade.contains("approval_status"));
        assertTrue(upgrade.contains("operation_status"));
    }

    @Test
    public void workflowDefaultsUseProductionManagerAndAdminOverride() throws Exception {
        String constants = read("src/main/java/com/wangziyang/mes/workflow/WorkflowConstants.java");
        String permission = read("src/main/java/com/wangziyang/mes/workflow/WorkflowPermissionUtil.java");
        String workflowInit = read("src/main/java/com/wangziyang/mes/workflow/config/WorkflowSchemaInitializer.java");
        String taskService = read("src/main/java/com/wangziyang/mes/workflow/service/impl/SpWorkflowTaskServiceImpl.java");

        assertTrue(constants.contains("ROLE_PRODUCTION_MANAGER"));
        assertTrue(permission.contains("isSuperAdmin"));
        assertTrue(permission.contains("canApproveProduction"));
        assertTrue(workflowInit.contains("productionManagerRole"));
        assertTrue(workflowInit.contains("warehouseManagerRole"));
        assertTrue(taskService.contains("canHandleLegacyProductionApproval"));
    }

    @Test
    public void warehouseManagementCenterKeepsMenusAndPlanInboundFlowConnected() throws Exception {
        String initializer = read("src/main/java/com/wangziyang/mes/warehouse/config/WarehouseManagementSchemaInitializer.java");
        String controller = read("src/main/java/com/wangziyang/mes/warehouse/controller/SpWarehouseCenterController.java");
        String service = read("src/main/java/com/wangziyang/mes/warehouse/service/impl/SpWarehouseRequestServiceImpl.java");
        String materialPlanController = read("src/main/java/com/wangziyang/mes/productionorder/controller/SpMaterialRequirementPlanController.java");
        String materialPlanPage = read("src/main/resources/templates/productionorder/materialplan/list.ftl");
        String confirmPage = read("src/main/resources/templates/warehouse/requestConfirm.ftl");
        String upgrade = read("../scripts/sql/warehouse-management-center-upgrade-20260612.sql");

        assertTrue(initializer.contains("warehouse_management_center"));
        assertTrue(initializer.contains("warehouseManagementCenter"));
        assertTrue(initializer.contains("warehouse_manual_in_apply"));
        assertTrue(initializer.contains("warehouse_plan_in_confirm"));
        assertTrue(initializer.contains("warehouse_transaction"));
        assertTrue(initializer.contains("warehouseManagerRole"));
        assertTrue(initializer.contains("sp_warehouse_request"));
        assertTrue(initializer.contains("sp_warehouse_transaction"));
        assertTrue(initializer.contains("sp_warehouse_request_allocation"));
        assertTrue(initializer.contains("outbound_status"));
        assertTrue(initializer.contains("stock_status"));
        assertTrue(controller.contains("@RequestMapping(\"/warehouse\")"));
        assertTrue(controller.contains("/plan-inbound/confirm/list-ui"));
        assertTrue(controller.contains("/kitting-outbound/confirm/list-ui"));
        assertTrue(controller.contains("/kitting-outbound/precheck"));
        assertTrue(controller.contains("/kitting-outbound/plan-inbound-shortage"));
        assertTrue(controller.contains("/kitting-outbound/confirm-request"));
        assertTrue(controller.contains("/transaction/list-ui"));
        assertTrue(service.contains("syncPlanInboundRequests"));
        assertTrue(service.contains("BUSINESS_PLAN_IN"));
        assertTrue(service.contains("generateKittingOutboundRequest"));
        assertTrue(service.contains("planInboundForKittingShortage"));
        assertTrue(service.contains("confirmKittingOutboundRequest"));
        assertTrue(service.contains("FIFO"));
        assertTrue(materialPlanController.contains("warehouseRequestService.syncPlanInboundRequests"));
        assertTrue(materialPlanController.contains("/generate-kitting-outbound-request"));
        assertTrue(materialPlanPage.contains("lay-event=\"kitting\""));
        assertFalse(materialPlanPage.contains("lay-event=\"release\""));
        assertFalse(materialPlanPage.contains("lay-event=\"inbound\""));
        assertTrue(materialPlanPage.contains("outboundStatus"));
        assertTrue(confirmPage.contains("/warehouse/request/confirm-item"));
        assertTrue(confirmPage.contains("/warehouse/kitting-outbound/plan-inbound-shortage"));
        assertTrue(confirmPage.contains("/warehouse/kitting-outbound/confirm-request"));
        assertTrue(confirmPage.contains("库存不足，是否计划入库这些材料？"));
        assertTrue(confirmPage.contains("confirmRequestBtn"));
        assertTrue(confirmPage.contains("loadPrecheck"));
        assertFalse(confirmPage.contains("/warehouse/kitting-outbound/sync"));
        assertTrue(upgrade.contains("warehouse_inventory_detail"));
        assertTrue(upgrade.contains("sp_warehouse_request_allocation"));
        assertTrue(upgrade.contains("outbound_request_no"));
        assertTrue(upgrade.contains("warehouse_kitting_out_confirm"));
    }

    private String read(String path) throws Exception {
        Path resolved = Paths.get(path).toAbsolutePath().normalize();
        return new String(Files.readAllBytes(resolved), StandardCharsets.UTF_8);
    }
}
