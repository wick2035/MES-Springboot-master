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
    public void orderApprovalUpgradeAddsDesignerAndWarehouseApproval() throws Exception {
        String upgrade = read("../scripts/sql/order-approval-upgrade-20260608.sql");
        String readme = read("../README.md");

        assertTrue(upgrade.contains("designer_id"));
        assertTrue(upgrade.contains("approve_username"));
        assertTrue(upgrade.contains("warehouseManagerRole"));
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

    private String read(String path) throws Exception {
        Path resolved = Paths.get(path).toAbsolutePath().normalize();
        return new String(Files.readAllBytes(resolved), StandardCharsets.UTF_8);
    }
}
