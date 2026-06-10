-- ============================================================
-- MES sidebar menu order cleanup
-- Date: 2026-06-08
-- Content:
--   1) Keep the primary MES module first and push legacy empty roots back
--   2) Organize the left sidebar by MES workflow
--   3) Consolidate material/product/process entries into clearer groups
-- This script is idempotent.
-- ============================================================

-- Top header modules
UPDATE `sp_sys_menu` SET `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '1';
UPDATE `sp_sys_menu` SET `sort_num` = 90, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '2';
UPDATE `sp_sys_menu` SET `sort_num` = 99, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '3';

-- Free the unique menu-name slot before naming prod_data_center.
UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE5B7A5E889BAE7AEA1E79086 USING utf8mb4),
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '15';

UPDATE `sp_sys_menu`
SET `name` = 'matInfoDefHidden',
    `parent_id` = 'legacy_hidden',
    `sort_num` = 99,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = 'mat_info_def';

-- Main sidebar module order under "currency"
UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE59FBAE7A180E695B0E68DAEE4B8ADE5BF83 USING utf8mb4),
    `parent_id` = '1',
    `grade` = '2',
    `sort_num` = 1,
    `icon` = 'fa fa-database',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = 'base_data_center';

UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE4BAA7E59381E695B0E68DAEE4B8ADE5BF83 USING utf8mb4),
    `parent_id` = '1',
    `grade` = '2',
    `sort_num` = 2,
    `icon` = 'fa fa-cubes',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = 'prod_data_center';

UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE5B7A5E889BAE7AEA1E79086 USING utf8mb4),
    `parent_id` = '1',
    `grade` = '2',
    `sort_num` = 3,
    `icon` = 'fa fa-wrench',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '15';

UPDATE `sp_sys_menu` SET `sort_num` = 4, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '12';
UPDATE `sp_sys_menu` SET `sort_num` = 5, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '16';
UPDATE `sp_sys_menu` SET `sort_num` = 6, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '14';
UPDATE `sp_sys_menu` SET `sort_num` = 7, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '17';
UPDATE `sp_sys_menu` SET `sort_num` = 99, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '10';

-- Move legacy material/equipment leaves into the new data centers.
UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE789A9E69699E4BFA1E681AFE5AE9AE4B989 USING utf8mb4),
    `parent_id` = 'prod_data_center',
    `grade` = '3',
    `sort_num` = 1,
    `icon` = 'fa fa-microchip',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '131';

UPDATE `sp_sys_menu` SET `parent_id` = 'prod_data_center', `grade` = '3', `sort_num` = 2, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'component_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'prod_data_center', `grade` = '3', `sort_num` = 3, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '152';
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 4, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '133';

-- Keep the newer duplicate material item out of the rendered tree; roles using it are bridged to the canonical item below.
UPDATE `sp_sys_menu`
SET `parent_id` = 'legacy_hidden',
    `sort_num` = 99,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = 'mat_info_def';

-- Hide the old material directory once its leaves have moved.
UPDATE `sp_sys_menu`
SET `parent_id` = 'legacy_hidden',
    `sort_num` = 99,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '13';

-- Base data center children
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'banzu_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 2, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'bianzu_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 3, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'cangku_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 5, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '132';

-- Process management children
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '153';
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 2, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '151';
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 3, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '154';
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 4, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '155';
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 5, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '156';

-- Plan, WIP, digital children
UPDATE `sp_sys_menu` SET `parent_id` = '12', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '121';
UPDATE `sp_sys_menu`
SET `name` = CONVERT(0x534EE9809AE794A8E8BF87E7A88BE98787E99B86 USING utf8mb4),
    `url` = '/wip/sn-process/list-ui',
    `parent_id` = '16',
    `grade` = '3',
    `sort_num` = 1,
    `icon` = 'fa fa-barcode',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '161';
UPDATE `sp_sys_menu` SET `parent_id` = '14', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '141';
UPDATE `sp_sys_menu` SET `parent_id` = '17', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '171';

-- System management children
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '101';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 2, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '102';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 3, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '103';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 4, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '104';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 5, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '105';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 6, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '106';

-- Bridge role authorization from the hidden duplicate material menu to the canonical material menu.
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), srm.role_id, '131', NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role_menu` srm
WHERE srm.menu_id = 'mat_info_def'
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` target
    WHERE target.role_id = srm.role_id AND target.menu_id = '131'
  );

-- Make sure super administrators can see the full normalized sidebar.
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin', '888888')
  AND m.id IN (
    '1', 'base_data_center', 'prod_data_center', '15', '12', '16', '14', '17', '10',
    'banzu_def', 'bianzu_def', 'cangku_def', '133', '132',
    '131', 'component_def', '152',
    '153', '151', '154', '155', '156',
    '121', '161', '141', '171',
    '101', '102', '103', '104', '105', '106'
  )
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
