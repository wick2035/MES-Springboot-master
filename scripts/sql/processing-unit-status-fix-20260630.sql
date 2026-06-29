-- =============================================================================
-- 加工单元(sp_processing_unit)脏数据修复  2026-06-30
-- 背景：演示数据把 status 误写为 '1'（约定 0=正常 / 2=异常），unit_type 误写为
--       'staff'（约定 person/device）。导致「工序信息定义」里的加工单元选择框
--       (where status='0') 一条都查不到，而定义列表页因不过滤 status 且把 '1'
--       渲染成「正常」，掩盖了脏值。
-- 执行：mysql -uroot -p20041118 --default-character-set=utf8mb4 sparchetype-test < processing-unit-status-fix-20260630.sql
-- 注：演示脚本(demo-data-optimized-manufacturing-20260614.sql /
--     full-install-demo-20260625.sql)中的字面量已同步修正，重跑不会再复现。
-- =============================================================================

UPDATE sp_processing_unit
SET status = '0'
WHERE status = '1' AND is_deleted = '0';

UPDATE sp_processing_unit
SET unit_type = 'person'
WHERE unit_type = 'staff' AND is_deleted = '0';

-- 校验：预期所有未删除单元 status 为 '0'/'2'，unit_type 为 person/device
SELECT unit_code, unit_name, unit_type, status FROM sp_processing_unit WHERE is_deleted = '0' ORDER BY unit_code;
