package com.wangziyang.mes.productionorder.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * Keeps dispatched work order change tables compatible in local databases.
 */
@Component
public class WorkOrderChangeSchemaInitializer implements ApplicationRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(ApplicationArguments args) {
        addColumnIfMissing("sp_order", "remark",
                "ALTER TABLE `sp_order` ADD COLUMN `remark` varchar(500) DEFAULT NULL COMMENT '备注' AFTER `approve_time`");
        createChangeTable();
    }

    private void createChangeTable() {
        jdbcTemplate.execute("CREATE TABLE IF NOT EXISTS `sp_work_order_change` ("
                + "`id` varchar(64) NOT NULL,"
                + "`work_order_id` varchar(64) NOT NULL COMMENT '生产工单ID',"
                + "`work_order_code` varchar(64) DEFAULT NULL COMMENT '生产工单编号',"
                + "`production_order_id` varchar(64) NOT NULL COMMENT '生产计划ID',"
                + "`order_item_id` varchar(64) NOT NULL COMMENT '生产计划明细ID',"
                + "`before_flow_id` varchar(64) DEFAULT NULL COMMENT '变更前工艺路线',"
                + "`after_flow_id` varchar(64) DEFAULT NULL COMMENT '变更后工艺路线',"
                + "`before_qty` int DEFAULT NULL COMMENT '变更前数量',"
                + "`after_qty` int DEFAULT NULL COMMENT '变更后数量',"
                + "`before_plan_start_time` varchar(32) DEFAULT NULL COMMENT '变更前计划开始',"
                + "`after_plan_start_time` varchar(32) DEFAULT NULL COMMENT '变更后计划开始',"
                + "`before_plan_end_time` varchar(32) DEFAULT NULL COMMENT '变更前计划结束',"
                + "`after_plan_end_time` varchar(32) DEFAULT NULL COMMENT '变更后计划结束',"
                + "`before_remark` varchar(500) DEFAULT NULL COMMENT '变更前备注',"
                + "`after_remark` varchar(500) DEFAULT NULL COMMENT '变更后备注',"
                + "`status` varchar(32) NOT NULL DEFAULT 'APPROVING' COMMENT '审批状态',"
                + "`workflow_instance_id` varchar(64) DEFAULT NULL COMMENT '流程实例ID',"
                + "`apply_time` varchar(32) DEFAULT NULL COMMENT '生效时间',"
                + "`create_time` datetime NOT NULL,"
                + "`create_username` varchar(64) DEFAULT NULL,"
                + "`update_time` datetime NOT NULL,"
                + "`update_username` varchar(64) DEFAULT NULL,"
                + "PRIMARY KEY (`id`),"
                + "KEY `idx_work_order_change_work_order` (`work_order_id`, `status`),"
                + "KEY `idx_work_order_change_workflow` (`workflow_instance_id`)"
                + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='已下达工单变更申请'");
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
}
