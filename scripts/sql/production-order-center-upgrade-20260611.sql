-- ============================================================
-- 生产计划中心升级脚本
-- Date: 2026-06-11
-- Content:
--   1) 将“生产订单中心”升级为“生产计划中心”。
--   2) 将“订单计划管理”升级为“生产订单录入”。
--   3) 新增生产计划下发、生产工单查询、设备作业派工、员工作业派工菜单。
--   4) 新增设备作业派工结果表 sp_order_oper_equipment_assign。
-- ============================================================

CREATE TABLE IF NOT EXISTS `sp_production_order` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `order_no` varchar(64) NOT NULL COMMENT '生产订单编号',
  `source_type` varchar(16) NOT NULL COMMENT '订单类型 DEMAND需求订单 FORECAST预测订单',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '客户名称',
  `customer_group` varchar(128) DEFAULT NULL COMMENT '客户分组',
  `external_no` varchar(128) DEFAULT NULL COMMENT '外部订单号',
  `sales_contract_no` varchar(128) DEFAULT NULL COMMENT '销售合同号',
  `business_type` varchar(64) DEFAULT NULL COMMENT '业务类型',
  `order_date` varchar(32) DEFAULT NULL COMMENT '订单日期',
  `settlement_currency` varchar(32) DEFAULT NULL COMMENT '结算币种',
  `transport_mode` varchar(64) DEFAULT NULL COMMENT '运输方式',
  `payment_terms` varchar(128) DEFAULT NULL COMMENT '付款方式',
  `tax_rate` varchar(32) DEFAULT NULL COMMENT '税率',
  `receiver_name` varchar(64) DEFAULT NULL COMMENT '收货人',
  `receiver_phone` varchar(64) DEFAULT NULL COMMENT '收货人电话',
  `receiver_address` varchar(255) DEFAULT NULL COMMENT '收货地址',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `status` varchar(32) NOT NULL DEFAULT 'DRAFT' COMMENT '兼容状态',
  `approval_status` varchar(32) NOT NULL DEFAULT 'DRAFT' COMMENT '审核状态',
  `operation_status` varchar(32) NOT NULL DEFAULT 'NONE' COMMENT '下发状态',
  `creation_method` varchar(32) NOT NULL DEFAULT 'MANUAL' COMMENT '创建方式 MANUAL/EXCEL/ERP',
  `scheduling_method` varchar(32) NOT NULL DEFAULT 'REVERSE' COMMENT '排产方式 FORWARD/REVERSE',
  `erp_source_no` varchar(128) DEFAULT NULL COMMENT 'ERP来源单号',
  `erp_sync_time` varchar(32) DEFAULT NULL COMMENT 'ERP同步时间',
  `is_deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '软删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sp_production_order_no` (`order_no`),
  KEY `idx_sp_production_order_status` (`approval_status`, `operation_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生产计划中心-生产订单主表';

CREATE TABLE IF NOT EXISTS `sp_production_order_item` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `order_id` varchar(64) NOT NULL COMMENT '生产订单ID',
  `product_materiel` varchar(128) NOT NULL COMMENT '产品物料编码',
  `product_name` varchar(255) NOT NULL COMMENT '产品名称',
  `bom_id` varchar(64) DEFAULT NULL COMMENT 'BOM ID',
  `bom_code` varchar(128) DEFAULT NULL COMMENT 'BOM编码',
  `bom_version` varchar(64) DEFAULT NULL COMMENT 'BOM版本',
  `model` varchar(128) DEFAULT NULL COMMENT '型号',
  `specification` varchar(128) DEFAULT NULL COMMENT '规格',
  `qty` int NOT NULL DEFAULT 0 COMMENT '需求数量',
  `unit_price` decimal(12,2) DEFAULT NULL COMMENT '单价',
  `configuration` varchar(500) DEFAULT NULL COMMENT '配置要求',
  `plan_delivery_date` varchar(32) DEFAULT NULL COMMENT '计划交付日期',
  `plan_start_date` varchar(32) DEFAULT NULL COMMENT '计划开工日期',
  `lead_time_days` int NOT NULL DEFAULT 1 COMMENT '提前期(工作日)',
  `target_capacity` decimal(10,2) NOT NULL DEFAULT 5.00 COMMENT '目标产能',
  `computed_start_date` varchar(32) DEFAULT NULL COMMENT '系统建议开工日期',
  `computed_delivery_date` varchar(32) DEFAULT NULL COMMENT '系统预计交付日期',
  `adjust_note` varchar(500) DEFAULT NULL COMMENT '调整说明',
  `work_order_id` varchar(64) DEFAULT NULL COMMENT '生产工单ID',
  `work_order_code` varchar(64) DEFAULT NULL COMMENT '生产工单编号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `idx_sp_production_order_item_order` (`order_id`),
  KEY `idx_sp_production_order_item_product` (`product_materiel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生产计划中心-订单明细';

CREATE TABLE IF NOT EXISTS `sp_production_order_oper_plan` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `order_id` varchar(64) NOT NULL COMMENT '生产订单ID',
  `order_item_id` varchar(64) NOT NULL COMMENT '生产订单明细ID',
  `order_no` varchar(64) DEFAULT NULL COMMENT '生产订单编号',
  `product_materiel` varchar(128) DEFAULT NULL COMMENT '产品物料编码',
  `product_name` varchar(255) DEFAULT NULL COMMENT '产品名称',
  `flow_id` varchar(64) DEFAULT NULL COMMENT '工艺路线ID',
  `oper_id` varchar(64) DEFAULT NULL COMMENT '工序ID',
  `oper` varchar(128) DEFAULT NULL COMMENT '工序编码',
  `oper_desc` varchar(255) DEFAULT NULL COMMENT '工序名称',
  `sort_num` int DEFAULT NULL COMMENT '工序顺序',
  `unit_id` varchar(64) DEFAULT NULL COMMENT '加工单元',
  `plan_start_time` varchar(32) DEFAULT NULL COMMENT '计划开始时间',
  `plan_end_time` varchar(32) DEFAULT NULL COMMENT '计划结束时间',
  `duration_hours` decimal(12,2) DEFAULT NULL COMMENT '计划工时',
  `duration_source` varchar(32) DEFAULT NULL COMMENT '工时来源',
  `schedule_method` varchar(32) DEFAULT NULL COMMENT '排产方式',
  `calc_remark` varchar(500) DEFAULT NULL COMMENT '计算说明',
  `is_deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '软删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `idx_po_oper_plan_order` (`order_id`),
  KEY `idx_po_oper_plan_item` (`order_item_id`),
  KEY `idx_po_oper_plan_oper` (`oper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生产计划中心-工序排产明细';

CREATE TABLE IF NOT EXISTS `sp_order_oper_equipment_assign` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `order_id` varchar(64) DEFAULT NULL COMMENT '生产工单ID',
  `order_code` varchar(64) DEFAULT NULL COMMENT '生产工单编号',
  `production_order_id` varchar(64) NOT NULL COMMENT '生产订单ID',
  `order_item_id` varchar(64) NOT NULL COMMENT '生产订单明细ID',
  `oper_plan_id` varchar(64) NOT NULL COMMENT '工序计划ID',
  `oper_id` varchar(64) DEFAULT NULL COMMENT '工序ID',
  `oper` varchar(128) DEFAULT NULL COMMENT '工序编码',
  `oper_desc` varchar(255) DEFAULT NULL COMMENT '工序名称',
  `sort_num` int DEFAULT NULL COMMENT '工序顺序',
  `unit_id` varchar(64) DEFAULT NULL COMMENT '加工单元ID',
  `equipment_id` varchar(64) DEFAULT NULL COMMENT '设备ID',
  `equipment_code` varchar(128) DEFAULT NULL COMMENT '设备编号',
  `equipment_name` varchar(255) DEFAULT NULL COMMENT '设备名称',
  `status` varchar(32) NOT NULL DEFAULT 'WAIT' COMMENT '派工状态 WAIT/ASSIGNED',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '软删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_equipment_assign_plan` (`oper_plan_id`),
  KEY `idx_equipment_assign_order` (`production_order_id`),
  KEY `idx_equipment_assign_equipment` (`equipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生产计划中心-设备作业派工';

DROP PROCEDURE IF EXISTS `sp_add_column_if_missing`;
DELIMITER //
CREATE PROCEDURE `sp_add_column_if_missing`(IN p_table varchar(64), IN p_column varchar(64), IN p_sql text)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_column
  ) THEN
    SET @alter_sql = p_sql;
    PREPARE stmt FROM @alter_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
END//
DELIMITER ;

CALL sp_add_column_if_missing('sp_production_order', 'approval_status', 'ALTER TABLE sp_production_order ADD COLUMN approval_status varchar(32) NOT NULL DEFAULT ''DRAFT'' COMMENT ''审核状态'' AFTER status');
CALL sp_add_column_if_missing('sp_production_order', 'operation_status', 'ALTER TABLE sp_production_order ADD COLUMN operation_status varchar(32) NOT NULL DEFAULT ''NONE'' COMMENT ''下发状态'' AFTER approval_status');
CALL sp_add_column_if_missing('sp_production_order', 'creation_method', 'ALTER TABLE sp_production_order ADD COLUMN creation_method varchar(32) NOT NULL DEFAULT ''MANUAL'' COMMENT ''创建方式'' AFTER operation_status');
CALL sp_add_column_if_missing('sp_production_order', 'scheduling_method', 'ALTER TABLE sp_production_order ADD COLUMN scheduling_method varchar(32) NOT NULL DEFAULT ''REVERSE'' COMMENT ''排产方式'' AFTER creation_method');
CALL sp_add_column_if_missing('sp_production_order', 'erp_source_no', 'ALTER TABLE sp_production_order ADD COLUMN erp_source_no varchar(128) DEFAULT NULL COMMENT ''ERP来源单号'' AFTER scheduling_method');
CALL sp_add_column_if_missing('sp_production_order', 'erp_sync_time', 'ALTER TABLE sp_production_order ADD COLUMN erp_sync_time varchar(32) DEFAULT NULL COMMENT ''ERP同步时间'' AFTER erp_source_no');
CALL sp_add_column_if_missing('sp_production_order_item', 'bom_id', 'ALTER TABLE sp_production_order_item ADD COLUMN bom_id varchar(64) DEFAULT NULL COMMENT ''BOM ID'' AFTER product_name');
CALL sp_add_column_if_missing('sp_production_order_item', 'bom_code', 'ALTER TABLE sp_production_order_item ADD COLUMN bom_code varchar(128) DEFAULT NULL COMMENT ''BOM编码'' AFTER bom_id');
CALL sp_add_column_if_missing('sp_production_order_item', 'bom_version', 'ALTER TABLE sp_production_order_item ADD COLUMN bom_version varchar(64) DEFAULT NULL COMMENT ''BOM版本'' AFTER bom_code');
DROP PROCEDURE IF EXISTS `sp_add_column_if_missing`;

INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
SELECT 'production_order_center', 'productionOrderCenter', '生产计划中心', '#', '1', '2', 3, '0', 'productionOrder:view', 'fa fa-calendar-check-o', '生产计划中心', NOW(), 'admin', NOW(), 'admin'
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_menu` WHERE `id` = 'production_order_center');

UPDATE `sp_sys_menu`
SET `name` = '生产计划中心', `descr` = '生产计划中心', `url` = '#', `parent_id` = '1',
    `grade` = '2', `sort_num` = 3, `icon` = 'fa fa-calendar-check-o',
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `id` = 'production_order_center';

INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
SELECT 'production_order_plan', 'productionOrderPlan', '生产订单录入', '/production-order/plan/list-ui', 'production_order_center', '3', 1, '0', 'productionOrder:plan', 'fa fa-pencil-square-o', '生产订单录入', NOW(), 'admin', NOW(), 'admin'
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_menu` WHERE `id` = 'production_order_plan');

UPDATE `sp_sys_menu`
SET `name` = '生产订单录入', `descr` = '生产订单录入', `url` = '/production-order/plan/list-ui',
    `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 1,
    `permission` = 'productionOrder:plan', `icon` = 'fa fa-pencil-square-o',
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `id` = 'production_order_plan';

INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
SELECT menu_id, menu_code, menu_name, menu_url, 'production_order_center', '3', menu_sort, '0', menu_permission, menu_icon, menu_name, NOW(), 'admin', NOW(), 'admin'
FROM (
  SELECT 'production_equipment_dispatch' menu_id, 'productionEquipmentDispatch' menu_code, '设备作业派工' menu_name, '/production-order/equipment-dispatch/list-ui' menu_url, 2 menu_sort, 'productionOrder:equipmentDispatch' menu_permission, 'fa fa-cogs' menu_icon
  UNION ALL SELECT 'production_employee_dispatch', 'productionEmployeeDispatch', '员工作业派工', '/production-order/employee-dispatch/list-ui', 3, 'productionOrder:employeeDispatch', 'fa fa-users'
  UNION ALL SELECT 'production_plan_dispatch', 'productionPlanDispatch', '生产计划下发', '/production-order/dispatch/list-ui', 7, 'productionOrder:dispatch', 'fa fa-send'
  UNION ALL SELECT 'production_work_order_query', 'productionWorkOrderQuery', '生产工单查询', '/production-order/work-order/list-ui', 8, 'productionOrder:workOrder', 'fa fa-list-alt'
) menus
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_menu` sm WHERE sm.`id` = menus.menu_id);

UPDATE `sp_sys_menu` SET `name` = '设备作业派工', `descr` = '设备作业派工', `url` = '/production-order/equipment-dispatch/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 2, `permission` = 'productionOrder:equipmentDispatch', `icon` = 'fa fa-cogs', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'production_equipment_dispatch';
UPDATE `sp_sys_menu` SET `name` = '员工作业派工', `descr` = '员工作业派工', `url` = '/production-order/employee-dispatch/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 3, `permission` = 'productionOrder:employeeDispatch', `icon` = 'fa fa-users', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'production_employee_dispatch';
UPDATE `sp_sys_menu` SET `name` = '生产计划下发', `descr` = '生产计划下发', `url` = '/production-order/dispatch/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 7, `permission` = 'productionOrder:dispatch', `icon` = 'fa fa-send', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'production_plan_dispatch';
UPDATE `sp_sys_menu` SET `name` = '生产工单查询', `descr` = '生产工单查询', `url` = '/production-order/work-order/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 8, `permission` = 'productionOrder:workOrder', `icon` = 'fa fa-list-alt', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'production_work_order_query';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin', '888888', 'productionPlannerRole', 'productionManagerRole')
  AND m.id IN ('production_order_center', 'production_order_plan', 'production_plan_dispatch',
               'production_work_order_query', 'production_equipment_dispatch', 'production_employee_dispatch')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
