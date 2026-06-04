-- ============================================================
-- 编组设备定义（4.1 资源分配管理）升级脚本
-- 日期：2026-06-04
-- 内容：建表 sp_equipment_group / sp_equipment_group_device
--       + 菜单（基础数据中心 → 编组设备定义）+ 管理员授权
-- 说明：可重复执行（IF NOT EXISTS / INSERT IGNORE / NOT EXISTS 子查询）
-- ============================================================

-- ----------------------------
-- 1. 设备编组表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_equipment_group` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `group_code` varchar(64) NOT NULL COMMENT '编组编号',
  `group_name` varchar(255) DEFAULT NULL COMMENT '编组名称',
  `group_desc` varchar(500) DEFAULT NULL COMMENT '编组描述',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除 2禁用',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_code` (`group_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备编组表';

-- ----------------------------
-- 2. 编组-设备关系表（多对多）
-- 唯一性「同编组不重复同设备」在 Service 层校验（仅对 is_deleted='0' 生效），不加 DB 唯一索引，避免软删后再加入冲突
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_equipment_group_device` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `group_id` varchar(64) NOT NULL COMMENT '编组ID',
  `equipment_id` varchar(64) NOT NULL COMMENT '设备ID',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_group` (`group_id`),
  KEY `idx_equipment` (`equipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='编组设备关系表';

-- ----------------------------
-- 3. 菜单：基础数据中心（已存在则忽略）+ 「编组设备定义」子菜单
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('base_data_center', 'baseDataCenter', '基础数据中心', '#',                                '1',                '2', 7, '0', 'user:add', 'fa fa-database', '基础数据中心', NOW(), 'admin', NOW(), 'admin'),
('bianzu_def',       'bianzuDef',      '编组设备定义', '/basedata/equipment-group/list-ui', 'base_data_center', '3', 2, '0', 'user:add', 'fa fa-wrench',   '编组设备定义', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 4. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('base_data_center', 'bianzu_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
