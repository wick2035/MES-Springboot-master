-- ============================================================
-- Work order complete and delivery lifecycle
-- Date: 2026-06-12
-- Content:
--   1) Add completion and delivery status columns to sp_order
--   2) Rename Plan Management > Work Order Release to Work Order Management
--   3) Add delivered work order history menu
-- This script is idempotent.
-- ============================================================

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'complete_status'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `complete_status` varchar(32) NOT NULL DEFAULT ''WAIT'' COMMENT ''完工状态 WAIT/COMPLETED'' AFTER `work_start_time`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'complete_time'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `complete_time` varchar(32) DEFAULT NULL COMMENT ''完工时间'' AFTER `complete_status`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'complete_username'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `complete_username` varchar(64) DEFAULT NULL COMMENT ''完工操作人'' AFTER `complete_time`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'delivery_status'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `delivery_status` varchar(32) NOT NULL DEFAULT ''WAIT'' COMMENT ''交付状态 WAIT/DELIVERED'' AFTER `complete_username`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'delivery_time'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `delivery_time` varchar(32) DEFAULT NULL COMMENT ''交付时间'' AFTER `delivery_status`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'delivery_username'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `delivery_username` varchar(64) DEFAULT NULL COMMENT ''交付操作人'' AFTER `delivery_time`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND INDEX_NAME = 'idx_order_complete_status'
);
SET @ddl := IF(@idx_exists = 0,
  'CREATE INDEX `idx_order_complete_status` ON `sp_order` (`complete_status`)',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND INDEX_NAME = 'idx_order_delivery_status'
);
SET @ddl := IF(@idx_exists = 0,
  'CREATE INDEX `idx_order_delivery_status` ON `sp_order` (`delivery_status`)',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE `sp_sys_menu`
SET `name` = '工单管理',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `code` = 'orderRelease';

INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
SELECT 'orderDelivered', 'orderDelivered', '已交付工单', '/order/delivered/list-ui', '12', '3', 2, '0', 'user:add', 'fa fa-check-square-o', '已交付工单', NOW(), 'admin', NOW(), 'admin'
WHERE NOT EXISTS (
  SELECT 1 FROM `sp_sys_menu` WHERE `id` = 'orderDelivered' OR `code` = 'orderDelivered'
);

UPDATE `sp_sys_menu`
SET `name` = '已交付工单',
    `url` = '/order/delivered/list-ui',
    `parent_id` = '12',
    `grade` = '3',
    `sort_num` = 2,
    `icon` = 'fa fa-check-square-o',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `code` = 'orderDelivered';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('888888', 'productionPlannerRole', 'planManagerRole', 'productionManagerRole', 'warehouseManagerRole')
  AND m.code IN ('orderRelease', 'orderDelivered')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
