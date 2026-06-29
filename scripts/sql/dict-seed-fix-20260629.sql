-- ============================================================
-- 字典补种修复脚本（sp_sys_dict 整表为空导致下拉无数据）
-- 日期：2026-06-29
-- 现象：产品数据中心 → 物料信息定义 → 新增物料，4 个下拉（物料类型/物料来源/
--      计量单位/材质）全空。根因：sp_sys_dict 表 0 行。同表为空还导致角色管理
--      相关下拉为空。本脚本把全套标准字典补回。
-- 说明：幂等，可重复执行。每条用 WHERE NOT EXISTS(type+value) 守卫，不重复、不覆盖已有数据。
-- 执行：mysql --default-character-set=utf8mb4 -h127.0.0.1 -uroot -p20041118 \
--           sparchetype-test < scripts/sql/dict-seed-fix-20260629.sql
-- 字典来源对齐：full-install-demo-20260625.sql / material-info-upgrade-20260605.sql
-- ============================================================

-- ----------------------------
-- 1. 物料类型 material_type
--    成品 FG、半成品 PG、组件 COMP、零件 PART、产品 PRODUCT、标准件 STD、原材料 RAW、其他 OTHER
-- ----------------------------
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '成品'   name, 'FG'      value, 'material_type' type, '物料类型-成品'   descr, 2 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '半成品', 'PG',      'material_type', '物料类型-半成品', 3, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '组件',   'COMP',    'material_type', '物料类型-组件',   4, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '零件',   'PART',    'material_type', '物料类型-零件',   5, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '产品',   'PRODUCT', 'material_type', '物料类型-产品',   6, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '标准件', 'STD',     'material_type', '物料类型-标准件', 7, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '原材料', 'RAW',     'material_type', '物料类型-原材料', 9, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '其他',   'OTHER',   'material_type', '物料类型-其他',   8, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'material_type' AND d.value = t.value);

-- ----------------------------
-- 2. 物料来源 material_source：自制 SELF、外购 OUT
-- ----------------------------
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '自制' name, 'SELF' value, 'material_source' type, '物料来源-自制' descr, 1 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '外购', 'OUT', 'material_source', '物料来源-外购', 2, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'material_source' AND d.value = t.value);

-- ----------------------------
-- 3. 材质 material_texture：铝 AL、铁 IRON、纸质 PAPER、其他 OTHER
-- ----------------------------
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '铝' name, 'AL' value, 'material_texture' type, '材质-铝' descr, 1 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '铁',   'IRON',  'material_texture', '材质-铁',   2, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '纸质', 'PAPER', 'material_texture', '材质-纸质', 3, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '其他', 'OTHER', 'material_texture', '材质-其他', 4, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'material_texture' AND d.value = t.value);

-- ----------------------------
-- 4. 计量单位 ORDER_UNIT：个 PCS、箱 BOX、套 SET
-- ----------------------------
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '个' name, 'PCS' value, 'ORDER_UNIT' type, '生产单位' descr, 1 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '箱', 'BOX', 'ORDER_UNIT', '生产单位', 2, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '套', 'SET', 'ORDER_UNIT', '生产单位', 3, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'ORDER_UNIT' AND d.value = t.value);

-- ----------------------------
-- 5. 用户类型 user_type：员工 employee、管理员 manager
-- ----------------------------
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '员工' name, 'employee' value, 'user_type' type, '用户类型-员工' descr, 1 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '管理员', 'manager', 'user_type', '用户类型-管理员', 2, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'user_type' AND d.value = t.value);

-- ----------------------------
-- 6. 角色分类 role_category：普通角色 normal、系统角色 system
-- ----------------------------
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '普通角色' name, 'normal' value, 'role_category' type, '角色分类-普通角色' descr, 1 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '系统角色', 'system', 'role_category', '角色分类-系统角色', 2, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'role_category' AND d.value = t.value);

-- ----------------------------
-- 7. 数据范围 data_scope：全部 all、本部门 dept、本部门及子部门 dept_child、仅本人 self
-- ----------------------------
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '全部数据' name, 'all' value, 'data_scope' type, '数据范围-全部' descr, 1 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '本部门',         'dept',       'data_scope', '数据范围-本部门',         2, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '本部门及子部门', 'dept_child', 'data_scope', '数据范围-本部门及子部门', 3, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '仅本人',         'self',       'data_scope', '数据范围-仅本人',         4, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'data_scope' AND d.value = t.value);

-- ----------------------------
-- 8. 业务范围 business_scope：全部 all、本部门 dept、指定模块 specified
-- ----------------------------
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '全部业务' name, 'all' value, 'business_scope' type, '业务范围-全部' descr, 1 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '本部门业务',   'dept',      'business_scope', '业务范围-本部门',   2, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '指定业务模块', 'specified', 'business_scope', '业务范围-指定模块', 3, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'business_scope' AND d.value = t.value);

-- ----------------------------
-- 校验：执行后应见 8 个 type 均有数据
-- ----------------------------
SELECT type, COUNT(*) AS cnt FROM sp_sys_dict
WHERE type IN ('material_type','material_source','material_texture','ORDER_UNIT',
               'user_type','role_category','data_scope','business_scope')
GROUP BY type ORDER BY type;
