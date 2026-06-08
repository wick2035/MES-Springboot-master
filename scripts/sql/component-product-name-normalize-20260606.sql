-- ============================================================
-- 零部件定义产品名称规范化脚本
-- 日期：2026-06-06
-- 内容：修正产品名称末尾误带 ? / ？ 的历史数据
-- ============================================================

UPDATE `sp_component_def`
SET `product_name` = TRIM(TRAILING '？' FROM TRIM(TRAILING '?' FROM TRIM(`product_name`))),
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `product_name` LIKE '%?'
   OR `product_name` LIKE '%？';
