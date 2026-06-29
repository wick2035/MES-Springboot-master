-- ============================================================
-- 数字孪生生产线（3D 浅色大屏）升级脚本
-- 日期：2026-06-24
-- 内容：在「黑科数字孪生」（菜单 id=17）下新增菜单「数字孪生生产线」+ 管理员授权
-- 说明：
--   1. 仅新增菜单，不改动原有「数字仿真3D仓库」(id=171 → 3DProject) 菜单与页面。
--   2. 产线工位/指标全部来自真实业务表（生产订单、SN 工序采集），空数据时后端回退演示数据，无需建表，故本脚本只注册菜单。
--   3. 可重复执行（INSERT IGNORE / NOT EXISTS 子查询）。
--   导入务必带字符集，避免中文乱码：
--   mysql --default-character-set=utf8mb4 -uroot -p sparchetype < digital-production-line-upgrade-20260624.sql
-- ============================================================

-- ----------------------------
-- 1. 菜单：挂到已存在的「黑科数字孪生」父菜单（id=17）下
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('172', 'DigitalProductionLine', '数字孪生生产线', '/digital/production-line/line-ui', '17', '3', 2, '0', 'user:add', 'fa fa-industry', '数字孪生生产线', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 2. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id = '172'
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
