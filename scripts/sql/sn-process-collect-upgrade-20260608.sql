-- ============================================================
-- SN process collection minimal workflow
-- Date: 2026-06-08
-- Content:
--   1) Create sp_sn_process_record for WIP SN station records
--   2) Replace old /rrr placeholder menu with the new SN process page
--   3) Normalize the digital platform menu code and re-grant related menus
-- This script is idempotent.
-- ============================================================

CREATE TABLE IF NOT EXISTS `sp_sn_process_record` (
  `id` varchar(64) NOT NULL COMMENT 'Primary key',
  `sn` varchar(128) NOT NULL COMMENT 'SN',
  `order_id` varchar(64) NOT NULL COMMENT 'Production order ID',
  `order_code` varchar(255) DEFAULT NULL COMMENT 'Production order code',
  `flow_id` varchar(64) NOT NULL COMMENT 'Flow ID',
  `oper_id` varchar(64) NOT NULL COMMENT 'Operation ID',
  `oper` varchar(255) DEFAULT NULL COMMENT 'Operation code',
  `oper_desc` varchar(255) DEFAULT NULL COMMENT 'Operation description',
  `step_no` int DEFAULT NULL COMMENT 'Route step number',
  `status` varchar(16) NOT NULL COMMENT 'OK/NG',
  `remark` varchar(500) DEFAULT NULL COMMENT 'Remark',
  `create_time` datetime NOT NULL COMMENT 'Create time',
  `create_username` varchar(64) DEFAULT NULL COMMENT 'Create username',
  `update_time` datetime NOT NULL COMMENT 'Update time',
  `update_username` varchar(64) DEFAULT NULL COMMENT 'Update username',
  PRIMARY KEY (`id`),
  KEY `idx_sn_process_sn_order` (`sn`, `order_id`),
  KEY `idx_sn_process_order` (`order_id`),
  KEY `idx_sn_process_oper` (`oper_id`),
  KEY `idx_sn_process_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='SN process collection records';

UPDATE `sp_sys_menu`
SET `url` = '/wip/sn-process/list-ui',
    `name` = CONVERT(0x534EE9809AE794A8E8BF87E7A88BE98787E99B86 USING utf8mb4),
    `icon` = 'fa fa-barcode',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `code` = 'generalSnProcess' OR `id` = '161';

UPDATE `sp_sys_menu`
SET `code` = 'Digitalplatform',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '14';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('888888', 'productionOperatorRole')
  AND m.code IN ('currency', 'wip', 'generalSnProcess')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('888888', 'planManagerRole', 'dashboardViewerRole')
  AND m.code IN ('Digitalplatform', 'plandg')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );
