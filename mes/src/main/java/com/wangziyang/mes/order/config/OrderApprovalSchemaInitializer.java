package com.wangziyang.mes.order.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * Keeps the local development database compatible with the order approval fields.
 */
@Component
public class OrderApprovalSchemaInitializer implements ApplicationRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(ApplicationArguments args) {
        addColumnIfMissing("designer_id",
                "ALTER TABLE `sp_order` ADD COLUMN `designer_id` varchar(64) DEFAULT NULL COMMENT 'Designer user ID' AFTER `statue`");
        addColumnIfMissing("designer_name",
                "ALTER TABLE `sp_order` ADD COLUMN `designer_name` varchar(64) DEFAULT NULL COMMENT 'Designer name' AFTER `designer_id`");
        addColumnIfMissing("approve_user_id",
                "ALTER TABLE `sp_order` ADD COLUMN `approve_user_id` varchar(64) DEFAULT NULL COMMENT 'Approver user ID' AFTER `designer_name`");
        addColumnIfMissing("approve_username",
                "ALTER TABLE `sp_order` ADD COLUMN `approve_username` varchar(64) DEFAULT NULL COMMENT 'Approver name' AFTER `approve_user_id`");
        addColumnIfMissing("approve_time",
                "ALTER TABLE `sp_order` ADD COLUMN `approve_time` varchar(32) DEFAULT NULL COMMENT 'Approval time' AFTER `approve_username`");
    }

    private void addColumnIfMissing(String columnName, String ddl) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = ?",
                new Object[]{columnName},
                Integer.class);
        if (count == null || count == 0) {
            jdbcTemplate.execute(ddl);
        }
    }
}
