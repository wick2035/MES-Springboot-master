-- ============================================================
-- BOM 定版与有效性字段升级
-- Date: 2026-05-26
-- ============================================================

ALTER TABLE `sp_bom`
    ADD COLUMN `lock_status` varchar(10) NOT NULL DEFAULT 'draft'
        COMMENT '定版标识: draft=草稿 locked=已定版' AFTER `bom_level`,
    ADD COLUMN `validity` varchar(10) NOT NULL DEFAULT '有效'
        COMMENT '有效性: 有效/无效' AFTER `lock_status`;
