-- 菜单锁定状态升级（2026-06-29）
-- 给 sp_sys_menu 增加 state 列：0正常 1锁定。
-- 锁定的菜单将不再出现在用户导航（左侧/顶部/移动端/全局搜索）中，
-- 但仍显示在「菜单管理」列表里以便解锁。
-- 幂等：列已存在则跳过，可重复执行。

SELECT COUNT(*)
INTO @sp_sys_menu_state_exists
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'sp_sys_menu'
  AND COLUMN_NAME = 'state';

SET @sp_sys_menu_state_sql = IF(
    @sp_sys_menu_state_exists = 0,
    'ALTER TABLE `sp_sys_menu`
        ADD COLUMN `state` tinyint NOT NULL DEFAULT 0 COMMENT ''状态 0正常 1锁定''',
    'SELECT 1'
);

PREPARE stmt FROM @sp_sys_menu_state_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 兜底：确保历史数据全部为正常状态
UPDATE `sp_sys_menu` SET `state` = 0 WHERE `state` IS NULL;
