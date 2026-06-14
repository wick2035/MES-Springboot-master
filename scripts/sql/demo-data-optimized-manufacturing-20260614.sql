-- ============================================================
-- Demo data: optimized manufacturing walkthrough
-- Date: 2026-06-14
--
-- What this script provides:
--   1) One complete started manufacturing flow for DPC_HOST.
--      BOMs are locked/pass/有效, process routes are locked/completed,
--      the production order is approved, assigned, dispatched, and started.
--   2) One ASSIGNED-stage DPC_HOST order (approved + equipment/staff assigned,
--      work order statue=2, MRP net=0). It stops before dispatch so the
--      equipment-dispatch / employee-dispatch / plan-release pages are not empty
--      (those queues exclude DISPATCHED orders, so the order in 1) cannot fill them).
--   3) One complete master-data flow for IOT_TERMINAL whose BOM is still draft.
--      No work order, MRP, warehouse execution, or SN data is fabricated for it.
--
-- Precondition:
--   Run the schema upgrade scripts through the 2026-06-13 generation first.
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 0. Clean only this demo dataset.
-- ============================================================
DELETE FROM `sp_workflow_event_log` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_workflow_task` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_workflow_instance` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_warehouse_transaction` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_warehouse_request_allocation` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_warehouse_request_item` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_warehouse_request` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_material_inbound_request_item` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_material_inbound_request` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_material_requirement_plan` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_sn_process_record` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_order_oper_assign` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_order_oper_equipment_assign` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_production_order_oper_plan` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_production_order_item` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_production_order` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_order` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_inventory` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_process_material_rel` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_process_equipment_rel` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_process_content` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_process_route` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_flow_oper_relation` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_flow` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_oper` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_processing_unit_team` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_processing_unit` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_equipment_group_device` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_equipment_group` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_equipment` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_team_employee` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_team` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_warehouse_location` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_warehouse` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_bom_item` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_bom` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_component_def` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_materile` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_sys_user_role` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_sys_user` WHERE `id` LIKE 'demo_user\_%';
DELETE FROM `sp_sys_department` WHERE `id` LIKE 'demo_dept\_%';

-- ============================================================
-- 1. Organization and users.
-- Password plaintext for all demo users: 123456
-- Hash algorithm: Shiro Md5Hash(password, username, 3).
-- ============================================================
INSERT INTO `sp_sys_department`
(`id`,`parent_id`,`name`,`sort_num`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_dept_mfg','0','演示制造中心',10,'0',NOW(),'admin',NOW(),'admin'),
('demo_dept_tech','demo_dept_mfg','演示工艺部',10,'0',NOW(),'admin',NOW(),'admin'),
('demo_dept_plan','demo_dept_mfg','演示计划部',20,'0',NOW(),'admin',NOW(),'admin'),
('demo_dept_prod','demo_dept_mfg','演示生产部',30,'0',NOW(),'admin',NOW(),'admin'),
('demo_dept_wh','demo_dept_mfg','演示仓储部',40,'0',NOW(),'admin',NOW(),'admin'),
('demo_dept_qc','demo_dept_mfg','演示质量部',50,'0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `parent_id`=VALUES(`parent_id`),`name`=VALUES(`name`),`sort_num`=VALUES(`sort_num`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_sys_user`
(`id`,`name`,`username`,`password`,`dept_id`,`email`,`mobile`,`tel`,`sex`,`birthday`,`pic_id`,`id_card`,`hobby`,`province`,`city`,`district`,`street`,`street_number`,`descr`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_user_tech_01','林工艺','demo_tech_01','74d696fb7bde6536616b251aacb817eb','demo_dept_tech','demo_tech_01@example.com','13966010001','','1',NULL,'','','','江苏省','苏州市','工业园区','','','产品工艺维护','0',NOW(),'admin',NOW(),'admin'),
('demo_user_tech_02','周工艺','demo_tech_02','c8d3f27e6474d590f69aabdd26cf0fc5','demo_dept_tech','demo_tech_02@example.com','13966010002','','0',NULL,'','','','江苏省','苏州市','工业园区','','','BOM与工艺路线维护','0',NOW(),'admin',NOW(),'admin'),
('demo_user_plan_01','何计划','demo_plan_01','130f4d2a54b8cb1d30338e44b4fc2c61','demo_dept_plan','demo_plan_01@example.com','13966010003','','1',NULL,'','','','江苏省','苏州市','工业园区','','','生产计划员','0',NOW(),'admin',NOW(),'admin'),
('demo_user_plan_02','许计划','demo_plan_02','097f3cb2d7e8d6c551d72e2f3b3a36cd','demo_dept_plan','demo_plan_02@example.com','13966010004','','0',NULL,'','','','江苏省','苏州市','工业园区','','','计划排产','0',NOW(),'admin',NOW(),'admin'),
('demo_user_mgr_01','陈主管','demo_mgr_01','1f8cce526bd2dd17ccf7a48eb93622eb','demo_dept_prod','demo_mgr_01@example.com','13966010005','','1',NULL,'','','','江苏省','苏州市','工业园区','','','生产主管','0',NOW(),'admin',NOW(),'admin'),
('demo_user_mgr_02','赵主管','demo_mgr_02','f5a3245b2b80063c1636e61d03d45380','demo_dept_prod','demo_mgr_02@example.com','13966010006','','0',NULL,'','','','江苏省','苏州市','工业园区','','','现场主管','0',NOW(),'admin',NOW(),'admin'),
('demo_user_op_01','王装配','demo_op_01','81e18c64b229759babc91e02ef9c569c','demo_dept_prod','demo_op_01@example.com','13966010007','','1',NULL,'','','','江苏省','苏州市','工业园区','','','主板装配作业员','0',NOW(),'admin',NOW(),'admin'),
('demo_user_op_02','李总装','demo_op_02','cebd012c89ae56ae7be681a7c874b3b5','demo_dept_prod','demo_op_02@example.com','13966010008','','1',NULL,'','','','江苏省','苏州市','工业园区','','','总装作业员','0',NOW(),'admin',NOW(),'admin'),
('demo_user_op_03','刘测试','demo_op_03','81203ca80a7c61ec80062846fe0bfedc','demo_dept_prod','demo_op_03@example.com','13966010009','','0',NULL,'','','','江苏省','苏州市','工业园区','','','测试作业员','0',NOW(),'admin',NOW(),'admin'),
('demo_user_wh_01','吴仓储','demo_wh_01','b623fbf215ad3daac5c7956e056c79a6','demo_dept_wh','demo_wh_01@example.com','13966010010','','1',NULL,'','','','江苏省','苏州市','工业园区','','','原料仓管理员','0',NOW(),'admin',NOW(),'admin'),
('demo_user_wh_02','郑仓储','demo_wh_02','d691630dde4e27fb84169f05c01ac13e','demo_dept_wh','demo_wh_02@example.com','13966010011','','0',NULL,'','','','江苏省','苏州市','工业园区','','','成品仓管理员','0',NOW(),'admin',NOW(),'admin'),
('demo_user_qc_01','孙质检','demo_qc_01','bf0a5c3fa130127f7741674159a4916d','demo_dept_qc','demo_qc_01@example.com','13966010012','','0',NULL,'','','','江苏省','苏州市','工业园区','','','质量检验员','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`),`password`=VALUES(`password`),`dept_id`=VALUES(`dept_id`),`email`=VALUES(`email`),`mobile`=VALUES(`mobile`),`descr`=VALUES(`descr`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_tech_01','demo_user_tech_01',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='technologyRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_tech_02','demo_user_tech_02',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='technologyRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_plan_01','demo_user_plan_01',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionPlannerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_plan_02','demo_user_plan_02',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionPlannerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_mgr_01','demo_user_mgr_01',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionManagerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_mgr_02','demo_user_mgr_02',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionManagerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_op_01','demo_user_op_01',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionOperatorRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_op_02','demo_user_op_02',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionOperatorRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_op_03','demo_user_op_03',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionOperatorRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_wh_01','demo_user_wh_01',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='warehouseManagerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_wh_02','demo_user_wh_02',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='warehouseManagerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_qc_01','demo_user_qc_01',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='qualityManagerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();

-- ============================================================
-- 2. Teams, equipment, warehouses, and locations.
-- ============================================================
INSERT INTO `sp_team`
(`id`,`team_code`,`team_name`,`team_desc`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_team_board','DEMO-TM-BOARD','演示主板装配班组','负责台式电脑主板单元装配','完整制造流程','0',NOW(),'admin',NOW(),'admin'),
('demo_team_final','DEMO-TM-FINAL','演示总装测试班组','负责整机总装、测试、包装','完整制造流程','0',NOW(),'admin',NOW(),'admin'),
('demo_team_iot','DEMO-TM-IOT','演示物联终端班组','负责工业采集终端试制准备','BOM未定版流程','0',NOW(),'admin',NOW(),'admin'),
('demo_team_wh','DEMO-TM-WH','演示仓储班组','负责演示物料收发存','仓库演示','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `team_code`=VALUES(`team_code`),`team_name`=VALUES(`team_name`),`team_desc`=VALUES(`team_desc`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_team_employee`
(`id`,`team_id`,`user_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_te_board_01','demo_team_board','demo_user_op_01','主板装配主操','0',NOW(),'admin',NOW(),'admin'),
('demo_te_board_02','demo_team_board','demo_user_qc_01','主板过程检验','0',NOW(),'admin',NOW(),'admin'),
('demo_te_final_01','demo_team_final','demo_user_op_02','总装主操','0',NOW(),'admin',NOW(),'admin'),
('demo_te_final_02','demo_team_final','demo_user_op_03','功能测试主操','0',NOW(),'admin',NOW(),'admin'),
('demo_te_iot_01','demo_team_iot','demo_user_tech_02','试制工艺支持','0',NOW(),'admin',NOW(),'admin'),
('demo_te_wh_01','demo_team_wh','demo_user_wh_01','原料仓发料','0',NOW(),'admin',NOW(),'admin'),
('demo_te_wh_02','demo_team_wh','demo_user_wh_02','成品仓接收','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `team_id`=VALUES(`team_id`),`user_id`=VALUES(`user_id`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_equipment`
(`id`,`equipment_code`,`equipment_name`,`equipment_model`,`purpose`,`spec`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_eq_smt','DEMO-EQ-001','桌面贴装工作站','SMT-LITE-01','主板元件装配','ESD工作台+扭矩工具','1','0',NOW(),'admin',NOW(),'admin'),
('demo_eq_torque','DEMO-EQ-002','智能扭矩电批','TORQUE-200','机箱紧固','0.2-2.0N.m','1','0',NOW(),'admin',NOW(),'admin'),
('demo_eq_burn','DEMO-EQ-003','整机老化测试架','BURN-24H','整机老化与稳定性测试','24小时老化位','1','0',NOW(),'admin',NOW(),'admin'),
('demo_eq_pack','DEMO-EQ-004','自动贴标包装台','PACK-LABEL-01','标签打印与包装','标签+称重','1','0',NOW(),'admin',NOW(),'admin'),
('demo_eq_iot_fixture','DEMO-EQ-005','物联终端测试夹具','IOT-FIX-01','工业采集终端试制夹具','多通道采集','1','0',NOW(),'admin',NOW(),'admin'),
('demo_eq_scanner','DEMO-EQ-006','无线扫码枪','SCAN-2D','SN采集','2D barcode','1','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `equipment_code`=VALUES(`equipment_code`),`equipment_name`=VALUES(`equipment_name`),`equipment_model`=VALUES(`equipment_model`),`purpose`=VALUES(`purpose`),`spec`=VALUES(`spec`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_equipment_group`
(`id`,`group_code`,`group_name`,`group_desc`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_eg_assembly','DEMO-EG-ASM','演示装配设备组','主板、机箱、总装设备','完整制造流程','0',NOW(),'admin',NOW(),'admin'),
('demo_eg_test','DEMO-EG-TEST','演示测试包装设备组','老化测试、扫码、包装设备','完整制造流程','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `group_code`=VALUES(`group_code`),`group_name`=VALUES(`group_name`),`group_desc`=VALUES(`group_desc`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_equipment_group_device`
(`id`,`group_id`,`equipment_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_egd_smt','demo_eg_assembly','demo_eq_smt','主板装配','0',NOW(),'admin',NOW(),'admin'),
('demo_egd_torque','demo_eg_assembly','demo_eq_torque','机箱与总装紧固','0',NOW(),'admin',NOW(),'admin'),
('demo_egd_burn','demo_eg_test','demo_eq_burn','整机测试','0',NOW(),'admin',NOW(),'admin'),
('demo_egd_pack','demo_eg_test','demo_eq_pack','包装贴标','0',NOW(),'admin',NOW(),'admin'),
('demo_egd_scanner','demo_eg_test','demo_eq_scanner','SN采集','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `group_id`=VALUES(`group_id`),`equipment_id`=VALUES(`equipment_id`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse`
(`id`,`warehouse_code`,`warehouse_name`,`warehouse_type`,`warehouse_desc`,`spec_group`,`spec_row`,`spec_layer`,`spec_column`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wh_raw','DEMO-RM','演示原材料仓','1','电子件、结构件原材料仓',2,2,2,2,'完整制造流程发料仓','0',NOW(),'admin',NOW(),'admin'),
('demo_wh_line','DEMO-LINE','演示线边仓','3','产线齐套与过程周转仓',1,2,2,2,'生产线边仓','0',NOW(),'admin',NOW(),'admin'),
('demo_wh_fg','DEMO-FG','演示成品仓','2','成品与半成品仓',1,2,2,2,'成品入库仓','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `warehouse_code`=VALUES(`warehouse_code`),`warehouse_name`=VALUES(`warehouse_name`),`warehouse_type`=VALUES(`warehouse_type`),`warehouse_desc`=VALUES(`warehouse_desc`),`spec_group`=VALUES(`spec_group`),`spec_row`=VALUES(`spec_row`),`spec_layer`=VALUES(`spec_layer`),`spec_column`=VALUES(`spec_column`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_location`
(`id`,`warehouse_id`,`location_code`,`group_no`,`row_no`,`layer_no`,`column_no`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_loc_raw_01','demo_wh_raw','DEMO-RM-A-01-01-01',1,1,1,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_raw_02','demo_wh_raw','DEMO-RM-A-01-01-02',1,1,1,2,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_raw_03','demo_wh_raw','DEMO-RM-A-01-02-01',1,1,2,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_raw_04','demo_wh_raw','DEMO-RM-A-01-02-02',1,1,2,2,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_line_01','demo_wh_line','DEMO-LINE-A-01-01-01',1,1,1,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_line_02','demo_wh_line','DEMO-LINE-A-01-01-02',1,1,1,2,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_fg_01','demo_wh_fg','DEMO-FG-A-01-01-01',1,1,1,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_fg_02','demo_wh_fg','DEMO-FG-A-01-01-02',1,1,1,2,'0','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `warehouse_id`=VALUES(`warehouse_id`),`location_code`=VALUES(`location_code`),`group_no`=VALUES(`group_no`),`row_no`=VALUES(`row_no`),`layer_no`=VALUES(`layer_no`),`column_no`=VALUES(`column_no`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 3. Materials and component definitions.
-- ============================================================
INSERT INTO `sp_materile`
(`id`,`materiel`,`materiel_desc`,`unit`,`product_group`,`mat_type`,`model`,`size`,`flow_id`,`flow_desc`,`is_deleted`,`mat_source`,`texture`,`lead_time`,`safety_stock`,`image_urls`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_mat_dpc_host','DPC_HOST','台式电脑主机','台','演示台式电脑','FG','DPC-HOST-A','标准机箱','demo_flow_dpc_host','台式电脑主机完整装配流程','0','SELF','',1,5,NULL,'完整制造流程成品',NOW(),'admin',NOW(),'admin'),
('demo_mat_dpc_half','DPC_HOST_HALF','台式电脑主机半成品','台','演示台式电脑','PG','DPC-HALF-A','','demo_flow_dpc_host','主机半成品装配流程','0','SELF','',1,5,NULL,'总装前半成品',NOW(),'admin',NOW(),'admin'),
('demo_mat_dpc_board','DPC_MAINBOARD_UNIT','台式电脑主板单元','件','演示台式电脑','COMP','DPC-MB-A','','demo_flow_dpc_host','主板单元装配流程','0','SELF','',1,10,NULL,'主板组件',NOW(),'admin',NOW(),'admin'),
('demo_mat_dpc_case_unit','DPC_CASE_UNIT','台式电脑机箱单元','件','演示台式电脑','COMP','DPC-CASE-A','','demo_flow_dpc_host','机箱单元装配流程','0','SELF','',1,10,NULL,'机箱组件',NOW(),'admin',NOW(),'admin'),
('demo_mat_pcb','DPC_PCB','台式电脑主板PCB','件','演示台式电脑','PART','PCB-ATX-DEMO','','','','0','OUT','FR-4',2,20,NULL,'主板单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_cpu','DPC_CPU','台式电脑CPU','颗','演示台式电脑','PART','CPU-DEMO','','','','0','OUT','',3,20,NULL,'主板单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_ram','DPC_MEMORY','台式电脑内存条','条','演示台式电脑','PART','DDR-DEMO','','','','0','OUT','',2,20,NULL,'主板单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_ssd','DPC_SSD','台式电脑固态硬盘','块','演示台式电脑','PART','SSD-512G-DEMO','','','','0','OUT','',2,20,NULL,'主板单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_power','DPC_POWER_SUPPLY','台式电脑电源','件','演示台式电脑','PART','PSU-DEMO','','','','0','OUT','',2,10,NULL,'机箱单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_case_shell','DPC_CASE_SHELL','台式电脑机箱外壳','件','演示台式电脑','PART','CASE-DEMO','','','','0','OUT','钢板',2,10,NULL,'机箱单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_fan','DPC_COOLING_FAN','台式电脑散热风扇','件','演示台式电脑','PART','FAN-DEMO','','','','0','OUT','',2,10,NULL,'机箱单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_terminal','IOT_TERMINAL','工业采集终端','台','演示工业终端','FG','IOT-T100','','demo_flow_iot_terminal','工业采集终端试制流程','0','SELF','',4,3,NULL,'BOM未定版成品',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_control','IOT_CONTROL_UNIT','工业采集终端控制单元','件','演示工业终端','COMP','IOT-CTRL','','demo_flow_iot_terminal','控制单元试制流程','0','SELF','',3,5,NULL,'BOM未定版组件',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_shell','IOT_SHELL_UNIT','工业采集终端壳体单元','件','演示工业终端','COMP','IOT-SHELL','','demo_flow_iot_terminal','壳体单元试制流程','0','SELF','',3,5,NULL,'BOM未定版组件',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_mcu','IOT_MCU','工业采集MCU','颗','演示工业终端','PART','MCU-DEMO','','','','0','OUT','',10,20,NULL,'BOM未定版原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_sensor','IOT_SENSOR','工业采集传感器','颗','演示工业终端','PART','SENSOR-DEMO','','','','0','OUT','',7,20,NULL,'BOM未定版原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_lcd','IOT_LCD','工业终端显示屏','块','演示工业终端','PART','LCD-DEMO','','','','0','OUT','',6,10,NULL,'BOM未定版原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_shell_part','IOT_TERMINAL_SHELL','工业终端外壳','件','演示工业终端','PART','IOT-SHELL-PART','','','','0','OUT','铝合金',5,10,NULL,'BOM未定版原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_battery','IOT_BATTERY','工业终端备用电池','块','演示工业终端','PART','BAT-DEMO','','','','0','OUT','',5,10,NULL,'BOM未定版原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_wire','IOT_WIRE_HARNESS','工业终端线束','套','演示工业终端','PART','WIRE-DEMO','','','','0','OUT','铜芯',4,10,NULL,'BOM未定版原材料',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `materiel_desc`=VALUES(`materiel_desc`),`unit`=VALUES(`unit`),`product_group`=VALUES(`product_group`),`mat_type`=VALUES(`mat_type`),`model`=VALUES(`model`),`flow_id`=VALUES(`flow_id`),`flow_desc`=VALUES(`flow_desc`),`is_deleted`=VALUES(`is_deleted`),`mat_source`=VALUES(`mat_source`),`texture`=VALUES(`texture`),`lead_time`=VALUES(`lead_time`),`safety_stock`=VALUES(`safety_stock`),`remark`=VALUES(`remark`),`update_time`=NOW();

INSERT INTO `sp_component_def`
(`id`,`product_name`,`component_code`,`component_name`,`component_type`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_comp_dpc_half','台式电脑主机','DPC_HOST_HALF','台式电脑主机半成品','PG','完整制造流程半成品','0',NOW(),'admin',NOW(),'admin'),
('demo_comp_dpc_board','台式电脑主机','DPC_MAINBOARD_UNIT','台式电脑主板单元','COMP','完整制造流程主板组件','0',NOW(),'admin',NOW(),'admin'),
('demo_comp_dpc_case','台式电脑主机','DPC_CASE_UNIT','台式电脑机箱单元','COMP','完整制造流程机箱组件','0',NOW(),'admin',NOW(),'admin'),
('demo_comp_iot_control','工业采集终端','IOT_CONTROL_UNIT','工业采集终端控制单元','COMP','草稿BOM控制组件','0',NOW(),'admin',NOW(),'admin'),
('demo_comp_iot_shell','工业采集终端','IOT_SHELL_UNIT','工业采集终端壳体单元','COMP','草稿BOM壳体组件','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `product_name`=VALUES(`product_name`),`component_code`=VALUES(`component_code`),`component_name`=VALUES(`component_name`),`component_type`=VALUES(`component_type`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 4. BOMs. DPC is locked; IOT remains draft.
-- ============================================================
INSERT INTO `sp_bom`
(`id`,`bom_code`,`materiel_code`,`materiel_desc`,`remark`,`version_number`,`state`,`factory`,`is_deleted`,`bom_level`,`lock_status`,`validity`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_bom_dpc_host','BOM-DPC-HOST-V1','DPC_HOST','台式电脑主机','完整制造流程成品BOM','1','pass','center','0',0,'locked','有效',NOW(),'admin',NOW(),'admin'),
('demo_bom_dpc_half','BOM-DPC-HALF-V1','DPC_HOST_HALF','台式电脑主机半成品','完整制造流程半成品BOM','1','pass','center','0',1,'locked','有效',NOW(),'admin',NOW(),'admin'),
('demo_bom_dpc_board','BOM-DPC-BOARD-V1','DPC_MAINBOARD_UNIT','台式电脑主板单元','完整制造流程主板单元BOM','1','pass','center','0',2,'locked','有效',NOW(),'admin',NOW(),'admin'),
('demo_bom_dpc_case','BOM-DPC-CASE-V1','DPC_CASE_UNIT','台式电脑机箱单元','完整制造流程机箱单元BOM','1','pass','center','0',2,'locked','有效',NOW(),'admin',NOW(),'admin'),
('demo_bom_iot_terminal','BOM-IOT-TERMINAL-DRAFT','IOT_TERMINAL','工业采集终端','基础数据齐全，BOM未定版','0.1','creat','center','0',0,'draft','未生效',NOW(),'admin',NOW(),'admin'),
('demo_bom_iot_control','BOM-IOT-CONTROL-DRAFT','IOT_CONTROL_UNIT','工业采集终端控制单元','子BOM草稿，待工艺确认','0.1','creat','center','0',2,'draft','未生效',NOW(),'admin',NOW(),'admin'),
('demo_bom_iot_shell','BOM-IOT-SHELL-DRAFT','IOT_SHELL_UNIT','工业采集终端壳体单元','子BOM草稿，待结构确认','0.1','creat','center','0',2,'draft','未生效',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `bom_code`=VALUES(`bom_code`),`materiel_code`=VALUES(`materiel_code`),`materiel_desc`=VALUES(`materiel_desc`),`remark`=VALUES(`remark`),`version_number`=VALUES(`version_number`),`state`=VALUES(`state`),`factory`=VALUES(`factory`),`is_deleted`=VALUES(`is_deleted`),`bom_level`=VALUES(`bom_level`),`lock_status`=VALUES(`lock_status`),`validity`=VALUES(`validity`),`update_time`=NOW();

INSERT INTO `sp_bom_item`
(`id`,`bom_head_id`,`materiel_item_code`,`materiel_item_desc`,`line_no`,`item_num`,`item_unit`,`oper_typer`,`child_bom_id`,`item_mat_type`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_bom_item_dpc_host_half','demo_bom_dpc_host','DPC_HOST_HALF','台式电脑主机半成品','10',1,'台','总装','demo_bom_dpc_half','PG',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_half_board','demo_bom_dpc_half','DPC_MAINBOARD_UNIT','台式电脑主板单元','10',1,'件','主板装配','demo_bom_dpc_board','COMP',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_half_case','demo_bom_dpc_half','DPC_CASE_UNIT','台式电脑机箱单元','20',1,'件','机箱装配','demo_bom_dpc_case','COMP',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_pcb','demo_bom_dpc_board','DPC_PCB','台式电脑主板PCB','10',1,'件','主板装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_cpu','demo_bom_dpc_board','DPC_CPU','台式电脑CPU','20',1,'颗','主板装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_ram','demo_bom_dpc_board','DPC_MEMORY','台式电脑内存条','30',1,'条','主板装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_ssd','demo_bom_dpc_board','DPC_SSD','台式电脑固态硬盘','40',1,'块','主板装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_power','demo_bom_dpc_case','DPC_POWER_SUPPLY','台式电脑电源','10',1,'件','机箱装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_shell','demo_bom_dpc_case','DPC_CASE_SHELL','台式电脑机箱外壳','20',1,'件','机箱装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_fan','demo_bom_dpc_case','DPC_COOLING_FAN','台式电脑散热风扇','30',1,'件','机箱装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_control','demo_bom_iot_terminal','IOT_CONTROL_UNIT','工业采集终端控制单元','10',1,'件','控制单元试制','demo_bom_iot_control','COMP',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_shell','demo_bom_iot_terminal','IOT_SHELL_UNIT','工业采集终端壳体单元','20',1,'件','壳体试制','demo_bom_iot_shell','COMP',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_mcu','demo_bom_iot_control','IOT_MCU','工业采集MCU','10',1,'颗','控制板试制',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_sensor','demo_bom_iot_control','IOT_SENSOR','工业采集传感器','20',2,'颗','控制板试制',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_lcd','demo_bom_iot_control','IOT_LCD','工业终端显示屏','30',1,'块','控制板试制',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_shell_part','demo_bom_iot_shell','IOT_TERMINAL_SHELL','工业终端外壳','10',1,'件','壳体试制',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_battery','demo_bom_iot_shell','IOT_BATTERY','工业终端备用电池','20',1,'块','壳体试制',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_wire','demo_bom_iot_shell','IOT_WIRE_HARNESS','工业终端线束','30',1,'套','壳体试制',NULL,'PART',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `bom_head_id`=VALUES(`bom_head_id`),`materiel_item_code`=VALUES(`materiel_item_code`),`materiel_item_desc`=VALUES(`materiel_item_desc`),`line_no`=VALUES(`line_no`),`item_num`=VALUES(`item_num`),`item_unit`=VALUES(`item_unit`),`oper_typer`=VALUES(`oper_typer`),`child_bom_id`=VALUES(`child_bom_id`),`item_mat_type`=VALUES(`item_mat_type`),`update_time`=NOW();

-- ============================================================
-- 5. Processing units, operations, and flows.
-- ============================================================
INSERT INTO `sp_processing_unit`
(`id`,`unit_code`,`unit_name`,`unit_type`,`description`,`std_capacity`,`has_edge_warehouse`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_unit_board','DEMO-U-BOARD','演示主板装配单元','staff','主板元件装配与自检',20,1,'1','0',NOW(),'admin',NOW(),'admin'),
('demo_unit_case','DEMO-U-CASE','演示机箱装配单元','staff','机箱、电源、风扇装配',20,1,'1','0',NOW(),'admin',NOW(),'admin'),
('demo_unit_final','DEMO-U-FINAL','演示整机总装单元','staff','主板单元与机箱单元总装',20,1,'1','0',NOW(),'admin',NOW(),'admin'),
('demo_unit_test','DEMO-U-TEST','演示整机测试单元','device','整机老化与功能测试',20,1,'1','0',NOW(),'admin',NOW(),'admin'),
('demo_unit_pack','DEMO-U-PACK','演示包装入库单元','staff','包装贴标与成品入库',20,1,'1','0',NOW(),'admin',NOW(),'admin'),
('demo_unit_iot','DEMO-U-IOT','演示工业终端试制单元','staff','工业采集终端草稿BOM试制准备',10,1,'1','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `unit_code`=VALUES(`unit_code`),`unit_name`=VALUES(`unit_name`),`unit_type`=VALUES(`unit_type`),`description`=VALUES(`description`),`std_capacity`=VALUES(`std_capacity`),`has_edge_warehouse`=VALUES(`has_edge_warehouse`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_processing_unit_team`
(`id`,`unit_id`,`team_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_put_board','demo_unit_board','demo_team_board','主板装配单元对应班组','0',NOW(),'admin',NOW(),'admin'),
('demo_put_case','demo_unit_case','demo_team_final','机箱装配由总装班组负责','0',NOW(),'admin',NOW(),'admin'),
('demo_put_final','demo_unit_final','demo_team_final','整机总装单元对应班组','0',NOW(),'admin',NOW(),'admin'),
('demo_put_test','demo_unit_test','demo_team_final','测试单元对应班组','0',NOW(),'admin',NOW(),'admin'),
('demo_put_pack','demo_unit_pack','demo_team_wh','包装入库协同仓储班组','0',NOW(),'admin',NOW(),'admin'),
('demo_put_iot','demo_unit_iot','demo_team_iot','工业终端试制班组','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `unit_id`=VALUES(`unit_id`),`team_id`=VALUES(`team_id`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_oper`
(`id`,`oper`,`oper_desc`,`unit_id`,`oper_hours`,`manu_cycle`,`gen_plan`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_op_dpc_board','DPC-OP-010','主板单元装配','demo_unit_board',1.50,2.00,'Y','完整流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_dpc_case','DPC-OP-020','机箱单元装配','demo_unit_case',1.00,1.50,'Y','完整流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_dpc_final','DPC-OP-030','整机总装','demo_unit_final',1.20,1.50,'Y','完整流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_dpc_test','DPC-OP-040','整机老化测试','demo_unit_test',2.00,2.50,'Y','完整流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_dpc_pack','DPC-OP-050','包装入库','demo_unit_pack',0.60,1.00,'Y','完整流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_iot_control','IOT-OP-010','控制单元试制','demo_unit_iot',2.00,3.00,'Y','BOM未定版流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_iot_shell','IOT-OP-020','壳体单元试制','demo_unit_iot',1.50,2.00,'Y','BOM未定版流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_iot_test','IOT-OP-030','整机联调试制','demo_unit_iot',2.50,3.00,'Y','BOM未定版流程工序',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`unit_id`=VALUES(`unit_id`),`oper_hours`=VALUES(`oper_hours`),`manu_cycle`=VALUES(`manu_cycle`),`gen_plan`=VALUES(`gen_plan`),`remark`=VALUES(`remark`),`update_time`=NOW();

INSERT INTO `sp_flow`
(`id`,`flow`,`flow_desc`,`process`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_flow_dpc_host','DPC-FLOW-001','台式电脑主机完整装配流程','主板单元装配->机箱单元装配->整机总装->整机老化测试->包装入库',NOW(),'admin',NOW(),'admin'),
('demo_flow_iot_terminal','IOT-FLOW-DRAFT','工业采集终端试制流程','控制单元试制->壳体单元试制->整机联调试制',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `flow`=VALUES(`flow`),`flow_desc`=VALUES(`flow_desc`),`process`=VALUES(`process`),`update_time`=NOW();

INSERT INTO `sp_flow_oper_relation`
(`id`,`flow_id`,`flow`,`per_oper_id`,`per_oper`,`oper_id`,`oper`,`next_oper_id`,`next_oper`,`sort_num`,`oper_type`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_for_dpc_010','demo_flow_dpc_host','DPC-FLOW-001',NULL,NULL,'demo_op_dpc_board','DPC-OP-010','demo_op_dpc_case','DPC-OP-020',10,'firstOper',NOW(),'admin',NOW(),'admin'),
('demo_for_dpc_020','demo_flow_dpc_host','DPC-FLOW-001','demo_op_dpc_board','DPC-OP-010','demo_op_dpc_case','DPC-OP-020','demo_op_dpc_final','DPC-OP-030',20,NULL,NOW(),'admin',NOW(),'admin'),
('demo_for_dpc_030','demo_flow_dpc_host','DPC-FLOW-001','demo_op_dpc_case','DPC-OP-020','demo_op_dpc_final','DPC-OP-030','demo_op_dpc_test','DPC-OP-040',30,NULL,NOW(),'admin',NOW(),'admin'),
('demo_for_dpc_040','demo_flow_dpc_host','DPC-FLOW-001','demo_op_dpc_final','DPC-OP-030','demo_op_dpc_test','DPC-OP-040','demo_op_dpc_pack','DPC-OP-050',40,NULL,NOW(),'admin',NOW(),'admin'),
('demo_for_dpc_050','demo_flow_dpc_host','DPC-FLOW-001','demo_op_dpc_test','DPC-OP-040','demo_op_dpc_pack','DPC-OP-050',NULL,NULL,50,'lastOper',NOW(),'admin',NOW(),'admin'),
('demo_for_iot_010','demo_flow_iot_terminal','IOT-FLOW-DRAFT',NULL,NULL,'demo_op_iot_control','IOT-OP-010','demo_op_iot_shell','IOT-OP-020',10,'firstOper',NOW(),'admin',NOW(),'admin'),
('demo_for_iot_020','demo_flow_iot_terminal','IOT-FLOW-DRAFT','demo_op_iot_control','IOT-OP-010','demo_op_iot_shell','IOT-OP-020','demo_op_iot_test','IOT-OP-030',20,NULL,NOW(),'admin',NOW(),'admin'),
('demo_for_iot_030','demo_flow_iot_terminal','IOT-FLOW-DRAFT','demo_op_iot_shell','IOT-OP-020','demo_op_iot_test','IOT-OP-030',NULL,NULL,30,'lastOper',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `flow_id`=VALUES(`flow_id`),`flow`=VALUES(`flow`),`per_oper_id`=VALUES(`per_oper_id`),`per_oper`=VALUES(`per_oper`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`next_oper_id`=VALUES(`next_oper_id`),`next_oper`=VALUES(`next_oper`),`sort_num`=VALUES(`sort_num`),`oper_type`=VALUES(`oper_type`),`update_time`=NOW();

-- ============================================================
-- 6. Locked DPC process route and work instructions.
-- No IOT process route is inserted because its BOM is not locked.
-- ============================================================
INSERT INTO `sp_process_route`
(`id`,`bom_id`,`bom_item_id`,`route_code`,`parent_route_id`,`node_name`,`materiel_code`,`oper_id`,`seq_no`,`lock_status`,`edit_status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_route_dpc_root','demo_bom_dpc_host',NULL,'NGY_3_DPC_HOST',NULL,'台式电脑主机','DPC_HOST','demo_op_dpc_pack',50,'locked','completed','0',NOW(),'admin',NOW(),'admin'),
('demo_route_dpc_half','demo_bom_dpc_host','demo_bom_item_dpc_host_half','NGY_3_DPC_HOST_001','demo_route_dpc_root','台式电脑主机半成品','DPC_HOST_HALF','demo_op_dpc_final',30,'locked','completed','0',NOW(),'admin',NOW(),'admin'),
('demo_route_dpc_board','demo_bom_dpc_host','demo_bom_item_dpc_half_board','NGY_3_DPC_HOST_001_001','demo_route_dpc_half','台式电脑主板单元','DPC_MAINBOARD_UNIT','demo_op_dpc_board',10,'locked','completed','0',NOW(),'admin',NOW(),'admin'),
('demo_route_dpc_case','demo_bom_dpc_host','demo_bom_item_dpc_half_case','NGY_3_DPC_HOST_001_002','demo_route_dpc_half','台式电脑机箱单元','DPC_CASE_UNIT','demo_op_dpc_case',20,'locked','completed','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `bom_id`=VALUES(`bom_id`),`bom_item_id`=VALUES(`bom_item_id`),`route_code`=VALUES(`route_code`),`parent_route_id`=VALUES(`parent_route_id`),`node_name`=VALUES(`node_name`),`materiel_code`=VALUES(`materiel_code`),`oper_id`=VALUES(`oper_id`),`seq_no`=VALUES(`seq_no`),`lock_status`=VALUES(`lock_status`),`edit_status`=VALUES(`edit_status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_process_content`
(`id`,`route_id`,`content_text`,`require_text`,`need_check`,`precaution_text`,`tech_doc_desc`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_pc_board','demo_route_dpc_board','装配PCB、CPU、内存、SSD并完成目检。','ESD防护到位，CPU针脚无弯曲，内存卡扣闭合。','Y','禁止裸手接触金手指。','DPC-SOP-010 主板单元装配作业指导书',NOW(),'admin',NOW(),'admin'),
('demo_pc_case','demo_route_dpc_case','安装电源、机箱外壳与散热风扇。','电源线束固定，风扇方向正确。','Y','扭矩按工艺卡执行。','DPC-SOP-020 机箱单元装配作业指导书',NOW(),'admin',NOW(),'admin'),
('demo_pc_half','demo_route_dpc_half','将主板单元装入机箱单元并接线。','线束不压伤，接口全部插紧。','Y','走线避开风扇叶片。','DPC-SOP-030 整机总装作业指导书',NOW(),'admin',NOW(),'admin'),
('demo_pc_root','demo_route_dpc_root','完成老化、贴标、包装、入库确认。','SN标签一致，包装附件齐套。','Y','老化不合格不得入库。','DPC-SOP-050 包装入库作业指导书',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `route_id`=VALUES(`route_id`),`content_text`=VALUES(`content_text`),`require_text`=VALUES(`require_text`),`need_check`=VALUES(`need_check`),`precaution_text`=VALUES(`precaution_text`),`tech_doc_desc`=VALUES(`tech_doc_desc`),`update_time`=NOW();

INSERT INTO `sp_process_equipment_rel`
(`id`,`route_id`,`equipment_id`,`req_qty`,`remark`,`create_time`,`create_username`) VALUES
('demo_per_board_smt','demo_route_dpc_board','demo_eq_smt',1,'主板装配工作站',NOW(),'admin'),
('demo_per_case_torque','demo_route_dpc_case','demo_eq_torque',1,'机箱装配扭矩工具',NOW(),'admin'),
('demo_per_half_torque','demo_route_dpc_half','demo_eq_torque',1,'整机总装扭矩工具',NOW(),'admin'),
('demo_per_root_burn','demo_route_dpc_root','demo_eq_burn',1,'整机老化测试架',NOW(),'admin'),
('demo_per_root_pack','demo_route_dpc_root','demo_eq_pack',1,'包装贴标设备',NOW(),'admin')
ON DUPLICATE KEY UPDATE `route_id`=VALUES(`route_id`),`equipment_id`=VALUES(`equipment_id`),`req_qty`=VALUES(`req_qty`),`remark`=VALUES(`remark`);

INSERT INTO `sp_process_material_rel`
(`id`,`route_id`,`materiel_id`,`req_qty`,`remark`,`create_time`,`create_username`) VALUES
('demo_pmr_board_pcb','demo_route_dpc_board','demo_mat_pcb',1,'主板PCB',NOW(),'admin'),
('demo_pmr_board_cpu','demo_route_dpc_board','demo_mat_cpu',1,'CPU',NOW(),'admin'),
('demo_pmr_board_ram','demo_route_dpc_board','demo_mat_ram',1,'内存条',NOW(),'admin'),
('demo_pmr_board_ssd','demo_route_dpc_board','demo_mat_ssd',1,'固态硬盘',NOW(),'admin'),
('demo_pmr_case_power','demo_route_dpc_case','demo_mat_power',1,'电源',NOW(),'admin'),
('demo_pmr_case_shell','demo_route_dpc_case','demo_mat_case_shell',1,'机箱外壳',NOW(),'admin'),
('demo_pmr_case_fan','demo_route_dpc_case','demo_mat_fan',1,'散热风扇',NOW(),'admin')
ON DUPLICATE KEY UPDATE `route_id`=VALUES(`route_id`),`materiel_id`=VALUES(`materiel_id`),`req_qty`=VALUES(`req_qty`),`remark`=VALUES(`remark`);

-- ============================================================
-- 7. Inventory after confirmed kitting-out for DPC order.
-- Before issuing, each DPC raw material had 120 units. The order issued 20.
-- ============================================================
INSERT INTO `sp_inventory`
(`id`,`warehouse_id`,`location_id`,`materiel_id`,`batch_no`,`qty`,`unit`,`stock_status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_inv_pcb','demo_wh_raw','demo_loc_raw_01','demo_mat_pcb','DPC-RM-20260601',100.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_cpu','demo_wh_raw','demo_loc_raw_01','demo_mat_cpu','DPC-RM-20260601',100.0000,'颗','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_ram','demo_wh_raw','demo_loc_raw_02','demo_mat_ram','DPC-RM-20260601',100.0000,'条','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_ssd','demo_wh_raw','demo_loc_raw_02','demo_mat_ssd','DPC-RM-20260601',100.0000,'块','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_power','demo_wh_raw','demo_loc_raw_03','demo_mat_power','DPC-RM-20260601',100.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_case_shell','demo_wh_raw','demo_loc_raw_03','demo_mat_case_shell','DPC-RM-20260601',100.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_fan','demo_wh_raw','demo_loc_raw_04','demo_mat_fan','DPC-RM-20260601',100.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_iot_mcu','demo_wh_raw','demo_loc_raw_04','demo_mat_iot_mcu','IOT-RM-20260601',50.0000,'颗','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_iot_sensor','demo_wh_raw','demo_loc_raw_04','demo_mat_iot_sensor','IOT-RM-20260601',80.0000,'颗','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_iot_shell','demo_wh_raw','demo_loc_raw_03','demo_mat_iot_shell_part','IOT-RM-20260601',40.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_dpc_finished','demo_wh_fg','demo_loc_fg_01','demo_mat_dpc_host','DPC-FG-20260614',20.0000,'台','AVAILABLE','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`materiel_id`=VALUES(`materiel_id`),`batch_no`=VALUES(`batch_no`),`qty`=VALUES(`qty`),`unit`=VALUES(`unit`),`stock_status`=VALUES(`stock_status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 8. Production order: DPC complete/started, IOT draft only.
-- ============================================================
INSERT INTO `sp_production_order`
(`id`,`order_no`,`source_type`,`customer_name`,`customer_group`,`external_no`,`sales_contract_no`,`business_type`,`order_date`,`settlement_currency`,`transport_mode`,`payment_terms`,`tax_rate`,`receiver_name`,`receiver_phone`,`receiver_address`,`remark`,`status`,`approval_status`,`operation_status`,`creation_method`,`scheduling_method`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_po_dpc','DD-DEMO-20260614-001','DEMAND','演示客户-华东智造','华东大客户','EXT-DEMO-DPC-001','HT-DEMO-DPC-001','普通销售','2026-06-14','人民币','公路运输','月结30天','不含税','王采购','13866010001','上海市浦东新区演示路1号','完整制造流程：已审批、已派工、已下发、已开工','CONFIRMED','APPROVED','DISPATCHED','MANUAL','REVERSE','0',NOW(),'admin',NOW(),'admin'),
('demo_po_iot','DD-DEMO-20260614-002','DEMAND','演示客户-北方能源','能源行业客户','EXT-DEMO-IOT-001','HT-DEMO-IOT-001','试制订单','2026-06-14','人民币','公路运输','预付30%','不含税','李采购','13866010002','北京市海淀区演示路2号','基础数据齐全，但BOM未定版；仅演示草稿录入','DRAFT','DRAFT','NONE','MANUAL','REVERSE','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `customer_name`=VALUES(`customer_name`),`customer_group`=VALUES(`customer_group`),`external_no`=VALUES(`external_no`),`sales_contract_no`=VALUES(`sales_contract_no`),`business_type`=VALUES(`business_type`),`order_date`=VALUES(`order_date`),`remark`=VALUES(`remark`),`status`=VALUES(`status`),`approval_status`=VALUES(`approval_status`),`operation_status`=VALUES(`operation_status`),`creation_method`=VALUES(`creation_method`),`scheduling_method`=VALUES(`scheduling_method`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order`
(`id`,`order_code`,`order_description`,`qty`,`order_type`,`flow_id`,`materiel`,`materiel_desc`,`plan_start_time`,`plan_end_time`,`statue`,`designer_id`,`designer_name`,`approve_user_id`,`approve_username`,`approve_time`,`remark`,`work_status`,`work_start_time`,`complete_status`,`complete_time`,`complete_username`,`delivery_status`,`delivery_time`,`delivery_username`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wo_dpc','GD-DEMO-20260614-001','DD-DEMO-20260614-001 / 台式电脑主机',20,'P','demo_flow_dpc_host','DPC_HOST','台式电脑主机','2026-06-14 08:00:00','2026-06-18 17:00:00',5,'demo_user_plan_01','何计划','demo_user_mgr_01','陈主管','2026-06-14 09:00:00','DPC complete workflow: dispatched, started, completed and delivered','STARTED','2026-06-14 10:00:00','COMPLETED','2026-06-18 17:10:00','demo_wh_02','DELIVERED','2026-06-18 17:30:00','demo_wh_02',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_code`=VALUES(`order_code`),`order_description`=VALUES(`order_description`),`qty`=VALUES(`qty`),`order_type`=VALUES(`order_type`),`flow_id`=VALUES(`flow_id`),`materiel`=VALUES(`materiel`),`materiel_desc`=VALUES(`materiel_desc`),`plan_start_time`=VALUES(`plan_start_time`),`plan_end_time`=VALUES(`plan_end_time`),`statue`=VALUES(`statue`),`designer_id`=VALUES(`designer_id`),`designer_name`=VALUES(`designer_name`),`approve_user_id`=VALUES(`approve_user_id`),`approve_username`=VALUES(`approve_username`),`approve_time`=VALUES(`approve_time`),`remark`=VALUES(`remark`),`work_status`=VALUES(`work_status`),`work_start_time`=VALUES(`work_start_time`),`complete_status`=VALUES(`complete_status`),`complete_time`=VALUES(`complete_time`),`complete_username`=VALUES(`complete_username`),`delivery_status`=VALUES(`delivery_status`),`delivery_time`=VALUES(`delivery_time`),`delivery_username`=VALUES(`delivery_username`),`update_time`=NOW();

INSERT INTO `sp_production_order_item`
(`id`,`order_id`,`product_materiel`,`product_name`,`bom_id`,`bom_code`,`bom_version`,`model`,`specification`,`qty`,`unit_price`,`configuration`,`plan_delivery_date`,`plan_start_date`,`lead_time_days`,`target_capacity`,`computed_start_date`,`computed_delivery_date`,`material_ready_date`,`adjust_note`,`work_order_id`,`work_order_code`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_poi_dpc','demo_po_dpc','DPC_HOST','台式电脑主机','demo_bom_dpc_host','BOM-DPC-HOST-V1','1','DPC-HOST-A','标准配置',20,3999.00,'i5/16G/512G/标准机箱','2026-06-18','2026-06-14',1,20.00,'2026-06-14','2026-06-18','2026-06-14',NULL,'demo_wo_dpc','GD-DEMO-20260614-001',NOW(),'admin',NOW(),'admin'),
('demo_poi_iot','demo_po_iot','IOT_TERMINAL','工业采集终端','demo_bom_iot_terminal','BOM-IOT-TERMINAL-DRAFT','0.1','IOT-T100','草稿配置',12,1899.00,'4G/多通道采集/备用电池','2026-07-05','2026-06-26',4,6.00,'2026-06-26','2026-07-05',NULL,'BOM未定版，暂不生成工单',NULL,NULL,NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`bom_id`=VALUES(`bom_id`),`bom_code`=VALUES(`bom_code`),`bom_version`=VALUES(`bom_version`),`model`=VALUES(`model`),`specification`=VALUES(`specification`),`qty`=VALUES(`qty`),`unit_price`=VALUES(`unit_price`),`configuration`=VALUES(`configuration`),`plan_delivery_date`=VALUES(`plan_delivery_date`),`plan_start_date`=VALUES(`plan_start_date`),`lead_time_days`=VALUES(`lead_time_days`),`target_capacity`=VALUES(`target_capacity`),`computed_start_date`=VALUES(`computed_start_date`),`computed_delivery_date`=VALUES(`computed_delivery_date`),`material_ready_date`=VALUES(`material_ready_date`),`adjust_note`=VALUES(`adjust_note`),`work_order_id`=VALUES(`work_order_id`),`work_order_code`=VALUES(`work_order_code`),`update_time`=NOW();

INSERT INTO `sp_production_order_oper_plan`
(`id`,`order_id`,`order_item_id`,`order_no`,`product_materiel`,`product_name`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`plan_start_time`,`plan_end_time`,`duration_hours`,`duration_source`,`schedule_method`,`calc_remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_pop_dpc_010','demo_po_dpc','demo_poi_dpc','DD-DEMO-20260614-001','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'demo_unit_board','2026-06-14 08:00:00','2026-06-14 12:00:00',4.00,'MANUAL','REVERSE','演示排产：主板单元', '0',NOW(),'admin',NOW(),'admin'),
('demo_pop_dpc_020','demo_po_dpc','demo_poi_dpc','DD-DEMO-20260614-001','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'demo_unit_case','2026-06-14 13:00:00','2026-06-15 10:00:00',5.00,'MANUAL','REVERSE','演示排产：机箱单元','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_dpc_030','demo_po_dpc','demo_poi_dpc','DD-DEMO-20260614-001','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_final','DPC-OP-030','整机总装',30,'demo_unit_final','2026-06-15 10:00:00','2026-06-16 12:00:00',10.00,'MANUAL','REVERSE','演示排产：整机总装','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_dpc_040','demo_po_dpc','demo_poi_dpc','DD-DEMO-20260614-001','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'demo_unit_test','2026-06-16 13:00:00','2026-06-18 10:00:00',13.00,'MANUAL','REVERSE','演示排产：整机测试','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_dpc_050','demo_po_dpc','demo_poi_dpc','DD-DEMO-20260614-001','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'demo_unit_pack','2026-06-18 10:00:00','2026-06-18 17:00:00',7.00,'MANUAL','REVERSE','演示排产：包装入库','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_item_id`=VALUES(`order_item_id`),`order_no`=VALUES(`order_no`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`flow_id`=VALUES(`flow_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`plan_start_time`=VALUES(`plan_start_time`),`plan_end_time`=VALUES(`plan_end_time`),`duration_hours`=VALUES(`duration_hours`),`duration_source`=VALUES(`duration_source`),`schedule_method`=VALUES(`schedule_method`),`calc_remark`=VALUES(`calc_remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order_oper_equipment_assign`
(`id`,`order_id`,`order_code`,`production_order_id`,`order_item_id`,`oper_plan_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`equipment_id`,`equipment_code`,`equipment_name`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_ooea_dpc_010','demo_wo_dpc','GD-DEMO-20260614-001','demo_po_dpc','demo_poi_dpc','demo_pop_dpc_010','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'demo_unit_board','demo_eq_smt','DEMO-EQ-001','桌面贴装工作站','ASSIGNED','主板单元设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_dpc_020','demo_wo_dpc','GD-DEMO-20260614-001','demo_po_dpc','demo_poi_dpc','demo_pop_dpc_020','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'demo_unit_case','demo_eq_torque','DEMO-EQ-002','智能扭矩电批','ASSIGNED','机箱装配设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_dpc_030','demo_wo_dpc','GD-DEMO-20260614-001','demo_po_dpc','demo_poi_dpc','demo_pop_dpc_030','demo_op_dpc_final','DPC-OP-030','整机总装',30,'demo_unit_final','demo_eq_torque','DEMO-EQ-002','智能扭矩电批','ASSIGNED','总装设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_dpc_040','demo_wo_dpc','GD-DEMO-20260614-001','demo_po_dpc','demo_poi_dpc','demo_pop_dpc_040','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'demo_unit_test','demo_eq_burn','DEMO-EQ-003','整机老化测试架','ASSIGNED','测试设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_dpc_050','demo_wo_dpc','GD-DEMO-20260614-001','demo_po_dpc','demo_poi_dpc','demo_pop_dpc_050','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'demo_unit_pack','demo_eq_pack','DEMO-EQ-004','自动贴标包装台','ASSIGNED','包装设备已派工','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_code`=VALUES(`order_code`),`production_order_id`=VALUES(`production_order_id`),`order_item_id`=VALUES(`order_item_id`),`oper_plan_id`=VALUES(`oper_plan_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`equipment_id`=VALUES(`equipment_id`),`equipment_code`=VALUES(`equipment_code`),`equipment_name`=VALUES(`equipment_name`),`status`=VALUES(`status`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order_oper_assign`
(`id`,`order_id`,`order_code`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`team_id`,`user_id`,`user_name`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_ooa_dpc_010','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'demo_unit_board','demo_team_board','demo_user_op_01','王装配','1','主板装配已开工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_dpc_020','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'demo_unit_case','demo_team_final','demo_user_op_02','李总装','1','机箱装配已开工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_dpc_030','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_final','DPC-OP-030','整机总装',30,'demo_unit_final','demo_team_final','demo_user_op_02','李总装','1','整机总装已开工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_dpc_040','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'demo_unit_test','demo_team_final','demo_user_op_03','刘测试','1','整机测试已开工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_dpc_050','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'demo_unit_pack','demo_team_wh','demo_user_wh_02','郑仓储','1','包装入库已开工','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_code`=VALUES(`order_code`),`flow_id`=VALUES(`flow_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`team_id`=VALUES(`team_id`),`user_id`=VALUES(`user_id`),`user_name`=VALUES(`user_name`),`status`=VALUES(`status`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 9. MRP and confirmed kitting-out for DPC order.
-- ============================================================
INSERT INTO `sp_material_requirement_plan`
(`id`,`production_order_id`,`production_order_no`,`order_item_id`,`product_serial_no`,`product_materiel`,`product_name`,`material_id`,`material_code`,`material_name`,`material_type`,`material_source`,`unit`,`bom_level`,`bom_path`,`gross_requirement`,`available_stock`,`safety_stock`,`net_requirement`,`requirement_date`,`lead_time_days`,`release_date`,`delivery_status`,`inbound_status`,`inbound_request_id`,`inbound_request_no`,`outbound_status`,`outbound_request_id`,`outbound_request_no`,`calc_batch_no`,`calc_time`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_mrp_dpc_pcb','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_pcb','DPC_PCB','台式电脑主板PCB','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_PCB',20.00,120.00,20.00,0.00,'2026-06-14',2,'2026-06-12','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_dpc_cpu','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_cpu','DPC_CPU','台式电脑CPU','PART','OUT','颗',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_CPU',20.00,120.00,20.00,0.00,'2026-06-14',3,'2026-06-11','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_dpc_ram','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_ram','DPC_MEMORY','台式电脑内存条','PART','OUT','条',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_MEMORY',20.00,120.00,20.00,0.00,'2026-06-14',2,'2026-06-12','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_dpc_ssd','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_ssd','DPC_SSD','台式电脑固态硬盘','PART','OUT','块',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_SSD',20.00,120.00,20.00,0.00,'2026-06-14',2,'2026-06-12','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_dpc_power','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_power','DPC_POWER_SUPPLY','台式电脑电源','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_CASE_UNIT>DPC_POWER_SUPPLY',20.00,120.00,10.00,0.00,'2026-06-14',2,'2026-06-12','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_dpc_shell','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_case_shell','DPC_CASE_SHELL','台式电脑机箱外壳','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_CASE_UNIT>DPC_CASE_SHELL',20.00,120.00,10.00,0.00,'2026-06-14',2,'2026-06-12','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_dpc_fan','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_fan','DPC_COOLING_FAN','台式电脑散热风扇','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_CASE_UNIT>DPC_COOLING_FAN',20.00,120.00,10.00,0.00,'2026-06-14',2,'2026-06-12','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `production_order_id`=VALUES(`production_order_id`),`production_order_no`=VALUES(`production_order_no`),`order_item_id`=VALUES(`order_item_id`),`product_serial_no`=VALUES(`product_serial_no`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`material_id`=VALUES(`material_id`),`material_code`=VALUES(`material_code`),`material_name`=VALUES(`material_name`),`material_type`=VALUES(`material_type`),`material_source`=VALUES(`material_source`),`unit`=VALUES(`unit`),`bom_level`=VALUES(`bom_level`),`bom_path`=VALUES(`bom_path`),`gross_requirement`=VALUES(`gross_requirement`),`available_stock`=VALUES(`available_stock`),`safety_stock`=VALUES(`safety_stock`),`net_requirement`=VALUES(`net_requirement`),`requirement_date`=VALUES(`requirement_date`),`lead_time_days`=VALUES(`lead_time_days`),`release_date`=VALUES(`release_date`),`delivery_status`=VALUES(`delivery_status`),`inbound_status`=VALUES(`inbound_status`),`outbound_status`=VALUES(`outbound_status`),`outbound_request_id`=VALUES(`outbound_request_id`),`outbound_request_no`=VALUES(`outbound_request_no`),`calc_batch_no`=VALUES(`calc_batch_no`),`calc_time`=VALUES(`calc_time`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_request`
(`id`,`request_no`,`business_type`,`source_type`,`source_id`,`source_no`,`warehouse_id`,`status`,`item_count`,`total_qty`,`apply_username`,`apply_time`,`confirm_username`,`confirm_time`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wr_kit_dpc','WKO-DEMO-20260614-001','KITTING_OUT','MRP','demo_po_dpc','DD-DEMO-20260614-001','demo_wh_raw','CONFIRMED',7,140.0000,'demo_wh_01','2026-06-14 08:30:00','demo_wh_01','2026-06-14 09:10:00','完整制造流程齐套出库，支持工单开工','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_no`=VALUES(`request_no`),`business_type`=VALUES(`business_type`),`source_type`=VALUES(`source_type`),`source_id`=VALUES(`source_id`),`source_no`=VALUES(`source_no`),`warehouse_id`=VALUES(`warehouse_id`),`status`=VALUES(`status`),`item_count`=VALUES(`item_count`),`total_qty`=VALUES(`total_qty`),`apply_username`=VALUES(`apply_username`),`apply_time`=VALUES(`apply_time`),`confirm_username`=VALUES(`confirm_username`),`confirm_time`=VALUES(`confirm_time`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_request_item`
(`id`,`request_id`,`material_id`,`material_code`,`material_name`,`warehouse_id`,`location_id`,`batch_no`,`request_qty`,`confirmed_qty`,`unit`,`status`,`source_item_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wri_pcb','demo_wr_kit_dpc','demo_mat_pcb','DPC_PCB','台式电脑主板PCB','demo_wh_raw','demo_loc_raw_01','DPC-RM-20260601',20.0000,20.0000,'件','CONFIRMED','demo_mrp_dpc_pcb','齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_wri_cpu','demo_wr_kit_dpc','demo_mat_cpu','DPC_CPU','台式电脑CPU','demo_wh_raw','demo_loc_raw_01','DPC-RM-20260601',20.0000,20.0000,'颗','CONFIRMED','demo_mrp_dpc_cpu','齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_wri_ram','demo_wr_kit_dpc','demo_mat_ram','DPC_MEMORY','台式电脑内存条','demo_wh_raw','demo_loc_raw_02','DPC-RM-20260601',20.0000,20.0000,'条','CONFIRMED','demo_mrp_dpc_ram','齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_wri_ssd','demo_wr_kit_dpc','demo_mat_ssd','DPC_SSD','台式电脑固态硬盘','demo_wh_raw','demo_loc_raw_02','DPC-RM-20260601',20.0000,20.0000,'块','CONFIRMED','demo_mrp_dpc_ssd','齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_wri_power','demo_wr_kit_dpc','demo_mat_power','DPC_POWER_SUPPLY','台式电脑电源','demo_wh_raw','demo_loc_raw_03','DPC-RM-20260601',20.0000,20.0000,'件','CONFIRMED','demo_mrp_dpc_power','齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_wri_shell','demo_wr_kit_dpc','demo_mat_case_shell','DPC_CASE_SHELL','台式电脑机箱外壳','demo_wh_raw','demo_loc_raw_03','DPC-RM-20260601',20.0000,20.0000,'件','CONFIRMED','demo_mrp_dpc_shell','齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_wri_fan','demo_wr_kit_dpc','demo_mat_fan','DPC_COOLING_FAN','台式电脑散热风扇','demo_wh_raw','demo_loc_raw_04','DPC-RM-20260601',20.0000,20.0000,'件','CONFIRMED','demo_mrp_dpc_fan','齐套出库','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_id`=VALUES(`request_id`),`material_id`=VALUES(`material_id`),`material_code`=VALUES(`material_code`),`material_name`=VALUES(`material_name`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`batch_no`=VALUES(`batch_no`),`request_qty`=VALUES(`request_qty`),`confirmed_qty`=VALUES(`confirmed_qty`),`unit`=VALUES(`unit`),`status`=VALUES(`status`),`source_item_id`=VALUES(`source_item_id`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_request_allocation`
(`id`,`request_id`,`request_item_id`,`inventory_id`,`warehouse_id`,`location_id`,`material_id`,`batch_no`,`qty`,`before_qty`,`after_qty`,`allocation_rule`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wra_pcb','demo_wr_kit_dpc','demo_wri_pcb','demo_inv_pcb','demo_wh_raw','demo_loc_raw_01','demo_mat_pcb','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('demo_wra_cpu','demo_wr_kit_dpc','demo_wri_cpu','demo_inv_cpu','demo_wh_raw','demo_loc_raw_01','demo_mat_cpu','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('demo_wra_ram','demo_wr_kit_dpc','demo_wri_ram','demo_inv_ram','demo_wh_raw','demo_loc_raw_02','demo_mat_ram','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('demo_wra_ssd','demo_wr_kit_dpc','demo_wri_ssd','demo_inv_ssd','demo_wh_raw','demo_loc_raw_02','demo_mat_ssd','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('demo_wra_power','demo_wr_kit_dpc','demo_wri_power','demo_inv_power','demo_wh_raw','demo_loc_raw_03','demo_mat_power','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('demo_wra_shell','demo_wr_kit_dpc','demo_wri_shell','demo_inv_case_shell','demo_wh_raw','demo_loc_raw_03','demo_mat_case_shell','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('demo_wra_fan','demo_wr_kit_dpc','demo_wri_fan','demo_inv_fan','demo_wh_raw','demo_loc_raw_04','demo_mat_fan','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_id`=VALUES(`request_id`),`request_item_id`=VALUES(`request_item_id`),`inventory_id`=VALUES(`inventory_id`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`material_id`=VALUES(`material_id`),`batch_no`=VALUES(`batch_no`),`qty`=VALUES(`qty`),`before_qty`=VALUES(`before_qty`),`after_qty`=VALUES(`after_qty`),`allocation_rule`=VALUES(`allocation_rule`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_transaction`
(`id`,`transaction_no`,`request_id`,`request_no`,`request_item_id`,`direction`,`business_type`,`warehouse_id`,`location_id`,`material_id`,`batch_no`,`qty`,`before_qty`,`after_qty`,`operator_username`,`operate_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wtx_pcb','WO-DEMO-20260614-001','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_pcb','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_01','demo_mat_pcb','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑主板PCB齐套出库',NOW(),'admin',NOW(),'admin'),
('demo_wtx_cpu','WO-DEMO-20260614-002','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_cpu','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_01','demo_mat_cpu','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑CPU齐套出库',NOW(),'admin',NOW(),'admin'),
('demo_wtx_ram','WO-DEMO-20260614-003','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_ram','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_02','demo_mat_ram','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑内存条齐套出库',NOW(),'admin',NOW(),'admin'),
('demo_wtx_ssd','WO-DEMO-20260614-004','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_ssd','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_02','demo_mat_ssd','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑固态硬盘齐套出库',NOW(),'admin',NOW(),'admin'),
('demo_wtx_power','WO-DEMO-20260614-005','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_power','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_03','demo_mat_power','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑电源齐套出库',NOW(),'admin',NOW(),'admin'),
('demo_wtx_shell','WO-DEMO-20260614-006','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_shell','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_03','demo_mat_case_shell','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑机箱外壳齐套出库',NOW(),'admin',NOW(),'admin'),
('demo_wtx_fan','WO-DEMO-20260614-007','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_fan','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_04','demo_mat_fan','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑散热风扇齐套出库',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `transaction_no`=VALUES(`transaction_no`),`request_id`=VALUES(`request_id`),`request_no`=VALUES(`request_no`),`request_item_id`=VALUES(`request_item_id`),`direction`=VALUES(`direction`),`business_type`=VALUES(`business_type`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`material_id`=VALUES(`material_id`),`batch_no`=VALUES(`batch_no`),`qty`=VALUES(`qty`),`before_qty`=VALUES(`before_qty`),`after_qty`=VALUES(`after_qty`),`operator_username`=VALUES(`operator_username`),`operate_time`=VALUES(`operate_time`),`remark`=VALUES(`remark`),`update_time`=NOW();

INSERT INTO `sp_warehouse_request`
(`id`,`request_no`,`business_type`,`source_type`,`source_id`,`source_no`,`warehouse_id`,`status`,`item_count`,`total_qty`,`apply_username`,`apply_time`,`confirm_username`,`confirm_time`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wr_fg_dpc','WIN-DEMO-20260618-001','MANUAL_IN','WORK_ORDER','demo_wo_dpc','GD-DEMO-20260614-001','demo_wh_fg','CONFIRMED',1,20.0000,'demo_wh_02','2026-06-18 17:00:00','demo_wh_02','2026-06-18 17:10:00','DPC finished goods inbound','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_no`=VALUES(`request_no`),`business_type`=VALUES(`business_type`),`source_type`=VALUES(`source_type`),`source_id`=VALUES(`source_id`),`source_no`=VALUES(`source_no`),`warehouse_id`=VALUES(`warehouse_id`),`status`=VALUES(`status`),`item_count`=VALUES(`item_count`),`total_qty`=VALUES(`total_qty`),`apply_username`=VALUES(`apply_username`),`apply_time`=VALUES(`apply_time`),`confirm_username`=VALUES(`confirm_username`),`confirm_time`=VALUES(`confirm_time`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_request_item`
(`id`,`request_id`,`material_id`,`material_code`,`material_name`,`warehouse_id`,`location_id`,`batch_no`,`request_qty`,`confirmed_qty`,`unit`,`status`,`source_item_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wri_fg_dpc','demo_wr_fg_dpc','demo_mat_dpc_host','DPC_HOST','DPC_HOST','demo_wh_fg','demo_loc_fg_01','DPC-FG-20260614',20.0000,20.0000,'pcs','CONFIRMED','demo_poi_dpc','finished goods inbound','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_id`=VALUES(`request_id`),`material_id`=VALUES(`material_id`),`material_code`=VALUES(`material_code`),`material_name`=VALUES(`material_name`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`batch_no`=VALUES(`batch_no`),`request_qty`=VALUES(`request_qty`),`confirmed_qty`=VALUES(`confirmed_qty`),`unit`=VALUES(`unit`),`status`=VALUES(`status`),`source_item_id`=VALUES(`source_item_id`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_transaction`
(`id`,`transaction_no`,`request_id`,`request_no`,`request_item_id`,`direction`,`business_type`,`warehouse_id`,`location_id`,`material_id`,`batch_no`,`qty`,`before_qty`,`after_qty`,`operator_username`,`operate_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wtx_dpc_fg_in','WI-DEMO-20260618-001','demo_wr_fg_dpc','WIN-DEMO-20260618-001','demo_wri_fg_dpc','IN','MANUAL_IN','demo_wh_fg','demo_loc_fg_01','demo_mat_dpc_host','DPC-FG-20260614',20.0000,0.0000,20.0000,'demo_wh_02','2026-06-18 17:10:00','DPC finished goods inbound',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `transaction_no`=VALUES(`transaction_no`),`request_id`=VALUES(`request_id`),`request_no`=VALUES(`request_no`),`request_item_id`=VALUES(`request_item_id`),`direction`=VALUES(`direction`),`business_type`=VALUES(`business_type`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`material_id`=VALUES(`material_id`),`batch_no`=VALUES(`batch_no`),`qty`=VALUES(`qty`),`before_qty`=VALUES(`before_qty`),`after_qty`=VALUES(`after_qty`),`operator_username`=VALUES(`operator_username`),`operate_time`=VALUES(`operate_time`),`remark`=VALUES(`remark`),`update_time`=NOW();

-- ============================================================
-- 10. Started WIP/SN collection and completed approval trace.
-- ============================================================
INSERT INTO `sp_sn_process_record`
(`id`,`sn`,`order_id`,`order_code`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`step_no`,`status`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_sn_dpc_001_010','DPC202606140001','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'OK','首台主板装配完成',NOW(),'demo_op_01',NOW(),'demo_op_01'),
('demo_sn_dpc_001_020','DPC202606140001','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'OK','首台机箱装配完成',NOW(),'demo_op_02',NOW(),'demo_op_02'),
('demo_sn_dpc_001_030','DPC202606140001','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_final','DPC-OP-030','整机总装',30,'OK','首台整机总装完成',NOW(),'demo_op_02',NOW(),'demo_op_02'),
('demo_sn_dpc_001_040','DPC202606140001','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'OK','首台老化测试通过',NOW(),'demo_op_03',NOW(),'demo_op_03'),
('demo_sn_dpc_001_050','DPC202606140001','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'OK','首台包装完成，待批量完工入库',NOW(),'demo_wh_02',NOW(),'demo_wh_02')
ON DUPLICATE KEY UPDATE `sn`=VALUES(`sn`),`order_id`=VALUES(`order_id`),`order_code`=VALUES(`order_code`),`flow_id`=VALUES(`flow_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`step_no`=VALUES(`step_no`),`status`=VALUES(`status`),`remark`=VALUES(`remark`),`update_time`=NOW();

INSERT INTO `sp_workflow_instance`
(`id`,`definition_id`,`business_type`,`business_id`,`business_code`,`title`,`status`,`current_node_key`,`current_node_name`,`start_user_id`,`start_username`,`start_time`,`end_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wfi_dpc_approval','wf_def_order_approval_v1','ORDER_APPROVAL','demo_wo_dpc','GD-DEMO-20260614-001','生产订单审批-GD-DEMO-20260614-001','completed','end','审批完成','demo_user_plan_01','何计划','2026-06-14 08:40:00','2026-06-14 09:00:00','演示生产主管审批通过',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `definition_id`=VALUES(`definition_id`),`business_type`=VALUES(`business_type`),`business_id`=VALUES(`business_id`),`business_code`=VALUES(`business_code`),`title`=VALUES(`title`),`status`=VALUES(`status`),`current_node_key`=VALUES(`current_node_key`),`current_node_name`=VALUES(`current_node_name`),`start_user_id`=VALUES(`start_user_id`),`start_username`=VALUES(`start_username`),`start_time`=VALUES(`start_time`),`end_time`=VALUES(`end_time`),`remark`=VALUES(`remark`),`update_time`=NOW();

INSERT INTO `sp_workflow_task`
(`id`,`instance_id`,`definition_id`,`business_type`,`business_id`,`business_code`,`task_name`,`node_key`,`node_name`,`assignee_type`,`assignee_id`,`assignee_name`,`status`,`action`,`opinion`,`start_time`,`complete_time`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wft_dpc_approval','demo_wfi_dpc_approval','wf_def_order_approval_v1','ORDER_APPROVAL','demo_wo_dpc','GD-DEMO-20260614-001','生产订单审批','order_approve','生产订单审批','role','productionManagerRole','生产主管','done','approve','同意，按演示计划开工','2026-06-14 08:40:00','2026-06-14 09:00:00',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `instance_id`=VALUES(`instance_id`),`definition_id`=VALUES(`definition_id`),`business_type`=VALUES(`business_type`),`business_id`=VALUES(`business_id`),`business_code`=VALUES(`business_code`),`task_name`=VALUES(`task_name`),`node_key`=VALUES(`node_key`),`node_name`=VALUES(`node_name`),`assignee_type`=VALUES(`assignee_type`),`assignee_id`=VALUES(`assignee_id`),`assignee_name`=VALUES(`assignee_name`),`status`=VALUES(`status`),`action`=VALUES(`action`),`opinion`=VALUES(`opinion`),`start_time`=VALUES(`start_time`),`complete_time`=VALUES(`complete_time`),`update_time`=NOW();

INSERT INTO `sp_workflow_event_log`
(`id`,`definition_id`,`instance_id`,`task_id`,`event_type`,`action_code`,`result_status`,`result_msg`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wfel_dpc_order_approve','wf_def_order_approval_v1','demo_wfi_dpc_approval','demo_wft_dpc_approval','complete','ORDER_APPROVE','success','order status synced to approved',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `definition_id`=VALUES(`definition_id`),`instance_id`=VALUES(`instance_id`),`task_id`=VALUES(`task_id`),`event_type`=VALUES(`event_type`),`action_code`=VALUES(`action_code`),`result_status`=VALUES(`result_status`),`result_msg`=VALUES(`result_msg`),`update_time`=NOW();

-- ============================================================
-- 11. ASSIGNED-stage DPC order to fill the assign/release queues.
--   approval_status=APPROVED, operation_status=ASSIGNED, work order statue=2.
--   Equipment + staff are fully assigned and MRP net=0, so the order shows up on
--   设备派工 / 员工派工 / 生产计划下发 and can be dispatched in the UI.
-- ============================================================
INSERT INTO `sp_production_order`
(`id`,`order_no`,`source_type`,`customer_name`,`customer_group`,`external_no`,`sales_contract_no`,`business_type`,`order_date`,`settlement_currency`,`transport_mode`,`payment_terms`,`tax_rate`,`receiver_name`,`receiver_phone`,`receiver_address`,`remark`,`status`,`approval_status`,`operation_status`,`creation_method`,`scheduling_method`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_po_dpc_assign','DD-DEMO-20260614-003','DEMAND','演示客户-华南智联','华南大客户','EXT-DEMO-DPC-002','HT-DEMO-DPC-002','普通销售','2026-06-14','人民币','公路运输','月结30天','不含税','张采购','13866010003','广州市天河区演示路3号','完整制造流程：已审批、设备/员工派工完成，待生产计划下发（用于派工/下发演示）','CONFIRMED','APPROVED','ASSIGNED','MANUAL','REVERSE','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `customer_name`=VALUES(`customer_name`),`customer_group`=VALUES(`customer_group`),`external_no`=VALUES(`external_no`),`sales_contract_no`=VALUES(`sales_contract_no`),`business_type`=VALUES(`business_type`),`order_date`=VALUES(`order_date`),`remark`=VALUES(`remark`),`status`=VALUES(`status`),`approval_status`=VALUES(`approval_status`),`operation_status`=VALUES(`operation_status`),`creation_method`=VALUES(`creation_method`),`scheduling_method`=VALUES(`scheduling_method`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order`
(`id`,`order_code`,`order_description`,`qty`,`order_type`,`flow_id`,`materiel`,`materiel_desc`,`plan_start_time`,`plan_end_time`,`statue`,`designer_id`,`designer_name`,`approve_user_id`,`approve_username`,`approve_time`,`remark`,`work_status`,`work_start_time`,`complete_status`,`complete_time`,`complete_username`,`delivery_status`,`delivery_time`,`delivery_username`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wo_dpc_assign','GD-DEMO-20260614-002','DD-DEMO-20260614-003 / 台式电脑主机',10,'P','demo_flow_dpc_host','DPC_HOST','台式电脑主机','2026-06-20 08:00:00','2026-06-24 17:00:00',2,'demo_user_plan_02','许计划','demo_user_mgr_01','陈主管','2026-06-14 11:00:00','已审批通过，设备/员工派工完成，待生产计划下发','NOT_STARTED',NULL,'WAIT',NULL,NULL,'WAIT',NULL,NULL,NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_code`=VALUES(`order_code`),`order_description`=VALUES(`order_description`),`qty`=VALUES(`qty`),`order_type`=VALUES(`order_type`),`flow_id`=VALUES(`flow_id`),`materiel`=VALUES(`materiel`),`materiel_desc`=VALUES(`materiel_desc`),`plan_start_time`=VALUES(`plan_start_time`),`plan_end_time`=VALUES(`plan_end_time`),`statue`=VALUES(`statue`),`designer_id`=VALUES(`designer_id`),`designer_name`=VALUES(`designer_name`),`approve_user_id`=VALUES(`approve_user_id`),`approve_username`=VALUES(`approve_username`),`approve_time`=VALUES(`approve_time`),`remark`=VALUES(`remark`),`work_status`=VALUES(`work_status`),`complete_status`=VALUES(`complete_status`),`delivery_status`=VALUES(`delivery_status`),`update_time`=NOW();

INSERT INTO `sp_production_order_item`
(`id`,`order_id`,`product_materiel`,`product_name`,`bom_id`,`bom_code`,`bom_version`,`model`,`specification`,`qty`,`unit_price`,`configuration`,`plan_delivery_date`,`plan_start_date`,`lead_time_days`,`target_capacity`,`computed_start_date`,`computed_delivery_date`,`material_ready_date`,`adjust_note`,`work_order_id`,`work_order_code`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_poi_dpc_assign','demo_po_dpc_assign','DPC_HOST','台式电脑主机','demo_bom_dpc_host','BOM-DPC-HOST-V1','1','DPC-HOST-A','标准配置',10,3999.00,'i5/16G/512G/标准机箱','2026-06-24','2026-06-20',1,20.00,'2026-06-20','2026-06-24','2026-06-20',NULL,'demo_wo_dpc_assign','GD-DEMO-20260614-002',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`bom_id`=VALUES(`bom_id`),`bom_code`=VALUES(`bom_code`),`bom_version`=VALUES(`bom_version`),`model`=VALUES(`model`),`specification`=VALUES(`specification`),`qty`=VALUES(`qty`),`unit_price`=VALUES(`unit_price`),`configuration`=VALUES(`configuration`),`plan_delivery_date`=VALUES(`plan_delivery_date`),`plan_start_date`=VALUES(`plan_start_date`),`lead_time_days`=VALUES(`lead_time_days`),`target_capacity`=VALUES(`target_capacity`),`computed_start_date`=VALUES(`computed_start_date`),`computed_delivery_date`=VALUES(`computed_delivery_date`),`material_ready_date`=VALUES(`material_ready_date`),`work_order_id`=VALUES(`work_order_id`),`work_order_code`=VALUES(`work_order_code`),`update_time`=NOW();

INSERT INTO `sp_production_order_oper_plan`
(`id`,`order_id`,`order_item_id`,`order_no`,`product_materiel`,`product_name`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`plan_start_time`,`plan_end_time`,`duration_hours`,`duration_source`,`schedule_method`,`calc_remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_pop_assign_010','demo_po_dpc_assign','demo_poi_dpc_assign','DD-DEMO-20260614-003','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'demo_unit_board','2026-06-20 08:00:00','2026-06-20 12:00:00',4.00,'MANUAL','REVERSE','演示排产：主板单元','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_assign_020','demo_po_dpc_assign','demo_poi_dpc_assign','DD-DEMO-20260614-003','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'demo_unit_case','2026-06-20 13:00:00','2026-06-21 10:00:00',5.00,'MANUAL','REVERSE','演示排产：机箱单元','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_assign_030','demo_po_dpc_assign','demo_poi_dpc_assign','DD-DEMO-20260614-003','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_final','DPC-OP-030','整机总装',30,'demo_unit_final','2026-06-21 10:00:00','2026-06-22 12:00:00',10.00,'MANUAL','REVERSE','演示排产：整机总装','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_assign_040','demo_po_dpc_assign','demo_poi_dpc_assign','DD-DEMO-20260614-003','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'demo_unit_test','2026-06-22 13:00:00','2026-06-24 10:00:00',13.00,'MANUAL','REVERSE','演示排产：整机测试','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_assign_050','demo_po_dpc_assign','demo_poi_dpc_assign','DD-DEMO-20260614-003','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'demo_unit_pack','2026-06-24 10:00:00','2026-06-24 17:00:00',7.00,'MANUAL','REVERSE','演示排产：包装入库','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_item_id`=VALUES(`order_item_id`),`order_no`=VALUES(`order_no`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`flow_id`=VALUES(`flow_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`plan_start_time`=VALUES(`plan_start_time`),`plan_end_time`=VALUES(`plan_end_time`),`duration_hours`=VALUES(`duration_hours`),`duration_source`=VALUES(`duration_source`),`schedule_method`=VALUES(`schedule_method`),`calc_remark`=VALUES(`calc_remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order_oper_equipment_assign`
(`id`,`order_id`,`order_code`,`production_order_id`,`order_item_id`,`oper_plan_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`equipment_id`,`equipment_code`,`equipment_name`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_ooea_assign_010','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_po_dpc_assign','demo_poi_dpc_assign','demo_pop_assign_010','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'demo_unit_board','demo_eq_smt','DEMO-EQ-001','桌面贴装工作站','ASSIGNED','主板单元设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_assign_020','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_po_dpc_assign','demo_poi_dpc_assign','demo_pop_assign_020','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'demo_unit_case','demo_eq_torque','DEMO-EQ-002','智能扭矩电批','ASSIGNED','机箱装配设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_assign_030','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_po_dpc_assign','demo_poi_dpc_assign','demo_pop_assign_030','demo_op_dpc_final','DPC-OP-030','整机总装',30,'demo_unit_final','demo_eq_torque','DEMO-EQ-002','智能扭矩电批','ASSIGNED','总装设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_assign_040','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_po_dpc_assign','demo_poi_dpc_assign','demo_pop_assign_040','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'demo_unit_test','demo_eq_burn','DEMO-EQ-003','整机老化测试架','ASSIGNED','测试设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_assign_050','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_po_dpc_assign','demo_poi_dpc_assign','demo_pop_assign_050','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'demo_unit_pack','demo_eq_pack','DEMO-EQ-004','自动贴标包装台','ASSIGNED','包装设备已派工','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_code`=VALUES(`order_code`),`production_order_id`=VALUES(`production_order_id`),`order_item_id`=VALUES(`order_item_id`),`oper_plan_id`=VALUES(`oper_plan_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`equipment_id`=VALUES(`equipment_id`),`equipment_code`=VALUES(`equipment_code`),`equipment_name`=VALUES(`equipment_name`),`status`=VALUES(`status`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order_oper_assign`
(`id`,`order_id`,`order_code`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`team_id`,`user_id`,`user_name`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_ooa_assign_010','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_flow_dpc_host','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'demo_unit_board','demo_team_board','demo_user_op_01','王装配','1','主板装配已派工待下发','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_assign_020','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_flow_dpc_host','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'demo_unit_case','demo_team_final','demo_user_op_02','李总装','1','机箱装配已派工待下发','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_assign_030','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_flow_dpc_host','demo_op_dpc_final','DPC-OP-030','整机总装',30,'demo_unit_final','demo_team_final','demo_user_op_02','李总装','1','整机总装已派工待下发','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_assign_040','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_flow_dpc_host','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'demo_unit_test','demo_team_final','demo_user_op_03','刘测试','1','整机测试已派工待下发','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_assign_050','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_flow_dpc_host','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'demo_unit_pack','demo_team_wh','demo_user_wh_02','郑仓储','1','包装入库已派工待下发','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_code`=VALUES(`order_code`),`flow_id`=VALUES(`flow_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`team_id`=VALUES(`team_id`),`user_id`=VALUES(`user_id`),`user_name`=VALUES(`user_name`),`status`=VALUES(`status`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_material_requirement_plan`
(`id`,`production_order_id`,`production_order_no`,`order_item_id`,`product_serial_no`,`product_materiel`,`product_name`,`material_id`,`material_code`,`material_name`,`material_type`,`material_source`,`unit`,`bom_level`,`bom_path`,`gross_requirement`,`available_stock`,`safety_stock`,`net_requirement`,`requirement_date`,`lead_time_days`,`release_date`,`delivery_status`,`inbound_status`,`inbound_request_id`,`inbound_request_no`,`outbound_status`,`outbound_request_id`,`outbound_request_no`,`calc_batch_no`,`calc_time`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_mrp_assign_pcb','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_pcb','DPC_PCB','台式电脑主板PCB','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_PCB',10.00,100.00,20.00,0.00,'2026-06-20',2,'2026-06-18','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_assign_cpu','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_cpu','DPC_CPU','台式电脑CPU','PART','OUT','颗',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_CPU',10.00,100.00,20.00,0.00,'2026-06-20',3,'2026-06-17','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_assign_ram','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_ram','DPC_MEMORY','台式电脑内存条','PART','OUT','条',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_MEMORY',10.00,100.00,20.00,0.00,'2026-06-20',2,'2026-06-18','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_assign_ssd','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_ssd','DPC_SSD','台式电脑固态硬盘','PART','OUT','块',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_SSD',10.00,100.00,20.00,0.00,'2026-06-20',2,'2026-06-18','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_assign_power','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_power','DPC_POWER_SUPPLY','台式电脑电源','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_CASE_UNIT>DPC_POWER_SUPPLY',10.00,100.00,10.00,0.00,'2026-06-20',2,'2026-06-18','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_assign_shell','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_case_shell','DPC_CASE_SHELL','台式电脑机箱外壳','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_CASE_UNIT>DPC_CASE_SHELL',10.00,100.00,10.00,0.00,'2026-06-20',2,'2026-06-18','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_assign_fan','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_fan','DPC_COOLING_FAN','台式电脑散热风扇','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_CASE_UNIT>DPC_COOLING_FAN',10.00,100.00,10.00,0.00,'2026-06-20',2,'2026-06-18','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `production_order_id`=VALUES(`production_order_id`),`production_order_no`=VALUES(`production_order_no`),`order_item_id`=VALUES(`order_item_id`),`product_serial_no`=VALUES(`product_serial_no`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`material_id`=VALUES(`material_id`),`material_code`=VALUES(`material_code`),`material_name`=VALUES(`material_name`),`material_type`=VALUES(`material_type`),`material_source`=VALUES(`material_source`),`unit`=VALUES(`unit`),`bom_level`=VALUES(`bom_level`),`bom_path`=VALUES(`bom_path`),`gross_requirement`=VALUES(`gross_requirement`),`available_stock`=VALUES(`available_stock`),`safety_stock`=VALUES(`safety_stock`),`net_requirement`=VALUES(`net_requirement`),`requirement_date`=VALUES(`requirement_date`),`lead_time_days`=VALUES(`lead_time_days`),`release_date`=VALUES(`release_date`),`delivery_status`=VALUES(`delivery_status`),`inbound_status`=VALUES(`inbound_status`),`outbound_status`=VALUES(`outbound_status`),`calc_batch_no`=VALUES(`calc_batch_no`),`calc_time`=VALUES(`calc_time`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_workflow_instance`
(`id`,`definition_id`,`business_type`,`business_id`,`business_code`,`title`,`status`,`current_node_key`,`current_node_name`,`start_user_id`,`start_username`,`start_time`,`end_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wfi_assign_approval','wf_def_order_approval_v1','ORDER_APPROVAL','demo_wo_dpc_assign','GD-DEMO-20260614-002','生产订单审批-GD-DEMO-20260614-002','completed','end','审批完成','demo_user_plan_02','许计划','2026-06-14 10:40:00','2026-06-14 11:00:00','演示生产主管审批通过',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `definition_id`=VALUES(`definition_id`),`business_type`=VALUES(`business_type`),`business_id`=VALUES(`business_id`),`business_code`=VALUES(`business_code`),`title`=VALUES(`title`),`status`=VALUES(`status`),`current_node_key`=VALUES(`current_node_key`),`current_node_name`=VALUES(`current_node_name`),`start_user_id`=VALUES(`start_user_id`),`start_username`=VALUES(`start_username`),`start_time`=VALUES(`start_time`),`end_time`=VALUES(`end_time`),`remark`=VALUES(`remark`),`update_time`=NOW();

INSERT INTO `sp_workflow_task`
(`id`,`instance_id`,`definition_id`,`business_type`,`business_id`,`business_code`,`task_name`,`node_key`,`node_name`,`assignee_type`,`assignee_id`,`assignee_name`,`status`,`action`,`opinion`,`start_time`,`complete_time`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wft_assign_approval','demo_wfi_assign_approval','wf_def_order_approval_v1','ORDER_APPROVAL','demo_wo_dpc_assign','GD-DEMO-20260614-002','生产订单审批','order_approve','生产订单审批','role','productionManagerRole','生产主管','done','approve','同意，按演示计划派工','2026-06-14 10:40:00','2026-06-14 11:00:00',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `instance_id`=VALUES(`instance_id`),`definition_id`=VALUES(`definition_id`),`business_type`=VALUES(`business_type`),`business_id`=VALUES(`business_id`),`business_code`=VALUES(`business_code`),`task_name`=VALUES(`task_name`),`node_key`=VALUES(`node_key`),`node_name`=VALUES(`node_name`),`assignee_type`=VALUES(`assignee_type`),`assignee_id`=VALUES(`assignee_id`),`assignee_name`=VALUES(`assignee_name`),`status`=VALUES(`status`),`action`=VALUES(`action`),`opinion`=VALUES(`opinion`),`start_time`=VALUES(`start_time`),`complete_time`=VALUES(`complete_time`),`update_time`=NOW();

INSERT INTO `sp_workflow_event_log`
(`id`,`definition_id`,`instance_id`,`task_id`,`event_type`,`action_code`,`result_status`,`result_msg`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wfel_assign_order_approve','wf_def_order_approval_v1','demo_wfi_assign_approval','demo_wft_assign_approval','complete','ORDER_APPROVE','success','order status synced to approved',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `definition_id`=VALUES(`definition_id`),`instance_id`=VALUES(`instance_id`),`task_id`=VALUES(`task_id`),`event_type`=VALUES(`event_type`),`action_code`=VALUES(`action_code`),`result_status`=VALUES(`result_status`),`result_msg`=VALUES(`result_msg`),`update_time`=NOW();

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- Post-run verification queries.
-- Expected:
--   locked_dpc_bom_count = 4
--   bad_dpc_route_count = 0
--   completed_dpc_work_order_count = 1
--   dpc_sn_record_count >= 4
--   dpc_approval_event_log_count = 1
--   dpc_fg_in_transaction_count = 1
--   dpc_finished_goods_qty = 20.0000
--   dpc_gross_kitting_qty_match = 1
--   draft_iot_bom_count = 3
--   iot_work_order_link_count = 0
--   iot_execution_data_count = 0
--   demo_user_count = 12
--   users_without_role_count = 0
--   assign_stage_ready_count = 1   (APPROVED + ASSIGNED, work order statue=2)
--   assign_stage_full_assign_count = 5  (every oper plan has equipment + staff)
--   assign_stage_mrp_blocking_count = 0  (no net>0 row missing CONFIRMED outbound)
-- ============================================================
SELECT COUNT(*) AS locked_dpc_bom_count
FROM `sp_bom`
WHERE `id` IN ('demo_bom_dpc_host','demo_bom_dpc_half','demo_bom_dpc_board','demo_bom_dpc_case')
  AND `lock_status`='locked' AND `state`='pass' AND `validity`='有效';

SELECT COUNT(*) AS bad_dpc_route_count
FROM `sp_process_route`
WHERE `id` LIKE 'demo_route_dpc\_%'
  AND (`lock_status`<>'locked' OR `edit_status`<>'completed' OR `oper_id` IS NULL OR `oper_id`='');

SELECT COUNT(*) AS completed_dpc_work_order_count
FROM `sp_order`
WHERE `id`='demo_wo_dpc'
  AND `statue`=5
  AND `work_status`='STARTED'
  AND `complete_status`='COMPLETED'
  AND `delivery_status`='DELIVERED';

SELECT COUNT(*) AS dpc_sn_record_count
FROM `sp_sn_process_record`
WHERE `order_id`='demo_wo_dpc';

SELECT COUNT(*) AS dpc_approval_event_log_count
FROM `sp_workflow_event_log`
WHERE `id`='demo_wfel_dpc_order_approve'
  AND `instance_id`='demo_wfi_dpc_approval'
  AND `task_id`='demo_wft_dpc_approval'
  AND `action_code`='ORDER_APPROVE'
  AND `result_status`='success';

SELECT COUNT(*) AS dpc_fg_in_transaction_count
FROM `sp_warehouse_transaction`
WHERE `id`='demo_wtx_dpc_fg_in'
  AND `direction`='IN'
  AND `business_type`='MANUAL_IN'
  AND `qty`=20.0000
  AND `before_qty`=0.0000
  AND `after_qty`=20.0000;

SELECT `qty` AS dpc_finished_goods_qty
FROM `sp_inventory`
WHERE `id`='demo_inv_dpc_finished';

SELECT CASE
  WHEN
    (SELECT COALESCE(SUM(`request_qty`),0) FROM `sp_warehouse_request_item` WHERE `request_id`='demo_wr_kit_dpc')
    =
    (SELECT COALESCE(SUM(`gross_requirement`),0) FROM `sp_material_requirement_plan` WHERE `production_order_id`='demo_po_dpc')
  THEN 1 ELSE 0 END AS dpc_gross_kitting_qty_match;

SELECT COUNT(*) AS draft_iot_bom_count
FROM `sp_bom`
WHERE `id` IN ('demo_bom_iot_terminal','demo_bom_iot_control','demo_bom_iot_shell')
  AND `lock_status`='draft' AND `state`='creat' AND `validity`='未生效';

SELECT COUNT(*) AS iot_work_order_link_count
FROM `sp_production_order_item`
WHERE `id`='demo_poi_iot' AND (`work_order_id` IS NOT NULL OR `work_order_code` IS NOT NULL);

SELECT
  (SELECT COUNT(*) FROM `sp_order` WHERE `id` LIKE 'demo\_%' AND `materiel`='IOT_TERMINAL') +
  (SELECT COUNT(*) FROM `sp_material_requirement_plan` WHERE `production_order_id`='demo_po_iot') +
  (SELECT COUNT(*) FROM `sp_sn_process_record` WHERE `order_id` LIKE 'demo_iot\_%') AS iot_execution_data_count;

SELECT COUNT(*) AS demo_user_count
FROM `sp_sys_user`
WHERE `id` LIKE 'demo_user\_%';

SELECT COUNT(*) AS users_without_role_count
FROM `sp_sys_user` u
WHERE u.`id` LIKE 'demo_user\_%'
  AND NOT EXISTS (SELECT 1 FROM `sp_sys_user_role` ur WHERE ur.`user_id`=u.`id`);

-- The ASSIGNED-stage order must be APPROVED + ASSIGNED and its work order approved (statue>=2)
-- so it shows on 设备派工 / 员工派工 / 生产计划下发.
SELECT COUNT(*) AS assign_stage_ready_count
FROM `sp_production_order` po
JOIN `sp_order` wo ON wo.`id`='demo_wo_dpc_assign'
WHERE po.`id`='demo_po_dpc_assign'
  AND po.`approval_status`='APPROVED'
  AND po.`operation_status`='ASSIGNED'
  AND wo.`statue`>=2;

-- Every operation plan of the ASSIGNED order has both equipment and staff assigned.
SELECT COUNT(*) AS assign_stage_full_assign_count
FROM `sp_production_order_oper_plan` p
WHERE p.`order_id`='demo_po_dpc_assign'
  AND p.`is_deleted`='0'
  AND EXISTS (SELECT 1 FROM `sp_order_oper_equipment_assign` e
              WHERE e.`oper_plan_id`=p.`id` AND e.`is_deleted`='0' AND e.`equipment_id`<>'')
  AND EXISTS (SELECT 1 FROM `sp_order_oper_assign` a
              WHERE a.`order_id`='demo_wo_dpc_assign' AND a.`oper_id`=p.`oper_id`
                AND a.`is_deleted`='0' AND a.`user_id`<>'');

-- No MRP row blocks dispatch (net>0 without a CONFIRMED outbound).
SELECT COUNT(*) AS assign_stage_mrp_blocking_count
FROM `sp_material_requirement_plan`
WHERE `production_order_id`='demo_po_dpc_assign'
  AND `is_deleted`='0'
  AND `net_requirement`>0
  AND `outbound_status`<>'CONFIRMED';
