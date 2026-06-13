package com.wangziyang.mes.system.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class MenuOrderInitializer {

    private static final String PROCESS_CENTER_NAME = "CONVERT(0xE5B7A5E889BAE7AEA1E79086E4B8ADE5BF83 USING utf8mb4)";

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Value("${mes.schema.init-menus:false}")
    private boolean initMenus;

    @EventListener(ApplicationReadyEvent.class)
    public void applySidebarOrder() {
        if (!initMenus) {
            return;
        }

        jdbcTemplate.execute("UPDATE `sp_sys_menu` SET `parent_id` = '1', `grade` = '2', "
                + "`sort_num` = CASE `id` "
                + "WHEN '10' THEN 1 "
                + "WHEN 'base_data_center' THEN 2 "
                + "WHEN 'prod_data_center' THEN 3 "
                + "WHEN '15' THEN 4 "
                + "WHEN 'warehouse_management_center' THEN 5 "
                + "WHEN 'workflow_tool' THEN 6 "
                + "WHEN 'production_order_center' THEN 7 "
                + "WHEN '12' THEN 8 "
                + "WHEN '16' THEN 9 "
                + "WHEN '14' THEN 10 "
                + "WHEN '17' THEN 11 "
                + "WHEN 'llm_center' THEN 12 "
                + "ELSE `sort_num` END, "
                + "`update_time` = NOW(), `update_username` = 'admin' "
                + "WHERE `id` IN ('10','base_data_center','prod_data_center','15',"
                + "'warehouse_management_center','workflow_tool','production_order_center',"
                + "'12','16','14','17','llm_center')");

        jdbcTemplate.execute("UPDATE `sp_sys_menu` SET `name` = " + PROCESS_CENTER_NAME
                + ", `descr` = " + PROCESS_CENTER_NAME
                + ", `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '15'");
    }
}
