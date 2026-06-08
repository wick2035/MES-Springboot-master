-- ============================================================
-- 物料信息定义升级脚本（4.1 资源分配管理 - 物料信息定义）
-- 日期：2026-06-05
-- 内容：sp_materile 新增字段（来源/材质/提前期/安全库存/图片/备注）
--      + 字典（material_type 补充、material_source、material_texture、ORDER_UNIT 补充）
--      + 菜单（生产数据中心 → 物料信息定义）+ 管理员授权
-- 说明：可重复执行（INFORMATION_SCHEMA 列存在判断 / INSERT ... NOT EXISTS / INSERT IGNORE）
-- ============================================================

-- ----------------------------
-- 1. sp_materile 新增列（MySQL 不支持 ADD COLUMN IF NOT EXISTS，用 INFORMATION_SCHEMA 守卫）
-- ----------------------------

-- 物料来源：SELF=自制 OUT=外购
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND COLUMN_NAME = 'mat_source');
SET @sql := IF(@col = 0,
    'ALTER TABLE `sp_materile` ADD COLUMN `mat_source` varchar(16) NULL DEFAULT NULL COMMENT ''物料来源 SELF自制 OUT外购'' AFTER `model`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 材质
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND COLUMN_NAME = 'texture');
SET @sql := IF(@col = 0,
    'ALTER TABLE `sp_materile` ADD COLUMN `texture` varchar(32) NULL DEFAULT NULL COMMENT ''材质'' AFTER `mat_source`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 物料需求提前期(天)，不可为0，默认1
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND COLUMN_NAME = 'lead_time');
SET @sql := IF(@col = 0,
    'ALTER TABLE `sp_materile` ADD COLUMN `lead_time` int NOT NULL DEFAULT 1 COMMENT ''物料需求提前期(天)，至少1'' AFTER `texture`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 安全库存，可为0
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND COLUMN_NAME = 'safety_stock');
SET @sql := IF(@col = 0,
    'ALTER TABLE `sp_materile` ADD COLUMN `safety_stock` int NOT NULL DEFAULT 0 COMMENT ''安全库存'' AFTER `lead_time`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 图片地址（多张，逗号分隔的相对路径）
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND COLUMN_NAME = 'image_urls');
SET @sql := IF(@col = 0,
    'ALTER TABLE `sp_materile` ADD COLUMN `image_urls` varchar(2000) NULL DEFAULT NULL COMMENT ''物料图片，多张逗号分隔的相对路径'' AFTER `safety_stock`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 备注信息
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND COLUMN_NAME = 'remark');
SET @sql := IF(@col = 0,
    'ALTER TABLE `sp_materile` ADD COLUMN `remark` varchar(500) NULL DEFAULT NULL COMMENT ''备注信息'' AFTER `image_urls`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ----------------------------
-- 2. 字典 sp_sys_dict
-- ----------------------------

-- 2.1 material_type 补充：产品=PRODUCT、标准件=STD、其他=OTHER、原材料=RAW
--     （保留既有 成品FG/半成品PG/组件COMP/零件PART，BOM 层级逻辑依赖其 code）
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '产品' name, 'PRODUCT' value, 'material_type' type, '物料类型-产品' descr, 6 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '标准件', 'STD', 'material_type', '物料类型-标准件', 7, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '其他',  'OTHER', 'material_type', '物料类型-其他', 8, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '原材料', 'RAW', 'material_type', '物料类型-原材料', 9, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'material_type' AND d.value = t.value);

-- 2.2 物料来源 material_source：自制=SELF、外购=OUT
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '自制' name, 'SELF' value, 'material_source' type, '物料来源-自制' descr, 1 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '外购', 'OUT', 'material_source', '物料来源-外购', 2, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'material_source' AND d.value = t.value);

-- 2.3 材质 material_texture：铝=AL、铁=IRON、纸质=PAPER、其他=OTHER
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '铝' name, 'AL' value, 'material_texture' type, '材质-铝' descr, 1 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '铁',   'IRON',  'material_texture', '材质-铁', 2, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '纸质', 'PAPER', 'material_texture', '材质-纸质', 3, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '其他', 'OTHER', 'material_texture', '材质-其他', 4, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'material_texture' AND d.value = t.value);

-- 2.4 计量单位 ORDER_UNIT 补充：套=SET
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT REPLACE(UUID(),'-',''), '套', 'SET', 'ORDER_UNIT', '生产单位', 3, '""', '0', NOW(), 'admin', NOW(), 'admin'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'ORDER_UNIT' AND d.value = 'SET');

-- ----------------------------
-- 3. 菜单：生产数据中心 → 物料信息定义
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('prod_data_center', 'prodDataCenter', '生产数据中心', '#',                          '1',                '2', 8, '0', 'user:add', 'fa fa-database',     '生产数据中心', NOW(), 'admin', NOW(), 'admin'),
('mat_info_def',     'matInfoDef',     '物料信息定义', '/basedata/materile/list-ui', 'prod_data_center', '3', 1, '0', 'user:add', 'fa fa-info-circle', '物料信息定义', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 4. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('prod_data_center', 'mat_info_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
