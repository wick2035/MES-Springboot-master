-- ============================================================
-- 库存管理升级脚本
-- 日期：2026-06-08
-- 内容：建表 sp_inventory（库位+物料+数量）+ 菜单（基础数据中心 → 库存管理）+ 管理员授权
-- 说明：可重复执行（IF NOT EXISTS / INSERT IGNORE / NOT EXISTS 子查询）
--       库存供「数字仿真3D仓库」按真实数据放置货物盒
-- 执行示例：mysql --default-character-set=utf8mb4 -u root -p sparchetype < inventory-upgrade-20260608.sql
-- ============================================================

-- ----------------------------
-- 1. 库存表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_inventory` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `warehouse_id` varchar(64) NOT NULL COMMENT '所属库房ID',
  `location_id` varchar(64) NOT NULL COMMENT '所属库位ID',
  `materiel_id` varchar(64) NOT NULL COMMENT '物料ID',
  `batch_no` varchar(128) DEFAULT NULL COMMENT '批号',
  `qty` decimal(18,4) DEFAULT '0.0000' COMMENT '数量',
  `unit` varchar(32) DEFAULT NULL COMMENT '单位（保存时从物料带出）',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_warehouse` (`warehouse_id`),
  KEY `idx_location` (`location_id`),
  KEY `idx_materiel` (`materiel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存表';

-- ----------------------------
-- 2. 菜单：挂到已存在的「基础数据中心」父菜单（base_data_center）下
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('inventory_mgmt', 'inventoryMgmt', '库存管理', '/basedata/inventory/list-ui', 'base_data_center', '3', 3, '0', 'user:add', 'fa fa-archive', '库存管理', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 3. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('inventory_mgmt')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
