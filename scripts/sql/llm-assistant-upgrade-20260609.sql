-- ============================================================
-- 大模型智能助手（智能数据助手 + AI 生成 BOM）升级脚本
-- 日期：2026-06-09
-- 内容：建表 sp_llm_conversation / sp_llm_message + 菜单（智能助手中心 → 智能数据助手 / AI生成BOM）+ 管理员授权
-- 说明：可重复执行（IF NOT EXISTS / INSERT IGNORE / NOT EXISTS 子查询）
-- 执行务必带字符集：mysql --default-character-set=utf8mb4 ... < 本脚本
-- ============================================================

-- ----------------------------
-- 1. 会话表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_llm_conversation` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `title` varchar(255) DEFAULT NULL COMMENT '会话标题（首条提问摘要）',
  `user_id` varchar(64) DEFAULT NULL COMMENT '所属用户ID',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='智能助手会话表';

-- ----------------------------
-- 2. 会话消息表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_llm_message` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `conversation_id` varchar(64) NOT NULL COMMENT '所属会话ID',
  `role` varchar(20) NOT NULL COMMENT '角色 user/assistant',
  `content` longtext COMMENT '消息内容',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_conv` (`conversation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='智能助手会话消息表';

-- ----------------------------
-- 3. 菜单：智能助手中心（父） + 智能数据助手 / AI生成BOM（子）
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('llm_center',  'llmCenter',  '智能助手中心', '#',                  '1',          '2', 20, '0', 'user:add', 'fa fa-magic',     '智能助手中心', NOW(), 'admin', NOW(), 'admin'),
('llm_chat',    'llmChat',    '智能数据助手', '/llm/chat/chat-ui',  'llm_center', '3', 1,  '0', 'user:add', 'fa fa-comments',  '智能数据助手', NOW(), 'admin', NOW(), 'admin'),
('llm_bom_gen', 'llmBomGen',  'AI生成BOM',   '/llm/bom-gen/gen-ui', 'llm_center', '3', 2,  '0', 'user:add', 'fa fa-sitemap',   'AI辅助生成BOM', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 4. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('llm_center', 'llm_chat', 'llm_bom_gen')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
