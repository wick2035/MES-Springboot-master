-- ============================================================
-- 加工单元定义增强 + 加工单元班组管理（4.1 资源分配管理）升级脚本
-- 日期：2026-06-04
-- 内容：
--   1) 扩展 sp_processing_unit：新增 标准产能(日小时) / 是否有线边库 字段
--   2) 新建 sp_processing_unit_team 关系表（加工单元 ↔ 班组，多对多）
-- 说明：可重复执行（列存在判断 / IF NOT EXISTS）。菜单复用现有 132，无需新增。
-- ============================================================

-- ----------------------------
-- 1. sp_processing_unit 新增 std_capacity（日标准产能/小时）
-- ----------------------------
SET @col_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_SCHEMA = DATABASE()
                      AND TABLE_NAME = 'sp_processing_unit'
                      AND COLUMN_NAME = 'std_capacity');
SET @sql := IF(@col_exists = 0,
    'ALTER TABLE `sp_processing_unit` ADD COLUMN `std_capacity` decimal(8,2) NOT NULL DEFAULT 8.00 COMMENT ''日标准产能(小时)'' AFTER `description`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ----------------------------
-- 2. sp_processing_unit 新增 has_edge_warehouse（是否有线边库 Y是 N否）
-- ----------------------------
SET @col_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_SCHEMA = DATABASE()
                      AND TABLE_NAME = 'sp_processing_unit'
                      AND COLUMN_NAME = 'has_edge_warehouse');
SET @sql := IF(@col_exists = 0,
    'ALTER TABLE `sp_processing_unit` ADD COLUMN `has_edge_warehouse` char(1) NOT NULL DEFAULT ''N'' COMMENT ''是否有线边库 Y是 N否'' AFTER `std_capacity`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 给示例数据补值（新增 NOT NULL DEFAULT 列后旧行已取默认值，这里再显式刷新一遍）
UPDATE `sp_processing_unit` SET `std_capacity` = 8.00 WHERE `std_capacity` IS NULL;
UPDATE `sp_processing_unit` SET `has_edge_warehouse` = 'N' WHERE `has_edge_warehouse` IS NULL OR `has_edge_warehouse` = '';

-- ----------------------------
-- 3. 加工单元班组关系表（多对多）
-- 唯一性「同加工单元不重复同班组」在 Service 层校验（仅对 is_deleted='0' 生效），
-- 不加 DB 唯一索引，避免软删后再绑定冲突；班组↔加工单元绑定可交叉重复（小结第4点）。
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_processing_unit_team` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `unit_id` varchar(64) NOT NULL COMMENT '加工单元ID',
  `team_id` varchar(64) NOT NULL COMMENT '班组ID',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_unit` (`unit_id`),
  KEY `idx_team` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='加工单元班组关系表';

-- ----------------------------
-- 4. 菜单：把「加工单元」从「物料管理(13)」移入「基础数据中心(base_data_center)」侧栏，
--    并按侧栏命名风格更名为「加工单元定义」，排在末位（sort_num=3）。幂等。
-- ----------------------------
UPDATE `sp_sys_menu`
SET `parent_id` = 'base_data_center', `name` = '加工单元定义', `sort_num` = 3
WHERE `id` = '132';

