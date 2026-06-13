-- Clear business data for:
-- 1. Warehouse Management Center
-- 2. Workflow Configuration Center
-- 3. Production Plan Center / Plan Management
--
-- Scope:
-- - Clears documents, runtime records, workflow configs, stock rows, work orders,
--   production orders, dispatch plans, MRP rows, inbound requests, and SN process records.
-- - Keeps menus, roles, users, departments, materials, BOM, process routes,
--   warehouse definitions, warehouse locations, devices, teams, and employees.
--
-- Run this only after taking a database backup.

SET @old_sql_safe_updates := @@SQL_SAFE_UPDATES;
SET SQL_SAFE_UPDATES = 0;
SET @old_foreign_key_checks := @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

DROP PROCEDURE IF EXISTS sp_clear_table_if_exists;
DELIMITER //
CREATE PROCEDURE sp_clear_table_if_exists(IN p_table_name varchar(128))
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = p_table_name
  ) THEN
    SET @clear_sql = CONCAT('DELETE FROM `', REPLACE(p_table_name, '`', '``'), '`');
    PREPARE clear_stmt FROM @clear_sql;
    EXECUTE clear_stmt;
    DEALLOCATE PREPARE clear_stmt;
  END IF;
END//
DELIMITER ;

START TRANSACTION;

-- ============================================================
-- 1. Warehouse Management Center
-- ============================================================
CALL sp_clear_table_if_exists('sp_warehouse_request_allocation');
CALL sp_clear_table_if_exists('sp_warehouse_transaction');
CALL sp_clear_table_if_exists('sp_warehouse_request_item');
CALL sp_clear_table_if_exists('sp_warehouse_request');
CALL sp_clear_table_if_exists('sp_inventory');

-- ============================================================
-- 2. Workflow Configuration Center
-- ============================================================
CALL sp_clear_table_if_exists('sp_workflow_event_log');
CALL sp_clear_table_if_exists('sp_workflow_task');
CALL sp_clear_table_if_exists('sp_workflow_instance');
CALL sp_clear_table_if_exists('sp_workflow_event');
CALL sp_clear_table_if_exists('sp_workflow_form');
CALL sp_clear_table_if_exists('sp_workflow_definition');
CALL sp_clear_table_if_exists('sp_workflow_model');
CALL sp_clear_table_if_exists('sp_workflow_category');

-- ============================================================
-- 3. Production Plan Center / Plan Management
-- ============================================================
CALL sp_clear_table_if_exists('sp_sn_process_record');
CALL sp_clear_table_if_exists('sp_work_order_change');
CALL sp_clear_table_if_exists('sp_order_oper_equipment_assign');
CALL sp_clear_table_if_exists('sp_order_oper_assign');
CALL sp_clear_table_if_exists('sp_material_inbound_request_item');
CALL sp_clear_table_if_exists('sp_material_inbound_request');
CALL sp_clear_table_if_exists('sp_material_requirement_plan');
CALL sp_clear_table_if_exists('sp_production_order_oper_plan');
CALL sp_clear_table_if_exists('sp_production_order_item');
CALL sp_clear_table_if_exists('sp_production_order');
CALL sp_clear_table_if_exists('sp_order');

COMMIT;

DROP PROCEDURE IF EXISTS sp_clear_table_if_exists;
SET FOREIGN_KEY_CHECKS = @old_foreign_key_checks;
SET SQL_SAFE_UPDATES = @old_sql_safe_updates;
