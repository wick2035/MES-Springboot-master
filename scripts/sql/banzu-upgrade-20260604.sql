-- ============================================================
-- 班组管理 + 班组员工管理（4.1 资源分配管理）升级脚本
-- 日期：2026-06-04
-- 内容：建表 sp_team / sp_team_employee + 菜单（基础数据中心 → 班组员工定义）+ 管理员授权
-- 说明：可重复执行（IF NOT EXISTS / INSERT IGNORE / NOT EXISTS 子查询）
-- ============================================================

-- ----------------------------
-- 1. 班组表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_team` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `team_code` varchar(64) NOT NULL COMMENT '班组代码',
  `team_name` varchar(255) NOT NULL COMMENT '班组名称',
  `team_desc` varchar(500) DEFAULT NULL COMMENT '班组描述',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除 2禁用',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_team_code` (`team_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班组表';

-- ----------------------------
-- 2. 班组员工关系表（多对多）
-- 唯一性「同班组不重复同员工」在 Service 层校验（仅对 is_deleted='0' 生效），不加 DB 唯一索引，避免软删后再加入冲突
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_team_employee` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `team_id` varchar(64) NOT NULL COMMENT '班组ID',
  `user_id` varchar(64) NOT NULL COMMENT '员工(用户)ID',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_team` (`team_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班组员工关系表';

-- ----------------------------
-- 3. 菜单：新建「基础数据中心」父菜单 + 「班组员工定义」子菜单
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('base_data_center', 'baseDataCenter', '基础数据中心', '#',                      '1',                '2', 7, '0', 'user:add', 'fa fa-database', '基础数据中心', NOW(), 'admin', NOW(), 'admin'),
('banzu_def',        'banzuDef',       '班组员工定义', '/basedata/team/list-ui', 'base_data_center', '3', 1, '0', 'user:add', 'fa fa-users',    '班组员工定义', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 4. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('base_data_center', 'banzu_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
