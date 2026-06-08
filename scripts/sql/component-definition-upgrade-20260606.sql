-- ============================================================
-- 产品零部件定义升级脚本（4.2 BOM与组件数据管理）
-- 日期：2026-06-06
-- 内容：新增 sp_component_def + 菜单（产品数据中心 → 零部件定义）+ 管理员授权
-- 说明：可重复执行（CREATE TABLE IF NOT EXISTS / INSERT IGNORE / NOT EXISTS）
-- ============================================================

-- ----------------------------
-- 1. 零部件定义 sp_component_def
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_component_def` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `product_name`    varchar(128) NOT NULL                COMMENT '产品名称（手工输入）',
  `component_code`  varchar(32)  NOT NULL                COMMENT '零部件编号 BOM000001',
  `component_name`  varchar(128) NOT NULL                COMMENT '零部件名称',
  `component_type`  varchar(16)  NOT NULL DEFAULT 'COMP' COMMENT '零部件类型 PG=半成品 COMP=组件',
  `remark`          varchar(500) DEFAULT NULL            COMMENT '备注信息',
  `is_deleted`      char(1)      NOT NULL DEFAULT '0'    COMMENT '状态 0正常 1删除 2禁用',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  `update_time`     datetime     NOT NULL                COMMENT '最后更新时间',
  `update_username` varchar(64)  NOT NULL                COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_component_code` (`component_code`),
  KEY `idx_component_product` (`product_name`),
  KEY `idx_component_product_name` (`product_name`, `component_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='产品零部件定义';

-- ----------------------------
-- 2. 菜单：产品数据中心 → 零部件定义
-- ----------------------------
UPDATE `sp_sys_menu` SET `name` = '产品数据中心', `icon` = 'fa fa-cubes' WHERE `id` = '15';

INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('component_def', 'componentDef', '零部件定义', '/technology/component/list-ui', '15', '3', 1, '0', 'user:add', 'fa fa-cubes', '零部件定义', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 3. 给系统管理员（role code = 'admin' / '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin', '888888')
  AND m.id IN ('component_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );

-- 工艺员角色授权零部件定义
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_002', m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_menu` m
WHERE m.id IN ('component_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = 'r_mes_002' AND srm.menu_id = m.id
  );
