package com.wangziyang.mes.warehouse.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class WarehouseManagementSchemaInitializer implements ApplicationRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Value("${mes.schema.init-menus:false}")
    private boolean initMenus;

    @Override
    public void run(ApplicationArguments args) {
        createTables();
        migrateColumns();
        if (initMenus) {
            ensureMenus();
        }
    }

    private void createTables() {
        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_warehouse_request` ("
                + "`id` varchar(64) NOT NULL,"
                + "`request_no` varchar(64) NOT NULL,"
                + "`business_type` varchar(32) NOT NULL,"
                + "`source_type` varchar(32) DEFAULT NULL,"
                + "`source_id` varchar(64) DEFAULT NULL,"
                + "`source_no` varchar(64) DEFAULT NULL,"
                + "`warehouse_id` varchar(64) DEFAULT NULL,"
                + "`status` varchar(32) NOT NULL DEFAULT 'WAIT_CONFIRM',"
                + "`item_count` int NOT NULL DEFAULT 0,"
                + "`total_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,"
                + "`apply_username` varchar(64) DEFAULT NULL,"
                + "`apply_time` varchar(32) DEFAULT NULL,"
                + "`confirm_username` varchar(64) DEFAULT NULL,"
                + "`confirm_time` varchar(32) DEFAULT NULL,"
                + "`remark` varchar(500) DEFAULT NULL,"
                + "`is_deleted` varchar(1) NOT NULL DEFAULT '0',"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) DEFAULT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) DEFAULT NULL,"
                + "PRIMARY KEY (`id`),"
                + "UNIQUE KEY `uk_warehouse_request_no` (`request_no`),"
                + "KEY `idx_warehouse_request_type_status` (`business_type`,`status`),"
                + "KEY `idx_warehouse_request_source` (`source_type`,`source_id`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='warehouse inbound/outbound request header'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_warehouse_request_item` ("
                + "`id` varchar(64) NOT NULL,"
                + "`request_id` varchar(64) NOT NULL,"
                + "`material_id` varchar(64) NOT NULL,"
                + "`material_code` varchar(128) DEFAULT NULL,"
                + "`material_name` varchar(255) DEFAULT NULL,"
                + "`warehouse_id` varchar(64) DEFAULT NULL,"
                + "`location_id` varchar(64) DEFAULT NULL,"
                + "`batch_no` varchar(128) DEFAULT NULL,"
                + "`request_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,"
                + "`confirmed_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,"
                + "`unit` varchar(32) DEFAULT NULL,"
                + "`status` varchar(32) NOT NULL DEFAULT 'WAIT_CONFIRM',"
                + "`source_item_id` varchar(64) DEFAULT NULL,"
                + "`remark` varchar(500) DEFAULT NULL,"
                + "`is_deleted` varchar(1) NOT NULL DEFAULT '0',"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) DEFAULT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) DEFAULT NULL,"
                + "PRIMARY KEY (`id`),"
                + "KEY `idx_warehouse_request_item_req` (`request_id`),"
                + "KEY `idx_warehouse_request_item_src` (`source_item_id`),"
                + "KEY `idx_warehouse_request_item_stock` (`warehouse_id`,`location_id`,`material_id`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='warehouse inbound/outbound request item'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_warehouse_transaction` ("
                + "`id` varchar(64) NOT NULL,"
                + "`transaction_no` varchar(64) NOT NULL,"
                + "`request_id` varchar(64) DEFAULT NULL,"
                + "`request_no` varchar(64) DEFAULT NULL,"
                + "`request_item_id` varchar(64) DEFAULT NULL,"
                + "`direction` varchar(8) NOT NULL,"
                + "`business_type` varchar(32) NOT NULL,"
                + "`warehouse_id` varchar(64) NOT NULL,"
                + "`location_id` varchar(64) NOT NULL,"
                + "`material_id` varchar(64) NOT NULL,"
                + "`batch_no` varchar(128) DEFAULT NULL,"
                + "`qty` decimal(18,4) NOT NULL DEFAULT 0.0000,"
                + "`before_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,"
                + "`after_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,"
                + "`operator_username` varchar(64) DEFAULT NULL,"
                + "`operate_time` varchar(32) DEFAULT NULL,"
                + "`remark` varchar(500) DEFAULT NULL,"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) DEFAULT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) DEFAULT NULL,"
                + "PRIMARY KEY (`id`),"
                + "UNIQUE KEY `uk_warehouse_transaction_no` (`transaction_no`),"
                + "KEY `idx_warehouse_transaction_req` (`request_no`),"
                + "KEY `idx_warehouse_transaction_stock` (`warehouse_id`,`location_id`,`material_id`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='warehouse stock transaction'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_warehouse_request_allocation` ("
                + "`id` varchar(64) NOT NULL,"
                + "`request_id` varchar(64) NOT NULL,"
                + "`request_item_id` varchar(64) NOT NULL,"
                + "`inventory_id` varchar(64) NOT NULL,"
                + "`warehouse_id` varchar(64) NOT NULL,"
                + "`location_id` varchar(64) NOT NULL,"
                + "`material_id` varchar(64) NOT NULL,"
                + "`batch_no` varchar(128) DEFAULT NULL,"
                + "`qty` decimal(18,4) NOT NULL DEFAULT 0.0000,"
                + "`before_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,"
                + "`after_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,"
                + "`allocation_rule` varchar(32) NOT NULL DEFAULT 'FIFO',"
                + "`status` varchar(32) NOT NULL DEFAULT 'CONFIRMED',"
                + "`is_deleted` varchar(1) NOT NULL DEFAULT '0',"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) DEFAULT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) DEFAULT NULL,"
                + "PRIMARY KEY (`id`),"
                + "KEY `idx_wh_alloc_req` (`request_id`),"
                + "KEY `idx_wh_alloc_item` (`request_item_id`),"
                + "KEY `idx_wh_alloc_stock` (`inventory_id`,`material_id`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='warehouse request FIFO allocation'");
    }

    private void migrateColumns() {
        addColumnIfMissing("sp_inventory", "stock_status",
                "ALTER TABLE `sp_inventory` ADD COLUMN `stock_status` varchar(32) NOT NULL DEFAULT 'AVAILABLE' AFTER `unit`");
        jdbcTemplate.update("UPDATE `sp_inventory` SET `stock_status` = 'AVAILABLE' WHERE `stock_status` IS NULL OR `stock_status` = ''");
        addColumnIfMissing("sp_material_requirement_plan", "outbound_status",
                "ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_status` varchar(32) NOT NULL DEFAULT 'NONE' AFTER `inbound_request_no`");
        addColumnIfMissing("sp_material_requirement_plan", "outbound_request_id",
                "ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_id` varchar(64) DEFAULT NULL AFTER `outbound_status`");
        addColumnIfMissing("sp_material_requirement_plan", "outbound_request_no",
                "ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_no` varchar(64) DEFAULT NULL AFTER `outbound_request_id`");
        jdbcTemplate.update("UPDATE `sp_material_requirement_plan` SET `outbound_status` = 'NONE' WHERE `outbound_status` IS NULL OR `outbound_status` = ''");
    }

    private void ensureMenus() {
        upsertMenu("warehouse_management_center", "warehouseManagementCenter", "库房管理中心", "#",
                "1", "2", 4, "warehouse:view", "fa fa-industry", "库房管理中心");
        upsertMenu("warehouse_manual_in_apply", "warehouseManualInApply", "手工入库申请", "/warehouse/manual-inbound/apply/list-ui",
                "warehouse_management_center", "3", 1, "warehouse:manualIn:apply", "fa fa-sign-in", "手工入库申请");
        upsertMenu("warehouse_manual_in_confirm", "warehouseManualInConfirm", "手工入库确认", "/warehouse/manual-inbound/confirm/list-ui",
                "warehouse_management_center", "3", 2, "warehouse:manualIn:confirm", "fa fa-check-square-o", "手工入库确认");
        upsertMenu("warehouse_plan_in_confirm", "warehousePlanInConfirm", "计划入库确认", "/warehouse/plan-inbound/confirm/list-ui",
                "warehouse_management_center", "3", 3, "warehouse:planIn:confirm", "fa fa-archive", "计划入库确认");
        upsertMenu("warehouse_manual_out_apply", "warehouseManualOutApply", "手工出库申请", "/warehouse/manual-outbound/apply/list-ui",
                "warehouse_management_center", "3", 4, "warehouse:manualOut:apply", "fa fa-sign-out", "手工出库申请");
        upsertMenu("warehouse_manual_out_confirm", "warehouseManualOutConfirm", "手工出库确认", "/warehouse/manual-outbound/confirm/list-ui",
                "warehouse_management_center", "3", 5, "warehouse:manualOut:confirm", "fa fa-check", "手工出库确认");
        upsertMenu("warehouse_kitting_out_confirm", "warehouseKittingOutConfirm", "配套出库确认", "/warehouse/kitting-outbound/confirm/list-ui",
                "warehouse_management_center", "3", 6, "warehouse:kittingOut:confirm", "fa fa-cubes", "配套出库确认");
        upsertMenu("warehouse_inventory_detail", "warehouseInventoryDetail", "库存明细查询", "/warehouse/inventory/detail/list-ui",
                "warehouse_management_center", "3", 7, "warehouse:inventory:detail", "fa fa-list", "库存明细查询");
        upsertMenu("warehouse_transaction", "warehouseTransaction", "出入库流水查询", "/warehouse/transaction/list-ui",
                "warehouse_management_center", "3", 9, "warehouse:transaction", "fa fa-exchange", "出入库流水查询");

        jdbcTemplate.update("DELETE FROM `sp_sys_role_menu` WHERE `menu_id` = 'warehouse_ledger'");
        jdbcTemplate.update("DELETE FROM `sp_sys_menu` WHERE `id` = 'warehouse_ledger'");

        jdbcTemplate.update("INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username) "
                + "SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin' "
                + "FROM `sp_sys_role` r CROSS JOIN `sp_sys_menu` m "
                + "WHERE r.code IN ('admin', '888888', 'warehouseManagerRole', 'productionManagerRole') "
                + "AND m.id IN ('warehouse_management_center','warehouse_manual_in_apply','warehouse_manual_in_confirm',"
                + "'warehouse_plan_in_confirm','warehouse_manual_out_apply','warehouse_manual_out_confirm',"
                + "'warehouse_kitting_out_confirm','warehouse_inventory_detail','warehouse_transaction') "
                + "AND NOT EXISTS (SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id)");
    }

    private void addColumnIfMissing(String tableName, String columnName, String ddl) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?",
                new Object[]{tableName, columnName},
                Integer.class);
        if (count == null || count == 0) {
            jdbcTemplate.execute(ddl);
        }
    }

    private void upsertMenu(String id, String code, String name, String url, String parentId,
                            String grade, int sortNum, String permission, String icon, String descr) {
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM `sp_sys_menu` WHERE `id` = ?",
                new Object[]{id}, Integer.class);
        if (count == null || count == 0) {
            jdbcTemplate.update("INSERT INTO `sp_sys_menu` "
                            + "(`id`,`code`,`name`,`url`,`parent_id`,`grade`,`sort_num`,`type`,`permission`,`icon`,`descr`,"
                            + "`create_time`,`create_username`,`update_time`,`update_username`) "
                            + "VALUES (?,?,?,?,?,?,?,?,?,?,?,NOW(),'admin',NOW(),'admin')",
                    id, code, name, url, parentId, grade, sortNum, "0", permission, icon, descr);
        } else {
            jdbcTemplate.update("UPDATE `sp_sys_menu` SET `code`=?, `name`=?, `url`=?, `parent_id`=?, "
                            + "`grade`=?, `sort_num`=?, `type`='0', `permission`=?, `icon`=?, `descr`=?, "
                            + "`update_time`=NOW(), `update_username`='admin' WHERE `id`=?",
                    code, name, url, parentId, grade, sortNum, permission, icon, descr, id);
        }
    }
}
