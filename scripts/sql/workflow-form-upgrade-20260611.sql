-- ============================================================
-- Workflow form management upgrade
-- Date: 2026-06-11
-- Content:
--   1) Add sp_workflow_form for URL form binding and safe event templates
--   2) Move workflow form configuration into workflow definition management
--   3) Seed production order approval form: formKey=orderRecord
-- ============================================================

CREATE TABLE IF NOT EXISTS `sp_workflow_form` (
  `id` varchar(64) NOT NULL,
  `form_name` varchar(128) NOT NULL,
  `form_key` varchar(64) NOT NULL,
  `business_type` varchar(64) NOT NULL,
  `definition_code` varchar(64) NOT NULL,
  `form_type` varchar(32) NOT NULL DEFAULT 'url',
  `pc_form_url` varchar(500) NOT NULL,
  `mobile_form_url` varchar(500) DEFAULT NULL,
  `title_template` varchar(200) DEFAULT NULL,
  `event_template` varchar(500) DEFAULT NULL,
  `skip_first_node` tinyint NOT NULL DEFAULT 1,
  `skip_same_handler` tinyint NOT NULL DEFAULT 0,
  `allow_return` tinyint NOT NULL DEFAULT 1,
  `allow_transfer` tinyint NOT NULL DEFAULT 1,
  `allow_entrust` tinyint NOT NULL DEFAULT 1,
  `allow_revoke` tinyint NOT NULL DEFAULT 1,
  `status` varchar(16) NOT NULL DEFAULT '0',
  `sort_num` int NOT NULL DEFAULT 30,
  `remark` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_workflow_form_key` (`form_key`),
  KEY `idx_workflow_form_business` (`business_type`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程表单配置';

DELETE FROM `sp_sys_role_menu` WHERE `menu_id` = 'workflow_form';
DELETE FROM `sp_sys_menu` WHERE `id` = 'workflow_form';

UPDATE `sp_sys_menu`
SET `sort_num` = CASE `id`
    WHEN 'workflow_category' THEN 1
    WHEN 'workflow_model' THEN 2
    WHEN 'workflow_definition' THEN 3
    WHEN 'workflow_instance' THEN 4
    WHEN 'workflow_task' THEN 5
    ELSE `sort_num`
END,
`update_time` = NOW(),
`update_username` = 'admin'
WHERE `id` IN ('workflow_category','workflow_model','workflow_definition','workflow_instance','workflow_task');

INSERT IGNORE INTO `sp_workflow_form`
(`id`,`form_name`,`form_key`,`business_type`,`definition_code`,`form_type`,`pc_form_url`,`mobile_form_url`,
 `title_template`,`event_template`,`skip_first_node`,`skip_same_handler`,`allow_return`,`allow_transfer`,
 `allow_entrust`,`allow_revoke`,`status`,`sort_num`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('wf_form_order_record','生产订单审批流程','orderRecord','ORDER_APPROVAL','order_approval','url',
 '/order/release/add-or-update-ui?id=${task.procIns.bizKey}',
 '/order/release/add-or-update-ui?id=${task.procIns.bizKey}',
 '生产订单审批-${task.businessCode}','ORDER_APPROVE',1,0,1,1,1,1,'0',30,
 '默认生产订单审批表单，审批通过后同步工单状态。',NOW(),'admin',NOW(),'admin');
