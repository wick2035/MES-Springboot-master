package com.wangziyang.mes.productionorder.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class ProductionOrderSchemaInitializer implements ApplicationRunner {

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
        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_production_order` ("
                + "`id` varchar(64) NOT NULL,"
                + "`order_no` varchar(64) NOT NULL,"
                + "`source_type` varchar(16) NOT NULL,"
                + "`customer_name` varchar(128) DEFAULT NULL,"
                + "`customer_group` varchar(128) DEFAULT NULL,"
                + "`external_no` varchar(128) DEFAULT NULL,"
                + "`sales_contract_no` varchar(128) DEFAULT NULL,"
                + "`business_type` varchar(64) DEFAULT NULL,"
                + "`order_date` varchar(32) DEFAULT NULL,"
                + "`settlement_currency` varchar(32) DEFAULT NULL,"
                + "`transport_mode` varchar(64) DEFAULT NULL,"
                + "`payment_terms` varchar(128) DEFAULT NULL,"
                + "`tax_rate` varchar(32) DEFAULT NULL,"
                + "`receiver_name` varchar(64) DEFAULT NULL,"
                + "`receiver_phone` varchar(64) DEFAULT NULL,"
                + "`receiver_address` varchar(255) DEFAULT NULL,"
                + "`remark` varchar(500) DEFAULT NULL,"
                + "`status` varchar(32) NOT NULL DEFAULT 'DRAFT',"
                + "`approval_status` varchar(32) NOT NULL DEFAULT 'DRAFT',"
                + "`operation_status` varchar(32) NOT NULL DEFAULT 'NONE',"
                + "`creation_method` varchar(32) NOT NULL DEFAULT 'MANUAL',"
                + "`scheduling_method` varchar(32) NOT NULL DEFAULT 'REVERSE',"
                + "`erp_source_no` varchar(128) DEFAULT NULL,"
                + "`erp_sync_time` varchar(32) DEFAULT NULL,"
                + "`is_deleted` varchar(1) NOT NULL DEFAULT '0',"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) DEFAULT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) DEFAULT NULL,"
                + "PRIMARY KEY (`id`),"
                + "UNIQUE KEY `uk_sp_production_order_no` (`order_no`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='production order plan header'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_production_order_item` ("
                + "`id` varchar(64) NOT NULL,"
                + "`order_id` varchar(64) NOT NULL,"
                + "`product_materiel` varchar(128) NOT NULL,"
                + "`product_name` varchar(255) NOT NULL,"
                + "`bom_id` varchar(64) DEFAULT NULL,"
                + "`bom_code` varchar(128) DEFAULT NULL,"
                + "`bom_version` varchar(64) DEFAULT NULL,"
                + "`model` varchar(128) DEFAULT NULL,"
                + "`specification` varchar(128) DEFAULT NULL,"
                + "`qty` int NOT NULL DEFAULT 0,"
                + "`unit_price` decimal(12,2) DEFAULT NULL,"
                + "`configuration` varchar(500) DEFAULT NULL,"
                + "`plan_delivery_date` varchar(32) DEFAULT NULL,"
                + "`plan_start_date` varchar(32) DEFAULT NULL,"
                + "`lead_time_days` int NOT NULL DEFAULT 1,"
                + "`target_capacity` decimal(10,2) NOT NULL DEFAULT 5.00,"
                + "`computed_start_date` varchar(32) DEFAULT NULL,"
                + "`computed_delivery_date` varchar(32) DEFAULT NULL,"
                + "`material_ready_date` varchar(32) DEFAULT NULL,"
                + "`adjust_note` varchar(500) DEFAULT NULL,"
                + "`work_order_id` varchar(64) DEFAULT NULL,"
                + "`work_order_code` varchar(64) DEFAULT NULL,"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) DEFAULT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) DEFAULT NULL,"
                + "PRIMARY KEY (`id`),"
                + "KEY `idx_sp_production_order_item_order` (`order_id`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='production order plan item'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_production_order_oper_plan` ("
                + "`id` varchar(64) NOT NULL,"
                + "`order_id` varchar(64) NOT NULL,"
                + "`order_item_id` varchar(64) NOT NULL,"
                + "`order_no` varchar(64) DEFAULT NULL,"
                + "`product_materiel` varchar(128) DEFAULT NULL,"
                + "`product_name` varchar(255) DEFAULT NULL,"
                + "`flow_id` varchar(64) DEFAULT NULL,"
                + "`oper_id` varchar(64) DEFAULT NULL,"
                + "`oper` varchar(128) DEFAULT NULL,"
                + "`oper_desc` varchar(255) DEFAULT NULL,"
                + "`sort_num` int DEFAULT NULL,"
                + "`unit_id` varchar(64) DEFAULT NULL,"
                + "`plan_start_time` varchar(32) DEFAULT NULL,"
                + "`plan_end_time` varchar(32) DEFAULT NULL,"
                + "`duration_hours` decimal(12,2) DEFAULT NULL,"
                + "`duration_source` varchar(32) DEFAULT NULL,"
                + "`schedule_method` varchar(32) DEFAULT NULL,"
                + "`calc_remark` varchar(500) DEFAULT NULL,"
                + "`is_deleted` varchar(1) NOT NULL DEFAULT '0',"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) DEFAULT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) DEFAULT NULL,"
                + "PRIMARY KEY (`id`),"
                + "KEY `idx_po_oper_plan_order` (`order_id`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='production order operation plan'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_order_oper_equipment_assign` ("
                + "`id` varchar(64) NOT NULL,"
                + "`order_id` varchar(64) DEFAULT NULL,"
                + "`order_code` varchar(64) DEFAULT NULL,"
                + "`production_order_id` varchar(64) DEFAULT NULL,"
                + "`order_item_id` varchar(64) DEFAULT NULL,"
                + "`oper_plan_id` varchar(64) NOT NULL,"
                + "`oper_id` varchar(64) DEFAULT NULL,"
                + "`oper` varchar(64) DEFAULT NULL,"
                + "`oper_desc` varchar(255) DEFAULT NULL,"
                + "`sort_num` int DEFAULT NULL,"
                + "`unit_id` varchar(64) DEFAULT NULL,"
                + "`equipment_id` varchar(64) DEFAULT NULL,"
                + "`equipment_code` varchar(64) DEFAULT NULL,"
                + "`equipment_name` varchar(128) DEFAULT NULL,"
                + "`status` varchar(16) NOT NULL DEFAULT 'WAIT',"
                + "`remark` varchar(255) DEFAULT NULL,"
                + "`is_deleted` varchar(1) NOT NULL DEFAULT '0',"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) DEFAULT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) DEFAULT NULL,"
                + "PRIMARY KEY (`id`),"
                + "UNIQUE KEY `uk_equipment_assign_plan` (`oper_plan_id`),"
                + "KEY `idx_equipment_assign_order` (`order_id`),"
                + "KEY `idx_equipment_assign_equipment` (`equipment_id`, `status`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='operation equipment assignment'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_material_requirement_plan` ("
                + "`id` varchar(64) NOT NULL,"
                + "`production_order_id` varchar(64) NOT NULL,"
                + "`production_order_no` varchar(64) DEFAULT NULL,"
                + "`order_item_id` varchar(64) DEFAULT NULL,"
                + "`product_serial_no` varchar(128) DEFAULT NULL,"
                + "`product_materiel` varchar(128) DEFAULT NULL,"
                + "`product_name` varchar(255) DEFAULT NULL,"
                + "`material_id` varchar(64) DEFAULT NULL,"
                + "`material_code` varchar(128) NOT NULL,"
                + "`material_name` varchar(255) DEFAULT NULL,"
                + "`material_type` varchar(32) DEFAULT NULL,"
                + "`material_source` varchar(32) DEFAULT NULL,"
                + "`unit` varchar(32) DEFAULT NULL,"
                + "`bom_level` int DEFAULT NULL,"
                + "`bom_path` varchar(1000) DEFAULT NULL,"
                + "`gross_requirement` decimal(16,2) NOT NULL DEFAULT 0.00,"
                + "`available_stock` decimal(16,2) NOT NULL DEFAULT 0.00,"
                + "`safety_stock` decimal(16,2) NOT NULL DEFAULT 0.00,"
                + "`net_requirement` decimal(16,2) NOT NULL DEFAULT 0.00,"
                + "`requirement_date` varchar(32) DEFAULT NULL,"
                + "`lead_time_days` int NOT NULL DEFAULT 1,"
                + "`release_date` varchar(32) DEFAULT NULL,"
                + "`delivery_status` varchar(32) NOT NULL DEFAULT 'WAIT',"
                + "`inbound_status` varchar(32) NOT NULL DEFAULT 'NONE',"
                + "`inbound_request_id` varchar(64) DEFAULT NULL,"
                + "`inbound_request_no` varchar(64) DEFAULT NULL,"
                + "`outbound_status` varchar(32) NOT NULL DEFAULT 'NONE',"
                + "`outbound_request_id` varchar(64) DEFAULT NULL,"
                + "`outbound_request_no` varchar(64) DEFAULT NULL,"
                + "`calc_batch_no` varchar(64) DEFAULT NULL,"
                + "`calc_time` varchar(32) DEFAULT NULL,"
                + "`remark` varchar(500) DEFAULT NULL,"
                + "`is_deleted` varchar(1) NOT NULL DEFAULT '0',"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) DEFAULT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) DEFAULT NULL,"
                + "PRIMARY KEY (`id`),"
                + "KEY `idx_mrp_order` (`production_order_id`, `is_deleted`),"
                + "KEY `idx_mrp_material_date` (`material_code`, `requirement_date`),"
                + "KEY `idx_mrp_status` (`delivery_status`, `inbound_status`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='material requirement plan detail'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_material_inbound_request` ("
                + "`id` varchar(64) NOT NULL,"
                + "`request_no` varchar(64) NOT NULL,"
                + "`production_order_id` varchar(64) DEFAULT NULL,"
                + "`production_order_no` varchar(64) DEFAULT NULL,"
                + "`source_batch_no` varchar(64) DEFAULT NULL,"
                + "`status` varchar(32) NOT NULL DEFAULT 'GENERATED',"
                + "`item_count` int NOT NULL DEFAULT 0,"
                + "`total_net_qty` decimal(16,2) NOT NULL DEFAULT 0.00,"
                + "`remark` varchar(500) DEFAULT NULL,"
                + "`is_deleted` varchar(1) NOT NULL DEFAULT '0',"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) DEFAULT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) DEFAULT NULL,"
                + "PRIMARY KEY (`id`),"
                + "UNIQUE KEY `uk_material_inbound_request_no` (`request_no`),"
                + "KEY `idx_material_inbound_request_order` (`production_order_id`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='material inbound request header'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_material_inbound_request_item` ("
                + "`id` varchar(64) NOT NULL,"
                + "`request_id` varchar(64) NOT NULL,"
                + "`request_no` varchar(64) DEFAULT NULL,"
                + "`plan_id` varchar(64) NOT NULL,"
                + "`production_order_id` varchar(64) DEFAULT NULL,"
                + "`production_order_no` varchar(64) DEFAULT NULL,"
                + "`material_id` varchar(64) DEFAULT NULL,"
                + "`material_code` varchar(128) DEFAULT NULL,"
                + "`material_name` varchar(255) DEFAULT NULL,"
                + "`unit` varchar(32) DEFAULT NULL,"
                + "`request_qty` decimal(16,2) NOT NULL DEFAULT 0.00,"
                + "`requirement_date` varchar(32) DEFAULT NULL,"
                + "`release_date` varchar(32) DEFAULT NULL,"
                + "`remark` varchar(500) DEFAULT NULL,"
                + "`is_deleted` varchar(1) NOT NULL DEFAULT '0',"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) DEFAULT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) DEFAULT NULL,"
                + "PRIMARY KEY (`id`),"
                + "UNIQUE KEY `uk_material_inbound_item_plan` (`plan_id`),"
                + "KEY `idx_material_inbound_item_request` (`request_id`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='material inbound request item'");
    }

    private void migrateColumns() {
        addColumnIfMissing("sp_production_order", "approval_status",
                "ALTER TABLE `sp_production_order` ADD COLUMN `approval_status` varchar(32) NOT NULL DEFAULT 'DRAFT' AFTER `status`");
        addColumnIfMissing("sp_production_order", "operation_status",
                "ALTER TABLE `sp_production_order` ADD COLUMN `operation_status` varchar(32) NOT NULL DEFAULT 'NONE' AFTER `approval_status`");
        addColumnIfMissing("sp_production_order", "creation_method",
                "ALTER TABLE `sp_production_order` ADD COLUMN `creation_method` varchar(32) NOT NULL DEFAULT 'MANUAL' AFTER `operation_status`");
        addColumnIfMissing("sp_production_order", "scheduling_method",
                "ALTER TABLE `sp_production_order` ADD COLUMN `scheduling_method` varchar(32) NOT NULL DEFAULT 'REVERSE' AFTER `creation_method`");
        addColumnIfMissing("sp_production_order", "erp_source_no",
                "ALTER TABLE `sp_production_order` ADD COLUMN `erp_source_no` varchar(128) DEFAULT NULL AFTER `scheduling_method`");
        addColumnIfMissing("sp_production_order", "erp_sync_time",
                "ALTER TABLE `sp_production_order` ADD COLUMN `erp_sync_time` varchar(32) DEFAULT NULL AFTER `erp_source_no`");

        addColumnIfMissing("sp_production_order_item", "bom_id",
                "ALTER TABLE `sp_production_order_item` ADD COLUMN `bom_id` varchar(64) DEFAULT NULL AFTER `product_name`");
        addColumnIfMissing("sp_production_order_item", "bom_code",
                "ALTER TABLE `sp_production_order_item` ADD COLUMN `bom_code` varchar(128) DEFAULT NULL AFTER `bom_id`");
        addColumnIfMissing("sp_production_order_item", "bom_version",
                "ALTER TABLE `sp_production_order_item` ADD COLUMN `bom_version` varchar(64) DEFAULT NULL AFTER `bom_code`");
        addColumnIfMissing("sp_production_order_item", "unit_price",
                "ALTER TABLE `sp_production_order_item` ADD COLUMN `unit_price` decimal(12,2) DEFAULT NULL AFTER `qty`");
        addColumnIfMissing("sp_production_order_item", "plan_start_date",
                "ALTER TABLE `sp_production_order_item` ADD COLUMN `plan_start_date` varchar(32) DEFAULT NULL AFTER `plan_delivery_date`");
        addColumnIfMissing("sp_production_order_item", "computed_start_date",
                "ALTER TABLE `sp_production_order_item` ADD COLUMN `computed_start_date` varchar(32) DEFAULT NULL AFTER `target_capacity`");
        addColumnIfMissing("sp_production_order_item", "computed_delivery_date",
                "ALTER TABLE `sp_production_order_item` ADD COLUMN `computed_delivery_date` varchar(32) DEFAULT NULL AFTER `computed_start_date`");
        addColumnIfMissing("sp_production_order_item", "material_ready_date",
                "ALTER TABLE `sp_production_order_item` ADD COLUMN `material_ready_date` varchar(32) DEFAULT NULL AFTER `computed_delivery_date`");
        addColumnIfMissing("sp_production_order_item", "work_order_id",
                "ALTER TABLE `sp_production_order_item` ADD COLUMN `work_order_id` varchar(64) DEFAULT NULL AFTER `adjust_note`");
        addColumnIfMissing("sp_production_order_item", "work_order_code",
                "ALTER TABLE `sp_production_order_item` ADD COLUMN `work_order_code` varchar(64) DEFAULT NULL AFTER `work_order_id`");

        addColumnIfMissing("sp_material_requirement_plan", "outbound_status",
                "ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_status` varchar(32) NOT NULL DEFAULT 'NONE' AFTER `inbound_request_no`");
        addColumnIfMissing("sp_material_requirement_plan", "outbound_request_id",
                "ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_id` varchar(64) DEFAULT NULL AFTER `outbound_status`");
        addColumnIfMissing("sp_material_requirement_plan", "outbound_request_no",
                "ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_no` varchar(64) DEFAULT NULL AFTER `outbound_request_id`");
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

    private void ensureMenus() {
        upsertMenu("production_order_center", "productionOrderCenter", "生产计划中心", "#",
                "1", "2", 3, "productionOrder:view", "fa fa-calendar-check-o", "生产计划中心");
        upsertMenu("production_order_plan", "productionOrderPlan", "生产订单录入", "/production-order/plan/list-ui",
                "production_order_center", "3", 1, "productionOrder:plan", "fa fa-pencil-square-o", "生产订单录入");
        upsertMenu("production_equipment_dispatch", "productionEquipmentDispatch", "设备作业派工", "/production-order/equipment-dispatch/list-ui",
                "production_order_center", "3", 2, "productionOrder:equipmentDispatch", "fa fa-cogs", "设备作业派工");
        upsertMenu("production_employee_dispatch", "productionEmployeeDispatch", "员工作业派工", "/production-order/employee-dispatch/list-ui",
                "production_order_center", "3", 3, "productionOrder:employeeDispatch", "fa fa-users", "员工作业派工");
        upsertMenu("material_requirement_plan", "materialRequirementPlan", "物料需求计划(明细)", "/production-order/material-plan/list-ui",
                "production_order_center", "3", 4, "productionOrder:materialPlan", "fa fa-cubes", "物料需求计划明细");
        upsertMenu("material_requirement_week", "materialRequirementWeek", "物料需求计划(查询)", "/production-order/material-plan/week-ui",
                "production_order_center", "3", 5, "productionOrder:materialPlanWeek", "fa fa-calendar", "物料需求计划查询");
        upsertMenu("material_inbound_request", "materialInboundRequest", "入库申请单", "/production-order/material-plan/inbound-request/list-ui",
                "production_order_center", "3", 6, "productionOrder:inboundRequest", "fa fa-archive", "入库申请单");
        upsertMenu("production_plan_dispatch", "productionPlanDispatch", "生产计划下发", "/production-order/dispatch/list-ui",
                "production_order_center", "3", 7, "productionOrder:dispatch", "fa fa-send", "生产计划下发");
        upsertMenu("production_work_order_query", "productionWorkOrderQuery", "生产工单查询", "/production-order/work-order/list-ui",
                "production_order_center", "3", 8, "productionOrder:workOrder", "fa fa-list-alt", "生产工单查询");

        jdbcTemplate.update("INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username) "
                + "SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin' "
                + "FROM `sp_sys_role` r CROSS JOIN `sp_sys_menu` m "
                + "WHERE r.code IN ('admin', '888888', 'productionPlannerRole', 'productionManagerRole', 'warehouseManagerRole') "
                + "AND m.id IN ('production_order_center','production_order_plan','production_plan_dispatch',"
                + "'production_work_order_query','production_equipment_dispatch','production_employee_dispatch',"
                + "'material_requirement_plan','material_requirement_week','material_inbound_request') "
                + "AND NOT EXISTS (SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id)");
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
