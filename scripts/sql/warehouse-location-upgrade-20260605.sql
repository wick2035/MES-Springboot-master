-- ============================================================
-- 库房库位定义（4.1 资源分配管理）升级脚本
-- 日期：2026-06-05
-- 内容：建表 sp_warehouse / sp_warehouse_location + 菜单（基础数据中心 → 库房库位定义）+ 管理员授权
-- 说明：可重复执行（IF NOT EXISTS / INSERT IGNORE / NOT EXISTS 子查询）
--       库位按库房规格（组×排×层×列）自动生成，编码 = 库房码-组-排-层-列，由后端 Service 生成
-- ============================================================

-- ----------------------------
-- 1. 库房表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_warehouse` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `warehouse_code` varchar(64) NOT NULL COMMENT '库房编码',
  `warehouse_name` varchar(255) NOT NULL COMMENT '库房名称',
  `warehouse_type` varchar(2) NOT NULL COMMENT '库房类型 1原材料库 2成品库 3半成品库',
  `warehouse_desc` varchar(500) DEFAULT NULL COMMENT '库房描述',
  `spec_group` int(11) DEFAULT NULL COMMENT '规格-组',
  `spec_row` int(11) DEFAULT NULL COMMENT '规格-排',
  `spec_layer` int(11) DEFAULT NULL COMMENT '规格-层',
  `spec_column` int(11) DEFAULT NULL COMMENT '规格-列',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除 2禁用',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_warehouse_code` (`warehouse_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库房表';

-- ----------------------------
-- 2. 库位表（依库房规格自动生成）
-- 库位编码唯一性「同编码不重复」由生成逻辑保证（库房码-组-排-层-列），不加 DB 唯一索引，避免重新生成软删后冲突
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_warehouse_location` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `warehouse_id` varchar(64) NOT NULL COMMENT '所属库房ID',
  `location_code` varchar(128) NOT NULL COMMENT '库位编码 如 KF001-1-2-3-4',
  `group_no` int(11) DEFAULT NULL COMMENT '坐标-组',
  `row_no` int(11) DEFAULT NULL COMMENT '坐标-排',
  `layer_no` int(11) DEFAULT NULL COMMENT '坐标-层',
  `column_no` int(11) DEFAULT NULL COMMENT '坐标-列',
  `status` varchar(2) NOT NULL DEFAULT '0' COMMENT '状态 0正常 2禁用',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库位表';

-- ----------------------------
-- 3. 菜单：挂到已存在的「基础数据中心」父菜单（base_data_center）下
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('base_data_center', 'baseDataCenter', '基础数据中心', '#',                            '1',                '2', 7, '0', 'user:add', 'fa fa-database', '基础数据中心',   NOW(), 'admin', NOW(), 'admin'),
('cangku_def',       'cangkuDef',      '库房库位定义', '/basedata/warehouse/list-ui', 'base_data_center', '3', 2, '0', 'user:add', 'fa fa-cube',     '库房库位定义', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 4. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('base_data_center', 'cangku_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
