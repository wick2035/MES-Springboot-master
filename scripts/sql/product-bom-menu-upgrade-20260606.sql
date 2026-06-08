-- ============================================================
-- 产品BOM管理入口替换脚本
-- 日期：2026-06-06
-- 内容：复用原工艺BOM菜单入口，将显示名称替换为产品BOM管理
-- ============================================================

UPDATE `sp_sys_menu`
SET `name` = '产品BOM管理',
    `descr` = '产品BOM管理',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '152'
  AND `url` = '/technology/bom/list-ui';
