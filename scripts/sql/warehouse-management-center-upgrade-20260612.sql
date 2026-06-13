-- Warehouse Management Center upgrade.
-- Creates unified warehouse request/transaction tables, inventory stock status, and menus.

CREATE TABLE IF NOT EXISTS `sp_warehouse_request` (
  `id` varchar(64) NOT NULL,
  `request_no` varchar(64) NOT NULL,
  `business_type` varchar(32) NOT NULL,
  `source_type` varchar(32) DEFAULT NULL,
  `source_id` varchar(64) DEFAULT NULL,
  `source_no` varchar(64) DEFAULT NULL,
  `warehouse_id` varchar(64) DEFAULT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'WAIT_CONFIRM',
  `item_count` int NOT NULL DEFAULT 0,
  `total_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `apply_username` varchar(64) DEFAULT NULL,
  `apply_time` varchar(32) DEFAULT NULL,
  `confirm_username` varchar(64) DEFAULT NULL,
  `confirm_time` varchar(32) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_warehouse_request_no` (`request_no`),
  KEY `idx_warehouse_request_type_status` (`business_type`,`status`),
  KEY `idx_warehouse_request_source` (`source_type`,`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='warehouse inbound/outbound request header';

CREATE TABLE IF NOT EXISTS `sp_warehouse_request_item` (
  `id` varchar(64) NOT NULL,
  `request_id` varchar(64) NOT NULL,
  `material_id` varchar(64) NOT NULL,
  `material_code` varchar(128) DEFAULT NULL,
  `material_name` varchar(255) DEFAULT NULL,
  `warehouse_id` varchar(64) DEFAULT NULL,
  `location_id` varchar(64) DEFAULT NULL,
  `batch_no` varchar(128) DEFAULT NULL,
  `request_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `confirmed_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `unit` varchar(32) DEFAULT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'WAIT_CONFIRM',
  `source_item_id` varchar(64) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_warehouse_request_item_req` (`request_id`),
  KEY `idx_warehouse_request_item_src` (`source_item_id`),
  KEY `idx_warehouse_request_item_stock` (`warehouse_id`,`location_id`,`material_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='warehouse inbound/outbound request item';

CREATE TABLE IF NOT EXISTS `sp_warehouse_transaction` (
  `id` varchar(64) NOT NULL,
  `transaction_no` varchar(64) NOT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `request_no` varchar(64) DEFAULT NULL,
  `request_item_id` varchar(64) DEFAULT NULL,
  `direction` varchar(8) NOT NULL,
  `business_type` varchar(32) NOT NULL,
  `warehouse_id` varchar(64) NOT NULL,
  `location_id` varchar(64) NOT NULL,
  `material_id` varchar(64) NOT NULL,
  `batch_no` varchar(128) DEFAULT NULL,
  `qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `before_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `after_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `operator_username` varchar(64) DEFAULT NULL,
  `operate_time` varchar(32) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_warehouse_transaction_no` (`transaction_no`),
  KEY `idx_warehouse_transaction_req` (`request_no`),
  KEY `idx_warehouse_transaction_stock` (`warehouse_id`,`location_id`,`material_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='warehouse stock transaction';

SET @has_col := (
  SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_inventory' AND COLUMN_NAME = 'stock_status'
);
SET @ddl := IF(@has_col = 0,
  'ALTER TABLE `sp_inventory` ADD COLUMN `stock_status` varchar(32) NOT NULL DEFAULT ''AVAILABLE'' AFTER `unit`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
UPDATE `sp_inventory` SET `stock_status` = 'AVAILABLE' WHERE `stock_status` IS NULL OR `stock_status` = '';

INSERT INTO `sp_sys_menu`
(`id`,`code`,`name`,`url`,`parent_id`,`grade`,`sort_num`,`type`,`permission`,`icon`,`descr`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT menu_id, menu_code, menu_name, menu_url, menu_parent, menu_grade, menu_sort, '0', menu_permission, menu_icon, menu_name, NOW(), 'admin', NOW(), 'admin'
FROM (
  SELECT 'warehouse_management_center' menu_id, 'warehouseManagementCenter' menu_code, '库房管理中心' menu_name, '#' menu_url, '1' menu_parent, '2' menu_grade, 4 menu_sort, 'warehouse:view' menu_permission, 'fa fa-industry' menu_icon
  UNION ALL SELECT 'warehouse_manual_in_apply','warehouseManualInApply','手工入库申请','/warehouse/manual-inbound/apply/list-ui','warehouse_management_center','3',1,'warehouse:manualIn:apply','fa fa-sign-in'
  UNION ALL SELECT 'warehouse_manual_in_confirm','warehouseManualInConfirm','手工入库确认','/warehouse/manual-inbound/confirm/list-ui','warehouse_management_center','3',2,'warehouse:manualIn:confirm','fa fa-check-square-o'
  UNION ALL SELECT 'warehouse_plan_in_confirm','warehousePlanInConfirm','计划入库确认','/warehouse/plan-inbound/confirm/list-ui','warehouse_management_center','3',3,'warehouse:planIn:confirm','fa fa-archive'
  UNION ALL SELECT 'warehouse_manual_out_apply','warehouseManualOutApply','手工出库申请','/warehouse/manual-outbound/apply/list-ui','warehouse_management_center','3',4,'warehouse:manualOut:apply','fa fa-sign-out'
  UNION ALL SELECT 'warehouse_manual_out_confirm','warehouseManualOutConfirm','手工出库确认','/warehouse/manual-outbound/confirm/list-ui','warehouse_management_center','3',5,'warehouse:manualOut:confirm','fa fa-check'
  UNION ALL SELECT 'warehouse_kitting_out_confirm','warehouseKittingOutConfirm','配套出库确认','/warehouse/kitting-outbound/confirm/list-ui','warehouse_management_center','3',6,'warehouse:kittingOut:confirm','fa fa-cubes'
  UNION ALL SELECT 'warehouse_inventory_detail','warehouseInventoryDetail','库存明细查询','/warehouse/inventory/detail/list-ui','warehouse_management_center','3',7,'warehouse:inventory:detail','fa fa-list'
  UNION ALL SELECT 'warehouse_transaction','warehouseTransaction','出入流水查询','/warehouse/transaction/list-ui','warehouse_management_center','3',9,'warehouse:transaction','fa fa-exchange'
) menus
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_menu` sm WHERE sm.`id` = menus.menu_id);

DELETE FROM `sp_sys_role_menu` WHERE `menu_id` = 'warehouse_ledger';
DELETE FROM `sp_sys_menu` WHERE `id` = 'warehouse_ledger';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin', '888888', 'warehouseManagerRole', 'productionManagerRole')
  AND m.id IN ('warehouse_management_center','warehouse_manual_in_apply','warehouse_manual_in_confirm',
               'warehouse_plan_in_confirm','warehouse_manual_out_apply','warehouse_manual_out_confirm',
               'warehouse_kitting_out_confirm','warehouse_inventory_detail','warehouse_transaction')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );

CREATE TABLE IF NOT EXISTS `sp_warehouse_request_allocation` (
  `id` varchar(64) NOT NULL,
  `request_id` varchar(64) NOT NULL,
  `request_item_id` varchar(64) NOT NULL,
  `inventory_id` varchar(64) NOT NULL,
  `warehouse_id` varchar(64) NOT NULL,
  `location_id` varchar(64) NOT NULL,
  `material_id` varchar(64) NOT NULL,
  `batch_no` varchar(128) DEFAULT NULL,
  `qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `before_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `after_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `allocation_rule` varchar(32) NOT NULL DEFAULT 'FIFO',
  `status` varchar(32) NOT NULL DEFAULT 'CONFIRMED',
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_wh_alloc_req` (`request_id`),
  KEY `idx_wh_alloc_item` (`request_item_id`),
  KEY `idx_wh_alloc_stock` (`inventory_id`,`material_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='warehouse request FIFO allocation';

SET @has_col := (
  SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_status'
);
SET @ddl := IF(@has_col = 0,
  'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_status` varchar(32) NOT NULL DEFAULT ''NONE'' AFTER `inbound_request_no`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_col := (
  SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_request_id'
);
SET @ddl := IF(@has_col = 0,
  'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_id` varchar(64) DEFAULT NULL AFTER `outbound_status`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_col := (
  SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_request_no'
);
SET @ddl := IF(@has_col = 0,
  'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_no` varchar(64) DEFAULT NULL AFTER `outbound_request_id`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE `sp_material_requirement_plan`
SET `outbound_status` = 'NONE'
WHERE `outbound_status` IS NULL OR `outbound_status` = '';

UPDATE `sp_sys_menu` SET `name`='库房管理中心', `descr`='库房管理中心' WHERE `id`='warehouse_management_center';
UPDATE `sp_sys_menu` SET `name`='手工入库申请', `descr`='手工入库申请' WHERE `id`='warehouse_manual_in_apply';
UPDATE `sp_sys_menu` SET `name`='手工入库确认', `descr`='手工入库确认' WHERE `id`='warehouse_manual_in_confirm';
UPDATE `sp_sys_menu` SET `name`='计划入库确认', `descr`='计划入库确认' WHERE `id`='warehouse_plan_in_confirm';
UPDATE `sp_sys_menu` SET `name`='手工出库申请', `descr`='手工出库申请' WHERE `id`='warehouse_manual_out_apply';
UPDATE `sp_sys_menu` SET `name`='手工出库确认', `descr`='手工出库确认' WHERE `id`='warehouse_manual_out_confirm';
UPDATE `sp_sys_menu` SET `name`='配套出库确认', `descr`='配套出库确认' WHERE `id`='warehouse_kitting_out_confirm';
UPDATE `sp_sys_menu` SET `name`='库存明细查询', `descr`='库存明细查询' WHERE `id`='warehouse_inventory_detail';
UPDATE `sp_sys_menu` SET `name`='出入库流水查询', `descr`='出入库流水查询' WHERE `id`='warehouse_transaction';
