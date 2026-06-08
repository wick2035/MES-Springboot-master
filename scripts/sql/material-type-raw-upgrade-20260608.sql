-- ============================================================
-- 物料类型字典补充脚本
-- 日期：2026-06-08
-- 内容：物料信息定义 → 物料类型新增“原材料”
-- 说明：可重复执行；已存在 RAW 时不会重复插入
-- ============================================================

INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT REPLACE(UUID(),'-',''), '原材料', 'RAW', 'material_type', '物料类型-原材料', 9, '""', '0',
       NOW(), 'admin', NOW(), 'admin'
FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'material_type' AND d.value = 'RAW'
);
