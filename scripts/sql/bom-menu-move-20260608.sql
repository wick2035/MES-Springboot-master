-- ============================================================
-- 产品BOM管理菜单迁移脚本
-- 日期：2026-06-08
-- 内容：
--   1) 将"产品BOM管理"(id=152) 从"产品数据中心"移至"工艺管理"
--   2) 放在"工序信息定义"下方、原"工艺路线管理"上方
--   3) 工艺管理下其余子菜单排序顺延
--   4) 确保管理员角色持有该菜单的授权
-- 此脚本可重复执行（幂等）。
-- ============================================================

-- 1. 将 产品BOM管理 从 产品数据中心 移至 工艺管理，排在 工序信息定义 之后
UPDATE `sp_sys_menu`
SET `parent_id` = '15',
    `grade` = '3',
    `sort_num` = 2,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '152'
  AND `parent_id` = 'prod_data_center';

UPDATE `sp_sys_menu`
SET `parent_id` = '15',
    `grade` = '3',
    `sort_num` = 2,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '152'
  AND `parent_id` = '15';

-- 2. 工艺管理下其余子菜单排序顺延
--    工序信息定义 (153) 保持 sort=1
--    工艺路线管理 (151): 2 → 3
--    工艺流程管理 (154): 3 → 4
--    工艺内容编制 (155): 4 → 5
--    产品工艺查询 (156):  5 → 6

UPDATE `sp_sys_menu`
SET `sort_num` = 1,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '153'
  AND `parent_id` = '15';

UPDATE `sp_sys_menu`
SET `sort_num` = 3,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '151'
  AND `parent_id` = '15';

UPDATE `sp_sys_menu`
SET `sort_num` = 4,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '154'
  AND `parent_id` = '15';

UPDATE `sp_sys_menu`
SET `sort_num` = 5,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '155'
  AND `parent_id` = '15';

UPDATE `sp_sys_menu`
SET `sort_num` = 6,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '156'
  AND `parent_id` = '15';

-- 3. 确保超级管理员角色持有 产品BOM管理 的菜单授权
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, '152', NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
WHERE r.code IN ('admin', '888888')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm
    WHERE srm.role_id = r.id AND srm.menu_id = '152'
  );

-- 4. 同时确保管理员角色也持有 工序信息定义 的授权（位于同一父菜单下）
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, '153', NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
WHERE r.code IN ('admin', '888888')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm
    WHERE srm.role_id = r.id AND srm.menu_id = '153'
  );