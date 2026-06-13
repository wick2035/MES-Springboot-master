package com.wangziyang.mes.workflow.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class WorkflowSchemaInitializer implements ApplicationRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Value("${mes.schema.init-menus:false}")
    private boolean initMenus;

    @Override
    public void run(ApplicationArguments args) {
        createTables();
        migrateLegacyWorkflowModelTable();
        if (initMenus) {
            seedMenus();
        }
        seedDefaultWorkflow();
    }

    private void createTables() {
        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_workflow_category` ("
                + "`id` varchar(64) NOT NULL,"
                + "`parent_id` varchar(64) DEFAULT '0',"
                + "`category_name` varchar(128) NOT NULL,"
                + "`category_code` varchar(64) NOT NULL,"
                + "`sort_num` int NOT NULL DEFAULT 30,"
                + "`status` varchar(16) NOT NULL DEFAULT '0',"
                + "`remark` varchar(500) DEFAULT NULL,"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) NOT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) NOT NULL,"
                + "PRIMARY KEY (`id`), UNIQUE KEY `uk_workflow_category_code` (`category_code`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程分类'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_workflow_model` ("
                + "`id` varchar(64) NOT NULL,"
                + "`category_id` varchar(64) NOT NULL,"
                + "`model_code` varchar(64) NOT NULL,"
                + "`model_name` varchar(128) NOT NULL,"
                + "`business_type` varchar(64) NOT NULL,"
                + "`node_json` text NOT NULL,"
                + "`status` varchar(32) NOT NULL DEFAULT 'draft',"
                + "`remark` varchar(500) DEFAULT NULL,"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) NOT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) NOT NULL,"
                + "PRIMARY KEY (`id`), UNIQUE KEY `uk_workflow_model_code` (`model_code`),"
                + "KEY `idx_workflow_model_category` (`category_id`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程模型'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_workflow_definition` ("
                + "`id` varchar(64) NOT NULL,"
                + "`model_id` varchar(64) NOT NULL,"
                + "`category_id` varchar(64) NOT NULL,"
                + "`definition_code` varchar(64) NOT NULL,"
                + "`definition_name` varchar(128) NOT NULL,"
                + "`business_type` varchar(64) NOT NULL,"
                + "`version_no` int NOT NULL DEFAULT 1,"
                + "`node_json` text NOT NULL,"
                + "`status` varchar(32) NOT NULL DEFAULT 'active',"
                + "`publish_time` varchar(32) DEFAULT NULL,"
                + "`remark` varchar(500) DEFAULT NULL,"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) NOT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) NOT NULL,"
                + "PRIMARY KEY (`id`), KEY `idx_workflow_def_business` (`business_type`, `status`),"
                + "KEY `idx_workflow_def_code` (`definition_code`, `version_no`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程定义'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_workflow_form` ("
                + "`id` varchar(64) NOT NULL,"
                + "`form_name` varchar(128) NOT NULL,"
                + "`form_key` varchar(64) NOT NULL,"
                + "`business_type` varchar(64) NOT NULL,"
                + "`definition_code` varchar(64) NOT NULL,"
                + "`form_type` varchar(32) NOT NULL DEFAULT 'url',"
                + "`pc_form_url` varchar(500) NOT NULL,"
                + "`mobile_form_url` varchar(500) DEFAULT NULL,"
                + "`title_template` varchar(200) DEFAULT NULL,"
                + "`event_template` varchar(500) DEFAULT NULL,"
                + "`skip_first_node` tinyint NOT NULL DEFAULT 1,"
                + "`skip_same_handler` tinyint NOT NULL DEFAULT 0,"
                + "`allow_return` tinyint NOT NULL DEFAULT 1,"
                + "`allow_transfer` tinyint NOT NULL DEFAULT 1,"
                + "`allow_entrust` tinyint NOT NULL DEFAULT 1,"
                + "`allow_revoke` tinyint NOT NULL DEFAULT 1,"
                + "`status` varchar(16) NOT NULL DEFAULT '0',"
                + "`sort_num` int NOT NULL DEFAULT 30,"
                + "`remark` varchar(500) DEFAULT NULL,"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) NOT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) NOT NULL,"
                + "PRIMARY KEY (`id`), UNIQUE KEY `uk_workflow_form_key` (`form_key`),"
                + "KEY `idx_workflow_form_business` (`business_type`, `status`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程表单配置'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_workflow_instance` ("
                + "`id` varchar(64) NOT NULL,"
                + "`definition_id` varchar(64) NOT NULL,"
                + "`business_type` varchar(64) NOT NULL,"
                + "`business_id` varchar(64) NOT NULL,"
                + "`business_code` varchar(128) DEFAULT NULL,"
                + "`title` varchar(200) DEFAULT NULL,"
                + "`status` varchar(32) NOT NULL DEFAULT 'running',"
                + "`current_node_key` varchar(64) DEFAULT NULL,"
                + "`current_node_name` varchar(128) DEFAULT NULL,"
                + "`start_user_id` varchar(64) DEFAULT NULL,"
                + "`start_username` varchar(64) DEFAULT NULL,"
                + "`start_time` varchar(32) DEFAULT NULL,"
                + "`end_time` varchar(32) DEFAULT NULL,"
                + "`remark` varchar(500) DEFAULT NULL,"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) NOT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) NOT NULL,"
                + "PRIMARY KEY (`id`), KEY `idx_workflow_inst_business` (`business_type`, `business_id`),"
                + "KEY `idx_workflow_inst_status` (`status`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程实例'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_workflow_task` ("
                + "`id` varchar(64) NOT NULL,"
                + "`instance_id` varchar(64) NOT NULL,"
                + "`definition_id` varchar(64) NOT NULL,"
                + "`business_type` varchar(64) NOT NULL,"
                + "`business_id` varchar(64) NOT NULL,"
                + "`business_code` varchar(128) DEFAULT NULL,"
                + "`task_name` varchar(128) NOT NULL,"
                + "`node_key` varchar(64) NOT NULL,"
                + "`node_name` varchar(128) NOT NULL,"
                + "`assignee_type` varchar(32) NOT NULL,"
                + "`assignee_id` varchar(64) NOT NULL,"
                + "`assignee_name` varchar(128) DEFAULT NULL,"
                + "`status` varchar(32) NOT NULL DEFAULT 'todo',"
                + "`action` varchar(32) DEFAULT NULL,"
                + "`opinion` varchar(500) DEFAULT NULL,"
                + "`start_time` varchar(32) DEFAULT NULL,"
                + "`complete_time` varchar(32) DEFAULT NULL,"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) NOT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) NOT NULL,"
                + "PRIMARY KEY (`id`), KEY `idx_workflow_task_inst` (`instance_id`),"
                + "KEY `idx_workflow_task_assignee` (`assignee_type`, `assignee_id`, `status`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程任务'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_workflow_event` ("
                + "`id` varchar(64) NOT NULL,"
                + "`definition_id` varchar(64) NOT NULL,"
                + "`node_key` varchar(64) NOT NULL,"
                + "`event_type` varchar(32) NOT NULL,"
                + "`action_code` varchar(64) NOT NULL,"
                + "`action_name` varchar(128) DEFAULT NULL,"
                + "`status` varchar(16) NOT NULL DEFAULT '0',"
                + "`sort_num` int NOT NULL DEFAULT 1,"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) NOT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) NOT NULL,"
                + "PRIMARY KEY (`id`), KEY `idx_workflow_event_node` (`definition_id`, `node_key`, `event_type`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程事件模板'");

        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_workflow_event_log` ("
                + "`id` varchar(64) NOT NULL,"
                + "`definition_id` varchar(64) DEFAULT NULL,"
                + "`instance_id` varchar(64) DEFAULT NULL,"
                + "`task_id` varchar(64) DEFAULT NULL,"
                + "`event_type` varchar(32) DEFAULT NULL,"
                + "`action_code` varchar(64) DEFAULT NULL,"
                + "`result_status` varchar(32) DEFAULT NULL,"
                + "`result_msg` varchar(500) DEFAULT NULL,"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) NOT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) NOT NULL,"
                + "PRIMARY KEY (`id`), KEY `idx_workflow_event_log_inst` (`instance_id`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程事件日志'");
    }

    private void seedMenus() {
        jdbcTemplate.execute("INSERT IGNORE INTO `sp_sys_menu` "
                + "(`id`,`code`,`name`,`url`,`parent_id`,`grade`,`sort_num`,`type`,`permission`,`icon`,`descr`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES "
                + "('workflow_tool','workflowTool','流程配置工具','#','1','2',4,'0','user:add','fa fa-sitemap','流程配置工具',NOW(),'admin',NOW(),'admin'),"
                + "('workflow_handle','workflowHandle','流程办理','/workflow/handle/list-ui','workflow_tool','3',1,'0','user:add','fa fa-check-square-o','流程办理',NOW(),'admin',NOW(),'admin'),"
                + "('workflow_control','workflowControl','流程管控','#','workflow_tool','3',2,'0','user:add','fa fa-random','流程管控',NOW(),'admin',NOW(),'admin'),"
                + "('workflow_category','workflowCategory','流程分类管理','/workflow/category/list-ui','workflow_control','4',1,'0','user:add','fa fa-tags','流程分类管理',NOW(),'admin',NOW(),'admin'),"
                + "('workflow_model','workflowModel','流程模型设计','/workflow/model/list-ui','workflow_control','4',2,'0','user:add','fa fa-object-group','流程模型设计',NOW(),'admin',NOW(),'admin'),"
                + "('workflow_definition','workflowDefinition','流程定义管理','/workflow/definition/list-ui','workflow_control','4',3,'0','user:add','fa fa-code-fork','流程定义管理',NOW(),'admin',NOW(),'admin'),"
                + "('workflow_instance','workflowInstance','流程实例管理','/workflow/instance/list-ui','workflow_control','4',4,'0','user:add','fa fa-history','流程实例管理',NOW(),'admin',NOW(),'admin'),"
                + "('workflow_task','workflowTask','流程任务管理','/workflow/task/list-ui','workflow_control','4',5,'0','user:add','fa fa-check-square-o','流程任务管理',NOW(),'admin',NOW(),'admin')");

        jdbcTemplate.execute("UPDATE `sp_sys_menu` SET `parent_id` = '1', `grade` = '2', `sort_num` = 4, "
                + "`update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'workflow_tool'");
        jdbcTemplate.execute("UPDATE `sp_sys_menu` SET `sort_num` = CASE `id` "
                + "WHEN '12' THEN 5 WHEN '16' THEN 6 WHEN '14' THEN 7 WHEN '17' THEN 8 ELSE `sort_num` END, "
                + "`update_time` = NOW(), `update_username` = 'admin' "
                + "WHERE `id` IN ('12','16','14','17')");
        jdbcTemplate.execute("UPDATE `sp_sys_menu` SET `parent_id` = 'workflow_tool', `grade` = '3', `sort_num` = 2, "
                + "`update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'workflow_control'");
        jdbcTemplate.execute("UPDATE `sp_sys_menu` SET `code` = 'workflowHandle', `name` = '流程办理', "
                + "`url` = '/workflow/handle/list-ui', `parent_id` = 'workflow_tool', `grade` = '3', "
                + "`sort_num` = 1, `icon` = 'fa fa-check-square-o', `descr` = '流程办理', "
                + "`update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'workflow_handle'");
        jdbcTemplate.execute("DELETE FROM `sp_sys_role_menu` WHERE `menu_id` = 'workflow_form'");
        jdbcTemplate.execute("DELETE FROM `sp_sys_menu` WHERE `id` = 'workflow_form'");
        jdbcTemplate.execute("UPDATE `sp_sys_menu` SET `sort_num` = CASE `id` "
                + "WHEN 'workflow_category' THEN 1 WHEN 'workflow_model' THEN 2 WHEN 'workflow_definition' THEN 3 "
                + "WHEN 'workflow_instance' THEN 4 WHEN 'workflow_task' THEN 5 "
                + "ELSE `sort_num` END, `update_time` = NOW(), `update_username` = 'admin' "
                + "WHERE `id` IN ('workflow_category','workflow_model','workflow_definition','workflow_instance','workflow_task')");

        jdbcTemplate.execute("INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username) "
                + "SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin' "
                + "FROM `sp_sys_role` r CROSS JOIN `sp_sys_menu` m "
                + "WHERE r.code IN ('admin','888888','productionManagerRole','warehouseManagerRole') "
                + "AND m.id IN ('workflow_tool','workflow_handle','workflow_control','workflow_category','workflow_model','workflow_definition','workflow_instance','workflow_task') "
                + "AND NOT EXISTS (SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id)");
    }

    private void migrateLegacyWorkflowModelTable() {
        addColumnIfMissing("sp_workflow_model", "category_id",
                "ALTER TABLE `sp_workflow_model` ADD COLUMN `category_id` varchar(64) NOT NULL DEFAULT 'wf_cat_prod' AFTER `id`");
        addColumnIfMissing("sp_workflow_model", "model_code",
                "ALTER TABLE `sp_workflow_model` ADD COLUMN `model_code` varchar(64) DEFAULT NULL AFTER `category_id`");
        addColumnIfMissing("sp_workflow_model", "business_type",
                "ALTER TABLE `sp_workflow_model` ADD COLUMN `business_type` varchar(64) NOT NULL DEFAULT 'ORDER_APPROVAL' AFTER `model_name`");
        addColumnIfMissing("sp_workflow_model", "node_json",
                "ALTER TABLE `sp_workflow_model` ADD COLUMN `node_json` text NULL AFTER `business_type`");
        addColumnIfMissing("sp_workflow_model", "remark",
                "ALTER TABLE `sp_workflow_model` ADD COLUMN `remark` varchar(500) DEFAULT NULL AFTER `status`");
        if (columnExists("sp_workflow_model", "model_key")) {
            jdbcTemplate.execute("UPDATE `sp_workflow_model` SET `model_code` = `model_key` WHERE (`model_code` IS NULL OR `model_code` = '') AND `model_key` IS NOT NULL");
        }
    }

    private void addColumnIfMissing(String tableName, String columnName, String ddl) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?",
                new Object[]{tableName, columnName},
                Integer.class);
        if (count == null || count == 0) {
            jdbcTemplate.execute(ddl);
        }
    }

    private boolean columnExists(String tableName, String columnName) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?",
                new Object[]{tableName, columnName},
                Integer.class);
        return count != null && count > 0;
    }

    private void seedDefaultWorkflow() {
        String nodeJson = "[{\"nodeKey\":\"start\",\"nodeName\":\"订单提交\",\"nodeType\":\"start\"},"
                + "{\"nodeKey\":\"order_approve\",\"nodeName\":\"生产订单审批\",\"nodeType\":\"approval\","
                + "\"assigneeType\":\"role\",\"assigneeId\":\"productionManagerRole\",\"assigneeName\":\"生产主管\","
                + "\"events\":[{\"eventType\":\"complete\",\"actionCode\":\"ORDER_APPROVE\",\"actionName\":\"订单审批通过\"}]},"
                + "{\"nodeKey\":\"end\",\"nodeName\":\"审批完成\",\"nodeType\":\"end\"}]";

        jdbcTemplate.update("INSERT IGNORE INTO `sp_workflow_category` "
                + "(`id`,`parent_id`,`category_name`,`category_code`,`sort_num`,`status`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) "
                + "VALUES ('wf_cat_prod','0','生产流程','prod',30,'0','生产订单审批与生产流程管控默认分类',NOW(),'admin',NOW(),'admin')");

        jdbcTemplate.update("INSERT IGNORE INTO `sp_workflow_model` "
                + "(`id`,`category_id`,`model_code`,`model_name`,`business_type`,`node_json`,`status`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) "
                + "VALUES ('wf_model_order_approval','wf_cat_prod','order_approval','生产订单审批流程','ORDER_APPROVAL',?,"
                + "'published','订单创建后由生产/仓储管理角色审批，审批通过后工单进入已审批状态',NOW(),'admin',NOW(),'admin')", nodeJson);

        jdbcTemplate.update("INSERT IGNORE INTO `sp_workflow_definition` "
                + "(`id`,`model_id`,`category_id`,`definition_code`,`definition_name`,`business_type`,`version_no`,`node_json`,`status`,`publish_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) "
                + "VALUES ('wf_def_order_approval_v1','wf_model_order_approval','wf_cat_prod','order_approval','生产订单审批流程','ORDER_APPROVAL',1,?,"
                + "'active',DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s'),'默认生产订单审批流程',NOW(),'admin',NOW(),'admin')", nodeJson);

        jdbcTemplate.update("UPDATE `sp_workflow_model` SET `node_json` = REPLACE(REPLACE(`node_json`, 'warehouseManagerRole', 'productionManagerRole'), '仓储/生产管理角色', '生产主管'), "
                + "`update_time` = NOW(), `update_username` = 'admin' "
                + "WHERE `model_code` = 'order_approval' AND `node_json` LIKE '%warehouseManagerRole%'");
        jdbcTemplate.update("UPDATE `sp_workflow_definition` SET `node_json` = REPLACE(REPLACE(`node_json`, 'warehouseManagerRole', 'productionManagerRole'), '仓储/生产管理角色', '生产主管'), "
                + "`update_time` = NOW(), `update_username` = 'admin' "
                + "WHERE `definition_code` = 'order_approval' AND `node_json` LIKE '%warehouseManagerRole%'");
        jdbcTemplate.update("UPDATE `sp_workflow_task` SET `assignee_id` = 'productionManagerRole', `assignee_name` = '生产主管', "
                + "`update_time` = NOW(), `update_username` = 'admin' "
                + "WHERE `business_type` = 'ORDER_APPROVAL' AND `assignee_id` = 'warehouseManagerRole' AND `status` = 'todo'");

        jdbcTemplate.execute("INSERT IGNORE INTO `sp_workflow_event` "
                + "(`id`,`definition_id`,`node_key`,`event_type`,`action_code`,`action_name`,`status`,`sort_num`,`create_time`,`create_username`,`update_time`,`update_username`) "
                + "VALUES ('wf_event_order_approve','wf_def_order_approval_v1','order_approve','complete','ORDER_APPROVE','订单审批通过','0',1,NOW(),'admin',NOW(),'admin')");

        jdbcTemplate.execute("INSERT IGNORE INTO `sp_workflow_form` "
                + "(`id`,`form_name`,`form_key`,`business_type`,`definition_code`,`form_type`,`pc_form_url`,`mobile_form_url`,"
                + "`title_template`,`event_template`,`skip_first_node`,`skip_same_handler`,`allow_return`,`allow_transfer`,"
                + "`allow_entrust`,`allow_revoke`,`status`,`sort_num`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES "
                + "('wf_form_order_record','生产订单审批流程','orderRecord','ORDER_APPROVAL','order_approval','url',"
                + "'/order/release/add-or-update-ui?id=${task.procIns.bizKey}',"
                + "'/order/release/add-or-update-ui?id=${task.procIns.bizKey}',"
                + "'生产订单审批-${task.businessCode}','ORDER_APPROVE',1,0,1,1,1,1,'0',30,"
                + "'默认生产订单审批表单，审批通过后同步工单状态。',NOW(),'admin',NOW(),'admin')");
    }
}
