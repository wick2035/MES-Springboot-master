-- ============================================================
-- Production order designer and production manager approval workflow
-- Date: 2026-06-08
-- Content:
--   1) Add designer and approval fields to sp_order
--   2) Treat statue=1 as created/pending approval and statue=2 as approved
--   3) Grant the work-order release menu to production managers for approval
-- This script is idempotent.
-- ============================================================

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'designer_id'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `designer_id` varchar(64) DEFAULT NULL COMMENT ''Designer user ID'' AFTER `statue`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'designer_name'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `designer_name` varchar(64) DEFAULT NULL COMMENT ''Designer name'' AFTER `designer_id`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'approve_user_id'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `approve_user_id` varchar(64) DEFAULT NULL COMMENT ''Approver user ID'' AFTER `designer_name`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'approve_username'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `approve_username` varchar(64) DEFAULT NULL COMMENT ''Approver name'' AFTER `approve_user_id`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'approve_time'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `approve_time` varchar(32) DEFAULT NULL COMMENT ''Approval time'' AFTER `approve_username`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'work_status'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `work_status` varchar(32) NOT NULL DEFAULT ''NOT_STARTED'' COMMENT ''Work start status'' AFTER `approve_time`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'work_start_time'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `work_start_time` varchar(32) DEFAULT NULL COMMENT ''Work start time'' AFTER `work_status`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE `sp_order`
SET `designer_name` = `create_username`
WHERE (`designer_name` IS NULL OR `designer_name` = '')
  AND `create_username` IS NOT NULL
  AND `create_username` <> '';

ALTER TABLE `sp_order`
  MODIFY COLUMN `statue` tinyint(255) NULL DEFAULT NULL COMMENT '1 created/pending approval, 2 approved, 3 ended, 4 terminated';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('productionManagerRole', 'warehouseManagerRole')
  AND m.code IN ('currency', 'order', 'orderRelease')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
