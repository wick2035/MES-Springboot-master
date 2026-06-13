-- ============================================================
-- MES sidebar menu order cleanup
-- Date: 2026-06-12
-- Content:
--   1) Reorder the first-level sidebar menus under "currency"
--   2) Rename "process management" to "process management center"
-- This script is idempotent.
-- ============================================================

UPDATE `sp_sys_menu`
SET `parent_id` = '1',
    `grade` = '2',
    `sort_num` = CASE `id`
        WHEN '10' THEN 1
        WHEN 'base_data_center' THEN 2
        WHEN 'prod_data_center' THEN 3
        WHEN '15' THEN 4
        WHEN 'warehouse_management_center' THEN 5
        WHEN 'workflow_tool' THEN 6
        WHEN 'production_order_center' THEN 7
        WHEN '12' THEN 8
        WHEN '16' THEN 9
        WHEN '14' THEN 10
        WHEN '17' THEN 11
        WHEN 'llm_center' THEN 12
        ELSE `sort_num`
    END,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` IN (
    '10',
    'base_data_center',
    'prod_data_center',
    '15',
    'warehouse_management_center',
    'workflow_tool',
    'production_order_center',
    '12',
    '16',
    '14',
    '17',
    'llm_center'
);

UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE5B7A5E889BAE7AEA1E79086E4B8ADE5BF83 USING utf8mb4),
    `descr` = CONVERT(0xE5B7A5E889BAE7AEA1E79086E4B8ADE5BF83 USING utf8mb4),
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '15';
