-- ============================================================
-- 已下达工单变更审批升级脚本
-- Date: 2026-06-12
-- Content:
--   1) Add sp_order.remark
--   2) Add sp_work_order_change
--   3) Seed default work order change workflow
-- ============================================================

DROP PROCEDURE IF EXISTS `sp_add_column_if_missing`;
DELIMITER //
CREATE PROCEDURE `sp_add_column_if_missing`(IN p_table varchar(64), IN p_column varchar(64), IN p_sql text)
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_column
  ) THEN
    SET @alter_sql = p_sql;
    PREPARE stmt FROM @alter_sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
  END IF;
END//
DELIMITER ;

CALL sp_add_column_if_missing('sp_order', 'remark',
  'ALTER TABLE `sp_order` ADD COLUMN `remark` varchar(500) DEFAULT NULL COMMENT ''备注'' AFTER `approve_time`');

DROP PROCEDURE IF EXISTS `sp_add_column_if_missing`;

CREATE TABLE IF NOT EXISTS `sp_work_order_change` (
  `id` varchar(64) NOT NULL,
  `work_order_id` varchar(64) NOT NULL COMMENT '生产工单ID',
  `work_order_code` varchar(64) DEFAULT NULL COMMENT '生产工单编号',
  `production_order_id` varchar(64) NOT NULL COMMENT '生产计划ID',
  `order_item_id` varchar(64) NOT NULL COMMENT '生产计划明细ID',
  `before_flow_id` varchar(64) DEFAULT NULL COMMENT '变更前工艺路线',
  `after_flow_id` varchar(64) DEFAULT NULL COMMENT '变更后工艺路线',
  `before_qty` int DEFAULT NULL COMMENT '变更前数量',
  `after_qty` int DEFAULT NULL COMMENT '变更后数量',
  `before_plan_start_time` varchar(32) DEFAULT NULL COMMENT '变更前计划开始',
  `after_plan_start_time` varchar(32) DEFAULT NULL COMMENT '变更后计划开始',
  `before_plan_end_time` varchar(32) DEFAULT NULL COMMENT '变更前计划结束',
  `after_plan_end_time` varchar(32) DEFAULT NULL COMMENT '变更后计划结束',
  `before_remark` varchar(500) DEFAULT NULL COMMENT '变更前备注',
  `after_remark` varchar(500) DEFAULT NULL COMMENT '变更后备注',
  `status` varchar(32) NOT NULL DEFAULT 'APPROVING' COMMENT '审批状态',
  `workflow_instance_id` varchar(64) DEFAULT NULL COMMENT '流程实例ID',
  `apply_time` varchar(32) DEFAULT NULL COMMENT '生效时间',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_work_order_change_work_order` (`work_order_id`, `status`),
  KEY `idx_work_order_change_workflow` (`workflow_instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='已下达工单变更申请';

SET @workflow_change_node_json = '[{"nodeKey":"start","nodeName":"提交变更","nodeType":"start"},{"nodeKey":"work_order_change_approve","nodeName":"工单变更审批","nodeType":"approval","assigneeType":"role","assigneeId":"productionManagerRole","assigneeName":"生产主管","events":[{"eventType":"complete","actionCode":"WORK_ORDER_CHANGE_APPLY","actionName":"工单变更审批通过并生效"}]},{"nodeKey":"end","nodeName":"审批完成","nodeType":"end"}]';

INSERT IGNORE INTO `sp_workflow_model`
(`id`,`category_id`,`model_code`,`model_name`,`business_type`,`node_json`,`status`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`)
VALUES ('wf_model_work_order_change','wf_cat_prod','work_order_change','已下达工单变更审批流程','WORK_ORDER_CHANGE',@workflow_change_node_json,'published','已动工工单修改时由生产主管审批，审批通过后自动应用变更',NOW(),'admin',NOW(),'admin');

INSERT IGNORE INTO `sp_workflow_definition`
(`id`,`model_id`,`category_id`,`definition_code`,`definition_name`,`business_type`,`version_no`,`node_json`,`status`,`publish_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`)
VALUES ('wf_def_work_order_change_v1','wf_model_work_order_change','wf_cat_prod','work_order_change','已下达工单变更审批流程','WORK_ORDER_CHANGE',1,@workflow_change_node_json,'active',DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s'),'默认已下达工单变更审批流程',NOW(),'admin',NOW(),'admin');

INSERT IGNORE INTO `sp_workflow_event`
(`id`,`definition_id`,`node_key`,`event_type`,`action_code`,`action_name`,`status`,`sort_num`,`create_time`,`create_username`,`update_time`,`update_username`)
VALUES ('wf_event_work_order_change_apply','wf_def_work_order_change_v1','work_order_change_approve','complete','WORK_ORDER_CHANGE_APPLY','工单变更审批通过并生效','0',1,NOW(),'admin',NOW(),'admin');

INSERT IGNORE INTO `sp_workflow_form`
(`id`,`form_name`,`form_key`,`business_type`,`definition_code`,`form_type`,`pc_form_url`,`mobile_form_url`,
 `title_template`,`event_template`,`skip_first_node`,`skip_same_handler`,`allow_return`,`allow_transfer`,
 `allow_entrust`,`allow_revoke`,`status`,`sort_num`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('wf_form_work_order_change','已下达工单变更审批','workOrderChange','WORK_ORDER_CHANGE','work_order_change','url',
 '/workflow/task/list-ui',
 '/workflow/task/list-ui',
 '已下达工单变更审批-${task.businessCode}','WORK_ORDER_CHANGE_APPLY',1,0,1,1,1,1,'0',40,
 '已动工工单变更审批表单',NOW(),'admin',NOW(),'admin');
