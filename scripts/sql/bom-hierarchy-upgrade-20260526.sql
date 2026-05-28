-- ============================================================
-- BOM 三层层级结构升级迁移脚本
-- Date: 2026-05-26
-- Description: 升级扁平BOM为三层层级结构
-- ============================================================

-- 1. sp_bom_item 新增 child_bom_id 和 item_mat_type 两列
ALTER TABLE `sp_bom_item`
    ADD COLUMN `child_bom_id` varchar(64) NULL DEFAULT NULL
        COMMENT '子BOM ID (当子项是组件/半成品时关联sp_bom.id)' AFTER `oper_typer`,
    ADD COLUMN `item_mat_type` varchar(10) NULL DEFAULT NULL
        COMMENT '子项物料类型 FG/PG/COMP/PART' AFTER `child_bom_id`,
    ADD INDEX `idx_bom_item_child_bom_id` (`child_bom_id`),
    ADD INDEX `idx_bom_item_bom_head_id` (`bom_head_id`);

-- 2. sp_bom 新增 bom_level 列
ALTER TABLE `sp_bom`
    ADD COLUMN `bom_level` tinyint(1) NOT NULL DEFAULT 0
        COMMENT 'BOM层级: 0=成品BOM 1=半成品BOM 2=组件BOM' AFTER `factory`;

-- 3. 字典新增 COMP=组件、PART=零件（material_type 类型）
INSERT INTO `sp_sys_dict`
    (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
     `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
    (REPLACE(UUID(), '-', ''), '组件', 'COMP', 'material_type', '物料类型-组件', 4, '""', '0',
     NOW(), 'admin', NOW(), 'admin'),
    (REPLACE(UUID(), '-', ''), '零件', 'PART', 'material_type', '物料类型-零件', 5, '""', '0',
     NOW(), 'admin', NOW(), 'admin');
