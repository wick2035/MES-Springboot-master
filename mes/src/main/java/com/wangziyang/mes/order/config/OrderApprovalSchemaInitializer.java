package com.wangziyang.mes.order.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * Keeps the local development database compatible with the order approval fields.
 */
@Component
public class OrderApprovalSchemaInitializer implements ApplicationRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Value("${mes.schema.init-menus:false}")
    private boolean initMenus;

    @Override
    public void run(ApplicationArguments args) {
        addColumnIfMissing("designer_id",
                "ALTER TABLE `sp_order` ADD COLUMN `designer_id` varchar(64) DEFAULT NULL COMMENT 'Designer user ID' AFTER `statue`");
        addColumnIfMissing("designer_name",
                "ALTER TABLE `sp_order` ADD COLUMN `designer_name` varchar(64) DEFAULT NULL COMMENT 'Designer name' AFTER `designer_id`");
        addColumnIfMissing("approve_user_id",
                "ALTER TABLE `sp_order` ADD COLUMN `approve_user_id` varchar(64) DEFAULT NULL COMMENT 'Approver user ID' AFTER `designer_name`");
        addColumnIfMissing("approve_username",
                "ALTER TABLE `sp_order` ADD COLUMN `approve_username` varchar(64) DEFAULT NULL COMMENT 'Approver name' AFTER `approve_user_id`");
        addColumnIfMissing("approve_time",
                "ALTER TABLE `sp_order` ADD COLUMN `approve_time` varchar(32) DEFAULT NULL COMMENT 'Approval time' AFTER `approve_username`");
        addColumnIfMissing("work_status",
                "ALTER TABLE `sp_order` ADD COLUMN `work_status` varchar(32) NOT NULL DEFAULT 'NOT_STARTED' COMMENT 'Work start status' AFTER `approve_time`");
        addColumnIfMissing("work_start_time",
                "ALTER TABLE `sp_order` ADD COLUMN `work_start_time` varchar(32) DEFAULT NULL COMMENT 'Work start time' AFTER `work_status`");
        addColumnIfMissing("complete_status",
                "ALTER TABLE `sp_order` ADD COLUMN `complete_status` varchar(32) NOT NULL DEFAULT 'WAIT' COMMENT 'Complete status WAIT/COMPLETED' AFTER `work_start_time`");
        addColumnIfMissing("complete_time",
                "ALTER TABLE `sp_order` ADD COLUMN `complete_time` varchar(32) DEFAULT NULL COMMENT 'Complete time' AFTER `complete_status`");
        addColumnIfMissing("complete_username",
                "ALTER TABLE `sp_order` ADD COLUMN `complete_username` varchar(64) DEFAULT NULL COMMENT 'Complete operator' AFTER `complete_time`");
        addColumnIfMissing("delivery_status",
                "ALTER TABLE `sp_order` ADD COLUMN `delivery_status` varchar(32) NOT NULL DEFAULT 'WAIT' COMMENT 'Delivery status WAIT/DELIVERED' AFTER `complete_username`");
        addColumnIfMissing("delivery_time",
                "ALTER TABLE `sp_order` ADD COLUMN `delivery_time` varchar(32) DEFAULT NULL COMMENT 'Delivery time' AFTER `delivery_status`");
        addColumnIfMissing("delivery_username",
                "ALTER TABLE `sp_order` ADD COLUMN `delivery_username` varchar(64) DEFAULT NULL COMMENT 'Delivery operator' AFTER `delivery_time`");
        addIndexIfMissing("idx_order_complete_status",
                "CREATE INDEX `idx_order_complete_status` ON `sp_order` (`complete_status`)");
        addIndexIfMissing("idx_order_delivery_status",
                "CREATE INDEX `idx_order_delivery_status` ON `sp_order` (`delivery_status`)");
        if (initMenus) {
            initOrderLifecycleMenus();
        }
    }

    private void addColumnIfMissing(String columnName, String ddl) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = ?",
                new Object[]{columnName},
                Integer.class);
        if (count == null || count == 0) {
            jdbcTemplate.execute(ddl);
        }
    }

    private void addIndexIfMissing(String indexName, String ddl) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND INDEX_NAME = ?",
                new Object[]{indexName},
                Integer.class);
        if (count == null || count == 0) {
            jdbcTemplate.execute(ddl);
        }
    }

    private void initOrderLifecycleMenus() {
        jdbcTemplate.execute("UPDATE `sp_sys_menu` SET `name` = '工单管理', `update_time` = NOW(), `update_username` = 'admin' "
                + "WHERE `code` = 'orderRelease'");
        jdbcTemplate.execute("INSERT INTO `sp_sys_menu` "
                + "(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`) "
                + "SELECT 'orderDelivered', 'orderDelivered', '已交付工单', '/order/delivered/list-ui', '12', '3', 2, '0', 'user:add', 'fa fa-check-square-o', '已交付工单', NOW(), 'admin', NOW(), 'admin' "
                + "WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_menu` WHERE `id` = 'orderDelivered' OR `code` = 'orderDelivered')");
        jdbcTemplate.execute("UPDATE `sp_sys_menu` SET `name` = '已交付工单', `url` = '/order/delivered/list-ui', `parent_id` = '12', "
                + "`grade` = '3', `sort_num` = 2, `icon` = 'fa fa-check-square-o', `update_time` = NOW(), `update_username` = 'admin' "
                + "WHERE `code` = 'orderDelivered'");
        jdbcTemplate.execute("INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username) "
                + "SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin' "
                + "FROM `sp_sys_role` r CROSS JOIN `sp_sys_menu` m "
                + "WHERE r.code IN ('888888', 'productionPlannerRole', 'planManagerRole', 'productionManagerRole', 'warehouseManagerRole') "
                + "AND m.code IN ('orderRelease', 'orderDelivered') "
                + "AND NOT EXISTS (SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id)");
    }
}
