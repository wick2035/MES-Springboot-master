-- ============================================================
-- 工序信息定义业务规则兜底升级
-- 创建时间: 2026-06-06
-- 内容:
--   1) 检查 sp_oper.oper 是否存在重复编号
--   2) 在无重复数据时补充工序编号唯一索引 uk_sp_oper_oper
-- ============================================================

-- 如下查询返回数据时，请先清理重复工序编号，再执行本脚本。
SELECT `oper`, COUNT(*) AS duplicate_count
FROM `sp_oper`
WHERE `oper` IS NOT NULL AND `oper` <> ''
GROUP BY `oper`
HAVING COUNT(*) > 1;

SET @duplicate_oper_count := (
  SELECT COUNT(*)
  FROM (
    SELECT `oper`
    FROM `sp_oper`
    WHERE `oper` IS NOT NULL AND `oper` <> ''
    GROUP BY `oper`
    HAVING COUNT(*) > 1
  ) t
);

SET @oper_index_count := (
  SELECT COUNT(*)
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'sp_oper'
    AND INDEX_NAME = 'uk_sp_oper_oper'
);

SET @oper_index_sql := CASE
  WHEN @duplicate_oper_count > 0 THEN
    'SELECT ''存在重复工序编号，请先清理 sp_oper.oper 后再创建唯一索引'' AS message'
  WHEN @oper_index_count > 0 THEN
    'SELECT ''uk_sp_oper_oper 已存在，无需重复创建'' AS message'
  ELSE
    'ALTER TABLE `sp_oper` ADD UNIQUE KEY `uk_sp_oper_oper` (`oper`)'
END;

PREPARE stmt FROM @oper_index_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
