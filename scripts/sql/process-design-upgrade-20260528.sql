-- ============================================================
-- 工艺设计管理增强 - 数据库迁移脚本
-- 创建时间: 2026-05-28
-- 内容：
--   1) 新增 加工单元、设备 主数据
--   2) 扩展 sp_oper（工序信息定义）字段
--   3) 新增 工艺流程管理（按BOM节点绑定工序）
--   4) 新增 工艺内容编制（7步向导）相关表
--   5) 菜单和角色权限同步
-- ============================================================

-- ----------------------------
-- 1. 加工单元 sp_processing_unit
-- ----------------------------
DROP TABLE IF EXISTS `sp_processing_unit`;
CREATE TABLE `sp_processing_unit` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `unit_code`       varchar(32)  NOT NULL                COMMENT '加工单元编号 JG000001',
  `unit_name`       varchar(128) NOT NULL                COMMENT '加工单元名称',
  `unit_type`       varchar(32)  NOT NULL DEFAULT 'person' COMMENT '加工单元类型 person=人员作业单元 device=设备作业单元',
  `description`     varchar(500) DEFAULT NULL            COMMENT '描述',
  `status`          char(1)      NOT NULL DEFAULT '0'    COMMENT '状态 0正常 2异常',
  `is_deleted`      char(1)      NOT NULL DEFAULT '0'    COMMENT '是否删除',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  `update_time`     datetime     NOT NULL                COMMENT '最后更新时间',
  `update_username` varchar(64)  NOT NULL                COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unit_code` (`unit_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='加工单元主数据';

INSERT INTO `sp_processing_unit` VALUES
('jg_unit_001', 'JG000001', '电脑组装单元', 'person', 'PDF示例-电脑组装作业人员单元', '0', '0', NOW(), 'admin', NOW(), 'admin'),
('jg_unit_002', 'JG000002', '加工单元1',     'device', 'PDF示例-轮毂上线工序所属单元',   '0', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 2. 设备 sp_equipment
-- ----------------------------
DROP TABLE IF EXISTS `sp_equipment`;
CREATE TABLE `sp_equipment` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `equipment_code`  varchar(32)  NOT NULL                COMMENT '设备编号 EQ000001',
  `equipment_name`  varchar(128) NOT NULL                COMMENT '设备名称',
  `equipment_model` varchar(128) DEFAULT NULL            COMMENT '设备规格/型号',
  `purpose`         varchar(255) DEFAULT NULL            COMMENT '设备用途',
  `spec`            varchar(255) DEFAULT NULL            COMMENT '设定条件',
  `status`          char(1)      NOT NULL DEFAULT '1'    COMMENT '状态 1启用 0停用',
  `is_deleted`      char(1)      NOT NULL DEFAULT '0'    COMMENT '是否删除',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  `update_time`     datetime     NOT NULL                COMMENT '最后更新时间',
  `update_username` varchar(64)  NOT NULL                COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_equipment_code` (`equipment_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备主数据';

INSERT INTO `sp_equipment` VALUES
('eq_001', 'EQ000001', '吊车',       '123',       '物料搬运',          '',     '1', '0', NOW(), 'admin', NOW(), 'admin'),
('eq_002', 'EQ000002', '主板测试夹具', 'GJ-PCB-01', '主板安装与测试的夹具', '',     '1', '0', NOW(), 'admin', NOW(), 'admin'),
('eq_003', 'EQ000003', '瓶体夹具',    '',          '瓶体加工夹具',      '',     '1', '0', NOW(), 'admin', NOW(), 'admin'),
('eq_004', 'EQ000004', '手指套',     '',          '装配防护',          '防静电', '1', '0', NOW(), 'admin', NOW(), 'admin'),
('eq_005', 'EQ000005', '静电环',     'OWS20A',    '装配防静电',         '',     '1', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 3. 扩展 sp_oper（工序信息定义）
-- ----------------------------
ALTER TABLE `sp_oper`
  ADD COLUMN `unit_id`     varchar(64)   DEFAULT NULL  COMMENT '加工单元ID'                  AFTER `oper_desc`,
  ADD COLUMN `oper_hours`  decimal(8,2)  DEFAULT 0     COMMENT '工序工时(h)'                 AFTER `unit_id`,
  ADD COLUMN `manu_cycle`  decimal(8,2)  DEFAULT 0     COMMENT '制造周期(h)'                 AFTER `oper_hours`,
  ADD COLUMN `gen_plan`    char(1)       DEFAULT 'Y'   COMMENT '是否生成生产计划 Y是 N否'    AFTER `manu_cycle`,
  ADD COLUMN `remark`      varchar(500)  DEFAULT NULL  COMMENT '备注信息'                   AFTER `gen_plan`;

-- ----------------------------
-- 4. 工艺流程管理 sp_process_route （按BOM节点绑定工序）
-- ----------------------------
DROP TABLE IF EXISTS `sp_process_route`;
CREATE TABLE `sp_process_route` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `bom_id`          varchar(64)  NOT NULL                COMMENT '所属BOM',
  `bom_item_id`     varchar(64)  DEFAULT NULL            COMMENT 'BOM节点ID（空表示根产品节点）',
  `route_code`      varchar(128) NOT NULL                COMMENT '工艺编号 NGY_3_M000003_001_001',
  `parent_route_id` varchar(64)  DEFAULT NULL            COMMENT '上级工艺ID',
  `node_name`       varchar(128) NOT NULL                COMMENT '节点名称（冗余便于显示）',
  `materiel_code`   varchar(64)  DEFAULT NULL            COMMENT '物料编码（冗余）',
  `oper_id`         varchar(64)  DEFAULT NULL            COMMENT '绑定的工序ID',
  `seq_no`          int(11)      NOT NULL DEFAULT 30     COMMENT '排序号 30/60/90',
  `lock_status`     varchar(10)  NOT NULL DEFAULT 'draft' COMMENT 'draft草稿 locked已锁定',
  `edit_status`     varchar(10)  NOT NULL DEFAULT 'pending' COMMENT 'pending未编制 editing编制中 completed已完成',
  `is_deleted`      char(1)      NOT NULL DEFAULT '0'    COMMENT '是否删除',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  `update_time`     datetime     NOT NULL                COMMENT '最后更新时间',
  `update_username` varchar(64)  NOT NULL                COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_route_code` (`route_code`),
  KEY `idx_bom_id` (`bom_id`),
  KEY `idx_parent_route_id` (`parent_route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='产品工艺流程（按BOM节点）';

-- ----------------------------
-- 5. 工艺内容编制 sp_process_content （主表）
-- ----------------------------
DROP TABLE IF EXISTS `sp_process_content`;
CREATE TABLE `sp_process_content` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `route_id`        varchar(64)  NOT NULL                COMMENT '工艺ID FK sp_process_route',
  `content_text`    text         DEFAULT NULL            COMMENT '工序内容文本',
  `require_text`    text         DEFAULT NULL            COMMENT '工序要求文本',
  `need_check`      char(1)      NOT NULL DEFAULT 'Y'    COMMENT '是否需要检验',
  `precaution_text` text         DEFAULT NULL            COMMENT '注意事项文本',
  `tech_doc_desc`   varchar(500) DEFAULT NULL            COMMENT '技术文档描述',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  `update_time`     datetime     NOT NULL                COMMENT '最后更新时间',
  `update_username` varchar(64)  NOT NULL                COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_route_id` (`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工艺内容编制主表';

-- ----------------------------
-- 6. 工艺文件 sp_process_file （图片/附件）
-- ----------------------------
DROP TABLE IF EXISTS `sp_process_file`;
CREATE TABLE `sp_process_file` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `route_id`        varchar(64)  NOT NULL                COMMENT '工艺ID',
  `file_type`       varchar(32)  NOT NULL                COMMENT 'CONTENT_IMG/REQ_IMG/PREC_IMG/TECH_IMG/TECH_ATTACH',
  `file_path`       varchar(500) NOT NULL                COMMENT '相对路径（不含access-prefix）',
  `original_name`   varchar(255) NOT NULL                COMMENT '原始文件名',
  `file_size`       bigint       NOT NULL DEFAULT 0      COMMENT '文件大小（字节）',
  `sort_no`         int(11)      NOT NULL DEFAULT 0      COMMENT '排序',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `idx_route_type` (`route_id`, `file_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工艺内容文件附件';

-- ----------------------------
-- 7. 工装设备关联 sp_process_equipment_rel
-- ----------------------------
DROP TABLE IF EXISTS `sp_process_equipment_rel`;
CREATE TABLE `sp_process_equipment_rel` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `route_id`        varchar(64)  NOT NULL                COMMENT '工艺ID',
  `equipment_id`    varchar(64)  NOT NULL                COMMENT '设备ID',
  `req_qty`         int(11)      NOT NULL DEFAULT 1      COMMENT '需求数量',
  `remark`          varchar(500) DEFAULT NULL            COMMENT '备注',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `idx_route_id` (`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工艺-工装设备关联';

-- ----------------------------
-- 8. 备料清单 sp_process_material_rel
-- ----------------------------
DROP TABLE IF EXISTS `sp_process_material_rel`;
CREATE TABLE `sp_process_material_rel` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `route_id`        varchar(64)  NOT NULL                COMMENT '工艺ID',
  `materiel_id`     varchar(64)  NOT NULL                COMMENT '物料ID',
  `req_qty`         decimal(12,3) NOT NULL DEFAULT 1     COMMENT '需求数量',
  `remark`          varchar(500) DEFAULT NULL            COMMENT '备注',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `idx_route_id` (`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工艺-备料清单';

-- ----------------------------
-- 9. 菜单：将15重命名为"产品数据中心"，新增4个子菜单 + 加工单元/设备
-- ----------------------------
UPDATE `sp_sys_menu` SET `name` = '产品数据中心', `icon` = 'fa fa-cubes' WHERE `id` = '15';

INSERT IGNORE INTO `sp_sys_menu` (id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('153', 'sp_oper_def',      '工序信息定义', '/technology/oper/list-ui',           '15', '3', 3, '0', 'user:add', 'fa fa-thumb-tack',  '工序信息定义', NOW(), 'admin', NOW(), 'admin'),
('154', 'process_route',    '工艺流程管理', '/technology/process-route/tree-ui',  '15', '3', 4, '0', 'user:add', 'fa fa-sitemap',     '工艺流程管理', NOW(), 'admin', NOW(), 'admin'),
('155', 'process_content',  '工艺内容编制', '/technology/process-content/tree-ui','15', '3', 5, '0', 'user:add', 'fa fa-edit',        '工艺内容编制', NOW(), 'admin', NOW(), 'admin'),
('156', 'process_query',    '产品工艺查询', '/technology/process-query/tree-ui',  '15', '3', 6, '0', 'user:add', 'fa fa-search',      '产品工艺查询', NOW(), 'admin', NOW(), 'admin');

-- 加工单元、设备 挂在 13 物料管理下（同属基础主数据）
INSERT IGNORE INTO `sp_sys_menu` (id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('132', 'processing_unit', '加工单元', '/basedata/processing-unit/list-ui', '13', '3', 2, '0', 'user:add', 'fa fa-cog',     '加工单元主数据', NOW(), 'admin', NOW(), 'admin'),
('133', 'equipment',       '设备',     '/basedata/equipment/list-ui',       '13', '3', 3, '0', 'user:add', 'fa fa-wrench',  '设备主数据',     NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 10. 系统管理员（code='888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('153','154','155','156','132','133')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );

-- 工艺员角色授权工艺相关菜单
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_002', m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_menu` m
WHERE m.id IN ('153','154','155','156')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = 'r_mes_002' AND srm.menu_id = m.id
  );

-- 数据员角色授权主数据菜单
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_001', m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_menu` m
WHERE m.id IN ('132','133')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = 'r_mes_001' AND srm.menu_id = m.id
  );
