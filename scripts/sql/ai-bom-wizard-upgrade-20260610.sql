-- ============================================================
-- AI 智能建模分步向导升级脚本
-- 日期：2026-06-10
-- 内容：
--   1. 新建工单工序人员分配表 sp_order_oper_assign
--   2. 菜单「AI生成BOM」更名为「AI智能建模」（url 不变）
--   3. 管理员角色授权兜底
-- 说明：可重复执行（IF NOT EXISTS / NOT EXISTS 子查询）
-- 执行务必带字符集：mysql --default-character-set=utf8mb4 ... < 本脚本
-- ============================================================

-- ----------------------------
-- 1. 工单工序人员分配表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_order_oper_assign` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `order_id` varchar(64) NOT NULL COMMENT '工单ID',
  `order_code` varchar(64) DEFAULT NULL COMMENT '工单编号',
  `flow_id` varchar(64) DEFAULT NULL COMMENT '工艺路线ID',
  `oper_id` varchar(64) NOT NULL COMMENT '工序ID',
  `oper` varchar(32) DEFAULT NULL COMMENT '工序编码',
  `oper_desc` varchar(255) DEFAULT NULL COMMENT '工序名称',
  `sort_num` int(11) DEFAULT NULL COMMENT '工序顺序',
  `unit_id` varchar(64) DEFAULT NULL COMMENT '加工单元ID',
  `team_id` varchar(64) DEFAULT NULL COMMENT '班组ID',
  `user_id` varchar(64) DEFAULT NULL COMMENT '员工用户ID',
  `user_name` varchar(64) DEFAULT NULL COMMENT '员工姓名',
  `status` varchar(2) NOT NULL DEFAULT '0' COMMENT '任务状态 0待开工 1进行中 2已完成',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_assign_order` (`order_id`),
  KEY `idx_assign_user_status` (`user_id`, `status`),
  KEY `idx_assign_oper` (`oper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工单工序人员分配表';

-- ----------------------------
-- 2. 菜单更名：AI生成BOM → AI智能建模（url 保持 /llm/bom-gen/gen-ui，避免授权/收藏失效）
-- ----------------------------
UPDATE `sp_sys_menu`
SET `name` = 'AI智能建模',
    `descr` = 'AI生成BOM/工艺/工单分步向导',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = 'llm_bom_gen';

-- ----------------------------
-- 3. 给系统管理员（role code = '888888'）授权兜底（已授权则跳过）
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('llm_center', 'llm_bom_gen')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
