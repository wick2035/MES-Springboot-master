-- 加工单元状态语义调整：0正常 2异常
-- 旧版本状态为 1启用 0停用；仅当仍是旧字段注释时，将启用转为正常、停用转为异常。

SELECT COLUMN_COMMENT
INTO @sp_processing_unit_status_comment
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'sp_processing_unit'
  AND COLUMN_NAME = 'status';

SET @sp_processing_unit_status_sql = IF(
    @sp_processing_unit_status_comment LIKE '%1启用 0停用%',
    'UPDATE `sp_processing_unit`
        SET `status` = CASE
            WHEN `status` = ''1'' OR `status` IS NULL OR `status` = '''' THEN ''0''
            WHEN `status` = ''0'' THEN ''2''
            ELSE `status`
        END',
    'UPDATE `sp_processing_unit`
        SET `status` = ''0''
        WHERE `status` = ''1'' OR `status` IS NULL OR `status` = '''''
);

PREPARE stmt FROM @sp_processing_unit_status_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

ALTER TABLE `sp_processing_unit`
    MODIFY COLUMN `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态 0正常 2异常';
