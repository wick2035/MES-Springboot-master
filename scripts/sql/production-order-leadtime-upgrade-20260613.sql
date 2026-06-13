-- =============================================================================
-- 生产订单录入「排产运算」修复：提前期改为开工前备料提前期
-- 新增明细级「建议备料日」字段 material_ready_date = 生产开工日 − 备料提前期(工作日)
-- 幂等：INFORMATION_SCHEMA 判列存在；可重复执行。
-- 执行：mysql --default-character-set=utf8mb4 -u root -p sparchetype < production-order-leadtime-upgrade-20260613.sql
-- =============================================================================

-- sp_production_order_item 增加 material_ready_date 列（建议备料日）
SET @col_exists := (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'sp_production_order_item'
      AND COLUMN_NAME = 'material_ready_date'
);
SET @ddl := IF(@col_exists = 0,
    'ALTER TABLE `sp_production_order_item` ADD COLUMN `material_ready_date` varchar(32) DEFAULT NULL AFTER `computed_delivery_date`',
    'SELECT 1');
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
