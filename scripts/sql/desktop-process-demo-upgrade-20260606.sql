-- ============================================================
-- 台式电脑主机工艺流程演示数据
-- 日期: 2026-06-06
-- 内容:
--   1) 台式电脑主机装配所需物料、零部件定义、BOM与子BOM
--   2) 电脑组装加工单元与三条固定工序
--   3) 所有BOM默认已锁定、审核通过、有效，可直接进入工艺流程管理初始化
-- 说明: 使用稳定主键 + ON DUPLICATE KEY UPDATE，脚本可重复执行
-- ============================================================

INSERT INTO `sp_processing_unit`
(`id`, `unit_code`, `unit_name`, `unit_type`, `description`, `status`, `is_deleted`,
 `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('jg_unit_001', 'JG000001', '电脑组装单元', 'person', '台式电脑主机装配演示加工单元', '0', '0',
 NOW(), 'admin', NOW(), 'admin')
ON DUPLICATE KEY UPDATE
 `unit_name` = VALUES(`unit_name`),
 `unit_type` = VALUES(`unit_type`),
 `description` = VALUES(`description`),
 `status` = VALUES(`status`),
 `is_deleted` = VALUES(`is_deleted`),
 `update_time` = NOW(),
 `update_username` = 'admin';

INSERT INTO `sp_oper`
(`id`, `oper`, `oper_desc`, `unit_id`, `oper_hours`, `manu_cycle`, `gen_plan`, `remark`,
 `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('op_gx000002', 'GX000002', '主板装配作业工序', 'jg_unit_001', 1, 2, 'Y', '主板电路板、CPU、内存条装配为台式电脑主板',
 NOW(), 'admin', NOW(), 'admin'),
('op_gx000003', 'GX000003', '机箱组装作业工序', 'jg_unit_001', 1, 2, 'Y', '电源、机箱装配为台式电脑机箱',
 NOW(), 'admin', NOW(), 'admin'),
('op_gx000008', 'GX000008', '主机装配作业', 'jg_unit_001', 1, 2, 'Y', '台式电脑主板与台式电脑机箱装配为台式电脑主机半成品',
 NOW(), 'admin', NOW(), 'admin')
ON DUPLICATE KEY UPDATE
 `oper` = VALUES(`oper`),
 `oper_desc` = VALUES(`oper_desc`),
 `unit_id` = VALUES(`unit_id`),
 `oper_hours` = VALUES(`oper_hours`),
 `manu_cycle` = VALUES(`manu_cycle`),
 `gen_plan` = VALUES(`gen_plan`),
 `remark` = VALUES(`remark`),
 `update_time` = NOW(),
 `update_username` = 'admin';

INSERT INTO `sp_materile`
(`id`, `materiel`, `materiel_desc`, `unit`, `product_group`, `mat_type`, `model`, `size`,
 `flow_id`, `flow_desc`, `is_deleted`, `mat_source`, `texture`, `lead_time`, `safety_stock`,
 `image_urls`, `remark`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('mat_pc_host', 'PC_HOST', '台式电脑主机', '台', '台式电脑', 'FG', 'DESKTOP-HOST', '', NULL, NULL, '0', 'SELF', '', 1, 0, NULL, '工艺流程演示成品', NOW(), 'admin', NOW(), 'admin'),
('mat_pc_host_half', 'PC_HOST_HALF', '台式电脑主机半成品', '台', '台式电脑', 'PG', 'DESKTOP-HOST-HALF', '', NULL, NULL, '0', 'SELF', '', 1, 0, NULL, '主机装配工序产出', NOW(), 'admin', NOW(), 'admin'),
('mat_mainboard_unit', 'MAINBOARD_UNIT', '主板单元', '件', '台式电脑', 'COMP', 'MAINBOARD-UNIT', '', NULL, NULL, '0', 'SELF', '', 1, 0, NULL, '主板装配工序产出', NOW(), 'admin', NOW(), 'admin'),
('mat_case_unit', 'CASE_UNIT', '机箱单元', '件', '台式电脑', 'COMP', 'CASE-UNIT', '', NULL, NULL, '0', 'SELF', '', 1, 0, NULL, '机箱组装工序产出', NOW(), 'admin', NOW(), 'admin'),
('mat_pcb', 'PCB_BOARD', '主板电路板', '件', '台式电脑', 'PART', 'PCB-ATX', '', NULL, NULL, '0', 'OUT', 'FR-4', 1, 0, NULL, '主板单元零件', NOW(), 'admin', NOW(), 'admin'),
('mat_cpu', 'CPU', 'CPU', '颗', '台式电脑', 'PART', 'CPU-DEMO', '', NULL, NULL, '0', 'OUT', '', 1, 0, NULL, '主板单元零件', NOW(), 'admin', NOW(), 'admin'),
('mat_ram', 'MEMORY', '内存条', '条', '台式电脑', 'PART', 'DDR-DEMO', '', NULL, NULL, '0', 'OUT', '', 1, 0, NULL, '主板单元零件', NOW(), 'admin', NOW(), 'admin'),
('mat_power', 'POWER_SUPPLY', '电源', '件', '台式电脑', 'PART', 'PSU-DEMO', '', NULL, NULL, '0', 'OUT', '', 1, 0, NULL, '机箱单元零件', NOW(), 'admin', NOW(), 'admin'),
('mat_case', 'CASE_SHELL', '机箱', '件', '台式电脑', 'PART', 'CASE-DEMO', '', NULL, NULL, '0', 'OUT', '钢板', 1, 0, NULL, '机箱单元零件', NOW(), 'admin', NOW(), 'admin')
ON DUPLICATE KEY UPDATE
 `materiel` = VALUES(`materiel`),
 `materiel_desc` = VALUES(`materiel_desc`),
 `unit` = VALUES(`unit`),
 `product_group` = VALUES(`product_group`),
 `mat_type` = VALUES(`mat_type`),
 `model` = VALUES(`model`),
 `is_deleted` = VALUES(`is_deleted`),
 `mat_source` = VALUES(`mat_source`),
 `texture` = VALUES(`texture`),
 `lead_time` = VALUES(`lead_time`),
 `safety_stock` = VALUES(`safety_stock`),
 `remark` = VALUES(`remark`),
 `update_time` = NOW(),
 `update_username` = 'admin';

INSERT INTO `sp_component_def`
(`id`, `product_name`, `component_code`, `component_name`, `component_type`, `remark`, `is_deleted`,
 `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('comp_pc_host_half', '台式电脑主机', 'PC_HOST_HALF', '台式电脑主机半成品', 'PG', '台式电脑主机一级半成品', '0', NOW(), 'admin', NOW(), 'admin'),
('comp_mainboard_unit', '台式电脑主机', 'MAINBOARD_UNIT', '主板单元', 'COMP', '由主板电路板、CPU、内存条装配', '0', NOW(), 'admin', NOW(), 'admin'),
('comp_case_unit', '台式电脑主机', 'CASE_UNIT', '机箱单元', 'COMP', '由电源、机箱装配', '0', NOW(), 'admin', NOW(), 'admin')
ON DUPLICATE KEY UPDATE
 `product_name` = VALUES(`product_name`),
 `component_code` = VALUES(`component_code`),
 `component_name` = VALUES(`component_name`),
 `component_type` = VALUES(`component_type`),
 `remark` = VALUES(`remark`),
 `is_deleted` = VALUES(`is_deleted`),
 `update_time` = NOW(),
 `update_username` = 'admin';

INSERT INTO `sp_bom`
(`id`, `bom_code`, `materiel_code`, `materiel_desc`, `remark`, `version_number`, `state`, `factory`,
 `is_deleted`, `bom_level`, `lock_status`, `validity`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('bom_pc_host', 'BOM-PC-HOST', 'PC_HOST', '台式电脑主机', '台式电脑主机装配演示BOM', '1', 'pass', 'center', '0', 0, 'locked', '有效', NOW(), 'admin', NOW(), 'admin'),
('bom_pc_host_half', 'BOM-PC-HOST-HALF', 'PC_HOST_HALF', '台式电脑主机半成品', '台式电脑主机半成品BOM', '1', 'pass', 'center', '0', 1, 'locked', '有效', NOW(), 'admin', NOW(), 'admin'),
('bom_mainboard_unit', 'BOM-MAINBOARD-UNIT', 'MAINBOARD_UNIT', '主板单元', '主板单元BOM', '1', 'pass', 'center', '0', 2, 'locked', '有效', NOW(), 'admin', NOW(), 'admin'),
('bom_case_unit', 'BOM-CASE-UNIT', 'CASE_UNIT', '机箱单元', '机箱单元BOM', '1', 'pass', 'center', '0', 2, 'locked', '有效', NOW(), 'admin', NOW(), 'admin')
ON DUPLICATE KEY UPDATE
 `bom_code` = VALUES(`bom_code`),
 `materiel_code` = VALUES(`materiel_code`),
 `materiel_desc` = VALUES(`materiel_desc`),
 `remark` = VALUES(`remark`),
 `version_number` = VALUES(`version_number`),
 `state` = VALUES(`state`),
 `factory` = VALUES(`factory`),
 `is_deleted` = VALUES(`is_deleted`),
 `bom_level` = VALUES(`bom_level`),
 `lock_status` = VALUES(`lock_status`),
 `validity` = VALUES(`validity`),
 `update_time` = NOW(),
 `update_username` = 'admin';

INSERT INTO `sp_bom_item`
(`id`, `bom_head_id`, `materiel_item_code`, `materiel_item_desc`, `line_no`, `item_num`, `item_unit`,
 `oper_typer`, `child_bom_id`, `item_mat_type`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('bom_item_host_half', 'bom_pc_host', 'PC_HOST_HALF', '台式电脑主机半成品', '10', 1, '台', '主机装配', 'bom_pc_host_half', 'PG', NOW(), 'admin', NOW(), 'admin'),
('bom_item_half_mainboard', 'bom_pc_host_half', 'MAINBOARD_UNIT', '主板单元', '10', 1, '件', '主板装配', 'bom_mainboard_unit', 'COMP', NOW(), 'admin', NOW(), 'admin'),
('bom_item_half_case', 'bom_pc_host_half', 'CASE_UNIT', '机箱单元', '20', 1, '件', '机箱装配', 'bom_case_unit', 'COMP', NOW(), 'admin', NOW(), 'admin'),
('bom_item_main_pcb', 'bom_mainboard_unit', 'PCB_BOARD', '主板电路板', '10', 1, '件', '主板装配', NULL, 'PART', NOW(), 'admin', NOW(), 'admin'),
('bom_item_main_cpu', 'bom_mainboard_unit', 'CPU', 'CPU', '20', 1, '颗', '主板装配', NULL, 'PART', NOW(), 'admin', NOW(), 'admin'),
('bom_item_main_ram', 'bom_mainboard_unit', 'MEMORY', '内存条', '30', 1, '条', '主板装配', NULL, 'PART', NOW(), 'admin', NOW(), 'admin'),
('bom_item_case_power', 'bom_case_unit', 'POWER_SUPPLY', '电源', '10', 1, '件', '机箱装配', NULL, 'PART', NOW(), 'admin', NOW(), 'admin'),
('bom_item_case_shell', 'bom_case_unit', 'CASE_SHELL', '机箱', '20', 1, '件', '机箱装配', NULL, 'PART', NOW(), 'admin', NOW(), 'admin')
ON DUPLICATE KEY UPDATE
 `bom_head_id` = VALUES(`bom_head_id`),
 `materiel_item_code` = VALUES(`materiel_item_code`),
 `materiel_item_desc` = VALUES(`materiel_item_desc`),
 `line_no` = VALUES(`line_no`),
 `item_num` = VALUES(`item_num`),
 `item_unit` = VALUES(`item_unit`),
 `oper_typer` = VALUES(`oper_typer`),
 `child_bom_id` = VALUES(`child_bom_id`),
 `item_mat_type` = VALUES(`item_mat_type`),
 `update_time` = NOW(),
 `update_username` = 'admin';
