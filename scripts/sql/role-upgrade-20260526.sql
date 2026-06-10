-- ============================================================
-- 角色权限管理增强 - 数据库迁移脚本
-- 创建时间: 2026-05-26
-- ============================================================

-- ----------------------------
-- 1. 扩展 sp_sys_role 表字段
-- ----------------------------
ALTER TABLE `sp_sys_role`
  MODIFY COLUMN `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用';

ALTER TABLE `sp_sys_role`
  ADD COLUMN `sort_num`       int(11)     NOT NULL DEFAULT 0    COMMENT '排序号'           AFTER `descr`,
  ADD COLUMN `is_system_role` char(1)     NOT NULL DEFAULT '0'  COMMENT '系统角色(0否1是)'  AFTER `sort_num`,
  ADD COLUMN `user_type`      varchar(32) DEFAULT NULL           COMMENT '用户类型'          AFTER `is_system_role`,
  ADD COLUMN `role_category`  varchar(32) DEFAULT NULL           COMMENT '角色分类'          AFTER `user_type`,
  ADD COLUMN `data_scope`     varchar(32) DEFAULT NULL           COMMENT '数据范围'          AFTER `role_category`,
  ADD COLUMN `business_scope` varchar(32) DEFAULT NULL           COMMENT '业务范围'          AFTER `data_scope`;

-- ----------------------------
-- 2. 字典数据：用户类型 user_type
-- ----------------------------
INSERT INTO `sp_sys_dict` (id, name, value, type, descr, sort_num, parent_id, is_deleted, create_time, create_username, update_time, update_username) VALUES
('roledict001', '员工',   'employee',  'user_type', '用户类型-员工',   1, '""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict002', '管理员', 'manager',   'user_type', '用户类型-管理员', 2, '""', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 3. 字典数据：角色分类 role_category
-- ----------------------------
INSERT INTO `sp_sys_dict` (id, name, value, type, descr, sort_num, parent_id, is_deleted, create_time, create_username, update_time, update_username) VALUES
('roledict011', '普通角色', 'normal',   'role_category', '角色分类-普通角色', 1, '""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict012', '系统角色', 'system',   'role_category', '角色分类-系统角色', 2, '""', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 4. 字典数据：数据范围 data_scope
-- ----------------------------
INSERT INTO `sp_sys_dict` (id, name, value, type, descr, sort_num, parent_id, is_deleted, create_time, create_username, update_time, update_username) VALUES
('roledict021', '全部数据',       'all',       'data_scope', '数据范围-全部',         1, '""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict022', '本部门',         'dept',      'data_scope', '数据范围-本部门',       2, '""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict023', '本部门及子部门', 'dept_child','data_scope', '数据范围-本部门及子部门',3,'""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict024', '仅本人',         'self',      'data_scope', '数据范围-仅本人',       4, '""', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 5. 字典数据：业务范围 business_scope
-- ----------------------------
INSERT INTO `sp_sys_dict` (id, name, value, type, descr, sort_num, parent_id, is_deleted, create_time, create_username, update_time, update_username) VALUES
('roledict031', '全部业务',     'all',       'business_scope', '业务范围-全部',     1, '""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict032', '本部门业务',   'dept',      'business_scope', '业务范围-本部门',   2, '""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict033', '指定业务模块', 'specified', 'business_scope', '业务范围-指定模块', 3, '""', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 6. 插入7个预设角色（IGNORE 跳过已存在的记录）
-- ----------------------------
INSERT IGNORE INTO `sp_sys_role` (id, name, code, descr, sort_num, is_system_role, user_type, role_category, is_deleted, create_time, create_username, update_time, update_username) VALUES
('r_mes_001', '数据员',    'baseDataRole',          '基础数据管理角色，负责物料、基础配置等数据维护',     10, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin'),
('r_mes_002', '工艺员',    'technologyRole',        '产品工艺管理角色，负责BOM和工艺路线维护',           20, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin'),
('r_mes_003', '生产计划员','productionPlannerRole',  '生产计划管理角色，负责工单下达和生产计划',           30, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin'),
('r_mes_004', '生产主管',  'productionManagerRole', '生产及设备管理角色，负责生产计划和设备管理',         40, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin'),
('r_mes_005', '生产作业员','productionOperatorRole', '生产执行角色，负责在制品过程采集和生产执行',         50, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin'),
('r_mes_006', '库房管理员','warehouseManagerRole',   '库房管理角色，负责库存和物料出入库管理',             60, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin'),
('r_mes_007', '质量管理员','qualityManagerRole',     '质量管理角色，负责质量检验和质量报表',               70, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 7. 预设角色菜单分配（基于现有菜单结构）
-- 说明：通过 menu code 关联，适应不同部署环境的菜单ID
-- ----------------------------

-- 数据员 → 常规管理根节点 + 物料管理模块 + 基础数据配置
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_001', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'materiel', 'matdef', 'basedata', 'basedatamanager', 'system');

-- 工艺员 → 常规管理根节点 + 工艺管理模块（工艺路线、BOM）
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_002', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'ProcessManage', 'flowProcess', 'bom');

-- 生产计划员 → 常规管理根节点 + 计划管理模块
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_003', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'order', 'orderRelease');

-- 生产主管 → 常规管理根节点 + 计划管理 + 数字化平台（含看板大屏，近似设备管理）
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_004', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'order', 'orderRelease', 'Digitalplatform', 'plandg');

-- 生产作业员 → 常规管理根节点 + 在制品管理（生产执行）
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_005', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'wip', 'generalSnProcess');

-- 库房管理员 → 常规管理根节点 + 物料管理（库房模块待扩展时补充）
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_006', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'materiel', 'matdef');

-- 质量管理员 → 常规管理根节点 + 数字化平台（质量模块待扩展时补充）
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_007', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'Digitalplatform', 'plandg');

-- ----------------------------
-- 8. 角色管理直接挂在"系统管理"目录下（已取消多余的"权限管理"中间目录，见 menu-role-flatten-upgrade-20260609.sql）
-- ----------------------------
UPDATE `sp_sys_menu` SET parent_id = '10', grade = '3', sort_num = 3 WHERE id = '103';

-- ----------------------------
-- 9. 给 code='888888' 的角色（系统管理员）分配全部菜单
-- 先清空该角色原有菜单关联，再重新插入全量菜单
-- ----------------------------
DELETE srm FROM `sp_sys_role_menu` srm
INNER JOIN `sp_sys_role` r ON r.id = srm.role_id
WHERE r.code = '888888';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888';
