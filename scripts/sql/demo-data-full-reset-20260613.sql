-- ============================================================
-- 演示数据：全链路清洗与重建（台式电脑主机）·全模块版
-- 日期：2026-06-13
-- 目标：
--   在 demo-data-full-reset-20260608.sql 的基础上，整合旧模块演示数据，
--   并向 6-08 之后新增的模块延伸，使「每个功能模块页面」都有连贯、
--   符合现实的演示数据，一次执行即可重建全系统演示数据。
--   覆盖：部门 → 班组/员工 → 设备/编组 → 库房/库位/库存 → 物料 →
--        零部件 → BOM(含子件) → 工序 → 加工单元 → 工艺流程/路线 →
--        旧工单(sp_order)+SN采集 →
--        【新】生产订单(3张，覆盖 草稿/已审待下发/已下发 三阶段)→
--             工序排产 → 设备派工 + 员工派工 → MRP 物料需求计划 →
--             入库申请单 → 库房单据(手工入/手工出/计划入/配套出 + 流水 + 分配)→
--             已下达工单变更 → 工作流实例/任务
-- 原则：
--   * 全部使用稳定字母前缀主键 + ON DUPLICATE KEY UPDATE / 幂等可重复执行
--   * 清洗仅针对历史「数字雪花ID」脏数据 + 本脚本自身的字母前缀演示数据
--   * 不触碰系统账户：管理员/用户/角色/菜单/字典（仅补部门并回填用户部门）
-- 关键业务口径（已对照 Controller/Service/Mapper 源码核实）：
--   * 设备派工/员工派工/生产计划下发页 只展示「已审批且未下发」的订单
--     (canAssign / buildDispatchRows 排除 DISPATCHED)，故用 po_assign 演示；
--   * 已下达工单变更 要求工单 statue=5(已下发) 且生产订单 operation_status=DISPATCHED，
--     故用 po_disp 演示；二者不可由同一张订单兼得，因此设三阶段订单。
--   * MRP 列表(pageList)用 sp_inventory 实时重算 available/net，
--     完成判定(isProductionOrderMrpCompleted)用「库内存储净需求」，
--     故库存终值与各单据增减、净需求口径全部对齐，避免页面自相矛盾。
-- 执行：mysql --default-character-set=utf8mb4 -uroot -p sparchetype < demo-data-full-reset-20260613.sql
-- 前置：相关结构升级脚本(生产计划中心/MRP/库房管理中心/工单变更/流程管控)已先执行。
-- ============================================================

SET NAMES utf8mb4;

-- ============================================================
-- 0. 清洗历史脏数据（数字雪花ID历史测试记录 + 本脚本演示前缀数据，幂等）
-- ============================================================
DELETE FROM `sp_flow_oper_relation` WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_flow`               WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_oper`               WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_bom`                WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_materile`           WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_processing_unit_team`    WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_team_employee`           WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_team`                    WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_equipment_group_device`  WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_equipment_group`         WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_order`                   WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_inventory`;
DELETE FROM `sp_process_content`        WHERE `route_id`  LIKE 'pr\_%';
DELETE FROM `sp_process_equipment_rel`  WHERE `route_id`  LIKE 'pr\_%';
DELETE FROM `sp_process_material_rel`   WHERE `route_id`  LIKE 'pr\_%';
DELETE FROM `sp_process_route`          WHERE `bom_id` = 'bom_pc_host';
DELETE FROM `sp_sn_process_record` WHERE `id` LIKE 'sn\_pc\_%';
DELETE FROM `sp_order`             WHERE `id` LIKE 'ord\_pc\_%' OR `id` LIKE 'wo\_pc\_%';
-- 新模块演示数据（字母前缀），重建前先清理，保证幂等
DELETE FROM `sp_workflow_task`               WHERE `id` LIKE 'wft\_%';
DELETE FROM `sp_workflow_instance`           WHERE `id` LIKE 'wfi\_%';
DELETE FROM `sp_work_order_change`           WHERE `id` LIKE 'woc\_%';
DELETE FROM `sp_warehouse_transaction`       WHERE `id` LIKE 'wtx\_%';
DELETE FROM `sp_warehouse_request_allocation` WHERE `id` LIKE 'wra\_%';
DELETE FROM `sp_warehouse_request_item`      WHERE `id` LIKE 'wri\_%';
DELETE FROM `sp_warehouse_request`           WHERE `id` LIKE 'wr\_%';
DELETE FROM `sp_material_inbound_request_item` WHERE `id` LIKE 'mir\_item\_%';
DELETE FROM `sp_material_inbound_request`    WHERE `id` LIKE 'mir\_%';
DELETE FROM `sp_material_requirement_plan`   WHERE `id` LIKE 'mrp\_%';
DELETE FROM `sp_order_oper_equipment_assign` WHERE `id` LIKE 'ooea\_%';
DELETE FROM `sp_order_oper_assign`           WHERE `id` LIKE 'ooa\_%';
DELETE FROM `sp_production_order_oper_plan`  WHERE `id` LIKE 'pop\_%';
DELETE FROM `sp_production_order_item`       WHERE `id` LIKE 'poi\_%';
DELETE FROM `sp_production_order`            WHERE `id` LIKE 'po\_%';

-- ============================================================
-- 1. 组织部门（sp_sys_department）
-- ============================================================
INSERT INTO `sp_sys_department` (`id`,`parent_id`,`name`,`sort_num`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('dept_mfg',  '0',        '制造中心', 1, '0', NOW(),'admin',NOW(),'admin'),
('dept_prod', 'dept_mfg', '生产部',   1, '0', NOW(),'admin',NOW(),'admin'),
('dept_tech', 'dept_mfg', '工艺部',   2, '0', NOW(),'admin',NOW(),'admin'),
('dept_qa',   'dept_mfg', '质量部',   3, '0', NOW(),'admin',NOW(),'admin'),
('dept_wh',   'dept_mfg', '仓储部',   4, '0', NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `parent_id`=VALUES(`parent_id`),`name`=VALUES(`name`),`sort_num`=VALUES(`sort_num`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

UPDATE `sp_sys_user` SET `dept_id`='dept_mfg'  WHERE `username`='admin';
UPDATE `sp_sys_user` SET `dept_id`='dept_tech' WHERE `username`='iamsongpeng';
UPDATE `sp_sys_user` SET `dept_id`='dept_prod' WHERE `username`='monkey';
UPDATE `sp_sys_user` SET `dept_id`='dept_prod' WHERE `username`='cassman.yang';
UPDATE `sp_sys_user` SET `dept_id`='dept_prod' WHERE `username`='xm';

-- ============================================================
-- 2. 班组（sp_team） + 班组员工（sp_team_employee）
-- ============================================================
INSERT INTO `sp_team` (`id`,`team_code`,`team_name`,`team_desc`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('team_01','TEAM01','主板装配班组','负责主板单元装配','',  '0',NOW(),'admin',NOW(),'admin'),
('team_02','TEAM02','机箱组装班组','负责机箱单元组装','',  '0',NOW(),'admin',NOW(),'admin'),
('team_03','TEAM03','总装测试班组','负责主机总装、测试与包装','','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `team_name`=VALUES(`team_name`),`team_desc`=VALUES(`team_desc`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_team_employee` (`id`,`team_id`,`user_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('te_01','team_01','1184009088826392578','宋鹏-主板装配','0',NOW(),'admin',NOW(),'admin'),
('te_02','team_01','1276512902757724162','小明-主板装配','0',NOW(),'admin',NOW(),'admin'),
('te_03','team_02','1184010472443396098','猴子-机箱组装','0',NOW(),'admin',NOW(),'admin'),
('te_04','team_02','1266201180838801409','cassman-机箱组装','0',NOW(),'admin',NOW(),'admin'),
('te_05','team_03','1184019107907227649','管理员-总装测试','0',NOW(),'admin',NOW(),'admin'),
('te_06','team_03','1184009088826392578','宋鹏-总装测试','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `team_id`=VALUES(`team_id`),`user_id`=VALUES(`user_id`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 3. 设备（sp_equipment） + 编组（sp_equipment_group / device）
-- ============================================================
INSERT INTO `sp_equipment` (`id`,`equipment_code`,`equipment_name`,`equipment_model`,`purpose`,`spec`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('eq_001','EQ000001','物料周转车','TC-200','线边物料周转','载重200kg','1','0',NOW(),'admin',NOW(),'admin'),
('eq_002','EQ000002','主板测试夹具','GJ-PCB-01','主板安装与测试夹具','','1','0',NOW(),'admin',NOW(),'admin'),
('eq_003','EQ000003','整机老化测试台','LX-100','整机老化与功能测试','24h老化','1','0',NOW(),'admin',NOW(),'admin'),
('eq_004','EQ000004','防静电手指套','','装配防护','防静电','1','0',NOW(),'admin',NOW(),'admin'),
('eq_005','EQ000005','防静电环','OWS20A','装配防静电','','1','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `equipment_name`=VALUES(`equipment_name`),`equipment_model`=VALUES(`equipment_model`),`purpose`=VALUES(`purpose`),`spec`=VALUES(`spec`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_equipment_group` (`id`,`group_code`,`group_name`,`group_desc`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('eg_01','EG000001','装配工装组','主板/机箱/总装通用工装与防护','','0',NOW(),'admin',NOW(),'admin'),
('eg_02','EG000002','测试设备组','整机测试相关设备','','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `group_name`=VALUES(`group_name`),`group_desc`=VALUES(`group_desc`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_equipment_group_device` (`id`,`group_id`,`equipment_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('egd_01','eg_01','eq_002','','0',NOW(),'admin',NOW(),'admin'),
('egd_02','eg_01','eq_004','','0',NOW(),'admin',NOW(),'admin'),
('egd_03','eg_01','eq_005','','0',NOW(),'admin',NOW(),'admin'),
('egd_04','eg_02','eq_003','','0',NOW(),'admin',NOW(),'admin'),
('egd_05','eg_02','eq_001','','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `group_id`=VALUES(`group_id`),`equipment_id`=VALUES(`equipment_id`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 4. 库房 / 库位（产品库 CP001；零件库 KF001 沿用既有 ID）
-- ============================================================
INSERT INTO `sp_warehouse` (`id`,`warehouse_code`,`warehouse_name`,`warehouse_type`,`warehouse_desc`,`spec_group`,`spec_row`,`spec_layer`,`spec_column`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('cp_wh_001','CP001','产品库','2','成品/半成品/组件存放库',1,2,2,1,'',  '0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `warehouse_name`=VALUES(`warehouse_name`),`warehouse_type`=VALUES(`warehouse_type`),`warehouse_desc`=VALUES(`warehouse_desc`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_location` (`id`,`warehouse_id`,`location_code`,`group_no`,`row_no`,`layer_no`,`column_no`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('cp_loc_001','cp_wh_001','CP001-1-1-1-1',1,1,1,1,'0','0',NOW(),'admin',NOW(),'admin'),
('cp_loc_002','cp_wh_001','CP001-1-1-2-1',1,1,2,1,'0','0',NOW(),'admin',NOW(),'admin'),
('cp_loc_003','cp_wh_001','CP001-1-2-1-1',1,2,1,1,'0','0',NOW(),'admin',NOW(),'admin'),
('cp_loc_004','cp_wh_001','CP001-1-2-2-1',1,2,2,1,'0','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `warehouse_id`=VALUES(`warehouse_id`),`location_code`=VALUES(`location_code`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 5. 物料（台式电脑主机 9 条；成品绑定装配流程）
-- ============================================================
INSERT INTO `sp_materile`
(`id`,`materiel`,`materiel_desc`,`unit`,`product_group`,`mat_type`,`model`,`size`,`flow_id`,`flow_desc`,`is_deleted`,`mat_source`,`texture`,`lead_time`,`safety_stock`,`image_urls`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('mat_pc_host',     'PC_HOST',       '台式电脑主机',       '台','台式电脑','FG',  'DESKTOP-HOST',     '','flow_pc_host','台式电脑主机装配流程','0','SELF','',1, 5, NULL,'装配演示成品',   NOW(),'admin',NOW(),'admin'),
('mat_pc_host_half','PC_HOST_HALF',  '台式电脑主机半成品', '台','台式电脑','PG',  'DESKTOP-HOST-HALF','',NULL,NULL,'0','SELF','',1, 5, NULL,'主机装配工序产出',NOW(),'admin',NOW(),'admin'),
('mat_mainboard_unit','MAINBOARD_UNIT','主板单元',         '件','台式电脑','COMP','MAINBOARD-UNIT',   '',NULL,NULL,'0','SELF','',1,10, NULL,'主板装配工序产出',NOW(),'admin',NOW(),'admin'),
('mat_case_unit',   'CASE_UNIT',     '机箱单元',           '件','台式电脑','COMP','CASE-UNIT',        '',NULL,NULL,'0','SELF','',1,10, NULL,'机箱组装工序产出',NOW(),'admin',NOW(),'admin'),
('mat_pcb',         'PCB_BOARD',     '主板电路板',         '件','台式电脑','PART','PCB-ATX',          '',NULL,NULL,'0','OUT','FR-4',2,50, NULL,'主板单元零件',   NOW(),'admin',NOW(),'admin'),
('mat_cpu',         'CPU',           'CPU',               '颗','台式电脑','PART','CPU-DEMO',         '',NULL,NULL,'0','OUT','',  3,30, NULL,'主板单元零件',   NOW(),'admin',NOW(),'admin'),
('mat_ram',         'MEMORY',        '内存条',             '条','台式电脑','PART','DDR-DEMO',         '',NULL,NULL,'0','OUT','',  2,40, NULL,'主板单元零件',   NOW(),'admin',NOW(),'admin'),
('mat_power',       'POWER_SUPPLY',  '电源',               '件','台式电脑','PART','PSU-DEMO',         '',NULL,NULL,'0','OUT','',  2,20, NULL,'机箱单元零件',   NOW(),'admin',NOW(),'admin'),
('mat_case',        'CASE_SHELL',    '机箱',               '件','台式电脑','PART','CASE-DEMO',        '',NULL,NULL,'0','OUT','钢板',2,15,NULL,'机箱单元零件',   NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `materiel`=VALUES(`materiel`),`materiel_desc`=VALUES(`materiel_desc`),`unit`=VALUES(`unit`),`product_group`=VALUES(`product_group`),`mat_type`=VALUES(`mat_type`),`model`=VALUES(`model`),`flow_id`=VALUES(`flow_id`),`flow_desc`=VALUES(`flow_desc`),`is_deleted`=VALUES(`is_deleted`),`mat_source`=VALUES(`mat_source`),`texture`=VALUES(`texture`),`lead_time`=VALUES(`lead_time`),`safety_stock`=VALUES(`safety_stock`),`remark`=VALUES(`remark`),`update_time`=NOW();

-- ============================================================
-- 6. 零部件定义（sp_component_def）
-- ============================================================
INSERT INTO `sp_component_def` (`id`,`product_name`,`component_code`,`component_name`,`component_type`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('comp_pc_host_half','台式电脑主机','PC_HOST_HALF','台式电脑主机半成品','PG','一级半成品',          '0',NOW(),'admin',NOW(),'admin'),
('comp_mainboard_unit','台式电脑主机','MAINBOARD_UNIT','主板单元','COMP','由主板电路板、CPU、内存条装配','0',NOW(),'admin',NOW(),'admin'),
('comp_case_unit','台式电脑主机','CASE_UNIT','机箱单元','COMP','由电源、机箱装配',                '0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `product_name`=VALUES(`product_name`),`component_name`=VALUES(`component_name`),`component_type`=VALUES(`component_type`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 7. BOM 三层结构（sp_bom） + 子件（sp_bom_item）
-- ============================================================
INSERT INTO `sp_bom`
(`id`,`bom_code`,`materiel_code`,`materiel_desc`,`remark`,`version_number`,`state`,`factory`,`is_deleted`,`bom_level`,`lock_status`,`validity`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('bom_pc_host',     'BOM-PC-HOST',      'PC_HOST',      '台式电脑主机',      '台式电脑主机装配演示BOM','1','pass','center','0',0,'locked','有效',NOW(),'admin',NOW(),'admin'),
('bom_pc_host_half','BOM-PC-HOST-HALF', 'PC_HOST_HALF', '台式电脑主机半成品','台式电脑主机半成品BOM',  '1','pass','center','0',1,'locked','有效',NOW(),'admin',NOW(),'admin'),
('bom_mainboard_unit','BOM-MAINBOARD-UNIT','MAINBOARD_UNIT','主板单元',     '主板单元BOM',           '1','pass','center','0',2,'locked','有效',NOW(),'admin',NOW(),'admin'),
('bom_case_unit',   'BOM-CASE-UNIT',    'CASE_UNIT',    '机箱单元',          '机箱单元BOM',           '1','pass','center','0',2,'locked','有效',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `bom_code`=VALUES(`bom_code`),`materiel_code`=VALUES(`materiel_code`),`materiel_desc`=VALUES(`materiel_desc`),`remark`=VALUES(`remark`),`version_number`=VALUES(`version_number`),`state`=VALUES(`state`),`factory`=VALUES(`factory`),`is_deleted`=VALUES(`is_deleted`),`bom_level`=VALUES(`bom_level`),`lock_status`=VALUES(`lock_status`),`validity`=VALUES(`validity`),`update_time`=NOW();

INSERT INTO `sp_bom_item`
(`id`,`bom_head_id`,`materiel_item_code`,`materiel_item_desc`,`line_no`,`item_num`,`item_unit`,`oper_typer`,`child_bom_id`,`item_mat_type`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('bom_item_host_half',     'bom_pc_host',     'PC_HOST_HALF', '台式电脑主机半成品','10',1,'台','主机装配','bom_pc_host_half','PG',  NOW(),'admin',NOW(),'admin'),
('bom_item_half_mainboard','bom_pc_host_half','MAINBOARD_UNIT','主板单元',        '10',1,'件','主板装配','bom_mainboard_unit','COMP',NOW(),'admin',NOW(),'admin'),
('bom_item_half_case',     'bom_pc_host_half','CASE_UNIT',    '机箱单元',         '20',1,'件','机箱装配','bom_case_unit','COMP',  NOW(),'admin',NOW(),'admin'),
('bom_item_main_pcb',      'bom_mainboard_unit','PCB_BOARD',  '主板电路板',       '10',1,'件','主板装配',NULL,'PART',          NOW(),'admin',NOW(),'admin'),
('bom_item_main_cpu',      'bom_mainboard_unit','CPU',        'CPU',             '20',1,'颗','主板装配',NULL,'PART',          NOW(),'admin',NOW(),'admin'),
('bom_item_main_ram',      'bom_mainboard_unit','MEMORY',     '内存条',           '30',1,'条','主板装配',NULL,'PART',          NOW(),'admin',NOW(),'admin'),
('bom_item_case_power',    'bom_case_unit',   'POWER_SUPPLY', '电源',             '10',1,'件','机箱装配',NULL,'PART',          NOW(),'admin',NOW(),'admin'),
('bom_item_case_shell',    'bom_case_unit',   'CASE_SHELL',   '机箱',             '20',1,'件','机箱装配',NULL,'PART',          NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `bom_head_id`=VALUES(`bom_head_id`),`materiel_item_code`=VALUES(`materiel_item_code`),`materiel_item_desc`=VALUES(`materiel_item_desc`),`line_no`=VALUES(`line_no`),`item_num`=VALUES(`item_num`),`item_unit`=VALUES(`item_unit`),`oper_typer`=VALUES(`oper_typer`),`child_bom_id`=VALUES(`child_bom_id`),`item_mat_type`=VALUES(`item_mat_type`),`update_time`=NOW();

-- ============================================================
-- 8. 加工单元（sp_processing_unit） + 单元-班组（sp_processing_unit_team）
-- ============================================================
INSERT INTO `sp_processing_unit` (`id`,`unit_code`,`unit_name`,`unit_type`,`description`,`std_capacity`,`has_edge_warehouse`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('jg_unit_001','JG000001','电脑组装单元','person','主板/机箱/主机装配作业单元',8.00,'Y','0','0',NOW(),'admin',NOW(),'admin'),
('jg_unit_002','JG000002','整机测试单元','device','整机老化与功能测试单元',    8.00,'N','0','0',NOW(),'admin',NOW(),'admin'),
('jg_unit_003','JG000003','包装入库单元','person','成品包装与入库作业单元',    8.00,'Y','0','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `unit_name`=VALUES(`unit_name`),`unit_type`=VALUES(`unit_type`),`description`=VALUES(`description`),`std_capacity`=VALUES(`std_capacity`),`has_edge_warehouse`=VALUES(`has_edge_warehouse`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_processing_unit_team` (`id`,`unit_id`,`team_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('put_01','jg_unit_001','team_01','','0',NOW(),'admin',NOW(),'admin'),
('put_02','jg_unit_001','team_02','','0',NOW(),'admin',NOW(),'admin'),
('put_03','jg_unit_002','team_03','','0',NOW(),'admin',NOW(),'admin'),
('put_04','jg_unit_003','team_03','','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `unit_id`=VALUES(`unit_id`),`team_id`=VALUES(`team_id`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 9. 工序信息定义（sp_oper）
-- ============================================================
INSERT INTO `sp_oper` (`id`,`oper`,`oper_desc`,`unit_id`,`oper_hours`,`manu_cycle`,`gen_plan`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('op_gx000002','GX000002','主板装配作业工序','jg_unit_001',1.00,2.00,'Y','主板电路板、CPU、内存条装配为主板单元',NOW(),'admin',NOW(),'admin'),
('op_gx000003','GX000003','机箱组装作业工序','jg_unit_001',1.00,2.00,'Y','电源、机箱组装为机箱单元',           NOW(),'admin',NOW(),'admin'),
('op_gx000008','GX000008','主机装配作业',    'jg_unit_001',1.00,2.00,'Y','主板单元与机箱单元装配为主机半成品', NOW(),'admin',NOW(),'admin'),
('op_gx000010','GX000010','整机测试作业',    'jg_unit_002',0.50,1.00,'Y','整机老化与功能测试',               NOW(),'admin',NOW(),'admin'),
('op_gx000011','GX000011','包装入库作业',    'jg_unit_003',0.30,0.50,'Y','成品包装并入库',                   NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `oper_desc`=VALUES(`oper_desc`),`unit_id`=VALUES(`unit_id`),`oper_hours`=VALUES(`oper_hours`),`manu_cycle`=VALUES(`manu_cycle`),`gen_plan`=VALUES(`gen_plan`),`remark`=VALUES(`remark`),`update_time`=NOW();

-- ============================================================
-- 10. 工艺流程/线体（sp_flow） + 工序串接关系（sp_flow_oper_relation）
-- ============================================================
INSERT INTO `sp_flow` (`id`,`flow`,`flow_desc`,`process`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('flow_pc_host','FLOW_PCHOST','台式电脑主机装配流程','主板装配——>机箱组装——>主机装配——>整机测试——>包装入库',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `flow`=VALUES(`flow`),`flow_desc`=VALUES(`flow_desc`),`process`=VALUES(`process`),`update_time`=NOW();

INSERT INTO `sp_flow_oper_relation`
(`id`,`flow_id`,`flow`,`per_oper_id`,`per_oper`,`oper_id`,`oper`,`next_oper_id`,`next_oper`,`sort_num`,`oper_type`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('rel_pc_01','flow_pc_host','FLOW_PCHOST',NULL,NULL,                'op_gx000002','GX000002','op_gx000003','GX000003',1,'firstOper',NOW(),'admin',NOW(),'admin'),
('rel_pc_02','flow_pc_host','FLOW_PCHOST','op_gx000002','GX000002','op_gx000003','GX000003','op_gx000008','GX000008',2,NULL,       NOW(),'admin',NOW(),'admin'),
('rel_pc_03','flow_pc_host','FLOW_PCHOST','op_gx000003','GX000003','op_gx000008','GX000008','op_gx000010','GX000010',3,NULL,       NOW(),'admin',NOW(),'admin'),
('rel_pc_04','flow_pc_host','FLOW_PCHOST','op_gx000008','GX000008','op_gx000010','GX000010','op_gx000011','GX000011',4,NULL,       NOW(),'admin',NOW(),'admin'),
('rel_pc_05','flow_pc_host','FLOW_PCHOST','op_gx000010','GX000010','op_gx000011','GX000011',NULL,NULL,                5,'lastOper', NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `per_oper_id`=VALUES(`per_oper_id`),`per_oper`=VALUES(`per_oper`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`next_oper_id`=VALUES(`next_oper_id`),`next_oper`=VALUES(`next_oper`),`sort_num`=VALUES(`sort_num`),`oper_type`=VALUES(`oper_type`),`update_time`=NOW();

-- ============================================================
-- 11. 工艺路线（sp_process_route，按BOM节点绑定工序，已锁定/已完成）
-- ============================================================
INSERT INTO `sp_process_route`
(`id`,`bom_id`,`bom_item_id`,`route_code`,`parent_route_id`,`node_name`,`materiel_code`,`oper_id`,`seq_no`,`lock_status`,`edit_status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('pr_root','bom_pc_host',NULL,                       'NGY_3_PC_HOST',        NULL,    '台式电脑主机',     'PC_HOST',       'op_gx000011',30,'locked','completed','0',NOW(),'admin',NOW(),'admin'),
('pr_half','bom_pc_host','bom_item_host_half',       'NGY_3_PC_HOST_001',    'pr_root','台式电脑主机半成品','PC_HOST_HALF','op_gx000008',30,'locked','completed','0',NOW(),'admin',NOW(),'admin'),
('pr_main','bom_pc_host','bom_item_half_mainboard',  'NGY_3_PC_HOST_001_001','pr_half','主板单元',         'MAINBOARD_UNIT','op_gx000002',30,'locked','completed','0',NOW(),'admin',NOW(),'admin'),
('pr_case','bom_pc_host','bom_item_half_case',       'NGY_3_PC_HOST_001_002','pr_half','机箱单元',         'CASE_UNIT',     'op_gx000003',60,'locked','completed','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `bom_item_id`=VALUES(`bom_item_id`),`parent_route_id`=VALUES(`parent_route_id`),`node_name`=VALUES(`node_name`),`materiel_code`=VALUES(`materiel_code`),`oper_id`=VALUES(`oper_id`),`seq_no`=VALUES(`seq_no`),`lock_status`=VALUES(`lock_status`),`edit_status`=VALUES(`edit_status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_process_content` (`id`,`route_id`,`content_text`,`require_text`,`need_check`,`precaution_text`,`tech_doc_desc`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('pc_main','pr_main','在主板电路板上安装CPU、内存条，完成主板单元装配','CPU方向对位防呆，内存条卡扣到位','Y','佩戴防静电环，避免静电损伤','主板装配作业指导书',NOW(),'admin',NOW(),'admin'),
('pc_case','pr_case','将电源固定到机箱并连接供电线束，完成机箱单元组装','电源螺丝紧固到位，线束理顺','Y','注意金属边缘划伤防护','机箱组装作业指导书',NOW(),'admin',NOW(),'admin'),
('pc_half','pr_half','将主板单元与机箱单元装配并连接，产出主机半成品','接插件牢固，走线规范','Y','防止压线、漏接','主机总装作业指导书',NOW(),'admin',NOW(),'admin'),
('pc_root','pr_root','整机测试合格后进行成品包装与入库','按装箱清单核对配件','Y','轻拿轻放，标签朝外','成品包装作业指导书',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `content_text`=VALUES(`content_text`),`require_text`=VALUES(`require_text`),`need_check`=VALUES(`need_check`),`precaution_text`=VALUES(`precaution_text`),`tech_doc_desc`=VALUES(`tech_doc_desc`),`update_time`=NOW();

INSERT INTO `sp_process_equipment_rel` (`id`,`route_id`,`equipment_id`,`req_qty`,`remark`,`create_time`,`create_username`) VALUES
('per_main_1','pr_main','eq_002',1,'主板测试夹具',NOW(),'admin'),
('per_main_2','pr_main','eq_005',2,'防静电环',    NOW(),'admin'),
('per_case_1','pr_case','eq_004',2,'防静电手指套',NOW(),'admin'),
('per_half_1','pr_half','eq_005',2,'防静电环',    NOW(),'admin'),
('per_root_1','pr_root','eq_003',1,'整机老化测试台',NOW(),'admin'),
('per_root_2','pr_root','eq_001',1,'物料周转车',  NOW(),'admin')
ON DUPLICATE KEY UPDATE `equipment_id`=VALUES(`equipment_id`),`req_qty`=VALUES(`req_qty`),`remark`=VALUES(`remark`);

INSERT INTO `sp_process_material_rel` (`id`,`route_id`,`materiel_id`,`req_qty`,`remark`,`create_time`,`create_username`) VALUES
('pmr_main_1','pr_main','mat_pcb',1.000,'主板电路板',NOW(),'admin'),
('pmr_main_2','pr_main','mat_cpu',1.000,'CPU',      NOW(),'admin'),
('pmr_main_3','pr_main','mat_ram',1.000,'内存条',    NOW(),'admin'),
('pmr_case_1','pr_case','mat_power',1.000,'电源',    NOW(),'admin'),
('pmr_case_2','pr_case','mat_case',1.000,'机箱',     NOW(),'admin'),
('pmr_half_1','pr_half','mat_mainboard_unit',1.000,'主板单元',NOW(),'admin'),
('pmr_half_2','pr_half','mat_case_unit',1.000,'机箱单元',    NOW(),'admin'),
('pmr_root_1','pr_root','mat_pc_host_half',1.000,'主机半成品',NOW(),'admin')
ON DUPLICATE KEY UPDATE `materiel_id`=VALUES(`materiel_id`),`req_qty`=VALUES(`req_qty`),`remark`=VALUES(`remark`);

-- ============================================================
-- 12. 库存（sp_inventory）·终值已对齐下方库房单据增减
--   零件库 KF001：PCB 500 / CPU 40(=25起+15计划入) / RAM 450(=400+50手工入)
--                 POWER 195(=200-5手工出) / CASE 150
--   产品库 CP001：主板单元 70(=80-10配套出) / 机箱单元 50(=60-10配套出)
--                 半成品 30 / 成品 20
-- ============================================================
INSERT INTO `sp_inventory` (`id`,`warehouse_id`,`location_id`,`materiel_id`,`batch_no`,`qty`,`unit`,`stock_status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('inv_pcb',  '2062753868678729730','2062753868741644290','mat_pcb',        'B20260601',500.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('inv_cpu',  '2062753868678729730','2062753868741644291','mat_cpu',        'B20260601', 40.0000,'颗','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('inv_ram',  '2062753868678729730','2062753868741644292','mat_ram',        'B20260601',450.0000,'条','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('inv_power','2062753868678729730','2062753868741644293','mat_power',      'B20260601',195.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('inv_case', '2062753868678729730','2062753868741644294','mat_case',       'B20260601',150.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('inv_main_unit','cp_wh_001','cp_loc_001','mat_mainboard_unit','B20260605', 70.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('inv_case_unit','cp_wh_001','cp_loc_002','mat_case_unit',     'B20260605', 50.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('inv_half',     'cp_wh_001','cp_loc_003','mat_pc_host_half',  'B20260606', 30.0000,'台','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('inv_fg',       'cp_wh_001','cp_loc_004','mat_pc_host',       'B20260608', 20.0000,'台','AVAILABLE','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`materiel_id`=VALUES(`materiel_id`),`batch_no`=VALUES(`batch_no`),`qty`=VALUES(`qty`),`unit`=VALUES(`unit`),`stock_status`=VALUES(`stock_status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 13. 旧工单（sp_order）·驱动 SN采集 / 工单管理 / 已交付工单
--   statue：1 待审批 / 2 已审批 / 3 已完成 / 4 已终止 / 5 已下发
--   ord_pc_001 量产单已完工并交付（驱动「已交付工单」页）
-- ============================================================
INSERT INTO `sp_order`
(`id`,`order_code`,`order_description`,`qty`,`order_type`,`flow_id`,`materiel`,`materiel_desc`,`plan_start_time`,`plan_end_time`,`statue`,`designer_id`,`designer_name`,`approve_user_id`,`approve_username`,`approve_time`,`remark`,`work_status`,`work_start_time`,`complete_status`,`complete_time`,`complete_username`,`delivery_status`,`delivery_time`,`delivery_username`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('ord_pc_001','DD20260601001','台式电脑主机量产工单',100,'P','flow_pc_host','PC_HOST','台式电脑主机','2026-06-01','2026-06-10',3,'1184009088826392578','宋鹏','1184019107907227649','超级管理员','2026-06-01 09:00:00','量产已完工交付','STARTED','2026-06-01 09:30:00','COMPLETED','2026-06-10 17:00:00','admin','DELIVERED','2026-06-11 10:00:00','admin',NOW(),'admin',NOW(),'admin'),
('ord_pc_002','DD20260605001','台式电脑主机试产工单', 50,'A','flow_pc_host','PC_HOST','台式电脑主机','2026-06-06','2026-06-12',1,'1184009088826392578','宋鹏',NULL,NULL,NULL,'试产待审批','NOT_STARTED',NULL,'WAIT',NULL,NULL,'WAIT',NULL,NULL,NOW(),'admin',NOW(),'admin'),
('ord_pc_003','DD20260608001','台式电脑主机返工工单', 10,'F','flow_pc_host','PC_HOST','台式电脑主机','2026-06-08','2026-06-11',2,'1184009088826392578','宋鹏','1184019107907227649','超级管理员','2026-06-08 10:30:00','返工已审批','NOT_STARTED',NULL,'WAIT',NULL,NULL,'WAIT',NULL,NULL,NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_description`=VALUES(`order_description`),`qty`=VALUES(`qty`),`order_type`=VALUES(`order_type`),`flow_id`=VALUES(`flow_id`),`materiel`=VALUES(`materiel`),`materiel_desc`=VALUES(`materiel_desc`),`plan_start_time`=VALUES(`plan_start_time`),`plan_end_time`=VALUES(`plan_end_time`),`statue`=VALUES(`statue`),`designer_id`=VALUES(`designer_id`),`designer_name`=VALUES(`designer_name`),`approve_user_id`=VALUES(`approve_user_id`),`approve_username`=VALUES(`approve_username`),`approve_time`=VALUES(`approve_time`),`remark`=VALUES(`remark`),`work_status`=VALUES(`work_status`),`work_start_time`=VALUES(`work_start_time`),`complete_status`=VALUES(`complete_status`),`complete_time`=VALUES(`complete_time`),`complete_username`=VALUES(`complete_username`),`delivery_status`=VALUES(`delivery_status`),`delivery_time`=VALUES(`delivery_time`),`delivery_username`=VALUES(`delivery_username`),`update_time`=NOW();

-- ============================================================
-- 14. SN 过程采集（sp_sn_process_record）·已完工量产工单 ord_pc_001
-- ============================================================
INSERT INTO `sp_sn_process_record`
(`id`,`sn`,`order_id`,`order_code`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`step_no`,`status`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('sn_pc_0101','PC2026060100001','ord_pc_001','DD20260601001','flow_pc_host','op_gx000002','GX000002','主板装配作业工序',1,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0102','PC2026060100001','ord_pc_001','DD20260601001','flow_pc_host','op_gx000003','GX000003','机箱组装作业工序',2,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0103','PC2026060100001','ord_pc_001','DD20260601001','flow_pc_host','op_gx000008','GX000008','主机装配作业',    3,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0104','PC2026060100001','ord_pc_001','DD20260601001','flow_pc_host','op_gx000010','GX000010','整机测试作业',    4,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0105','PC2026060100001','ord_pc_001','DD20260601001','flow_pc_host','op_gx000011','GX000011','包装入库作业',    5,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0201','PC2026060100002','ord_pc_001','DD20260601001','flow_pc_host','op_gx000002','GX000002','主板装配作业工序',1,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0202','PC2026060100002','ord_pc_001','DD20260601001','flow_pc_host','op_gx000003','GX000003','机箱组装作业工序',2,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0203','PC2026060100002','ord_pc_001','DD20260601001','flow_pc_host','op_gx000008','GX000008','主机装配作业',    3,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0204','PC2026060100002','ord_pc_001','DD20260601001','flow_pc_host','op_gx000010','GX000010','整机测试作业',    4,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0205','PC2026060100002','ord_pc_001','DD20260601001','flow_pc_host','op_gx000011','GX000011','包装入库作业',    5,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0301','PC2026060100003','ord_pc_001','DD20260601001','flow_pc_host','op_gx000002','GX000002','主板装配作业工序',1,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0302','PC2026060100003','ord_pc_001','DD20260601001','flow_pc_host','op_gx000003','GX000003','机箱组装作业工序',2,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0303','PC2026060100003','ord_pc_001','DD20260601001','flow_pc_host','op_gx000008','GX000008','主机装配作业',    3,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0304','PC2026060100003','ord_pc_001','DD20260601001','flow_pc_host','op_gx000010','GX000010','整机测试作业',    4,'NG','开机无显示，主板返修',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`step_no`=VALUES(`step_no`),`status`=VALUES(`status`),`remark`=VALUES(`remark`),`update_time`=NOW();

-- ============================================================
-- ============ 以下为 6-08 之后新增模块演示数据 ===============
-- ============================================================

-- ============================================================
-- 15. 生产工单（sp_order）·支撑生产计划下发链路的两张工单
--   wo_assign：statue=2 已审批（对应已审待下发的生产订单 po_assign）
--   wo_disp  ：statue=5 已下发、work_status=STARTED（对应已下发的生产订单 po_disp）
-- ============================================================
INSERT INTO `sp_order`
(`id`,`order_code`,`order_description`,`qty`,`order_type`,`flow_id`,`materiel`,`materiel_desc`,`plan_start_time`,`plan_end_time`,`statue`,`designer_id`,`designer_name`,`approve_user_id`,`approve_username`,`approve_time`,`remark`,`work_status`,`work_start_time`,`complete_status`,`complete_time`,`complete_username`,`delivery_status`,`delivery_time`,`delivery_username`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('wo_pc_assign','GD20260612001','台式电脑主机生产工单(待下发)',10,'P','flow_pc_host','PC_HOST','台式电脑主机','2026-06-18','2026-06-24',2,'1184009088826392578','宋鹏','1184019107907227649','超级管理员','2026-06-12 10:00:00','生产计划派工完成待下发','NOT_STARTED',NULL,'WAIT',NULL,NULL,'WAIT',NULL,NULL,NOW(),'admin',NOW(),'admin'),
('wo_pc_disp','GD20260610001','台式电脑主机生产工单(已下发)',10,'P','flow_pc_host','PC_HOST','台式电脑主机','2026-06-15','2026-06-20',5,'1184009088826392578','宋鹏','1184019107907227649','超级管理员','2026-06-10 10:00:00','生产计划已下发并已开工','STARTED','2026-06-15 08:30:00','WAIT',NULL,NULL,'WAIT',NULL,NULL,NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_description`=VALUES(`order_description`),`qty`=VALUES(`qty`),`order_type`=VALUES(`order_type`),`flow_id`=VALUES(`flow_id`),`materiel`=VALUES(`materiel`),`materiel_desc`=VALUES(`materiel_desc`),`plan_start_time`=VALUES(`plan_start_time`),`plan_end_time`=VALUES(`plan_end_time`),`statue`=VALUES(`statue`),`approve_username`=VALUES(`approve_username`),`approve_time`=VALUES(`approve_time`),`remark`=VALUES(`remark`),`work_status`=VALUES(`work_status`),`work_start_time`=VALUES(`work_start_time`),`update_time`=NOW();

-- 已开工标记：wo_pc_disp 增加 1 条 SN 采集，使 hasStarted=true（工单变更走审批分支）
INSERT INTO `sp_sn_process_record`
(`id`,`sn`,`order_id`,`order_code`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`step_no`,`status`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('sn_pc_wo01','PC2026061000001','wo_pc_disp','GD20260610001','flow_pc_host','op_gx000002','GX000002','主板装配作业工序',1,'OK','已下发工单开工首件',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `status`=VALUES(`status`),`remark`=VALUES(`remark`),`update_time`=NOW();

-- ============================================================
-- 16. 生产订单（sp_production_order）·三阶段
--   po_draft ：草稿(DRAFT/DRAFT/NONE)        → 生产订单录入
--   po_assign：已审待下发(APPROVED/ASSIGNED)  → 设备派工/员工派工/生产计划下发/工单查询
--   po_disp  ：已下发(APPROVED/DISPATCHED)    → 工单查询(可变更)/MRP/库房/工单变更/工作流
-- ============================================================
INSERT INTO `sp_production_order`
(`id`,`order_no`,`source_type`,`customer_name`,`customer_group`,`external_no`,`sales_contract_no`,`business_type`,`order_date`,`settlement_currency`,`transport_mode`,`payment_terms`,`tax_rate`,`receiver_name`,`receiver_phone`,`receiver_address`,`remark`,`status`,`approval_status`,`operation_status`,`creation_method`,`scheduling_method`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('po_draft','DD20260613001','DEMAND','示范客户-恒新科技','华东大客户','EXT-20260613-01','HT20260613','普通销售','2026-06-13','人民币','公路运输','月结30天','不含税','王采购','13800000001','上海市浦东新区张江路1号','草稿待提交审批','DRAFT','DRAFT','NONE','MANUAL','REVERSE','0',NOW(),'admin',NOW(),'admin'),
('po_assign','DD20260612001','DEMAND','示范客户-恒新科技','华东大客户','EXT-20260612-01','HT20260612','普通销售','2026-06-12','人民币','公路运输','月结30天','不含税','王采购','13800000001','上海市浦东新区张江路1号','已审批且设备/员工派工完成，待下发','CONFIRMED','APPROVED','ASSIGNED','MANUAL','REVERSE','0',NOW(),'admin',NOW(),'admin'),
('po_disp','DD20260610001','DEMAND','示范客户-华兴电子','华南客户','EXT-20260610-01','HT20260610','普通销售','2026-06-10','人民币','公路运输','款到发货','不含税','李收货','13900000002','广州市天河区科韵路2号','已下发生产计划(全链路演示)','CONFIRMED','APPROVED','DISPATCHED','MANUAL','REVERSE','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `source_type`=VALUES(`source_type`),`customer_name`=VALUES(`customer_name`),`business_type`=VALUES(`business_type`),`order_date`=VALUES(`order_date`),`remark`=VALUES(`remark`),`status`=VALUES(`status`),`approval_status`=VALUES(`approval_status`),`operation_status`=VALUES(`operation_status`),`creation_method`=VALUES(`creation_method`),`scheduling_method`=VALUES(`scheduling_method`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 17. 生产订单明细（sp_production_order_item）
-- ============================================================
INSERT INTO `sp_production_order_item`
(`id`,`order_id`,`product_materiel`,`product_name`,`bom_id`,`bom_code`,`bom_version`,`model`,`specification`,`qty`,`unit_price`,`configuration`,`plan_delivery_date`,`plan_start_date`,`lead_time_days`,`target_capacity`,`computed_start_date`,`computed_delivery_date`,`adjust_note`,`work_order_id`,`work_order_code`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('poi_draft','po_draft','PC_HOST','台式电脑主机','bom_pc_host','BOM-PC-HOST','1','DESKTOP-HOST','标准配置',8,3999.00,'标准配置(i5/16G/512G)','2026-06-27','2026-06-22',1,5.00,'2026-06-22','2026-06-27',NULL,NULL,NULL,NOW(),'admin',NOW(),'admin'),
('poi_assign','po_assign','PC_HOST','台式电脑主机','bom_pc_host','BOM-PC-HOST','1','DESKTOP-HOST','标准配置',10,3999.00,'标准配置(i5/16G/512G)','2026-06-24','2026-06-18',1,5.00,'2026-06-18','2026-06-24',NULL,'wo_pc_assign','GD20260612001',NOW(),'admin',NOW(),'admin'),
('poi_disp','po_disp','PC_HOST','台式电脑主机','bom_pc_host','BOM-PC-HOST','1','DESKTOP-HOST','标准配置',10,3999.00,'标准配置(i5/16G/512G)','2026-06-20','2026-06-15',1,5.00,'2026-06-15','2026-06-20',NULL,'wo_pc_disp','GD20260610001',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`bom_id`=VALUES(`bom_id`),`bom_code`=VALUES(`bom_code`),`bom_version`=VALUES(`bom_version`),`qty`=VALUES(`qty`),`unit_price`=VALUES(`unit_price`),`configuration`=VALUES(`configuration`),`plan_delivery_date`=VALUES(`plan_delivery_date`),`plan_start_date`=VALUES(`plan_start_date`),`computed_start_date`=VALUES(`computed_start_date`),`computed_delivery_date`=VALUES(`computed_delivery_date`),`work_order_id`=VALUES(`work_order_id`),`work_order_code`=VALUES(`work_order_code`),`update_time`=NOW();

-- ============================================================
-- 18. 工序排产明细（sp_production_order_oper_plan）·po_assign / po_disp 各 5 工序
-- ============================================================
INSERT INTO `sp_production_order_oper_plan`
(`id`,`order_id`,`order_item_id`,`order_no`,`product_materiel`,`product_name`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`plan_start_time`,`plan_end_time`,`duration_hours`,`duration_source`,`schedule_method`,`calc_remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
-- po_assign（待下发，计划日 2026-06-23 逆排产）
('pop_a1','po_assign','poi_assign','DD20260612001','PC_HOST','台式电脑主机','flow_pc_host','op_gx000002','GX000002','主板装配作业工序',1,'jg_unit_001','2026-06-23 08:00:00','2026-06-23 10:00:00',2.00,'MANU_CYCLE','REVERSE','按制造周期逆排产','0',NOW(),'admin',NOW(),'admin'),
('pop_a2','po_assign','poi_assign','DD20260612001','PC_HOST','台式电脑主机','flow_pc_host','op_gx000003','GX000003','机箱组装作业工序',2,'jg_unit_001','2026-06-23 10:00:00','2026-06-23 12:00:00',2.00,'MANU_CYCLE','REVERSE','按制造周期逆排产','0',NOW(),'admin',NOW(),'admin'),
('pop_a3','po_assign','poi_assign','DD20260612001','PC_HOST','台式电脑主机','flow_pc_host','op_gx000008','GX000008','主机装配作业',3,'jg_unit_001','2026-06-23 13:00:00','2026-06-23 15:00:00',2.00,'MANU_CYCLE','REVERSE','按制造周期逆排产','0',NOW(),'admin',NOW(),'admin'),
('pop_a4','po_assign','poi_assign','DD20260612001','PC_HOST','台式电脑主机','flow_pc_host','op_gx000010','GX000010','整机测试作业',4,'jg_unit_002','2026-06-23 15:00:00','2026-06-23 16:00:00',1.00,'MANU_CYCLE','REVERSE','按制造周期逆排产','0',NOW(),'admin',NOW(),'admin'),
('pop_a5','po_assign','poi_assign','DD20260612001','PC_HOST','台式电脑主机','flow_pc_host','op_gx000011','GX000011','包装入库作业',5,'jg_unit_003','2026-06-23 16:00:00','2026-06-23 16:30:00',0.50,'MANU_CYCLE','REVERSE','按制造周期逆排产','0',NOW(),'admin',NOW(),'admin'),
-- po_disp（已下发，计划日 2026-06-19 逆排产）
('pop_d1','po_disp','poi_disp','DD20260610001','PC_HOST','台式电脑主机','flow_pc_host','op_gx000002','GX000002','主板装配作业工序',1,'jg_unit_001','2026-06-19 08:00:00','2026-06-19 10:00:00',2.00,'MANU_CYCLE','REVERSE','按制造周期逆排产','0',NOW(),'admin',NOW(),'admin'),
('pop_d2','po_disp','poi_disp','DD20260610001','PC_HOST','台式电脑主机','flow_pc_host','op_gx000003','GX000003','机箱组装作业工序',2,'jg_unit_001','2026-06-19 10:00:00','2026-06-19 12:00:00',2.00,'MANU_CYCLE','REVERSE','按制造周期逆排产','0',NOW(),'admin',NOW(),'admin'),
('pop_d3','po_disp','poi_disp','DD20260610001','PC_HOST','台式电脑主机','flow_pc_host','op_gx000008','GX000008','主机装配作业',3,'jg_unit_001','2026-06-19 13:00:00','2026-06-19 15:00:00',2.00,'MANU_CYCLE','REVERSE','按制造周期逆排产','0',NOW(),'admin',NOW(),'admin'),
('pop_d4','po_disp','poi_disp','DD20260610001','PC_HOST','台式电脑主机','flow_pc_host','op_gx000010','GX000010','整机测试作业',4,'jg_unit_002','2026-06-19 15:00:00','2026-06-19 16:00:00',1.00,'MANU_CYCLE','REVERSE','按制造周期逆排产','0',NOW(),'admin',NOW(),'admin'),
('pop_d5','po_disp','poi_disp','DD20260610001','PC_HOST','台式电脑主机','flow_pc_host','op_gx000011','GX000011','包装入库作业',5,'jg_unit_003','2026-06-19 16:00:00','2026-06-19 16:30:00',0.50,'MANU_CYCLE','REVERSE','按制造周期逆排产','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_item_id`=VALUES(`order_item_id`),`order_no`=VALUES(`order_no`),`flow_id`=VALUES(`flow_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`plan_start_time`=VALUES(`plan_start_time`),`plan_end_time`=VALUES(`plan_end_time`),`duration_hours`=VALUES(`duration_hours`),`duration_source`=VALUES(`duration_source`),`schedule_method`=VALUES(`schedule_method`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 19. 设备作业派工（sp_order_oper_equipment_assign）+ 员工作业派工（sp_order_oper_assign）
--   每个工序计划均完成 设备 + 员工 双派工，满足下发判定
-- ============================================================
INSERT INTO `sp_order_oper_equipment_assign`
(`id`,`order_id`,`order_code`,`production_order_id`,`order_item_id`,`oper_plan_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`equipment_id`,`equipment_code`,`equipment_name`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('ooea_a1','wo_pc_assign','GD20260612001','po_assign','poi_assign','pop_a1','op_gx000002','GX000002','主板装配作业工序',1,'jg_unit_001','eq_002','EQ000002','主板测试夹具','ASSIGNED','',  '0',NOW(),'admin',NOW(),'admin'),
('ooea_a2','wo_pc_assign','GD20260612001','po_assign','poi_assign','pop_a2','op_gx000003','GX000003','机箱组装作业工序',2,'jg_unit_001','eq_004','EQ000004','防静电手指套','ASSIGNED','','0',NOW(),'admin',NOW(),'admin'),
('ooea_a3','wo_pc_assign','GD20260612001','po_assign','poi_assign','pop_a3','op_gx000008','GX000008','主机装配作业',3,'jg_unit_001','eq_005','EQ000005','防静电环','ASSIGNED','','0',NOW(),'admin',NOW(),'admin'),
('ooea_a4','wo_pc_assign','GD20260612001','po_assign','poi_assign','pop_a4','op_gx000010','GX000010','整机测试作业',4,'jg_unit_002','eq_003','EQ000003','整机老化测试台','ASSIGNED','','0',NOW(),'admin',NOW(),'admin'),
('ooea_a5','wo_pc_assign','GD20260612001','po_assign','poi_assign','pop_a5','op_gx000011','GX000011','包装入库作业',5,'jg_unit_003','eq_001','EQ000001','物料周转车','ASSIGNED','','0',NOW(),'admin',NOW(),'admin'),
('ooea_d1','wo_pc_disp','GD20260610001','po_disp','poi_disp','pop_d1','op_gx000002','GX000002','主板装配作业工序',1,'jg_unit_001','eq_002','EQ000002','主板测试夹具','ASSIGNED','','0',NOW(),'admin',NOW(),'admin'),
('ooea_d2','wo_pc_disp','GD20260610001','po_disp','poi_disp','pop_d2','op_gx000003','GX000003','机箱组装作业工序',2,'jg_unit_001','eq_004','EQ000004','防静电手指套','ASSIGNED','','0',NOW(),'admin',NOW(),'admin'),
('ooea_d3','wo_pc_disp','GD20260610001','po_disp','poi_disp','pop_d3','op_gx000008','GX000008','主机装配作业',3,'jg_unit_001','eq_005','EQ000005','防静电环','ASSIGNED','','0',NOW(),'admin',NOW(),'admin'),
('ooea_d4','wo_pc_disp','GD20260610001','po_disp','poi_disp','pop_d4','op_gx000010','GX000010','整机测试作业',4,'jg_unit_002','eq_003','EQ000003','整机老化测试台','ASSIGNED','','0',NOW(),'admin',NOW(),'admin'),
('ooea_d5','wo_pc_disp','GD20260610001','po_disp','poi_disp','pop_d5','op_gx000011','GX000011','包装入库作业',5,'jg_unit_003','eq_001','EQ000001','物料周转车','ASSIGNED','','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_code`=VALUES(`order_code`),`production_order_id`=VALUES(`production_order_id`),`order_item_id`=VALUES(`order_item_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`equipment_id`=VALUES(`equipment_id`),`equipment_code`=VALUES(`equipment_code`),`equipment_name`=VALUES(`equipment_name`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order_oper_assign`
(`id`,`order_id`,`order_code`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`team_id`,`user_id`,`user_name`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('ooa_a1','wo_pc_assign','GD20260612001','flow_pc_host','op_gx000002','GX000002','主板装配作业工序',1,'jg_unit_001','team_01','1184009088826392578','宋鹏','0','',  '0',NOW(),'admin',NOW(),'admin'),
('ooa_a2','wo_pc_assign','GD20260612001','flow_pc_host','op_gx000003','GX000003','机箱组装作业工序',2,'jg_unit_001','team_02','1184010472443396098','猴子','0','','0',NOW(),'admin',NOW(),'admin'),
('ooa_a3','wo_pc_assign','GD20260612001','flow_pc_host','op_gx000008','GX000008','主机装配作业',3,'jg_unit_001','team_01','1276512902757724162','小明','0','','0',NOW(),'admin',NOW(),'admin'),
('ooa_a4','wo_pc_assign','GD20260612001','flow_pc_host','op_gx000010','GX000010','整机测试作业',4,'jg_unit_002','team_03','1184010472443396098','猴子','0','','0',NOW(),'admin',NOW(),'admin'),
('ooa_a5','wo_pc_assign','GD20260612001','flow_pc_host','op_gx000011','GX000011','包装入库作业',5,'jg_unit_003','team_03','1276512902757724162','小明','0','','0',NOW(),'admin',NOW(),'admin'),
('ooa_d1','wo_pc_disp','GD20260610001','flow_pc_host','op_gx000002','GX000002','主板装配作业工序',1,'jg_unit_001','team_01','1184009088826392578','宋鹏','0','','0',NOW(),'admin',NOW(),'admin'),
('ooa_d2','wo_pc_disp','GD20260610001','flow_pc_host','op_gx000003','GX000003','机箱组装作业工序',2,'jg_unit_001','team_02','1184010472443396098','猴子','0','','0',NOW(),'admin',NOW(),'admin'),
('ooa_d3','wo_pc_disp','GD20260610001','flow_pc_host','op_gx000008','GX000008','主机装配作业',3,'jg_unit_001','team_01','1276512902757724162','小明','0','','0',NOW(),'admin',NOW(),'admin'),
('ooa_d4','wo_pc_disp','GD20260610001','flow_pc_host','op_gx000010','GX000010','整机测试作业',4,'jg_unit_002','team_03','1184010472443396098','猴子','0','','0',NOW(),'admin',NOW(),'admin'),
('ooa_d5','wo_pc_disp','GD20260610001','flow_pc_host','op_gx000011','GX000011','包装入库作业',5,'jg_unit_003','team_03','1276512902757724162','小明','0','','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_code`=VALUES(`order_code`),`flow_id`=VALUES(`flow_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`team_id`=VALUES(`team_id`),`user_id`=VALUES(`user_id`),`user_name`=VALUES(`user_name`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 20. 物料需求计划 MRP（sp_material_requirement_plan）
--   BOM 展开仅叶子零件(5种)。库存充足，净需求基本为 0；
--   po_disp 的 CPU 演示「曾短缺→已生成入库申请→已计划入库补足」历史：
--     存储净需求 15(运算时库存25)，inbound_status=GENERATED，挂入库申请单；
--     列表页按实时库存(40)重算后净需求显示 0(已补足)，逻辑自洽。
-- ============================================================
INSERT INTO `sp_material_requirement_plan`
(`id`,`production_order_id`,`production_order_no`,`order_item_id`,`product_serial_no`,`product_materiel`,`product_name`,`material_id`,`material_code`,`material_name`,`material_type`,`material_source`,`unit`,`bom_level`,`bom_path`,`gross_requirement`,`available_stock`,`safety_stock`,`net_requirement`,`requirement_date`,`lead_time_days`,`release_date`,`delivery_status`,`inbound_status`,`inbound_request_id`,`inbound_request_no`,`outbound_status`,`outbound_request_id`,`outbound_request_no`,`calc_batch_no`,`calc_time`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
-- po_assign（已审待下发；全部净需求 0，MRP 视为完成，可下发）
('mrp_a_pcb','po_assign','DD20260612001','poi_assign','DD20260612001-SN001','PC_HOST','台式电脑主机','mat_pcb','PCB_BOARD','主板电路板','PART','OUT','件',3,'BOM-PC-HOST(PC_HOST) > PC_HOST_HALF > MAINBOARD_UNIT > PCB_BOARD',10.00,500.00,50.00,0.00,'2026-06-18',2,'2026-06-16','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP20260613100002','2026-06-13 10:05:00','库存充足','0',NOW(),'admin',NOW(),'admin'),
('mrp_a_cpu','po_assign','DD20260612001','poi_assign','DD20260612001-SN001','PC_HOST','台式电脑主机','mat_cpu','CPU','CPU','PART','OUT','颗',3,'BOM-PC-HOST(PC_HOST) > PC_HOST_HALF > MAINBOARD_UNIT > CPU',10.00,40.00,30.00,0.00,'2026-06-18',3,'2026-06-13','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP20260613100002','2026-06-13 10:05:00','库存充足','0',NOW(),'admin',NOW(),'admin'),
('mrp_a_ram','po_assign','DD20260612001','poi_assign','DD20260612001-SN001','PC_HOST','台式电脑主机','mat_ram','MEMORY','内存条','PART','OUT','条',3,'BOM-PC-HOST(PC_HOST) > PC_HOST_HALF > MAINBOARD_UNIT > MEMORY',10.00,450.00,40.00,0.00,'2026-06-18',2,'2026-06-16','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP20260613100002','2026-06-13 10:05:00','库存充足','0',NOW(),'admin',NOW(),'admin'),
('mrp_a_power','po_assign','DD20260612001','poi_assign','DD20260612001-SN001','PC_HOST','台式电脑主机','mat_power','POWER_SUPPLY','电源','PART','OUT','件',3,'BOM-PC-HOST(PC_HOST) > PC_HOST_HALF > CASE_UNIT > POWER_SUPPLY',10.00,195.00,20.00,0.00,'2026-06-18',2,'2026-06-16','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP20260613100002','2026-06-13 10:05:00','库存充足','0',NOW(),'admin',NOW(),'admin'),
('mrp_a_case','po_assign','DD20260612001','poi_assign','DD20260612001-SN001','PC_HOST','台式电脑主机','mat_case','CASE_SHELL','机箱','PART','OUT','件',3,'BOM-PC-HOST(PC_HOST) > PC_HOST_HALF > CASE_UNIT > CASE_SHELL',10.00,150.00,15.00,0.00,'2026-06-18',2,'2026-06-16','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP20260613100002','2026-06-13 10:05:00','库存充足','0',NOW(),'admin',NOW(),'admin'),
-- po_disp（已下发；CPU 历史短缺已补足）
('mrp_d_pcb','po_disp','DD20260610001','poi_disp','DD20260610001-SN001','PC_HOST','台式电脑主机','mat_pcb','PCB_BOARD','主板电路板','PART','OUT','件',3,'BOM-PC-HOST(PC_HOST) > PC_HOST_HALF > MAINBOARD_UNIT > PCB_BOARD',10.00,500.00,50.00,0.00,'2026-06-15',2,'2026-06-11','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP20260613100001','2026-06-13 10:00:00','库存充足','0',NOW(),'admin',NOW(),'admin'),
('mrp_d_cpu','po_disp','DD20260610001','poi_disp','DD20260610001-SN001','PC_HOST','台式电脑主机','mat_cpu','CPU','CPU','PART','OUT','颗',3,'BOM-PC-HOST(PC_HOST) > PC_HOST_HALF > MAINBOARD_UNIT > CPU',10.00,25.00,30.00,15.00,'2026-06-15',3,'2026-06-10','RELEASED','GENERATED','mir_cpu','IR20260613001','NONE',NULL,NULL,'MRP20260613100001','2026-06-13 10:00:00','运算时库存25颗短缺15，已生成入库申请并计划入库补足','0',NOW(),'admin',NOW(),'admin'),
('mrp_d_ram','po_disp','DD20260610001','poi_disp','DD20260610001-SN001','PC_HOST','台式电脑主机','mat_ram','MEMORY','内存条','PART','OUT','条',3,'BOM-PC-HOST(PC_HOST) > PC_HOST_HALF > MAINBOARD_UNIT > MEMORY',10.00,400.00,40.00,0.00,'2026-06-15',2,'2026-06-11','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP20260613100001','2026-06-13 10:00:00','库存充足','0',NOW(),'admin',NOW(),'admin'),
('mrp_d_power','po_disp','DD20260610001','poi_disp','DD20260610001-SN001','PC_HOST','台式电脑主机','mat_power','POWER_SUPPLY','电源','PART','OUT','件',3,'BOM-PC-HOST(PC_HOST) > PC_HOST_HALF > CASE_UNIT > POWER_SUPPLY',10.00,200.00,20.00,0.00,'2026-06-15',2,'2026-06-11','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP20260613100001','2026-06-13 10:00:00','库存充足','0',NOW(),'admin',NOW(),'admin'),
('mrp_d_case','po_disp','DD20260610001','poi_disp','DD20260610001-SN001','PC_HOST','台式电脑主机','mat_case','CASE_SHELL','机箱','PART','OUT','件',3,'BOM-PC-HOST(PC_HOST) > PC_HOST_HALF > CASE_UNIT > CASE_SHELL',10.00,150.00,15.00,0.00,'2026-06-15',2,'2026-06-11','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP20260613100001','2026-06-13 10:00:00','库存充足','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `production_order_id`=VALUES(`production_order_id`),`production_order_no`=VALUES(`production_order_no`),`order_item_id`=VALUES(`order_item_id`),`material_id`=VALUES(`material_id`),`material_code`=VALUES(`material_code`),`material_name`=VALUES(`material_name`),`material_type`=VALUES(`material_type`),`material_source`=VALUES(`material_source`),`unit`=VALUES(`unit`),`bom_level`=VALUES(`bom_level`),`bom_path`=VALUES(`bom_path`),`gross_requirement`=VALUES(`gross_requirement`),`available_stock`=VALUES(`available_stock`),`safety_stock`=VALUES(`safety_stock`),`net_requirement`=VALUES(`net_requirement`),`requirement_date`=VALUES(`requirement_date`),`lead_time_days`=VALUES(`lead_time_days`),`release_date`=VALUES(`release_date`),`delivery_status`=VALUES(`delivery_status`),`inbound_status`=VALUES(`inbound_status`),`inbound_request_id`=VALUES(`inbound_request_id`),`inbound_request_no`=VALUES(`inbound_request_no`),`outbound_status`=VALUES(`outbound_status`),`calc_batch_no`=VALUES(`calc_batch_no`),`calc_time`=VALUES(`calc_time`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 21. 入库申请单（sp_material_inbound_request / _item）·CPU 短缺补料
-- ============================================================
INSERT INTO `sp_material_inbound_request`
(`id`,`request_no`,`production_order_id`,`production_order_no`,`source_batch_no`,`status`,`item_count`,`total_net_qty`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('mir_cpu','IR20260613001','po_disp','DD20260610001','MRP20260613100001','CONFIRMED',1,15.00,'由MRP物料需求计划生成(CPU短缺15颗)','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `production_order_id`=VALUES(`production_order_id`),`production_order_no`=VALUES(`production_order_no`),`source_batch_no`=VALUES(`source_batch_no`),`status`=VALUES(`status`),`item_count`=VALUES(`item_count`),`total_net_qty`=VALUES(`total_net_qty`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_material_inbound_request_item`
(`id`,`request_id`,`request_no`,`plan_id`,`production_order_id`,`production_order_no`,`material_id`,`material_code`,`material_name`,`unit`,`request_qty`,`requirement_date`,`release_date`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('mir_item_cpu','mir_cpu','IR20260613001','mrp_d_cpu','po_disp','DD20260610001','mat_cpu','CPU','CPU','颗',15.00,'2026-06-15','2026-06-10','CPU补料','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_id`=VALUES(`request_id`),`request_no`=VALUES(`request_no`),`plan_id`=VALUES(`plan_id`),`production_order_id`=VALUES(`production_order_id`),`production_order_no`=VALUES(`production_order_no`),`material_id`=VALUES(`material_id`),`material_code`=VALUES(`material_code`),`material_name`=VALUES(`material_name`),`unit`=VALUES(`unit`),`request_qty`=VALUES(`request_qty`),`requirement_date`=VALUES(`requirement_date`),`release_date`=VALUES(`release_date`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 22. 库房单据（请求/明细/分配/流水）·覆盖手工入/手工出/计划入/配套出全部页面
--   库存增减与第12节终值对齐：
--     计划入库 CPU +15(25→40) / 手工入库 RAM +50(400→450) /
--     手工出库 POWER -5(200→195) / 配套出库 主板单元-10(80→70)、机箱单元-10(60→50)
--   另含 2 张待确认单(手工入PCB200/手工出PCB10)，供确认页操作演示，未影响库存
-- ============================================================
INSERT INTO `sp_warehouse_request`
(`id`,`request_no`,`business_type`,`source_type`,`source_id`,`source_no`,`warehouse_id`,`status`,`item_count`,`total_qty`,`apply_username`,`apply_time`,`confirm_username`,`confirm_time`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('wr_plan_cpu','WPI20260613001','PLAN_IN','PLAN_INBOUND','mir_cpu','IR20260613001','2062753868678729730','CONFIRMED',1,15.0000,'admin','2026-06-13 10:10:00','admin','2026-06-13 10:30:00','计划入库：CPU补料15颗','0',NOW(),'admin',NOW(),'admin'),
('wr_min_ram','WMI20260613001','MANUAL_IN','MANUAL',NULL,NULL,'2062753868678729730','CONFIRMED',1,50.0000,'admin','2026-06-13 09:00:00','admin','2026-06-13 09:20:00','手工入库：内存条到货50条','0',NOW(),'admin',NOW(),'admin'),
('wr_min_pcb','WMI20260613002','MANUAL_IN','MANUAL',NULL,NULL,'2062753868678729730','WAIT_CONFIRM',1,200.0000,'admin','2026-06-13 14:00:00',NULL,NULL,'手工入库申请：主板电路板到货200件(待确认)','0',NOW(),'admin',NOW(),'admin'),
('wr_mout_power','WMO20260613001','MANUAL_OUT','MANUAL',NULL,NULL,'2062753868678729730','CONFIRMED',1,5.0000,'admin','2026-06-13 09:30:00','admin','2026-06-13 09:45:00','手工出库：电源领用5件(检修)','0',NOW(),'admin',NOW(),'admin'),
('wr_mout_pcb','WMO20260613002','MANUAL_OUT','MANUAL',NULL,NULL,'2062753868678729730','WAIT_CONFIRM',1,10.0000,'admin','2026-06-13 15:00:00',NULL,NULL,'手工出库申请：主板电路板领用10件(待确认)','0',NOW(),'admin',NOW(),'admin'),
('wr_kit','WKO20260613001','KITTING_OUT','MRP','po_disp','DD20260610001','cp_wh_001','CONFIRMED',2,20.0000,'admin','2026-06-13 11:00:00','admin','2026-06-13 11:10:00','配套出库：已下发工单GD20260610001领料','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `business_type`=VALUES(`business_type`),`source_type`=VALUES(`source_type`),`source_id`=VALUES(`source_id`),`source_no`=VALUES(`source_no`),`warehouse_id`=VALUES(`warehouse_id`),`status`=VALUES(`status`),`item_count`=VALUES(`item_count`),`total_qty`=VALUES(`total_qty`),`apply_username`=VALUES(`apply_username`),`apply_time`=VALUES(`apply_time`),`confirm_username`=VALUES(`confirm_username`),`confirm_time`=VALUES(`confirm_time`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_request_item`
(`id`,`request_id`,`material_id`,`material_code`,`material_name`,`warehouse_id`,`location_id`,`batch_no`,`request_qty`,`confirmed_qty`,`unit`,`status`,`source_item_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('wri_plan_cpu','wr_plan_cpu','mat_cpu','CPU','CPU','2062753868678729730','2062753868741644291','IR20260613001',15.0000,15.0000,'颗','CONFIRMED','mir_item_cpu','计划入库CPU','0',NOW(),'admin',NOW(),'admin'),
('wri_min_ram','wr_min_ram','mat_ram','MEMORY','内存条','2062753868678729730','2062753868741644292','B20260613',50.0000,50.0000,'条','CONFIRMED',NULL,'手工入库内存条','0',NOW(),'admin',NOW(),'admin'),
('wri_min_pcb','wr_min_pcb','mat_pcb','PCB_BOARD','主板电路板','2062753868678729730','2062753868741644290','B20260613',200.0000,0.0000,'件','WAIT_CONFIRM',NULL,'待确认入库','0',NOW(),'admin',NOW(),'admin'),
('wri_mout_power','wr_mout_power','mat_power','POWER_SUPPLY','电源','2062753868678729730','2062753868741644293','B20260601',5.0000,5.0000,'件','CONFIRMED',NULL,'手工出库电源','0',NOW(),'admin',NOW(),'admin'),
('wri_mout_pcb','wr_mout_pcb','mat_pcb','PCB_BOARD','主板电路板','2062753868678729730','2062753868741644290','B20260601',10.0000,0.0000,'件','WAIT_CONFIRM',NULL,'待确认出库','0',NOW(),'admin',NOW(),'admin'),
('wri_kit_mb','wr_kit','mat_mainboard_unit','MAINBOARD_UNIT','主板单元','cp_wh_001','cp_loc_001','B20260605',10.0000,10.0000,'件','CONFIRMED',NULL,'配套出库主板单元','0',NOW(),'admin',NOW(),'admin'),
('wri_kit_case','wr_kit','mat_case_unit','CASE_UNIT','机箱单元','cp_wh_001','cp_loc_002','B20260605',10.0000,10.0000,'件','CONFIRMED',NULL,'配套出库机箱单元','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_id`=VALUES(`request_id`),`material_id`=VALUES(`material_id`),`material_code`=VALUES(`material_code`),`material_name`=VALUES(`material_name`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`batch_no`=VALUES(`batch_no`),`request_qty`=VALUES(`request_qty`),`confirmed_qty`=VALUES(`confirmed_qty`),`unit`=VALUES(`unit`),`status`=VALUES(`status`),`source_item_id`=VALUES(`source_item_id`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_request_allocation`
(`id`,`request_id`,`request_item_id`,`inventory_id`,`warehouse_id`,`location_id`,`material_id`,`batch_no`,`qty`,`before_qty`,`after_qty`,`allocation_rule`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('wra_mout_power','wr_mout_power','wri_mout_power','inv_power','2062753868678729730','2062753868741644293','mat_power','B20260601',5.0000,200.0000,195.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('wra_kit_mb','wr_kit','wri_kit_mb','inv_main_unit','cp_wh_001','cp_loc_001','mat_mainboard_unit','B20260605',10.0000,80.0000,70.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('wra_kit_case','wr_kit','wri_kit_case','inv_case_unit','cp_wh_001','cp_loc_002','mat_case_unit','B20260605',10.0000,60.0000,50.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_id`=VALUES(`request_id`),`request_item_id`=VALUES(`request_item_id`),`inventory_id`=VALUES(`inventory_id`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`material_id`=VALUES(`material_id`),`batch_no`=VALUES(`batch_no`),`qty`=VALUES(`qty`),`before_qty`=VALUES(`before_qty`),`after_qty`=VALUES(`after_qty`),`allocation_rule`=VALUES(`allocation_rule`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- 出入库流水（sp_warehouse_transaction，无软删列）
INSERT INTO `sp_warehouse_transaction`
(`id`,`transaction_no`,`request_id`,`request_no`,`request_item_id`,`direction`,`business_type`,`warehouse_id`,`location_id`,`material_id`,`batch_no`,`qty`,`before_qty`,`after_qty`,`operator_username`,`operate_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('wtx_in_cpu','WI20260613001','wr_plan_cpu','WPI20260613001','wri_plan_cpu','IN','PLAN_IN','2062753868678729730','2062753868741644291','mat_cpu','IR20260613001',15.0000,25.0000,40.0000,'admin','2026-06-13 10:30:00','计划入库CPU+15',NOW(),'admin',NOW(),'admin'),
('wtx_in_ram','WI20260613002','wr_min_ram','WMI20260613001','wri_min_ram','IN','MANUAL_IN','2062753868678729730','2062753868741644292','mat_ram','B20260613',50.0000,400.0000,450.0000,'admin','2026-06-13 09:20:00','手工入库内存条+50',NOW(),'admin',NOW(),'admin'),
('wtx_out_power','WO20260613001','wr_mout_power','WMO20260613001','wri_mout_power','OUT','MANUAL_OUT','2062753868678729730','2062753868741644293','mat_power','B20260601',5.0000,200.0000,195.0000,'admin','2026-06-13 09:45:00','手工出库电源-5',NOW(),'admin',NOW(),'admin'),
('wtx_out_mb','WO20260613002','wr_kit','WKO20260613001','wri_kit_mb','OUT','KITTING_OUT','cp_wh_001','cp_loc_001','mat_mainboard_unit','B20260605',10.0000,80.0000,70.0000,'admin','2026-06-13 11:10:00','配套出库主板单元-10',NOW(),'admin',NOW(),'admin'),
('wtx_out_case','WO20260613003','wr_kit','WKO20260613001','wri_kit_case','OUT','KITTING_OUT','cp_wh_001','cp_loc_002','mat_case_unit','B20260605',10.0000,60.0000,50.0000,'admin','2026-06-13 11:10:00','配套出库机箱单元-10',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_id`=VALUES(`request_id`),`request_no`=VALUES(`request_no`),`request_item_id`=VALUES(`request_item_id`),`direction`=VALUES(`direction`),`business_type`=VALUES(`business_type`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`material_id`=VALUES(`material_id`),`batch_no`=VALUES(`batch_no`),`qty`=VALUES(`qty`),`before_qty`=VALUES(`before_qty`),`after_qty`=VALUES(`after_qty`),`operator_username`=VALUES(`operator_username`),`operate_time`=VALUES(`operate_time`),`remark`=VALUES(`remark`),`update_time`=NOW();

-- ============================================================
-- 23. 已下达工单变更（sp_work_order_change）·po_disp 工单数量 10→12 审批中
-- ============================================================
INSERT INTO `sp_work_order_change`
(`id`,`work_order_id`,`work_order_code`,`production_order_id`,`order_item_id`,`before_flow_id`,`after_flow_id`,`before_qty`,`after_qty`,`before_plan_start_time`,`after_plan_start_time`,`before_plan_end_time`,`after_plan_end_time`,`before_remark`,`after_remark`,`status`,`workflow_instance_id`,`apply_time`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('woc_disp','wo_pc_disp','GD20260610001','po_disp','poi_disp','flow_pc_host','flow_pc_host',10,12,'2026-06-15 08:00:00','2026-06-15 08:00:00','2026-06-20 17:00:00','2026-06-21 17:00:00','','客户追加2台，交付顺延1天','APPROVING','wfi_woc',NULL,NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `work_order_code`=VALUES(`work_order_code`),`production_order_id`=VALUES(`production_order_id`),`order_item_id`=VALUES(`order_item_id`),`before_qty`=VALUES(`before_qty`),`after_qty`=VALUES(`after_qty`),`after_plan_end_time`=VALUES(`after_plan_end_time`),`after_remark`=VALUES(`after_remark`),`status`=VALUES(`status`),`workflow_instance_id`=VALUES(`workflow_instance_id`),`update_time`=NOW();

-- ============================================================
-- 24. 工作流（种子兜底 + 运行时实例/任务）
--   分类/模型/定义已由升级脚本(workflow-control / work-order-change)注入，
--   此处 INSERT IGNORE 兜底，确保实例/任务的外键定义存在。
-- ============================================================
SET @wf_oa_json := '[{"nodeKey":"start","nodeName":"订单提交","nodeType":"start"},{"nodeKey":"order_approve","nodeName":"生产订单审批","nodeType":"approval","assigneeType":"role","assigneeId":"productionManagerRole","assigneeName":"生产主管","events":[{"eventType":"complete","actionCode":"ORDER_APPROVE","actionName":"订单审批通过"}]},{"nodeKey":"end","nodeName":"审批完成","nodeType":"end"}]';
SET @wf_woc_json := '[{"nodeKey":"start","nodeName":"提交变更","nodeType":"start"},{"nodeKey":"work_order_change_approve","nodeName":"工单变更审批","nodeType":"approval","assigneeType":"role","assigneeId":"productionManagerRole","assigneeName":"生产主管","events":[{"eventType":"complete","actionCode":"WORK_ORDER_CHANGE_APPLY","actionName":"工单变更审批通过并生效"}]},{"nodeKey":"end","nodeName":"审批完成","nodeType":"end"}]';

INSERT IGNORE INTO `sp_workflow_category`
(`id`,`parent_id`,`category_name`,`category_code`,`sort_num`,`status`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`)
VALUES ('wf_cat_prod','0','生产流程','prod',30,'0','生产订单审批与生产流程管控默认分类',NOW(),'admin',NOW(),'admin');

INSERT IGNORE INTO `sp_workflow_model`
(`id`,`category_id`,`model_code`,`model_name`,`business_type`,`node_json`,`status`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('wf_model_order_approval','wf_cat_prod','order_approval','生产订单审批流程','ORDER_APPROVAL',@wf_oa_json,'published','生产订单审批',NOW(),'admin',NOW(),'admin'),
('wf_model_work_order_change','wf_cat_prod','work_order_change','已下达工单变更审批流程','WORK_ORDER_CHANGE',@wf_woc_json,'published','已下达工单变更审批',NOW(),'admin',NOW(),'admin');

INSERT IGNORE INTO `sp_workflow_definition`
(`id`,`model_id`,`category_id`,`definition_code`,`definition_name`,`business_type`,`version_no`,`node_json`,`status`,`publish_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('wf_def_order_approval_v1','wf_model_order_approval','wf_cat_prod','order_approval','生产订单审批流程','ORDER_APPROVAL',1,@wf_oa_json,'active','2026-06-11 00:00:00','默认生产订单审批流程',NOW(),'admin',NOW(),'admin'),
('wf_def_work_order_change_v1','wf_model_work_order_change','wf_cat_prod','work_order_change','已下达工单变更审批流程','WORK_ORDER_CHANGE',1,@wf_woc_json,'active','2026-06-12 00:00:00','默认已下达工单变更审批流程',NOW(),'admin',NOW(),'admin');

-- 流程实例：2 条订单审批(已完成) + 1 条工单变更审批(运行中)
INSERT INTO `sp_workflow_instance`
(`id`,`definition_id`,`business_type`,`business_id`,`business_code`,`title`,`status`,`current_node_key`,`current_node_name`,`start_user_id`,`start_username`,`start_time`,`end_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('wfi_oa_assign','wf_def_order_approval_v1','ORDER_APPROVAL','wo_pc_assign','GD20260612001','生产订单审批-GD20260612001','completed','end','审批完成','1184009088826392578','宋鹏','2026-06-12 09:00:00','2026-06-12 10:00:00','审批通过','2026-06-12 09:00:00','admin',NOW(),'admin'),
('wfi_oa_disp','wf_def_order_approval_v1','ORDER_APPROVAL','wo_pc_disp','GD20260610001','生产订单审批-GD20260610001','completed','end','审批完成','1184009088826392578','宋鹏','2026-06-10 09:00:00','2026-06-10 10:00:00','审批通过','2026-06-10 09:00:00','admin',NOW(),'admin'),
('wfi_woc','wf_def_work_order_change_v1','WORK_ORDER_CHANGE','woc_disp','GD20260610001','已下达工单变更审批-GD20260610001','running','work_order_change_approve','工单变更审批','1184009088826392578','宋鹏','2026-06-13 12:00:00',NULL,'数量10→12审批中','2026-06-13 12:00:00','admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `definition_id`=VALUES(`definition_id`),`business_type`=VALUES(`business_type`),`business_id`=VALUES(`business_id`),`business_code`=VALUES(`business_code`),`title`=VALUES(`title`),`status`=VALUES(`status`),`current_node_key`=VALUES(`current_node_key`),`current_node_name`=VALUES(`current_node_name`),`start_username`=VALUES(`start_username`),`start_time`=VALUES(`start_time`),`end_time`=VALUES(`end_time`),`remark`=VALUES(`remark`),`update_time`=NOW();

-- 流程任务：2 条已办(订单审批) + 1 条待办(工单变更，分配给 生产主管角色)
INSERT INTO `sp_workflow_task`
(`id`,`instance_id`,`definition_id`,`business_type`,`business_id`,`business_code`,`task_name`,`node_key`,`node_name`,`assignee_type`,`assignee_id`,`assignee_name`,`status`,`action`,`opinion`,`start_time`,`complete_time`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('wft_oa_assign','wfi_oa_assign','wf_def_order_approval_v1','ORDER_APPROVAL','wo_pc_assign','GD20260612001','生产订单审批','order_approve','生产订单审批','role','productionManagerRole','生产主管','done','approve','同意，安排生产','2026-06-12 09:00:00','2026-06-12 10:00:00','2026-06-12 09:00:00','admin',NOW(),'admin'),
('wft_oa_disp','wfi_oa_disp','wf_def_order_approval_v1','ORDER_APPROVAL','wo_pc_disp','GD20260610001','生产订单审批','order_approve','生产订单审批','role','productionManagerRole','生产主管','done','approve','同意，优先排产','2026-06-10 09:00:00','2026-06-10 10:00:00','2026-06-10 09:00:00','admin',NOW(),'admin'),
('wft_woc','wfi_woc','wf_def_work_order_change_v1','WORK_ORDER_CHANGE','woc_disp','GD20260610001','工单变更审批','work_order_change_approve','工单变更审批','role','productionManagerRole','生产主管','todo',NULL,NULL,'2026-06-13 12:00:00',NULL,'2026-06-13 12:00:00','admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `instance_id`=VALUES(`instance_id`),`definition_id`=VALUES(`definition_id`),`business_type`=VALUES(`business_type`),`business_id`=VALUES(`business_id`),`business_code`=VALUES(`business_code`),`task_name`=VALUES(`task_name`),`node_key`=VALUES(`node_key`),`node_name`=VALUES(`node_name`),`assignee_type`=VALUES(`assignee_type`),`assignee_id`=VALUES(`assignee_id`),`assignee_name`=VALUES(`assignee_name`),`status`=VALUES(`status`),`action`=VALUES(`action`),`opinion`=VALUES(`opinion`),`start_time`=VALUES(`start_time`),`complete_time`=VALUES(`complete_time`),`update_time`=NOW();

-- ============================================================
-- 完成。建议执行后逐模块登录(admin)核对，或参照同名计划文件验证清单。
-- ============================================================
