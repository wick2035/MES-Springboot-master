-- ============================================================
-- 演示数据：全链路清洗与重建（台式电脑主机）
-- 日期：2026-06-08
-- 目标：
--   1) 清洗历史遗留测试数据（数字雪花ID的脏数据：工序/BOM/物料/流程/流程关系）
--   2) 围绕「台式电脑主机」装配场景，重建一套完整连贯的演示数据，
--      覆盖：部门 → 班组/员工 → 设备/编组 → 库房/库位/库存 →
--           物料 → 零部件 → BOM(含子件) → 工序 → 加工单元 →
--           工艺流程(线体) → 工艺路线(按BOM节点) → 生产订单 → SN过程采集
-- 原则：
--   * 全部使用稳定主键 + ON DUPLICATE KEY UPDATE / IF NOT EXISTS / DELETE 幂等，可重复执行
--   * 清洗仅针对「数字雪花ID」的历史脏数据，演示数据均为字母前缀ID，重复执行不被误删
--   * 不触碰系统表：用户/角色/菜单/字典（仅补充部门并回填用户部门）
-- 执行：mysql --default-character-set=utf8mb4 -u root -p sparchetype < demo-data-full-reset-20260608.sql
-- ============================================================

SET NAMES utf8mb4;

-- ============================================================
-- 0. 清洗历史脏数据（仅数字雪花ID的历史测试记录）
-- ============================================================
DELETE FROM `sp_flow_oper_relation` WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_flow`               WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_oper`               WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_bom`                WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_materile`           WHERE `id` REGEXP '^[0-9]+$';
-- 历史脏的班组/编组/单元关系/订单（均为数字雪花ID的早期测试记录）
DELETE FROM `sp_processing_unit_team`    WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_team_employee`           WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_team`                    WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_equipment_group_device`  WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_equipment_group`         WHERE `id` REGEXP '^[0-9]+$';
DELETE FROM `sp_order`                   WHERE `id` REGEXP '^[0-9]+$';
-- 库存全量重建（下方重新插入演示库存）
DELETE FROM `sp_inventory`;
-- 工艺路线/内容/关系按演示BOM重建（仅清理演示树，避免误删用户其它BOM工艺）
DELETE FROM `sp_process_content`        WHERE `route_id`  LIKE 'pr\_%';
DELETE FROM `sp_process_equipment_rel`  WHERE `route_id`  LIKE 'pr\_%';
DELETE FROM `sp_process_material_rel`   WHERE `route_id`  LIKE 'pr\_%';
DELETE FROM `sp_process_route`          WHERE `bom_id` = 'bom_pc_host';
-- 订单/SN采集演示数据重建
DELETE FROM `sp_sn_process_record` WHERE `id` LIKE 'sn\_pc\_%';
DELETE FROM `sp_order`             WHERE `id` LIKE 'ord\_pc\_%';

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

-- 回填演示用户部门归属（仅更新部门字段，不影响登录）
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
-- 3. 设备（sp_equipment，对齐电脑装配场景） + 编组（sp_equipment_group / device）
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
-- 4. 库房 / 库位（保留既有零件库 KF001，新增产品库 CP001）
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
-- 5. 物料（保留台式电脑主机 9 条；为成品绑定装配流程）
--    清洗已删除历史脏物料；此处补充确保演示物料存在并刷新关键字段
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
--     生产顺序：主板装配 → 机箱组装 → 主机装配 → 整机测试 → 包装入库
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
--     树结构对齐 SpProcessRouteServiceImpl.initRoutes：根=NGY_3_<materielCode>
-- ============================================================
INSERT INTO `sp_process_route`
(`id`,`bom_id`,`bom_item_id`,`route_code`,`parent_route_id`,`node_name`,`materiel_code`,`oper_id`,`seq_no`,`lock_status`,`edit_status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('pr_root','bom_pc_host',NULL,                       'NGY_3_PC_HOST',        NULL,    '台式电脑主机',     'PC_HOST',       'op_gx000011',30,'locked','completed','0',NOW(),'admin',NOW(),'admin'),
('pr_half','bom_pc_host','bom_item_host_half',       'NGY_3_PC_HOST_001',    'pr_root','台式电脑主机半成品','PC_HOST_HALF','op_gx000008',30,'locked','completed','0',NOW(),'admin',NOW(),'admin'),
('pr_main','bom_pc_host','bom_item_half_mainboard',  'NGY_3_PC_HOST_001_001','pr_half','主板单元',         'MAINBOARD_UNIT','op_gx000002',30,'locked','completed','0',NOW(),'admin',NOW(),'admin'),
('pr_case','bom_pc_host','bom_item_half_case',       'NGY_3_PC_HOST_001_002','pr_half','机箱单元',         'CASE_UNIT',     'op_gx000003',60,'locked','completed','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `bom_item_id`=VALUES(`bom_item_id`),`parent_route_id`=VALUES(`parent_route_id`),`node_name`=VALUES(`node_name`),`materiel_code`=VALUES(`materiel_code`),`oper_id`=VALUES(`oper_id`),`seq_no`=VALUES(`seq_no`),`lock_status`=VALUES(`lock_status`),`edit_status`=VALUES(`edit_status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- 11.1 工艺内容编制（sp_process_content）
INSERT INTO `sp_process_content` (`id`,`route_id`,`content_text`,`require_text`,`need_check`,`precaution_text`,`tech_doc_desc`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('pc_main','pr_main','在主板电路板上安装CPU、内存条，完成主板单元装配','CPU方向对位防呆，内存条卡扣到位','Y','佩戴防静电环，避免静电损伤','主板装配作业指导书',NOW(),'admin',NOW(),'admin'),
('pc_case','pr_case','将电源固定到机箱并连接供电线束，完成机箱单元组装','电源螺丝紧固到位，线束理顺','Y','注意金属边缘划伤防护','机箱组装作业指导书',NOW(),'admin',NOW(),'admin'),
('pc_half','pr_half','将主板单元与机箱单元装配并连接，产出主机半成品','接插件牢固，走线规范','Y','防止压线、漏接','主机总装作业指导书',NOW(),'admin',NOW(),'admin'),
('pc_root','pr_root','整机测试合格后进行成品包装与入库','按装箱清单核对配件','Y','轻拿轻放，标签朝外','成品包装作业指导书',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `content_text`=VALUES(`content_text`),`require_text`=VALUES(`require_text`),`need_check`=VALUES(`need_check`),`precaution_text`=VALUES(`precaution_text`),`tech_doc_desc`=VALUES(`tech_doc_desc`),`update_time`=NOW();

-- 11.2 工艺-工装设备关联（sp_process_equipment_rel）
INSERT INTO `sp_process_equipment_rel` (`id`,`route_id`,`equipment_id`,`req_qty`,`remark`,`create_time`,`create_username`) VALUES
('per_main_1','pr_main','eq_002',1,'主板测试夹具',NOW(),'admin'),
('per_main_2','pr_main','eq_005',2,'防静电环',    NOW(),'admin'),
('per_case_1','pr_case','eq_004',2,'防静电手指套',NOW(),'admin'),
('per_half_1','pr_half','eq_005',2,'防静电环',    NOW(),'admin'),
('per_root_1','pr_root','eq_003',1,'整机老化测试台',NOW(),'admin'),
('per_root_2','pr_root','eq_001',1,'物料周转车',  NOW(),'admin')
ON DUPLICATE KEY UPDATE `equipment_id`=VALUES(`equipment_id`),`req_qty`=VALUES(`req_qty`),`remark`=VALUES(`remark`);

-- 11.3 工艺-备料清单（sp_process_material_rel，与BOM子件一致）
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
-- 12. 库存（sp_inventory）：零件入零件库 KF001，半成品/组件/成品入产品库 CP001
-- ============================================================
INSERT INTO `sp_inventory` (`id`,`warehouse_id`,`location_id`,`materiel_id`,`batch_no`,`qty`,`unit`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
-- 零件库 KF001（既有库位ID）
('inv_pcb',  '2062753868678729730','2062753868741644290','mat_pcb',        'B20260601',500.0000,'件','0',NOW(),'admin',NOW(),'admin'),
('inv_cpu',  '2062753868678729730','2062753868741644291','mat_cpu',        'B20260601',300.0000,'颗','0',NOW(),'admin',NOW(),'admin'),
('inv_ram',  '2062753868678729730','2062753868741644292','mat_ram',        'B20260601',400.0000,'条','0',NOW(),'admin',NOW(),'admin'),
('inv_power','2062753868678729730','2062753868741644293','mat_power',      'B20260601',200.0000,'件','0',NOW(),'admin',NOW(),'admin'),
('inv_case', '2062753868678729730','2062753868741644294','mat_case',       'B20260601',150.0000,'件','0',NOW(),'admin',NOW(),'admin'),
-- 产品库 CP001
('inv_main_unit','cp_wh_001','cp_loc_001','mat_mainboard_unit','B20260605', 80.0000,'件','0',NOW(),'admin',NOW(),'admin'),
('inv_case_unit','cp_wh_001','cp_loc_002','mat_case_unit',     'B20260605', 60.0000,'件','0',NOW(),'admin',NOW(),'admin'),
('inv_half',     'cp_wh_001','cp_loc_003','mat_pc_host_half',  'B20260606', 30.0000,'台','0',NOW(),'admin',NOW(),'admin'),
('inv_fg',       'cp_wh_001','cp_loc_004','mat_pc_host',       'B20260608', 20.0000,'台','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`materiel_id`=VALUES(`materiel_id`),`batch_no`=VALUES(`batch_no`),`qty`=VALUES(`qty`),`unit`=VALUES(`unit`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 13. 生产订单（sp_order）
--     statue：1 待审批 / 2 已审批 / 3 结束 / 4 终结
-- ============================================================
INSERT INTO `sp_order`
(`id`,`order_code`,`order_description`,`qty`,`order_type`,`flow_id`,`materiel`,`materiel_desc`,`plan_start_time`,`plan_end_time`,`statue`,`designer_id`,`designer_name`,`approve_user_id`,`approve_username`,`approve_time`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('ord_pc_001','DD20260601001','台式电脑主机量产工单',100,'P','flow_pc_host','PC_HOST','台式电脑主机','2026-06-01','2026-06-10',2,'1184009088826392578','宋鹏','1184019107907227649','超级管理员','2026-06-01 09:00:00',NOW(),'admin',NOW(),'admin'),
('ord_pc_002','DD20260605001','台式电脑主机试产工单', 50,'A','flow_pc_host','PC_HOST','台式电脑主机','2026-06-06','2026-06-12',1,'1184009088826392578','宋鹏',NULL,NULL,NULL,NOW(),'admin',NOW(),'admin'),
('ord_pc_003','DD20260608001','台式电脑主机返工工单', 10,'F','flow_pc_host','PC_HOST','台式电脑主机','2026-06-08','2026-06-11',2,'1184009088826392578','宋鹏','1184019107907227649','超级管理员','2026-06-08 10:30:00',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_description`=VALUES(`order_description`),`qty`=VALUES(`qty`),`order_type`=VALUES(`order_type`),`flow_id`=VALUES(`flow_id`),`materiel`=VALUES(`materiel`),`materiel_desc`=VALUES(`materiel_desc`),`plan_start_time`=VALUES(`plan_start_time`),`plan_end_time`=VALUES(`plan_end_time`),`statue`=VALUES(`statue`),`designer_id`=VALUES(`designer_id`),`designer_name`=VALUES(`designer_name`),`approve_user_id`=VALUES(`approve_user_id`),`approve_username`=VALUES(`approve_username`),`approve_time`=VALUES(`approve_time`),`update_time`=NOW();

-- ============================================================
-- 14. SN 过程采集（sp_sn_process_record）：已审批量产工单 ord_pc_001
--     SN001/002 全流程OK；SN003 测试NG（终止于测试工序）
-- ============================================================
INSERT INTO `sp_sn_process_record`
(`id`,`sn`,`order_id`,`order_code`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`step_no`,`status`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
-- SN001 全流程OK
('sn_pc_0101','PC2026060100001','ord_pc_001','DD20260601001','flow_pc_host','op_gx000002','GX000002','主板装配作业工序',1,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0102','PC2026060100001','ord_pc_001','DD20260601001','flow_pc_host','op_gx000003','GX000003','机箱组装作业工序',2,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0103','PC2026060100001','ord_pc_001','DD20260601001','flow_pc_host','op_gx000008','GX000008','主机装配作业',    3,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0104','PC2026060100001','ord_pc_001','DD20260601001','flow_pc_host','op_gx000010','GX000010','整机测试作业',    4,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0105','PC2026060100001','ord_pc_001','DD20260601001','flow_pc_host','op_gx000011','GX000011','包装入库作业',    5,'OK','',NOW(),'admin',NOW(),'admin'),
-- SN002 全流程OK
('sn_pc_0201','PC2026060100002','ord_pc_001','DD20260601001','flow_pc_host','op_gx000002','GX000002','主板装配作业工序',1,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0202','PC2026060100002','ord_pc_001','DD20260601001','flow_pc_host','op_gx000003','GX000003','机箱组装作业工序',2,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0203','PC2026060100002','ord_pc_001','DD20260601001','flow_pc_host','op_gx000008','GX000008','主机装配作业',    3,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0204','PC2026060100002','ord_pc_001','DD20260601001','flow_pc_host','op_gx000010','GX000010','整机测试作业',    4,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0205','PC2026060100002','ord_pc_001','DD20260601001','flow_pc_host','op_gx000011','GX000011','包装入库作业',    5,'OK','',NOW(),'admin',NOW(),'admin'),
-- SN003 测试NG
('sn_pc_0301','PC2026060100003','ord_pc_001','DD20260601001','flow_pc_host','op_gx000002','GX000002','主板装配作业工序',1,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0302','PC2026060100003','ord_pc_001','DD20260601001','flow_pc_host','op_gx000003','GX000003','机箱组装作业工序',2,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0303','PC2026060100003','ord_pc_001','DD20260601001','flow_pc_host','op_gx000008','GX000008','主机装配作业',    3,'OK','',NOW(),'admin',NOW(),'admin'),
('sn_pc_0304','PC2026060100003','ord_pc_001','DD20260601001','flow_pc_host','op_gx000010','GX000010','整机测试作业',    4,'NG','开机无显示，主板返修',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`step_no`=VALUES(`step_no`),`status`=VALUES(`status`),`remark`=VALUES(`remark`),`update_time`=NOW();

-- ============================================================
-- 完成。验证建议见脚本同目录说明，或直接登录系统逐模块查看。
-- ============================================================
