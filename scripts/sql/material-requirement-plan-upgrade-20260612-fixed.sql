-- MRP upgrade (clean version, original has encoding corruption in COMMENT strings)

CREATE TABLE IF NOT EXISTS `sp_material_requirement_plan` (
  `id` varchar(64) NOT NULL,
  `production_order_id` varchar(64) NOT NULL,
  `production_order_no` varchar(64) DEFAULT NULL,
  `order_item_id` varchar(64) DEFAULT NULL,
  `product_serial_no` varchar(128) DEFAULT NULL,
  `product_materiel` varchar(128) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `material_id` varchar(64) DEFAULT NULL,
  `material_code` varchar(128) NOT NULL,
  `material_name` varchar(255) DEFAULT NULL,
  `material_type` varchar(32) DEFAULT NULL,
  `material_source` varchar(32) DEFAULT NULL,
  `unit` varchar(32) DEFAULT NULL,
  `bom_level` int DEFAULT NULL,
  `bom_path` varchar(1000) DEFAULT NULL,
  `gross_requirement` decimal(16,2) NOT NULL DEFAULT 0.00,
  `available_stock` decimal(16,2) NOT NULL DEFAULT 0.00,
  `safety_stock` decimal(16,2) NOT NULL DEFAULT 0.00,
  `net_requirement` decimal(16,2) NOT NULL DEFAULT 0.00,
  `requirement_date` varchar(32) DEFAULT NULL,
  `lead_time_days` int NOT NULL DEFAULT 1,
  `release_date` varchar(32) DEFAULT NULL,
  `delivery_status` varchar(32) NOT NULL DEFAULT 'WAIT',
  `inbound_status` varchar(32) NOT NULL DEFAULT 'NONE',
  `inbound_request_id` varchar(64) DEFAULT NULL,
  `inbound_request_no` varchar(64) DEFAULT NULL,
  `outbound_status` varchar(32) NOT NULL DEFAULT 'NONE',
  `outbound_request_id` varchar(64) DEFAULT NULL,
  `outbound_request_no` varchar(64) DEFAULT NULL,
  `calc_batch_no` varchar(64) DEFAULT NULL,
  `calc_time` varchar(32) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_mrp_order` (`production_order_id`, `is_deleted`),
  KEY `idx_mrp_material_date` (`material_code`, `requirement_date`),
  KEY `idx_mrp_status` (`delivery_status`, `inbound_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物料需求计划明细';

CREATE TABLE IF NOT EXISTS `sp_material_inbound_request` (
  `id` varchar(64) NOT NULL,
  `request_no` varchar(64) NOT NULL,
  `production_order_id` varchar(64) DEFAULT NULL,
  `production_order_no` varchar(64) DEFAULT NULL,
  `source_batch_no` varchar(64) DEFAULT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'GENERATED',
  `item_count` int NOT NULL DEFAULT 0,
  `total_net_qty` decimal(16,2) NOT NULL DEFAULT 0.00,
  `remark` varchar(500) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_inbound_request_no` (`request_no`),
  KEY `idx_material_inbound_request_order` (`production_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物料入库申请单主表';

CREATE TABLE IF NOT EXISTS `sp_material_inbound_request_item` (
  `id` varchar(64) NOT NULL,
  `request_id` varchar(64) NOT NULL,
  `request_no` varchar(64) DEFAULT NULL,
  `plan_id` varchar(64) NOT NULL,
  `production_order_id` varchar(64) DEFAULT NULL,
  `production_order_no` varchar(64) DEFAULT NULL,
  `material_id` varchar(64) DEFAULT NULL,
  `material_code` varchar(128) DEFAULT NULL,
  `material_name` varchar(255) DEFAULT NULL,
  `unit` varchar(32) DEFAULT NULL,
  `request_qty` decimal(16,2) NOT NULL DEFAULT 0.00,
  `requirement_date` varchar(32) DEFAULT NULL,
  `release_date` varchar(32) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_inbound_item_plan` (`plan_id`),
  KEY `idx_material_inbound_item_request` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物料入库申请单明细';

-- 补充 outbound 字段（幂等）
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_status');
SET @sql := IF(@col = 0, 'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_status` varchar(32) NOT NULL DEFAULT ''NONE'' AFTER `inbound_request_no`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_request_id');
SET @sql := IF(@col = 0, 'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_id` varchar(64) DEFAULT NULL AFTER `outbound_status`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_request_no');
SET @sql := IF(@col = 0, 'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_no` varchar(64) DEFAULT NULL AFTER `outbound_request_id`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 菜单注册
INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
SELECT menu_id, menu_code, menu_name, menu_url, 'production_order_center', '3', menu_sort, '0', menu_permission, menu_icon, menu_name, NOW(), 'admin', NOW(), 'admin'
FROM (
  SELECT 'material_requirement_plan' menu_id, 'materialRequirementPlan' menu_code, '物料需求计划(明细)' menu_name, '/production-order/material-plan/list-ui' menu_url, 4 menu_sort, 'productionOrder:materialPlan' menu_permission, 'fa fa-cubes' menu_icon
  UNION ALL SELECT 'material_requirement_week', 'materialRequirementWeek', '物料需求计划(查询)', '/production-order/material-plan/week-ui', 5, 'productionOrder:materialPlanWeek', 'fa fa-calendar'
  UNION ALL SELECT 'material_inbound_request', 'materialInboundRequest', '入库申请单', '/production-order/material-plan/inbound-request/list-ui', 6, 'productionOrder:inboundRequest', 'fa fa-archive'
) menus
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_menu` sm WHERE sm.`id` = menus.menu_id);

UPDATE `sp_sys_menu` SET `name` = '物料需求计划(明细)', `descr` = '物料需求计划明细', `url` = '/production-order/material-plan/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 4, `permission` = 'productionOrder:materialPlan', `icon` = 'fa fa-cubes', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'material_requirement_plan';
UPDATE `sp_sys_menu` SET `name` = '物料需求计划(查询)', `descr` = '物料需求计划查询', `url` = '/production-order/material-plan/week-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 5, `permission` = 'productionOrder:materialPlanWeek', `icon` = 'fa fa-calendar', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'material_requirement_week';
UPDATE `sp_sys_menu` SET `name` = '入库申请单', `descr` = '入库申请单', `url` = '/production-order/material-plan/inbound-request/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 6, `permission` = 'productionOrder:inboundRequest', `icon` = 'fa fa-archive', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'material_inbound_request';

-- 角色授权
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin', '888888', 'productionPlannerRole', 'productionManagerRole', 'warehouseManagerRole')
  AND m.id IN ('material_requirement_plan', 'material_requirement_week', 'material_inbound_request')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
