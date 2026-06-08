-- ============================================================
-- 移除「基础数据配置平台」+「基础数据维护」通用主数据模块
-- 菜单 id：105（基础数据配置平台）、106（基础数据维护）
-- 物理表：sp_table_manager、sp_table_manager_item
-- 执行方式：mysql --default-character-set=utf8mb4 ... < remove-tablemanager-20260608.sql
-- 可重复执行
-- ============================================================

-- 1. 收回角色对这两个菜单的授权
DELETE FROM `sp_sys_role_menu` WHERE `menu_id` IN ('105', '106');

-- 2. 删除菜单
DELETE FROM `sp_sys_menu` WHERE `id` IN ('105', '106');

-- 3. 删除该模块专用的物理表（仅本功能使用，删除不影响其它模块）
DROP TABLE IF EXISTS `sp_table_manager_item`;
DROP TABLE IF EXISTS `sp_table_manager`;
