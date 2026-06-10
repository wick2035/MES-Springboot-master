-- ============================================================
-- 智能制造数据中心（数据大屏）升级脚本
-- 日期：2026-06-09
-- 内容：在「数字化平台」（菜单 id=14）下新增菜单「智能制造数据中心」+ 管理员授权
-- 说明：
--   1. 仅新增菜单，不改动原有「智慧大屏」(id=141 → planDemo) 菜单与页面。
--   2. 大屏数据全部来自真实业务表，无需建表，故本脚本只注册菜单。
--   3. 可重复执行（INSERT IGNORE / NOT EXISTS 子查询）。
--   导入务必带字符集，避免中文乱码：
--   mysql --default-character-set=utf8mb4 -uroot -p sparchetype < dashboard-screen-upgrade-20260609.sql
-- ============================================================

-- ----------------------------
-- 1. 菜单：挂到已存在的「数字化平台」父菜单（id=14）下
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('mes_data_center', 'mesDataCenter', '智能制造数据中心', '/digitization/dashboard/screen-ui', '14', '3', 2, '0', 'user:add', 'fa fa-line-chart', '智能制造数据中心', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 2. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id = 'mes_data_center'
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
