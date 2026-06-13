-- ============================================================
-- 鐗╂枡闇€姹傝鍒掞紙MRP锛夊崌绾ц剼鏈?-- Date: 2026-06-12
-- Content:
--   1) 鏂板鐗╂枡闇€姹傝鍒掓槑缁嗚〃銆?--   2) 鏂板鍏ュ簱鐢宠鍗曚富琛?鏄庣粏琛ㄣ€?--   3) 鏂板鐗╂枡闇€姹傝鍒掕彍鍗曞拰瑙掕壊鎺堟潈銆?-- ============================================================

CREATE TABLE IF NOT EXISTS `sp_material_requirement_plan` (
  `id` varchar(64) NOT NULL COMMENT '涓婚敭ID',
  `production_order_id` varchar(64) NOT NULL COMMENT '鐢熶骇璁㈠崟ID',
  `production_order_no` varchar(64) DEFAULT NULL COMMENT '鐢熶骇璁㈠崟缂栧彿',
  `order_item_id` varchar(64) DEFAULT NULL COMMENT '鐢熶骇璁㈠崟鏄庣粏ID',
  `product_serial_no` varchar(128) DEFAULT NULL COMMENT '浜у搧搴忓垪鍙?,
  `product_materiel` varchar(128) DEFAULT NULL COMMENT '浜у搧鐗╂枡缂栫爜',
  `product_name` varchar(255) DEFAULT NULL COMMENT '浜у搧鍚嶇О',
  `material_id` varchar(64) DEFAULT NULL COMMENT '闇€姹傜墿鏂橧D',
  `material_code` varchar(128) NOT NULL COMMENT '闇€姹傜墿鏂欑紪鐮?,
  `material_name` varchar(255) DEFAULT NULL COMMENT '闇€姹傜墿鏂欏悕绉?,
  `material_type` varchar(32) DEFAULT NULL COMMENT '鐗╂枡绫诲瀷',
  `material_source` varchar(32) DEFAULT NULL COMMENT '鐗╂枡鏉ユ簮',
  `unit` varchar(32) DEFAULT NULL COMMENT '鍗曚綅',
  `bom_level` int DEFAULT NULL COMMENT 'BOM灞傜骇',
  `bom_path` varchar(1000) DEFAULT NULL COMMENT 'BOM璺緞',
  `gross_requirement` decimal(16,2) NOT NULL DEFAULT 0.00 COMMENT '姣涢渶姹?,
  `available_stock` decimal(16,2) NOT NULL DEFAULT 0.00 COMMENT '鍙敤搴撳瓨',
  `safety_stock` decimal(16,2) NOT NULL DEFAULT 0.00 COMMENT '瀹夊叏搴撳瓨',
  `net_requirement` decimal(16,2) NOT NULL DEFAULT 0.00 COMMENT '鍑€闇€姹?,
  `requirement_date` varchar(32) DEFAULT NULL COMMENT '闇€姹傛棩鏈?,
  `lead_time_days` int NOT NULL DEFAULT 1 COMMENT '鎻愬墠鏈?宸ヤ綔鏃?',
  `release_date` varchar(32) DEFAULT NULL COMMENT '寤鸿鍙戝竷鏃ユ湡',
  `delivery_status` varchar(32) NOT NULL DEFAULT 'WAIT' COMMENT '閰嶉€佺姸鎬?WAIT寰呬笅鍙?RELEASED宸蹭笅鍙?,
  `inbound_status` varchar(32) NOT NULL DEFAULT 'NONE' COMMENT '鍏ュ簱鐢宠鐘舵€?NONE鏈敓鎴?GENERATED宸茬敓鎴?,
  `inbound_request_id` varchar(64) DEFAULT NULL COMMENT '鍏ュ簱鐢宠鍗旾D',
  `inbound_request_no` varchar(64) DEFAULT NULL COMMENT '鍏ュ簱鐢宠鍗曞彿',
  `outbound_status` varchar(32) NOT NULL DEFAULT 'NONE' COMMENT '配套出库状态：NONE未申请，GENERATED已申请，CONFIRMED已完成',
  `outbound_request_id` varchar(64) DEFAULT NULL COMMENT '配套出库单ID',
  `outbound_request_no` varchar(64) DEFAULT NULL COMMENT '配套出库单号',
  `calc_batch_no` varchar(64) DEFAULT NULL COMMENT 'MRP杩愮畻鎵规',
  `calc_time` varchar(32) DEFAULT NULL COMMENT 'MRP杩愮畻鏃堕棿',
  `remark` varchar(500) DEFAULT NULL COMMENT '澶囨敞',
  `is_deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '杞垹闄?,
  `create_time` datetime NOT NULL COMMENT '鍒涘缓鏃堕棿',
  `create_username` varchar(64) DEFAULT NULL COMMENT '鍒涘缓浜?,
  `update_time` datetime NOT NULL COMMENT '鏇存柊鏃堕棿',
  `update_username` varchar(64) DEFAULT NULL COMMENT '鏇存柊浜?,
  PRIMARY KEY (`id`),
  KEY `idx_mrp_order` (`production_order_id`, `is_deleted`),
  KEY `idx_mrp_material_date` (`material_code`, `requirement_date`),
  KEY `idx_mrp_status` (`delivery_status`, `inbound_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='鐗╂枡闇€姹傝鍒掓槑缁?;

CREATE TABLE IF NOT EXISTS `sp_material_inbound_request` (
  `id` varchar(64) NOT NULL COMMENT '涓婚敭ID',
  `request_no` varchar(64) NOT NULL COMMENT '鍏ュ簱鐢宠鍗曞彿',
  `production_order_id` varchar(64) DEFAULT NULL COMMENT '鐢熶骇璁㈠崟ID',
  `production_order_no` varchar(64) DEFAULT NULL COMMENT '鐢熶骇璁㈠崟缂栧彿',
  `source_batch_no` varchar(64) DEFAULT NULL COMMENT '鏉ユ簮MRP鎵规',
  `status` varchar(32) NOT NULL DEFAULT 'GENERATED' COMMENT '鐘舵€?GENERATED宸茬敓鎴?CONFIRMED宸茬‘璁?,
  `item_count` int NOT NULL DEFAULT 0 COMMENT '鏄庣粏鏁伴噺',
  `total_net_qty` decimal(16,2) NOT NULL DEFAULT 0.00 COMMENT '鐢宠鎬绘暟閲?,
  `remark` varchar(500) DEFAULT NULL COMMENT '澶囨敞',
  `is_deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '杞垹闄?,
  `create_time` datetime NOT NULL COMMENT '鍒涘缓鏃堕棿',
  `create_username` varchar(64) DEFAULT NULL COMMENT '鍒涘缓浜?,
  `update_time` datetime NOT NULL COMMENT '鏇存柊鏃堕棿',
  `update_username` varchar(64) DEFAULT NULL COMMENT '鏇存柊浜?,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_inbound_request_no` (`request_no`),
  KEY `idx_material_inbound_request_order` (`production_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='鐗╂枡鍏ュ簱鐢宠鍗曚富琛?;

CREATE TABLE IF NOT EXISTS `sp_material_inbound_request_item` (
  `id` varchar(64) NOT NULL COMMENT '涓婚敭ID',
  `request_id` varchar(64) NOT NULL COMMENT '鍏ュ簱鐢宠鍗旾D',
  `request_no` varchar(64) DEFAULT NULL COMMENT '鍏ュ簱鐢宠鍗曞彿',
  `plan_id` varchar(64) NOT NULL COMMENT '鐗╂枡闇€姹傝鍒扞D',
  `production_order_id` varchar(64) DEFAULT NULL COMMENT '鐢熶骇璁㈠崟ID',
  `production_order_no` varchar(64) DEFAULT NULL COMMENT '鐢熶骇璁㈠崟缂栧彿',
  `material_id` varchar(64) DEFAULT NULL COMMENT '鐗╂枡ID',
  `material_code` varchar(128) DEFAULT NULL COMMENT '鐗╂枡缂栫爜',
  `material_name` varchar(255) DEFAULT NULL COMMENT '鐗╂枡鍚嶇О',
  `unit` varchar(32) DEFAULT NULL COMMENT '鍗曚綅',
  `request_qty` decimal(16,2) NOT NULL DEFAULT 0.00 COMMENT '鐢宠鏁伴噺',
  `requirement_date` varchar(32) DEFAULT NULL COMMENT '闇€姹傛棩鏈?,
  `release_date` varchar(32) DEFAULT NULL COMMENT '寤鸿鍙戝竷鏃ユ湡',
  `remark` varchar(500) DEFAULT NULL COMMENT '澶囨敞',
  `is_deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '杞垹闄?,
  `create_time` datetime NOT NULL COMMENT '鍒涘缓鏃堕棿',
  `create_username` varchar(64) DEFAULT NULL COMMENT '鍒涘缓浜?,
  `update_time` datetime NOT NULL COMMENT '鏇存柊鏃堕棿',
  `update_username` varchar(64) DEFAULT NULL COMMENT '鏇存柊浜?,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_inbound_item_plan` (`plan_id`),
  KEY `idx_material_inbound_item_request` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='鐗╂枡鍏ュ簱鐢宠鍗曟槑缁?;

INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
SELECT menu_id, menu_code, menu_name, menu_url, 'production_order_center', '3', menu_sort, '0', menu_permission, menu_icon, menu_name, NOW(), 'admin', NOW(), 'admin'
FROM (
  SELECT 'material_requirement_plan' menu_id, 'materialRequirementPlan' menu_code, '鐗╂枡闇€姹傝鍒?鏄庣粏)' menu_name, '/production-order/material-plan/list-ui' menu_url, 4 menu_sort, 'productionOrder:materialPlan' menu_permission, 'fa fa-cubes' menu_icon
  UNION ALL SELECT 'material_requirement_week', 'materialRequirementWeek', '鐗╂枡闇€姹傝鍒?鏌ヨ)', '/production-order/material-plan/week-ui', 5, 'productionOrder:materialPlanWeek', 'fa fa-calendar'
  UNION ALL SELECT 'material_inbound_request', 'materialInboundRequest', '鍏ュ簱鐢宠鍗?, '/production-order/material-plan/inbound-request/list-ui', 6, 'productionOrder:inboundRequest', 'fa fa-archive'
) menus
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_menu` sm WHERE sm.`id` = menus.menu_id);

UPDATE `sp_sys_menu` SET `name` = '鐗╂枡闇€姹傝鍒?鏄庣粏)', `descr` = '鐗╂枡闇€姹傝鍒掓槑缁?, `url` = '/production-order/material-plan/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 4, `permission` = 'productionOrder:materialPlan', `icon` = 'fa fa-cubes', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'material_requirement_plan';
UPDATE `sp_sys_menu` SET `name` = '鐗╂枡闇€姹傝鍒?鏌ヨ)', `descr` = '鐗╂枡闇€姹傝鍒掓煡璇?, `url` = '/production-order/material-plan/week-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 5, `permission` = 'productionOrder:materialPlanWeek', `icon` = 'fa fa-calendar', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'material_requirement_week';
UPDATE `sp_sys_menu` SET `name` = '鍏ュ簱鐢宠鍗?, `descr` = '鍏ュ簱鐢宠鍗?, `url` = '/production-order/material-plan/inbound-request/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 6, `permission` = 'productionOrder:inboundRequest', `icon` = 'fa fa-archive', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'material_inbound_request';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin', '888888', 'productionPlannerRole', 'productionManagerRole', 'warehouseManagerRole')
  AND m.id IN ('material_requirement_plan', 'material_requirement_week', 'material_inbound_request')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );


SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_status');
SET @sql := IF(@col = 0, 'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_status` varchar(32) NOT NULL DEFAULT ''NONE'' COMMENT ''配套出库状态：NONE未申请，GENERATED已申请，CONFIRMED已完成'' AFTER `inbound_request_no`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_request_id');
SET @sql := IF(@col = 0, 'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_id` varchar(64) DEFAULT NULL COMMENT ''配套出库单ID'' AFTER `outbound_status`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_request_no');
SET @sql := IF(@col = 0, 'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_no` varchar(64) DEFAULT NULL COMMENT ''配套出库单号'' AFTER `outbound_request_id`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
