-- ============================================================
-- MES 数据库全量初始化脚本 (init-all.sql)
-- 用途: 仅供"从0全新部署"一次性导入 (基础库 + 全部增量升级, 按日期顺序拼接)
-- 已有库请勿执行本文件, 改为按文件名日期顺序执行各 *-upgrade-*.sql 增量脚本
-- 生成方式: 由 scripts/sql/ 下 10 个脚本原文拼接而成, 内容幂等可重复执行
-- 导入命令: mysql --default-character-set=utf8mb4 -u root -p sparchetype < scripts/sql/init-all.sql
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;


-- ============================================================
-- [0] source: MySQL-20210225.sql
-- ============================================================
/*
 Navicat Premium Data Transfer

 Source Server         : aliyunmes
 Source Server Type    : MySQL
 Source Server Version : 80016
 Source Host           : rm-8vb0sazu4d9g0u290eo.mysql.zhangbei.rds.aliyuncs.com:3306
 Source Schema         : sparchetype

 Target Server Type    : MySQL
 Target Server Version : 80016
 File Encoding         : 65001

 Date: 21/07/2020 08:56:18
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sp_bom
-- ----------------------------
DROP TABLE IF EXISTS `sp_bom`;
CREATE TABLE `sp_bom`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `bom_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'bom编号',
  `materiel_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料ID',
  `materiel_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料描述',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `version_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '版本号',
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'BOM状态 creat创建 pass审核通过 ',
  `factory` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工厂',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'BOM主信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_bom
-- ----------------------------
INSERT INTO `sp_bom` VALUES ('1268447170115383298', 'bbbbb', 't002', 't002', '', '1', NULL, NULL, '0', '2020-06-04 15:39:07', 'admin', '2020-07-16 11:17:20', 'admin');
INSERT INTO `sp_bom` VALUES ('1268811409925582850', '0001', '2019001', '电子元件', '', '1', NULL, NULL, '0', '2020-06-05 15:46:28', 'admin', '2020-07-16 13:30:08', 'admin');
INSERT INTO `sp_bom` VALUES ('1270189758686146562', '测试', '123', '123', '', '1', NULL, NULL, '0', '2020-06-09 11:03:32', 'admin', '2020-07-04 15:32:47', 'admin');
INSERT INTO `sp_bom` VALUES ('1272019534564536322', '打算', '123', '123', '', '1', NULL, NULL, '2', '2020-06-14 12:14:25', 'admin', '2020-07-09 15:10:38', 'admin');
INSERT INTO `sp_bom` VALUES ('1272783744282112002', '阿斯顿发送到', 't002', 't002', '', '1', NULL, NULL, '0', '2020-06-16 14:51:06', 'admin', '2020-06-16 14:51:06', 'admin');
INSERT INTO `sp_bom` VALUES ('1276415594372247554', '77', '123', '123', '', '1', NULL, NULL, '0', '2020-06-26 15:22:47', 'admin', '2020-07-08 15:30:46', 'admin');
INSERT INTO `sp_bom` VALUES ('1276535719725346818', '001', '123', '123', '', '1', NULL, NULL, '0', '2020-06-26 23:20:07', 'admin', '2020-06-26 23:20:07', 'admin');
INSERT INTO `sp_bom` VALUES ('1277125952237973506', 'A0001', 't002', 't002', '', '1', NULL, NULL, '0', '2020-06-28 14:25:30', 'admin', '2020-06-28 14:25:30', 'admin');
INSERT INTO `sp_bom` VALUES ('1277599659653836802', 'Y001', 'Y001', 'Y001', '', '1', NULL, NULL, '0', '2020-06-29 21:47:50', 'admin', '2020-06-29 21:47:50', 'admin');
INSERT INTO `sp_bom` VALUES ('1278528374608998401', 'dc001', 'Y001', 'Y001', '', '1', NULL, NULL, '0', '2020-07-02 11:18:13', 'admin', '2020-07-02 11:18:13', 'admin');
INSERT INTO `sp_bom` VALUES ('1280124062753075202', '11111', '002-2918', '曲轴', '11111', '1', NULL, NULL, '0', '2020-07-06 20:58:55', 'admin', '2020-07-06 20:58:55', 'admin');
INSERT INTO `sp_bom` VALUES ('1281490436289179649', '001', '002-2918', '曲轴', '', '1', NULL, NULL, '0', '2020-07-10 15:28:24', 'admin', '2020-07-10 15:28:24', 'admin');
INSERT INTO `sp_bom` VALUES ('1283634934423203842', '333', '2019001', '电子元件', '', '1', NULL, NULL, '0', '2020-07-16 13:29:52', 'admin', '2020-07-16 13:29:52', 'admin');

-- ----------------------------
-- Table structure for sp_bom_item
-- ----------------------------
DROP TABLE IF EXISTS `sp_bom_item`;
CREATE TABLE `sp_bom_item`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `bom_head_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'bom编号',
  `materiel_item_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料ID',
  `materiel_item_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料描述',
  `line_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '行号',
  `item_num` decimal(10, 0) NULL DEFAULT 0 COMMENT '用量',
  `item_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子项基本单位',
  `oper_typer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所属工序类型',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'BOM子项表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sp_factroy
-- ----------------------------
DROP TABLE IF EXISTS `sp_factroy`;
CREATE TABLE `sp_factroy`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `factory` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `factory_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工厂表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_factroy
-- ----------------------------
INSERT INTO `sp_factroy` VALUES ('1336542027055136', 'center', '中心工厂123', '2020-03-12 15:22:02', 'admin', '2020-03-13 10:15:54', 'admin');
INSERT INTO `sp_factroy` VALUES ('1336542142398496', '123', '你好', '2020-03-12 15:22:37', 'admin', '2020-03-12 15:22:37', 'admin');
INSERT INTO `sp_factroy` VALUES ('1336542951899168', 'ABC', 'ABC', '2020-03-12 15:29:03', 'admin', '2020-03-12 15:29:03', 'admin');
INSERT INTO `sp_factroy` VALUES ('1336850679595040', '测试数据12', '测试数据12', '2020-03-14 08:14:39', 'admin', '2020-03-14 08:14:39', 'admin');
INSERT INTO `sp_factroy` VALUES ('1336856843124768', '测试数据2', '测试数据2', '2020-03-14 09:03:38', 'admin', '2020-03-14 09:03:38', 'admin');
INSERT INTO `sp_factroy` VALUES ('1336858327908384', '你好', '你好123', '2020-03-14 09:15:26', 'admin', '2020-03-14 09:17:30', 'admin');
INSERT INTO `sp_factroy` VALUES ('1336858648772640', '订单', '的', '2020-03-14 09:17:59', 'admin', '2020-03-14 09:17:59', 'admin');
INSERT INTO `sp_factroy` VALUES ('1336873681158176', 'we', 'wewe', '2020-03-14 11:17:27', 'admin', '2020-03-14 11:17:27', 'admin');
INSERT INTO `sp_factroy` VALUES ('1336873716809760', 'ds', 'sdsdds', '2020-03-14 11:17:44', 'admin', '2020-03-14 11:17:44', 'admin');

-- ----------------------------
-- Table structure for sp_flow
-- ----------------------------
DROP TABLE IF EXISTS `sp_flow`;
CREATE TABLE `sp_flow`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `flow` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程',
  `flow_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '线体描述',
  `process` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '流程绘制 A——>B——>C',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '流程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_flow
-- ----------------------------
INSERT INTO `sp_flow` VALUES ('1274977236873883649', '666', '666', '装配工序->测试工序->集成测试工序->封胶工序->清洗工序->包装工序', '2020-06-22 16:07:16', 'admin', '2020-07-20 20:49:33', 'admin');
INSERT INTO `sp_flow` VALUES ('1275430361590116354', '002', '111', '装配工序->包装工序', '2020-06-23 22:07:49', 'admin', '2020-06-23 22:07:49', 'admin');
INSERT INTO `sp_flow` VALUES ('1275430501520486401', '111', '222', '测试工序->焊接', '2020-06-23 22:08:23', 'admin', '2020-07-16 09:01:20', 'admin');
INSERT INTO `sp_flow` VALUES ('1277125413169246210', 'asfds', 'sdfsd', '装配工序->测试工序->封胶工序', '2020-06-28 14:23:21', 'admin', '2020-07-20 22:08:39', 'admin');
INSERT INTO `sp_flow` VALUES ('1277176874674663425', 'A01', 'A01', '装配工序->测试工序', '2020-06-28 17:47:50', 'admin', '2020-07-18 20:02:47', 'admin');
INSERT INTO `sp_flow` VALUES ('1277600512544583681', 'A001', 'A001', '装配工序->测试工序->包装工序', '2020-06-29 21:51:14', 'admin', '2020-06-29 21:51:14', 'admin');
INSERT INTO `sp_flow` VALUES ('1278145622063689729', '1212', '1212', '装配工序->包装工序', '2020-07-01 09:57:18', 'admin', '2020-07-01 09:57:18', 'admin');
INSERT INTO `sp_flow` VALUES ('1278528234456330242', 'dc001', '斗车', '装配工序->测试工序->包装工序', '2020-07-02 11:17:40', 'admin', '2020-07-02 11:17:40', 'admin');
INSERT INTO `sp_flow` VALUES ('1279942838902304770', '000005', '0005', '装配工序->包装工序', '2020-07-06 08:58:48', 'admin', '2020-07-06 08:59:11', 'admin');
INSERT INTO `sp_flow` VALUES ('1285142116192968706', '1234', '12222', '装配工序->集成测试工序->封胶工序', '2020-07-20 17:18:52', 'admin', '2020-07-20 17:18:52', 'admin');

-- ----------------------------
-- Table structure for sp_flow_oper_relation
-- ----------------------------
DROP TABLE IF EXISTS `sp_flow_oper_relation`;
CREATE TABLE `sp_flow_oper_relation`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `flow_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程ID',
  `flow` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程代码',
  `per_oper_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '前道工序ID',
  `per_oper` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '前道工序代码',
  `oper_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '当前工序ID',
  `oper` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '当前工序\r\n',
  `next_oper_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '下道工序ID',
  `next_oper` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '下道工序',
  `sort_num` int(11) NOT NULL COMMENT '排序',
  `oper_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序类型（首道工序firstOper;最后一道工序lastOper）',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `flow_id_index`(`flow_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '流程与工序关系表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_flow_oper_relation
-- ----------------------------
INSERT INTO `sp_flow_oper_relation` VALUES ('1267713369412186113', '1267713369349271553', '1111', '', '', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', 1, NULL, '2020-06-02 15:03:15', 'admin', '2020-06-02 15:03:15', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267713369412186114', '1267713369349271553', '1111', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', '', '', 2, NULL, '2020-06-02 15:03:15', 'admin', '2020-06-02 15:03:15', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267788592622841858', '1267788592555732994', '01', '', '', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', 1, NULL, '2020-06-02 20:02:10', 'admin', '2020-06-02 20:02:10', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267788592622841859', '1267788592555732994', '01', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', '1336864575324192', 'APK-01', 2, NULL, '2020-06-02 20:02:10', 'admin', '2020-06-02 20:02:10', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267788592622841860', '1267788592555732994', '01', '1336864537575456', 'TST-02', '1336864575324192', 'APK-01', '1336864613072928', 'TST-01', 3, NULL, '2020-06-02 20:02:10', 'admin', '2020-06-02 20:02:10', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267788592622841861', '1267788592555732994', '01', '1336864575324192', 'APK-01', '1336864613072928', 'TST-01', '', '', 4, NULL, '2020-06-02 20:02:10', 'admin', '2020-06-02 20:02:10', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267990052920864770', '1265284426327371778', '1', '', '', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', 1, NULL, '2020-06-03 09:22:41', 'admin', '2020-06-03 09:22:41', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267990052920864771', '1265284426327371778', '1', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', '1336868507484192', 'JS-01', 2, NULL, '2020-06-03 09:22:41', 'admin', '2020-06-03 09:22:41', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267990052920864772', '1265284426327371778', '1', '1336864537575456', 'TST-02', '1336868507484192', 'JS-01', '1336864575324192', 'APK-01', 3, NULL, '2020-06-03 09:22:41', 'admin', '2020-06-03 09:22:41', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267990052920864773', '1265284426327371778', '1', '1336868507484192', 'JS-01', '1336864575324192', 'APK-01', '', '', 4, NULL, '2020-06-03 09:22:41', 'admin', '2020-06-03 09:22:41', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267990103424479234', '1265589028092358657', '1111', '', '', '1336864489340960', 'ASY-01', '1336864575324192', 'APK-01', 1, NULL, '2020-06-03 09:22:53', 'admin', '2020-06-03 09:22:53', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267990103424479235', '1265589028092358657', '1111', '1336864489340960', 'ASY-01', '1336864575324192', 'APK-01', '1337248255574048', 'RK-01', 2, NULL, '2020-06-03 09:22:53', 'admin', '2020-06-03 09:22:53', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267990103424479236', '1265589028092358657', '1111', '1336864575324192', 'APK-01', '1337248255574048', 'RK-01', '1336868360683552', 'HJ-01', 3, NULL, '2020-06-03 09:22:53', 'admin', '2020-06-03 09:22:53', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1267990103424479237', '1265589028092358657', '1111', '1337248255574048', 'RK-01', '1336868360683552', 'HJ-01', '', '', 4, NULL, '2020-06-03 09:22:53', 'admin', '2020-06-03 09:22:53', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1268001010259046402', '1268001010166771713', '22', '', '', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', 1, NULL, '2020-06-03 10:06:14', 'admin', '2020-06-03 10:06:14', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1268001010259046403', '1268001010166771713', '22', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', '1336864575324192', 'APK-01', 2, NULL, '2020-06-03 10:06:14', 'admin', '2020-06-03 10:06:14', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1268001010259046404', '1268001010166771713', '22', '1336864537575456', 'TST-02', '1336864575324192', 'APK-01', '1336864613072928', 'TST-01', 3, NULL, '2020-06-03 10:06:14', 'admin', '2020-06-03 10:06:14', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1268001010259046405', '1268001010166771713', '22', '1336864575324192', 'APK-01', '1336864613072928', 'TST-01', '1336868360683552', 'HJ-01', 4, NULL, '2020-06-03 10:06:14', 'admin', '2020-06-03 10:06:14', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1268001010259046406', '1268001010166771713', '22', '1336864613072928', 'TST-01', '1336868360683552', 'HJ-01', '1336868452958240', 'FJ-01', 5, NULL, '2020-06-03 10:06:14', 'admin', '2020-06-03 10:06:14', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1268001010259046407', '1268001010166771713', '22', '1336868360683552', 'HJ-01', '1336868452958240', 'FJ-01', '1336868507484192', 'JS-01', 6, NULL, '2020-06-03 10:06:14', 'admin', '2020-06-03 10:06:14', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1268001010259046408', '1268001010166771713', '22', '1336868452958240', 'FJ-01', '1336868507484192', 'JS-01', '1336868562010144', 'QX-01', 7, NULL, '2020-06-03 10:06:14', 'admin', '2020-06-03 10:06:14', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1268001010259046409', '1268001010166771713', '22', '1336868507484192', 'JS-01', '1336868562010144', 'QX-01', '1337248255574048', 'RK-01', 8, NULL, '2020-06-03 10:06:14', 'admin', '2020-06-03 10:06:14', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1268001010259046410', '1268001010166771713', '22', '1336868562010144', 'QX-01', '1337248255574048', 'RK-01', '', '', 9, NULL, '2020-06-03 10:06:14', 'admin', '2020-06-03 10:06:14', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1270229560290684929', '1268552781134016513', '撒大声', '', '', '1336864489340960', 'ASY-01', '1336864575324192', 'APK-01', 1, NULL, '2020-06-09 13:41:42', 'admin', '2020-06-09 13:41:42', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1270229560290684930', '1268552781134016513', '撒大声', '1336864489340960', 'ASY-01', '1336864575324192', 'APK-01', '1336864613072928', 'TST-01', 2, NULL, '2020-06-09 13:41:42', 'admin', '2020-06-09 13:41:42', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1270229560290684931', '1268552781134016513', '撒大声', '1336864575324192', 'APK-01', '1336864613072928', 'TST-01', '', '', 3, NULL, '2020-06-09 13:41:42', 'admin', '2020-06-09 13:41:42', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1270954114197729281', '1270954114151591937', '121', '', '', '1336864489340960', 'ASY-01', '1336864575324192', 'APK-01', 1, NULL, '2020-06-11 13:40:49', 'admin', '2020-06-11 13:40:49', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1270954114197729282', '1270954114151591937', '121', '1336864489340960', 'ASY-01', '1336864575324192', 'APK-01', '', '', 2, NULL, '2020-06-11 13:40:49', 'admin', '2020-06-11 13:40:49', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1270954292094939138', '1270954193277136898', '222222', '', '', '1336864537575456', 'TST-02', '1336868360683552', 'HJ-01', 1, NULL, '2020-06-11 13:41:31', 'admin', '2020-06-11 13:41:31', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1270954292094939139', '1270954193277136898', '222222', '1336864537575456', 'TST-02', '1336868360683552', 'HJ-01', '', '', 2, NULL, '2020-06-11 13:41:31', 'admin', '2020-06-11 13:41:31', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1275430361636253697', '1275430361590116354', '002', '', '', '1336864489340960', 'ASY-01', '1336864575324192', 'APK-01', 1, NULL, '2020-06-23 22:07:49', 'admin', '2020-06-23 22:07:49', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1275430361636253698', '1275430361590116354', '002', '1336864489340960', 'ASY-01', '1336864575324192', 'APK-01', '', '', 2, NULL, '2020-06-23 22:07:49', 'admin', '2020-06-23 22:07:49', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1277600512599109634', '1277600512544583681', 'A001', '', '', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', 1, NULL, '2020-06-29 21:51:14', 'admin', '2020-06-29 21:51:14', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1277600512599109635', '1277600512544583681', 'A001', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', '1336864575324192', 'APK-01', 2, NULL, '2020-06-29 21:51:14', 'admin', '2020-06-29 21:51:14', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1277600512599109636', '1277600512544583681', 'A001', '1336864537575456', 'TST-02', '1336864575324192', 'APK-01', '', '', 3, NULL, '2020-06-29 21:51:14', 'admin', '2020-06-29 21:51:14', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1278145622248239105', '1278145622063689729', '1212', '', '', '1336864489340960', 'ASY-01', '1336864575324192', 'APK-01', 1, NULL, '2020-07-01 09:57:18', 'admin', '2020-07-01 09:57:18', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1278145622248239106', '1278145622063689729', '1212', '1336864489340960', 'ASY-01', '1336864575324192', 'APK-01', '', '', 2, NULL, '2020-07-01 09:57:18', 'admin', '2020-07-01 09:57:18', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1278528234506661890', '1278528234456330242', 'dc001', '', '', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', 1, NULL, '2020-07-02 11:17:40', 'admin', '2020-07-02 11:17:40', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1278528234506661891', '1278528234456330242', 'dc001', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', '1336864575324192', 'APK-01', 2, NULL, '2020-07-02 11:17:40', 'admin', '2020-07-02 11:17:40', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1278528234506661892', '1278528234456330242', 'dc001', '1336864537575456', 'TST-02', '1336864575324192', 'APK-01', '', '', 3, NULL, '2020-07-02 11:17:40', 'admin', '2020-07-02 11:17:40', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1279942938785460225', '1279942838902304770', '000005', '', '', '1336864489340960', 'ASY-01', '1336864575324192', 'APK-01', 1, NULL, '2020-07-06 08:59:11', 'admin', '2020-07-06 08:59:11', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1279942938785460226', '1279942838902304770', '000005', '1336864489340960', 'ASY-01', '1336864575324192', 'APK-01', '', '', 2, NULL, '2020-07-06 08:59:11', 'admin', '2020-07-06 08:59:11', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1283567357256773634', '1275430501520486401', '111', '', '', '1336864537575456', 'TST-02', '1336868360683552', 'HJ-01', 1, NULL, '2020-07-16 09:01:20', 'admin', '2020-07-16 09:01:20', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1283567357256773635', '1275430501520486401', '111', '1336864537575456', 'TST-02', '1336868360683552', 'HJ-01', '', '', 2, NULL, '2020-07-16 09:01:20', 'admin', '2020-07-16 09:01:20', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1284458592561508353', '1277176874674663425', 'A01', '', '', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', 1, NULL, '2020-07-18 20:02:47', 'admin', '2020-07-18 20:02:47', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1284458592561508354', '1277176874674663425', 'A01', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', '', '', 2, NULL, '2020-07-18 20:02:47', 'admin', '2020-07-18 20:02:47', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1285142116356546562', '1285142116192968706', '1234', '', '', '1336864489340960', 'ASY-01', '1336864613072928', 'TST-01', 1, NULL, '2020-07-20 17:18:52', 'admin', '2020-07-20 17:18:52', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1285142116385906690', '1285142116192968706', '1234', '1336864489340960', 'ASY-01', '1336864613072928', 'TST-01', '1336868452958240', 'FJ-01', 2, NULL, '2020-07-20 17:18:52', 'admin', '2020-07-20 17:18:52', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1285142116385906691', '1285142116192968706', '1234', '1336864613072928', 'TST-01', '1336868452958240', 'FJ-01', '', '', 3, NULL, '2020-07-20 17:18:52', 'admin', '2020-07-20 17:18:52', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1285195135865544705', '1274977236873883649', '666', '', '', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', 1, NULL, '2020-07-20 20:49:33', 'admin', '2020-07-20 20:49:33', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1285195135865544706', '1274977236873883649', '666', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', '1336864613072928', 'TST-01', 2, NULL, '2020-07-20 20:49:33', 'admin', '2020-07-20 20:49:33', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1285195135865544707', '1274977236873883649', '666', '1336864537575456', 'TST-02', '1336864613072928', 'TST-01', '1336868452958240', 'FJ-01', 3, NULL, '2020-07-20 20:49:33', 'admin', '2020-07-20 20:49:33', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1285195135865544708', '1274977236873883649', '666', '1336864613072928', 'TST-01', '1336868452958240', 'FJ-01', '1336868562010144', 'QX-01', 4, NULL, '2020-07-20 20:49:33', 'admin', '2020-07-20 20:49:33', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1285195135865544709', '1274977236873883649', '666', '1336868452958240', 'FJ-01', '1336868562010144', 'QX-01', '1336864575324192', 'APK-01', 5, NULL, '2020-07-20 20:49:33', 'admin', '2020-07-20 20:49:33', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1285195135865544710', '1274977236873883649', '666', '1336868562010144', 'QX-01', '1336864575324192', 'APK-01', '', '', 6, NULL, '2020-07-20 20:49:33', 'admin', '2020-07-20 20:49:33', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1285215041575149569', '1277125413169246210', 'asfds', '', '', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', 1, NULL, '2020-07-20 22:08:39', 'admin', '2020-07-20 22:08:39', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1285215041575149570', '1277125413169246210', 'asfds', '1336864489340960', 'ASY-01', '1336864537575456', 'TST-02', '1336868452958240', 'FJ-01', 2, NULL, '2020-07-20 22:08:39', 'admin', '2020-07-20 22:08:39', 'admin');
INSERT INTO `sp_flow_oper_relation` VALUES ('1285215041575149571', '1277125413169246210', 'asfds', '1336864537575456', 'TST-02', '1336868452958240', 'FJ-01', '', '', 3, NULL, '2020-07-20 22:08:39', 'admin', '2020-07-20 22:08:39', 'admin');

-- ----------------------------
-- Table structure for sp_line
-- ----------------------------
DROP TABLE IF EXISTS `sp_line`;
CREATE TABLE `sp_line`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `line` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '线体',
  `line_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '线体描述',
  `process_section` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序段代号',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '线体表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_line
-- ----------------------------
INSERT INTO `sp_line` VALUES ('1336867983196192', 'WZY-ASY-01', '装配线体01线', '从vv', '2020-03-14 10:32:10', 'admin', '2020-06-14 02:20:09', 'admin');
INSERT INTO `sp_line` VALUES ('1336868041916448', 'WZY-TEST-01', '测试01线体', 'TST', '2020-03-14 10:32:38', 'admin', '2020-03-14 10:32:38', 'admin');
INSERT INTO `sp_line` VALUES ('1336868662673440', 'WZY-DC-01', '电池组装01线', 'ASY', '2020-03-14 10:37:34', 'admin', '2020-06-16 11:47:04', 'admin');

-- ----------------------------
-- Table structure for sp_materile
-- ----------------------------
DROP TABLE IF EXISTS `sp_materile`;
CREATE TABLE `sp_materile`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `materiel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料编码',
  `materiel_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料描述',
  `unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '基本单位',
  `product_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '产品组',
  `mat_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料类型',
  `model` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '型号',
  `size` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '尺寸',
  `flow_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '流程',
  `flow_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '流程描述',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '基础物料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_materile
-- ----------------------------
INSERT INTO `sp_materile` VALUES ('1284051625900748801', '000001', '成品测试', '件', '产品1组', 'FG', '大', '8*8', '1279942838902304770', '0005', '2020-07-17 17:05:39', 'admin', '2020-07-21 08:32:19', 'admin', '0');

-- ----------------------------
-- Table structure for sp_oper
-- ----------------------------
DROP TABLE IF EXISTS `sp_oper`;
CREATE TABLE `sp_oper`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `oper` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序\r\n',
  `oper_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '工序描述',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工序表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_oper
-- ----------------------------
INSERT INTO `sp_oper` VALUES ('1336864489340960', 'ASY-01', '装配工序', '2020-03-14 10:04:24', 'admin', '2020-03-14 10:04:24', 'admin');
INSERT INTO `sp_oper` VALUES ('1336864537575456', 'TST-02', '测试工序', '2020-03-14 10:04:47', 'admin', '2020-03-14 10:04:47', 'admin');
INSERT INTO `sp_oper` VALUES ('1336864575324192', 'APK-01', '包装工序', '2020-03-14 10:05:05', 'admin', '2020-03-14 10:05:05', 'admin');
INSERT INTO `sp_oper` VALUES ('1336864613072928', 'TST-01', '集成测试工序', '2020-03-14 10:05:23', 'admin', '2020-03-14 10:05:23', 'admin');
INSERT INTO `sp_oper` VALUES ('1336868360683552', 'HJ-01', '焊接', '2020-03-14 10:35:10', 'admin', '2020-03-14 10:35:10', 'admin');
INSERT INTO `sp_oper` VALUES ('1336868452958240', 'FJ-01', '封胶工序', '2020-03-14 10:35:54', 'admin', '2020-03-14 10:35:54', 'admin');
INSERT INTO `sp_oper` VALUES ('1336868507484192', 'JS-01', '加酸工序', '2020-03-14 10:36:20', 'admin', '2020-03-14 10:36:20', 'admin');
INSERT INTO `sp_oper` VALUES ('1336868562010144', 'QX-01', '清洗工序', '2020-03-14 10:36:46', 'admin', '2020-03-14 10:36:46', 'admin');
INSERT INTO `sp_oper` VALUES ('1337248255574048', 'RK-01', '入库工序', '2020-03-16 12:54:18', 'admin', '2020-03-16 12:54:18', 'admin');

-- ----------------------------
-- Table structure for sp_order
-- ----------------------------
DROP TABLE IF EXISTS `sp_order`;
CREATE TABLE `sp_order`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `order_code` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工单编号',
  `order_description` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '工单描述',
  `qty` int(255) NULL DEFAULT NULL COMMENT '工单数量',
  `order_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '订单类型 P 量产 A验证 F返工 ',
  `flow_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '流程ID',
  `materiel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料编码',
  `materiel_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料描述',
  `plan_start_time` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '计划开始时间',
  `plan_end_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '计划结束时间',
  `statue` tinyint(255) NULL DEFAULT NULL COMMENT '1已创建/待审批 2已审批 3订单结束 4订单终结',
  `designer_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设计人用户ID',
  `designer_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设计人',
  `approve_user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批人用户ID',
  `approve_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批人',
  `approve_time` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '审批时间',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sp_sys_department
-- ----------------------------
DROP TABLE IF EXISTS `sp_sys_department`;
CREATE TABLE `sp_sys_department`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sort_num` int(11) NOT NULL,
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sp_sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sp_sys_dict`;
CREATE TABLE `sp_sys_dict`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签名',
  `value` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '数据值',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '描述',
  `sort_num` int(11) NOT NULL COMMENT '排序（升序）',
  `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '父级id',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sp_sys_dict_name`(`type`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_sys_dict
-- ----------------------------
INSERT INTO `sp_sys_dict` VALUES ('1337618042191904', '成品', 'FG', 'material_type', '物料类型', 2, '\"\"', '0', '2020-03-18 13:53:06', 'admin', '2020-03-18 13:53:06', 'admin');
INSERT INTO `sp_sys_dict` VALUES ('1337618163826720', '半成品', 'PG', 'material_type', '物料类型', 3, '\"\"', '0', '2020-03-18 13:54:04', 'admin', '2020-03-18 13:54:04', 'admin');
INSERT INTO `sp_sys_dict` VALUES ('1337618837012512', '个', 'PCS', 'ORDER_UNIT', '生产单位', 1, '\"\"', '0', '2020-03-18 13:59:25', 'admin', '2020-03-18 13:59:41', 'admin');
INSERT INTO `sp_sys_dict` VALUES ('1337618939772960', '箱', 'BOX', 'ORDER_UNIT', '生产单位', 2, '\"\"', '0', '2020-03-18 14:00:14', 'admin', '2020-03-18 14:00:14', 'admin');

-- ----------------------------

-- ----------------------------
-- Table structure for sp_sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sp_sys_menu`;
CREATE TABLE `sp_sys_menu`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单URL',
  `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '父菜单ID，一级菜单设为0',
  `grade` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '层级：1级、2级、3级......',
  `sort_num` int(11) NOT NULL COMMENT '排序',
  `type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型：0 目录；1 菜单；2 按钮',
  `permission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '授权(多个用逗号分隔，如：sys:menu:list,sys:menu:create)',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '菜单图标',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '描述',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_sp_sys_menu_name`(`name`) USING BTREE,
  UNIQUE INDEX `idx_sp_sys_menu_code`(`code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_sys_menu
-- ----------------------------
INSERT INTO `sp_sys_menu` VALUES ('1', 'currency', '常规管理', '#', '0', '1', 1, '0', 'user:add', 'fa fa-address-book', '', '2019-10-18 11:18:29', 'SongPeng', '2020-03-13 14:07:09', 'admin');
INSERT INTO `sp_sys_menu` VALUES ('10', 'system', '系统管理', '#', '1', '2', 1, '0', 'user:add', 'fa fa-gears', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
INSERT INTO `sp_sys_menu` VALUES ('101', 'menu', '菜单管理', '/admin/sys/menu/list-ui', '10', '3', 1, '0', 'user:add', 'fa fa-bars', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
INSERT INTO `sp_sys_menu` VALUES ('102', 'user', '用户管理', '/admin/sys/user/list-ui', '10', '3', 2, '0', 'user:add', 'fa fa-user', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
INSERT INTO `sp_sys_menu` VALUES ('103', 'role', '角色管理', '/admin/sys/role/list-ui', '10', '3', 3, '0', 'user:add', 'fa fa-child', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
INSERT INTO `sp_sys_menu` VALUES ('104', 'department', '部门管理', '/admin/sys/department/list-ui', '10', '3', 4, '0', 'user:add', 'fa fa-sitemap', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
INSERT INTO `sp_sys_menu` VALUES ('12', 'order', '计划管理', '', '1', '2', 4, '0', 'user:add', 'fa fa-calendar', '', '2019-10-18 11:18:29', 'Wangziyang', '2021-02-21 14:59:56', 'admin');
INSERT INTO `sp_sys_menu` VALUES ('121', 'orderRelease', '工单下达', '/order/release/list-ui', '12', '3', 1, '0', 'user:add', 'fa fa-flag-o', '', '2019-10-18 11:18:29', 'Wangziyang', '2019-10-18 11:18:29', 'Wangziyang');
INSERT INTO `sp_sys_menu` VALUES ('13', 'materiel', '物料管理', '#', '1', '2', 2, '0', 'user:add', 'fa fa-cubes', '', '2019-10-18 11:18:29', 'Wangziyang', '2019-10-18 11:18:29', 'Wangziyang');
INSERT INTO `sp_sys_menu` VALUES ('131', 'matdef', '物料维护', '/basedata/materile/list-ui', '13', '3', 1, '0', 'user:add', 'fa fa-microchip', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
INSERT INTO `sp_sys_menu` VALUES ('14', 'Digitalplatform\n\n', '数字化平台', '#', '1', '2', 6, '0', 'user:add', 'fa fa-pie-chart', '', '2019-10-18 11:18:29', 'Wangziyang', '2019-10-18 11:18:29', 'Wangziyang');
INSERT INTO `sp_sys_menu` VALUES ('141', 'plandg', '智慧大屏', '/digitization/plan/plan-ui', '14', '3', 1, '0', 'user:add', 'fa fa-desktop', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
INSERT INTO `sp_sys_menu` VALUES ('15', 'ProcessManage', '工艺管理', '', '1', '2', 3, '0', 'user:add', 'fa fa-wrench', '', '2019-10-18 11:18:29', 'Wangziyang', '2021-02-21 15:01:47', 'admin');
INSERT INTO `sp_sys_menu` VALUES ('151', 'flowProcess', '工艺路线管理', '/basedata/flow/process/list-ui', '15', '3', 1, '0', 'user:add', 'fa fa-retweet', '', '2019-10-18 11:18:29', 'Wangziyang', '2019-10-18 11:18:29', 'Wangziyang');
INSERT INTO `sp_sys_menu` VALUES ('152', 'bom', '产品BOM管理', '/technology/bom/list-ui', '15', '3', 2, '0', 'user:add', 'fa fa-file-text-o', '产品BOM管理', '2019-10-18 11:18:29', 'Wangziyang', '2019-10-18 11:18:29', 'Wangziyang');
INSERT INTO `sp_sys_menu` VALUES ('16', 'wip', '在制品管理', '#', '1', '2', 5, '0', 'user:add', 'fa fa-industry', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
INSERT INTO `sp_sys_menu` VALUES ('161', 'generalSnProcess', 'SN通用过程采集', '/rrr', '16', '3', 1, '0', 'user:add', 'fa fa-product-hunt', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
INSERT INTO `sp_sys_menu` VALUES ('17', 'DigitalSimulation', '黑科数字孪生', '#', '1', '2', 7, '0', 'user:add', 'fa fa-ravelry', '', '2019-10-18 11:18:29', 'Wangziyang', '2019-10-18 11:18:29', 'Wangziyang');
INSERT INTO `sp_sys_menu` VALUES ('171', 'DigitalSimulationFrom', '数字仿真3D仓库', '/digital/simulation/list-ui', '17', '3', 1, '0', 'user:add', 'fa fa-codepen', '', '2019-10-18 11:18:29', 'Wangziyang', '2019-10-18 11:18:29', 'Wangziyang');
INSERT INTO `sp_sys_menu` VALUES ('2', 'component', 'OPC操作', '#', '0', '1', 1, '0', 'user:add', 'fa fa-lemon-o', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
INSERT INTO `sp_sys_menu` VALUES ('3', 'other', '其他管理', '#', '0', '1', 1, '0', 'user:add', 'fa fa-slideshare', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
-- ============================================================
-- [16] source: sn-process-collect-upgrade-20260608.sql
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

SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------
-- Table structure for sp_sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sp_sys_role`;
CREATE TABLE `sp_sys_role`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色编码',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '角色描述',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_sp_sys_role_name`(`name`) USING BTREE,
  UNIQUE INDEX `idx_sp_sys_role_code`(`code`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_sys_role
-- ----------------------------
INSERT INTO `sp_sys_role` VALUES ('1185025876737396738', '超级管理员', 'admin', '超级管理员', '0', '2019-10-18 10:52:40', 'SongPeng', '2020-03-13 14:06:43', 'admin');
INSERT INTO `sp_sys_role` VALUES ('1232532514523213826', '体验者123', 'experience', '体验者', '0', '2020-02-26 13:07:05', 'admin', '2020-06-03 15:05:59', 'admin');
INSERT INTO `sp_sys_role` VALUES ('1274963902774620161', '12', '12', '12', '0', '2020-06-22 15:14:17', 'admin', '2020-06-22 15:14:17', 'admin');
INSERT INTO `sp_sys_role` VALUES ('1274963930100510721', '1212', '1212', '1212', '0', '2020-06-22 15:14:23', 'admin', '2020-06-22 15:14:23', 'admin');
INSERT INTO `sp_sys_role` VALUES ('1274963986383876098', '1311', '121', '111', '0', '2020-06-22 15:14:37', 'admin', '2020-06-22 15:14:37', 'admin');
INSERT INTO `sp_sys_role` VALUES ('1274964058609790977', '12121212', '12121', '1212', '0', '2020-06-22 15:14:54', 'admin', '2020-06-22 15:14:54', 'admin');
INSERT INTO `sp_sys_role` VALUES ('1274964096777957377', '1313', '12121212', '121212', '0', '2020-06-22 15:15:03', 'admin', '2020-06-22 15:15:03', 'admin');
INSERT INTO `sp_sys_role` VALUES ('1274964138322538497', '331', '1222', '22', '0', '2020-06-22 15:15:13', 'admin', '2020-06-22 15:15:13', 'admin');
INSERT INTO `sp_sys_role` VALUES ('1274964176301961218', '1211', '1111', '1111', '0', '2020-06-22 15:15:22', 'admin', '2020-06-22 15:15:22', 'admin');
INSERT INTO `sp_sys_role` VALUES ('1274964233344495618', '443', '333', '3', '0', '2020-06-22 15:15:36', 'admin', '2020-06-22 15:15:36', 'admin');
INSERT INTO `sp_sys_role` VALUES ('1280124406522425346', '11', '11', '11', '0', '2020-07-06 21:00:17', 'admin', '2020-07-06 21:00:17', 'admin');
INSERT INTO `sp_sys_role` VALUES ('1281217564303929346', '2315', '4324', '42342', '0', '2020-07-09 21:24:06', 'admin', '2020-07-17 00:34:09', 'admin');
INSERT INTO `sp_sys_role` VALUES ('1336542182244384', '王子杨', '123', '王子杨', '0', '2020-03-12 15:22:56', 'admin', '2020-03-12 15:22:56', 'admin');

-- ----------------------------
-- Table structure for sp_sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sp_sys_role_menu`;
CREATE TABLE `sp_sys_role_menu`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `role_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色id',
  `menu_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单id',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色对应的菜单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_sys_role_menu
-- ----------------------------
INSERT INTO `sp_sys_role_menu` VALUES ('1', '1185025876737396738', '1', '2019-10-28 14:51:44', 'admin', '2019-10-28 14:51:56', 'admin');
INSERT INTO `sp_sys_role_menu` VALUES ('2', '1185025876737396738', '2', '2019-10-28 14:51:44', 'admin', '2019-10-28 14:51:56', 'admin');
INSERT INTO `sp_sys_role_menu` VALUES ('3', '1185025876737396738', '3', '2019-10-28 14:51:44', 'admin', '2019-10-28 14:51:56', 'admin');
INSERT INTO `sp_sys_role_menu` VALUES ('4', '1185025876737396738', '101', '2019-10-28 14:51:44', 'admin', '2019-10-28 14:51:56', 'admin');
INSERT INTO `sp_sys_role_menu` VALUES ('5', '1185025876737396738', '102', '2019-10-28 14:51:44', 'admin', '2019-10-28 14:51:56', 'admin');
INSERT INTO `sp_sys_role_menu` VALUES ('6', '1185025876737396738', '103', '2019-10-28 14:51:44', 'admin', '2019-10-28 14:51:56', 'admin');
INSERT INTO `sp_sys_role_menu` VALUES ('7', '1185025876737396738', '104', '2019-10-28 14:51:44', 'admin', '2019-10-28 14:51:56', 'admin');

-- ----------------------------
-- Table structure for sp_sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sp_sys_user`;
CREATE TABLE `sp_sys_user`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '姓名',
  `username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `dept_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '部门id',
  `email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '邮箱',
  `mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手机号',
  `tel` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '固定电话',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '性别(0:女;1:男;2:其他)',
  `birthday` datetime(0) NULL DEFAULT NULL COMMENT '出生年月日',
  `pic_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '图片id，对应sys_file表中的id',
  `id_card` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '身份证',
  `hobby` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '爱好',
  `province` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '省份',
  `city` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '城市',
  `district` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '区县',
  `street` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '街道',
  `street_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '门牌号',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '\"\"' COMMENT '描述',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_sp_sys_user_username`(`username`) USING BTREE COMMENT '用户名唯一索引',
  UNIQUE INDEX `idx_sp_sys_user_mobile`(`mobile`) USING BTREE COMMENT '用户手机号唯一索引',
  INDEX `idx_sp_sys_user_email`(`email`) USING BTREE COMMENT '用户邮箱唯一索引',
  INDEX `idx_sp_sys_user_id_card`(`id_card`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_sys_user
-- ----------------------------
INSERT INTO `sp_sys_user` VALUES ('1184009088826392578', '宋鹏', 'iamsongpeng', '9d7281eeaebded0b091340cfa658a7e8', '', '', '13776337795', '', '1', NULL, '', '', '', '', '', '', '', '', '', '0', '2019-10-15 15:32:19', 'SongPeng', '2020-02-28 16:44:59', 'admin');
INSERT INTO `sp_sys_user` VALUES ('1184010472443396098', '猴子', 'monkey', '9d7281eeaebded0b091340cfa658a7e8', '123', '', '137763377', '', '0', NULL, '', '', '', '', '', '', '', '', '', '0', '2019-10-15 15:37:52', 'SongPeng', '2020-02-26 15:03:32', 'admin');
INSERT INTO `sp_sys_user` VALUES ('1184019107907227649', '超级管理员', 'admin', '9d7281eeaebded0b091340cfa658a7e8', '11', '', '13776337796', '44', '0', NULL, '55', '66', '77', '88', '99', '10', '11', '12', '13', '0', '2019-10-15 16:12:08', 'SongPeng', '2020-03-24 11:08:22', 'admin');
INSERT INTO `sp_sys_user` VALUES ('1266201180838801409', 'cassman', 'cassman.yang', '0302726d276d6b011d85404f2beb14a4', '90573703', 'cassman.yang@qq.com', '1111', '86195', '1', '2019-05-21 00:00:00', '#sd', '45+645+65+6511', 'swim', 'sad', 'dsa', 'fasd', 'daf', 'dsaf', 'daf', '0', '2020-05-29 10:54:21', 'admin', '2020-06-02 16:45:25', 'admin');
INSERT INTO `sp_sys_user` VALUES ('1276512902757724162', '小明', 'xm', 'a7c3fcdeca8ce6d49d2680eecd5e7431', '1', '1@qq.com', '19298833438', '323232', '0', '1998-09-12 00:00:00', '1', '1', '12', '1', '1', '1', '1', '1', '1', '0', '2020-06-26 21:49:27', 'admin', '2020-07-07 14:00:52', 'admin');

-- ----------------------------
-- Table structure for sp_sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sp_sys_user_role`;
CREATE TABLE `sp_sys_user_role`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户id',
  `role_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色id',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户对应的角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_sys_user_role
-- ----------------------------
INSERT INTO `sp_sys_user_role` VALUES ('1242287110472966146', '1184019107907227649', '1185025876737396738', '2020-03-24 11:08:22', 'admin', '2020-03-24 11:08:22', 'admin');
INSERT INTO `sp_sys_user_role` VALUES ('1267739082731270146', '1266201180838801409', '1336542182244384', '2020-06-02 16:45:25', 'admin', '2020-06-02 16:45:25', 'admin');
INSERT INTO `sp_sys_user_role` VALUES ('1280381244774002690', '1276512902757724162', '1232532514523213826', '2020-07-07 14:00:52', 'admin', '2020-07-07 14:00:52', 'admin');

-- ----------------------------
-- Table structure for sp_work_shop
-- ----------------------------
DROP TABLE IF EXISTS `sp_work_shop`;
CREATE TABLE `sp_work_shop`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `work_shop` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `work_shop_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '工作车间表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_work_shop
-- ----------------------------
INSERT INTO `sp_work_shop` VALUES ('1336875254022176', 'DC-车间1', '电池组装车间', '2020-03-14 11:29:57', 'admin', '2020-03-18 10:52:39', 'admin');
INSERT INTO `sp_work_shop` VALUES ('1336875591663648', 'DC-JS01', '加酸车间', '2020-03-14 11:32:38', 'admin', '2020-03-14 11:32:38', 'admin');

SET FOREIGN_KEY_CHECKS = 1;


-- ============================================================
-- [1] source: role-upgrade-20260526.sql
-- ============================================================
-- ============================================================
-- 角色权限管理增强 - 数据库迁移脚本
-- 创建时间: 2026-05-26
-- ============================================================

-- ----------------------------
-- 1. 扩展 sp_sys_role 表字段
-- ----------------------------
ALTER TABLE `sp_sys_role`
  ADD COLUMN `sort_num`       int(11)     NOT NULL DEFAULT 0    COMMENT '排序号'           AFTER `descr`,
  ADD COLUMN `is_system_role` char(1)     NOT NULL DEFAULT '0'  COMMENT '系统角色(0否1是)'  AFTER `sort_num`,
  ADD COLUMN `user_type`      varchar(32) DEFAULT NULL           COMMENT '用户类型'          AFTER `is_system_role`,
  ADD COLUMN `role_category`  varchar(32) DEFAULT NULL           COMMENT '角色分类'          AFTER `user_type`,
  ADD COLUMN `data_scope`     varchar(32) DEFAULT NULL           COMMENT '数据范围'          AFTER `role_category`,
  ADD COLUMN `business_scope` varchar(32) DEFAULT NULL           COMMENT '业务范围'          AFTER `data_scope`;

-- ----------------------------
-- 2. 字典数据：用户类型 user_type
-- ----------------------------
INSERT INTO `sp_sys_dict` (id, name, value, type, descr, sort_num, parent_id, is_deleted, create_time, create_username, update_time, update_username) VALUES
('roledict001', '员工',   'employee',  'user_type', '用户类型-员工',   1, '""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict002', '管理员', 'manager',   'user_type', '用户类型-管理员', 2, '""', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 3. 字典数据：角色分类 role_category
-- ----------------------------
INSERT INTO `sp_sys_dict` (id, name, value, type, descr, sort_num, parent_id, is_deleted, create_time, create_username, update_time, update_username) VALUES
('roledict011', '普通角色', 'normal',   'role_category', '角色分类-普通角色', 1, '""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict012', '系统角色', 'system',   'role_category', '角色分类-系统角色', 2, '""', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 4. 字典数据：数据范围 data_scope
-- ----------------------------
INSERT INTO `sp_sys_dict` (id, name, value, type, descr, sort_num, parent_id, is_deleted, create_time, create_username, update_time, update_username) VALUES
('roledict021', '全部数据',       'all',       'data_scope', '数据范围-全部',         1, '""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict022', '本部门',         'dept',      'data_scope', '数据范围-本部门',       2, '""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict023', '本部门及子部门', 'dept_child','data_scope', '数据范围-本部门及子部门',3,'""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict024', '仅本人',         'self',      'data_scope', '数据范围-仅本人',       4, '""', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 5. 字典数据：业务范围 business_scope
-- ----------------------------
INSERT INTO `sp_sys_dict` (id, name, value, type, descr, sort_num, parent_id, is_deleted, create_time, create_username, update_time, update_username) VALUES
('roledict031', '全部业务',     'all',       'business_scope', '业务范围-全部',     1, '""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict032', '本部门业务',   'dept',      'business_scope', '业务范围-本部门',   2, '""', '0', NOW(), 'admin', NOW(), 'admin'),
('roledict033', '指定业务模块', 'specified', 'business_scope', '业务范围-指定模块', 3, '""', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 6. 插入7个预设角色（IGNORE 跳过已存在的记录）
-- ----------------------------
INSERT IGNORE INTO `sp_sys_role` (id, name, code, descr, sort_num, is_system_role, user_type, role_category, is_deleted, create_time, create_username, update_time, update_username) VALUES
('r_mes_001', '数据员',    'baseDataRole',          '基础数据管理角色，负责物料、基础配置等数据维护',     10, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin'),
('r_mes_002', '工艺员',    'technologyRole',        '产品工艺管理角色，负责BOM和工艺路线维护',           20, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin'),
('r_mes_003', '生产计划员','productionPlannerRole',  '生产计划管理角色，负责工单下达和生产计划',           30, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin'),
('r_mes_004', '生产主管',  'productionManagerRole', '生产及设备管理角色，负责生产计划和设备管理',         40, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin'),
('r_mes_005', '生产作业员','productionOperatorRole', '生产执行角色，负责在制品过程采集和生产执行',         50, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin'),
('r_mes_006', '库房管理员','warehouseManagerRole',   '库房管理角色，负责库存和物料出入库管理',             60, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin'),
('r_mes_007', '质量管理员','qualityManagerRole',     '质量管理角色，负责质量检验和质量报表',               70, '0', 'employee', 'normal', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 7. 预设角色菜单分配（基于现有菜单结构）
-- 说明：通过 menu code 关联，适应不同部署环境的菜单ID
-- ----------------------------

-- 数据员 → 常规管理根节点 + 物料管理模块 + 基础数据配置
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_001', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'materiel', 'matdef', 'basedata', 'basedatamanager', 'system');

-- 工艺员 → 常规管理根节点 + 工艺管理模块（工艺路线、BOM）
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_002', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'ProcessManage', 'flowProcess', 'bom');

-- 生产计划员 → 常规管理根节点 + 计划管理模块
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_003', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'order', 'orderRelease');

-- 生产主管 → 常规管理根节点 + 计划管理 + 数字化平台（含看板大屏，近似设备管理）
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_004', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'order', 'orderRelease', 'Digitalplatform', 'plandg');

-- 生产作业员 → 常规管理根节点 + 在制品管理（生产执行）
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_005', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'wip', 'generalSnProcess');

-- 库房管理员 → 常规管理根节点 + 物料管理（库房模块待扩展时补充）
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_006', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'materiel', 'matdef', 'order', 'orderRelease');

-- 质量管理员 → 常规管理根节点 + 数字化平台（质量模块待扩展时补充）
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_007', id, NOW(), 'admin', NOW(), 'admin'
FROM sp_sys_menu WHERE code IN ('currency', 'Digitalplatform', 'plandg');

-- ----------------------------
-- 8. 角色管理直接挂在"系统管理"目录下（已取消多余的"权限管理"中间目录，见 menu-role-flatten-upgrade-20260609.sql）
-- ----------------------------
UPDATE `sp_sys_menu` SET parent_id = '10', grade = '3', sort_num = 3 WHERE id = '103';

-- ----------------------------
-- 9. 给 code='888888' 的角色（系统管理员）分配全部菜单
-- 先清空该角色原有菜单关联，再重新插入全量菜单
-- ----------------------------
DELETE srm FROM `sp_sys_role_menu` srm
INNER JOIN `sp_sys_role` r ON r.id = srm.role_id
WHERE r.code = '888888';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888';


-- ============================================================
-- [2] source: bom-hierarchy-upgrade-20260526.sql
-- ============================================================
-- ============================================================
-- BOM 三层层级结构升级迁移脚本
-- Date: 2026-05-26
-- Description: 升级扁平BOM为三层层级结构
-- ============================================================

-- 1. sp_bom_item 新增 child_bom_id 和 item_mat_type 两列
ALTER TABLE `sp_bom_item`
    ADD COLUMN `child_bom_id` varchar(64) NULL DEFAULT NULL
        COMMENT '子BOM ID (当子项是组件/半成品时关联sp_bom.id)' AFTER `oper_typer`,
    ADD COLUMN `item_mat_type` varchar(10) NULL DEFAULT NULL
        COMMENT '子项物料类型 FG/PG/COMP/PART' AFTER `child_bom_id`,
    ADD INDEX `idx_bom_item_child_bom_id` (`child_bom_id`),
    ADD INDEX `idx_bom_item_bom_head_id` (`bom_head_id`);

-- 2. sp_bom 新增 bom_level 列
ALTER TABLE `sp_bom`
    ADD COLUMN `bom_level` tinyint(1) NOT NULL DEFAULT 0
        COMMENT 'BOM层级: 0=成品BOM 1=半成品BOM 2=组件BOM' AFTER `factory`;

-- 3. 字典新增 COMP=组件、PART=零件（material_type 类型）
INSERT INTO `sp_sys_dict`
    (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
     `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
    (REPLACE(UUID(), '-', ''), '组件', 'COMP', 'material_type', '物料类型-组件', 4, '""', '0',
     NOW(), 'admin', NOW(), 'admin'),
    (REPLACE(UUID(), '-', ''), '零件', 'PART', 'material_type', '物料类型-零件', 5, '""', '0',
     NOW(), 'admin', NOW(), 'admin');


-- ============================================================
-- [3] source: bom-lock-upgrade-20260526.sql
-- ============================================================
-- ============================================================
-- BOM 定版与有效性字段升级
-- Date: 2026-05-26
-- ============================================================

ALTER TABLE `sp_bom`
    ADD COLUMN `lock_status` varchar(10) NOT NULL DEFAULT 'draft'
        COMMENT '定版标识: draft=草稿 locked=已定版' AFTER `bom_level`,
    ADD COLUMN `validity` varchar(10) NOT NULL DEFAULT '有效'
        COMMENT '有效性: 有效/无效' AFTER `lock_status`;


-- ============================================================
-- [4] source: process-design-upgrade-20260528.sql
-- ============================================================
-- ============================================================
-- 工艺设计管理增强 - 数据库迁移脚本
-- 创建时间: 2026-05-28
-- 内容：
--   1) 新增 加工单元、设备 主数据
--   2) 扩展 sp_oper（工序信息定义）字段
--   3) 新增 工艺流程管理（按BOM节点绑定工序）
--   4) 新增 工艺内容编制（7步向导）相关表
--   5) 菜单和角色权限同步
-- ============================================================

-- ----------------------------
-- 1. 加工单元 sp_processing_unit
-- ----------------------------
DROP TABLE IF EXISTS `sp_processing_unit`;
CREATE TABLE `sp_processing_unit` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `unit_code`       varchar(32)  NOT NULL                COMMENT '加工单元编号 JG000001',
  `unit_name`       varchar(128) NOT NULL                COMMENT '加工单元名称',
  `unit_type`       varchar(32)  NOT NULL DEFAULT 'person' COMMENT '加工单元类型 person=人员作业单元 device=设备作业单元',
  `description`     varchar(500) DEFAULT NULL            COMMENT '描述',
  `status`          char(1)      NOT NULL DEFAULT '0'    COMMENT '状态 0正常 2异常',
  `is_deleted`      char(1)      NOT NULL DEFAULT '0'    COMMENT '是否删除',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  `update_time`     datetime     NOT NULL                COMMENT '最后更新时间',
  `update_username` varchar(64)  NOT NULL                COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unit_code` (`unit_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='加工单元主数据';

INSERT INTO `sp_processing_unit` VALUES
('jg_unit_001', 'JG000001', '电脑组装单元', 'person', 'PDF示例-电脑组装作业人员单元', '0', '0', NOW(), 'admin', NOW(), 'admin'),
('jg_unit_002', 'JG000002', '加工单元1',     'device', 'PDF示例-轮毂上线工序所属单元',   '0', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 2. 设备 sp_equipment
-- ----------------------------
DROP TABLE IF EXISTS `sp_equipment`;
CREATE TABLE `sp_equipment` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `equipment_code`  varchar(32)  NOT NULL                COMMENT '设备编号 EQ000001',
  `equipment_name`  varchar(128) NOT NULL                COMMENT '设备名称',
  `equipment_model` varchar(128) DEFAULT NULL            COMMENT '设备规格/型号',
  `purpose`         varchar(255) DEFAULT NULL            COMMENT '设备用途',
  `spec`            varchar(255) DEFAULT NULL            COMMENT '设定条件',
  `status`          char(1)      NOT NULL DEFAULT '1'    COMMENT '状态 1启用 0停用',
  `is_deleted`      char(1)      NOT NULL DEFAULT '0'    COMMENT '是否删除',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  `update_time`     datetime     NOT NULL                COMMENT '最后更新时间',
  `update_username` varchar(64)  NOT NULL                COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_equipment_code` (`equipment_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备主数据';

INSERT INTO `sp_equipment` VALUES
('eq_001', 'EQ000001', '吊车',       '123',       '物料搬运',          '',     '1', '0', NOW(), 'admin', NOW(), 'admin'),
('eq_002', 'EQ000002', '主板测试夹具', 'GJ-PCB-01', '主板安装与测试的夹具', '',     '1', '0', NOW(), 'admin', NOW(), 'admin'),
('eq_003', 'EQ000003', '瓶体夹具',    '',          '瓶体加工夹具',      '',     '1', '0', NOW(), 'admin', NOW(), 'admin'),
('eq_004', 'EQ000004', '手指套',     '',          '装配防护',          '防静电', '1', '0', NOW(), 'admin', NOW(), 'admin'),
('eq_005', 'EQ000005', '静电环',     'OWS20A',    '装配防静电',         '',     '1', '0', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 3. 扩展 sp_oper（工序信息定义）
-- ----------------------------
ALTER TABLE `sp_oper`
  ADD COLUMN `unit_id`     varchar(64)   DEFAULT NULL  COMMENT '加工单元ID'                  AFTER `oper_desc`,
  ADD COLUMN `oper_hours`  decimal(8,2)  DEFAULT 0     COMMENT '工序工时(h)'                 AFTER `unit_id`,
  ADD COLUMN `manu_cycle`  decimal(8,2)  DEFAULT 0     COMMENT '制造周期(h)'                 AFTER `oper_hours`,
  ADD COLUMN `gen_plan`    char(1)       DEFAULT 'Y'   COMMENT '是否生成生产计划 Y是 N否'    AFTER `manu_cycle`,
  ADD COLUMN `remark`      varchar(500)  DEFAULT NULL  COMMENT '备注信息'                   AFTER `gen_plan`;

-- ----------------------------
-- 4. 工艺流程管理 sp_process_route （按BOM节点绑定工序）
-- ----------------------------
DROP TABLE IF EXISTS `sp_process_route`;
CREATE TABLE `sp_process_route` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `bom_id`          varchar(64)  NOT NULL                COMMENT '所属BOM',
  `bom_item_id`     varchar(64)  DEFAULT NULL            COMMENT 'BOM节点ID（空表示根产品节点）',
  `route_code`      varchar(128) NOT NULL                COMMENT '工艺编号 NGY_3_M000003_001_001',
  `parent_route_id` varchar(64)  DEFAULT NULL            COMMENT '上级工艺ID',
  `node_name`       varchar(128) NOT NULL                COMMENT '节点名称（冗余便于显示）',
  `materiel_code`   varchar(64)  DEFAULT NULL            COMMENT '物料编码（冗余）',
  `oper_id`         varchar(64)  DEFAULT NULL            COMMENT '绑定的工序ID',
  `seq_no`          int(11)      NOT NULL DEFAULT 30     COMMENT '排序号 30/60/90',
  `lock_status`     varchar(10)  NOT NULL DEFAULT 'draft' COMMENT 'draft草稿 locked已锁定',
  `edit_status`     varchar(10)  NOT NULL DEFAULT 'pending' COMMENT 'pending未编制 editing编制中 completed已完成',
  `is_deleted`      char(1)      NOT NULL DEFAULT '0'    COMMENT '是否删除',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  `update_time`     datetime     NOT NULL                COMMENT '最后更新时间',
  `update_username` varchar(64)  NOT NULL                COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_route_code` (`route_code`),
  KEY `idx_bom_id` (`bom_id`),
  KEY `idx_parent_route_id` (`parent_route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='产品工艺流程（按BOM节点）';

-- ----------------------------
-- 5. 工艺内容编制 sp_process_content （主表）
-- ----------------------------
DROP TABLE IF EXISTS `sp_process_content`;
CREATE TABLE `sp_process_content` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `route_id`        varchar(64)  NOT NULL                COMMENT '工艺ID FK sp_process_route',
  `content_text`    text         DEFAULT NULL            COMMENT '工序内容文本',
  `require_text`    text         DEFAULT NULL            COMMENT '工序要求文本',
  `need_check`      char(1)      NOT NULL DEFAULT 'Y'    COMMENT '是否需要检验',
  `precaution_text` text         DEFAULT NULL            COMMENT '注意事项文本',
  `tech_doc_desc`   varchar(500) DEFAULT NULL            COMMENT '技术文档描述',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  `update_time`     datetime     NOT NULL                COMMENT '最后更新时间',
  `update_username` varchar(64)  NOT NULL                COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_route_id` (`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工艺内容编制主表';

-- ----------------------------
-- 6. 工艺文件 sp_process_file （图片/附件）
-- ----------------------------
DROP TABLE IF EXISTS `sp_process_file`;
CREATE TABLE `sp_process_file` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `route_id`        varchar(64)  NOT NULL                COMMENT '工艺ID',
  `file_type`       varchar(32)  NOT NULL                COMMENT 'CONTENT_IMG/REQ_IMG/PREC_IMG/TECH_IMG/TECH_ATTACH',
  `file_path`       varchar(500) NOT NULL                COMMENT '相对路径（不含access-prefix）',
  `original_name`   varchar(255) NOT NULL                COMMENT '原始文件名',
  `file_size`       bigint       NOT NULL DEFAULT 0      COMMENT '文件大小（字节）',
  `sort_no`         int(11)      NOT NULL DEFAULT 0      COMMENT '排序',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `idx_route_type` (`route_id`, `file_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工艺内容文件附件';

-- ----------------------------
-- 7. 工装设备关联 sp_process_equipment_rel
-- ----------------------------
DROP TABLE IF EXISTS `sp_process_equipment_rel`;
CREATE TABLE `sp_process_equipment_rel` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `route_id`        varchar(64)  NOT NULL                COMMENT '工艺ID',
  `equipment_id`    varchar(64)  NOT NULL                COMMENT '设备ID',
  `req_qty`         int(11)      NOT NULL DEFAULT 1      COMMENT '需求数量',
  `remark`          varchar(500) DEFAULT NULL            COMMENT '备注',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `idx_route_id` (`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工艺-工装设备关联';

-- ----------------------------
-- 8. 备料清单 sp_process_material_rel
-- ----------------------------
DROP TABLE IF EXISTS `sp_process_material_rel`;
CREATE TABLE `sp_process_material_rel` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `route_id`        varchar(64)  NOT NULL                COMMENT '工艺ID',
  `materiel_id`     varchar(64)  NOT NULL                COMMENT '物料ID',
  `req_qty`         decimal(12,3) NOT NULL DEFAULT 1     COMMENT '需求数量',
  `remark`          varchar(500) DEFAULT NULL            COMMENT '备注',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `idx_route_id` (`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='工艺-备料清单';

-- ----------------------------
-- 9. 菜单：将15重命名为"产品数据中心"，新增4个子菜单 + 加工单元/设备
-- ----------------------------
UPDATE `sp_sys_menu` SET `name` = '产品数据中心', `icon` = 'fa fa-cubes' WHERE `id` = '15';

INSERT IGNORE INTO `sp_sys_menu` (id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('153', 'sp_oper_def',      '工序信息定义', '/technology/oper/list-ui',           '15', '3', 3, '0', 'user:add', 'fa fa-thumb-tack',  '工序信息定义', NOW(), 'admin', NOW(), 'admin'),
('154', 'process_route',    '工艺流程管理', '/technology/process-route/tree-ui',  '15', '3', 4, '0', 'user:add', 'fa fa-sitemap',     '工艺流程管理', NOW(), 'admin', NOW(), 'admin'),
('155', 'process_content',  '工艺内容编制', '/technology/process-content/tree-ui','15', '3', 5, '0', 'user:add', 'fa fa-edit',        '工艺内容编制', NOW(), 'admin', NOW(), 'admin'),
('156', 'process_query',    '产品工艺查询', '/technology/process-query/tree-ui',  '15', '3', 6, '0', 'user:add', 'fa fa-search',      '产品工艺查询', NOW(), 'admin', NOW(), 'admin');

-- 加工单元、设备 挂在 13 物料管理下（同属基础主数据）
INSERT IGNORE INTO `sp_sys_menu` (id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('132', 'processing_unit', '加工单元', '/basedata/processing-unit/list-ui', '13', '3', 2, '0', 'user:add', 'fa fa-cog',     '加工单元主数据', NOW(), 'admin', NOW(), 'admin'),
('133', 'equipment',       '设备',     '/basedata/equipment/list-ui',       '13', '3', 3, '0', 'user:add', 'fa fa-wrench',  '设备主数据',     NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 10. 系统管理员（code='888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('153','154','155','156','132','133')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );

-- 工艺员角色授权工艺相关菜单
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_002', m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_menu` m
WHERE m.id IN ('153','154','155','156')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = 'r_mes_002' AND srm.menu_id = m.id
  );

-- 数据员角色授权主数据菜单
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_001', m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_menu` m
WHERE m.id IN ('132','133')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = 'r_mes_001' AND srm.menu_id = m.id
  );


-- ============================================================
-- [5] source: banzu-upgrade-20260604.sql
-- ============================================================
-- ============================================================
-- 班组管理 + 班组员工管理（4.1 资源分配管理）升级脚本
-- 日期：2026-06-04
-- 内容：建表 sp_team / sp_team_employee + 菜单（基础数据中心 → 班组员工定义）+ 管理员授权
-- 说明：可重复执行（IF NOT EXISTS / INSERT IGNORE / NOT EXISTS 子查询）
-- ============================================================

-- ----------------------------
-- 1. 班组表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_team` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `team_code` varchar(64) NOT NULL COMMENT '班组代码',
  `team_name` varchar(255) NOT NULL COMMENT '班组名称',
  `team_desc` varchar(500) DEFAULT NULL COMMENT '班组描述',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除 2禁用',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_team_code` (`team_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班组表';

-- ----------------------------
-- 2. 班组员工关系表（多对多）
-- 唯一性「同班组不重复同员工」在 Service 层校验（仅对 is_deleted='0' 生效），不加 DB 唯一索引，避免软删后再加入冲突
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_team_employee` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `team_id` varchar(64) NOT NULL COMMENT '班组ID',
  `user_id` varchar(64) NOT NULL COMMENT '员工(用户)ID',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_team` (`team_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='班组员工关系表';

-- ----------------------------
-- 3. 菜单：新建「基础数据中心」父菜单 + 「班组员工定义」子菜单
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('base_data_center', 'baseDataCenter', '基础数据中心', '#',                      '1',                '2', 7, '0', 'user:add', 'fa fa-database', '基础数据中心', NOW(), 'admin', NOW(), 'admin'),
('banzu_def',        'banzuDef',       '班组员工定义', '/basedata/team/list-ui', 'base_data_center', '3', 1, '0', 'user:add', 'fa fa-users',    '班组员工定义', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 4. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('base_data_center', 'banzu_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );


-- ============================================================
-- [6] source: bianzu-upgrade-20260604.sql
-- ============================================================
-- ============================================================
-- 编组设备定义（4.1 资源分配管理）升级脚本
-- 日期：2026-06-04
-- 内容：建表 sp_equipment_group / sp_equipment_group_device
--       + 菜单（基础数据中心 → 编组设备定义）+ 管理员授权
-- 说明：可重复执行（IF NOT EXISTS / INSERT IGNORE / NOT EXISTS 子查询）
-- ============================================================

-- ----------------------------
-- 1. 设备编组表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_equipment_group` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `group_code` varchar(64) NOT NULL COMMENT '编组编号',
  `group_name` varchar(255) DEFAULT NULL COMMENT '编组名称',
  `group_desc` varchar(500) DEFAULT NULL COMMENT '编组描述',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除 2禁用',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_group_code` (`group_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='设备编组表';

-- ----------------------------
-- 2. 编组-设备关系表（多对多）
-- 唯一性「同编组不重复同设备」在 Service 层校验（仅对 is_deleted='0' 生效），不加 DB 唯一索引，避免软删后再加入冲突
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_equipment_group_device` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `group_id` varchar(64) NOT NULL COMMENT '编组ID',
  `equipment_id` varchar(64) NOT NULL COMMENT '设备ID',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_group` (`group_id`),
  KEY `idx_equipment` (`equipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='编组设备关系表';

-- ----------------------------
-- 3. 菜单：基础数据中心（已存在则忽略）+ 「编组设备定义」子菜单
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('base_data_center', 'baseDataCenter', '基础数据中心', '#',                                '1',                '2', 7, '0', 'user:add', 'fa fa-database', '基础数据中心', NOW(), 'admin', NOW(), 'admin'),
('bianzu_def',       'bianzuDef',      '编组设备定义', '/basedata/equipment-group/list-ui', 'base_data_center', '3', 2, '0', 'user:add', 'fa fa-wrench',   '编组设备定义', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 4. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('base_data_center', 'bianzu_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );


-- ============================================================
-- [7] source: jiagong-unit-banzu-upgrade-20260604.sql
-- ============================================================
-- ============================================================
-- 加工单元定义增强 + 加工单元班组管理（4.1 资源分配管理）升级脚本
-- 日期：2026-06-04
-- 内容：
--   1) 扩展 sp_processing_unit：新增 标准产能(日小时) / 是否有线边库 字段
--   2) 新建 sp_processing_unit_team 关系表（加工单元 ↔ 班组，多对多）
-- 说明：可重复执行（列存在判断 / IF NOT EXISTS）。菜单复用现有 132，无需新增。
-- ============================================================

-- ----------------------------
-- 1. sp_processing_unit 新增 std_capacity（日标准产能/小时）
-- ----------------------------
SET @col_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_SCHEMA = DATABASE()
                      AND TABLE_NAME = 'sp_processing_unit'
                      AND COLUMN_NAME = 'std_capacity');
SET @sql := IF(@col_exists = 0,
    'ALTER TABLE `sp_processing_unit` ADD COLUMN `std_capacity` decimal(8,2) NOT NULL DEFAULT 8.00 COMMENT ''日标准产能(小时)'' AFTER `description`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ----------------------------
-- 2. sp_processing_unit 新增 has_edge_warehouse（是否有线边库 Y是 N否）
-- ----------------------------
SET @col_exists := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
                    WHERE TABLE_SCHEMA = DATABASE()
                      AND TABLE_NAME = 'sp_processing_unit'
                      AND COLUMN_NAME = 'has_edge_warehouse');
SET @sql := IF(@col_exists = 0,
    'ALTER TABLE `sp_processing_unit` ADD COLUMN `has_edge_warehouse` char(1) NOT NULL DEFAULT ''N'' COMMENT ''是否有线边库 Y是 N否'' AFTER `std_capacity`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 给示例数据补值（新增 NOT NULL DEFAULT 列后旧行已取默认值，这里再显式刷新一遍）
UPDATE `sp_processing_unit` SET `std_capacity` = 8.00 WHERE `std_capacity` IS NULL;
UPDATE `sp_processing_unit` SET `has_edge_warehouse` = 'N' WHERE `has_edge_warehouse` IS NULL OR `has_edge_warehouse` = '';

-- ----------------------------
-- 3. 加工单元班组关系表（多对多）
-- 唯一性「同加工单元不重复同班组」在 Service 层校验（仅对 is_deleted='0' 生效），
-- 不加 DB 唯一索引，避免软删后再绑定冲突；班组↔加工单元绑定可交叉重复（小结第4点）。
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_processing_unit_team` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `unit_id` varchar(64) NOT NULL COMMENT '加工单元ID',
  `team_id` varchar(64) NOT NULL COMMENT '班组ID',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_unit` (`unit_id`),
  KEY `idx_team` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='加工单元班组关系表';

-- ----------------------------
-- 4. 菜单：把「加工单元」从「物料管理(13)」移入「基础数据中心(base_data_center)」侧栏，
--    并按侧栏命名风格更名为「加工单元定义」，排在末位（sort_num=3）。幂等。
-- ----------------------------
UPDATE `sp_sys_menu`
SET `parent_id` = 'base_data_center', `name` = '加工单元定义', `sort_num` = 3
WHERE `id` = '132';



-- ============================================================
-- [8] source: warehouse-location-upgrade-20260605.sql
-- ============================================================
-- ============================================================
-- 库房库位定义（4.1 资源分配管理）升级脚本
-- 日期：2026-06-05
-- 内容：建表 sp_warehouse / sp_warehouse_location + 菜单（基础数据中心 → 库房库位定义）+ 管理员授权
-- 说明：可重复执行（IF NOT EXISTS / INSERT IGNORE / NOT EXISTS 子查询）
--       库位按库房规格（组×排×层×列）自动生成，编码 = 库房码-组-排-层-列，由后端 Service 生成
-- ============================================================

-- ----------------------------
-- 1. 库房表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_warehouse` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `warehouse_code` varchar(64) NOT NULL COMMENT '库房编码',
  `warehouse_name` varchar(255) NOT NULL COMMENT '库房名称',
  `warehouse_type` varchar(2) NOT NULL COMMENT '库房类型 1原材料库 2成品库 3半成品库',
  `warehouse_desc` varchar(500) DEFAULT NULL COMMENT '库房描述',
  `spec_group` int(11) DEFAULT NULL COMMENT '规格-组',
  `spec_row` int(11) DEFAULT NULL COMMENT '规格-排',
  `spec_layer` int(11) DEFAULT NULL COMMENT '规格-层',
  `spec_column` int(11) DEFAULT NULL COMMENT '规格-列',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除 2禁用',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_warehouse_code` (`warehouse_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库房表';

-- ----------------------------
-- 2. 库位表（依库房规格自动生成）
-- 库位编码唯一性「同编码不重复」由生成逻辑保证（库房码-组-排-层-列），不加 DB 唯一索引，避免重新生成软删后冲突
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_warehouse_location` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `warehouse_id` varchar(64) NOT NULL COMMENT '所属库房ID',
  `location_code` varchar(128) NOT NULL COMMENT '库位编码 如 KF001-1-2-3-4',
  `group_no` int(11) DEFAULT NULL COMMENT '坐标-组',
  `row_no` int(11) DEFAULT NULL COMMENT '坐标-排',
  `layer_no` int(11) DEFAULT NULL COMMENT '坐标-层',
  `column_no` int(11) DEFAULT NULL COMMENT '坐标-列',
  `status` varchar(2) NOT NULL DEFAULT '0' COMMENT '状态 0正常 2禁用',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库位表';

-- ----------------------------
-- 3. 菜单：挂到已存在的「基础数据中心」父菜单（base_data_center）下
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('base_data_center', 'baseDataCenter', '基础数据中心', '#',                            '1',                '2', 7, '0', 'user:add', 'fa fa-database', '基础数据中心',   NOW(), 'admin', NOW(), 'admin'),
('cangku_def',       'cangkuDef',      '库房库位定义', '/basedata/warehouse/list-ui', 'base_data_center', '3', 2, '0', 'user:add', 'fa fa-cube',     '库房库位定义', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 4. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('base_data_center', 'cangku_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );


-- ============================================================
-- [9] source: material-info-upgrade-20260605.sql
-- ============================================================
-- ============================================================
-- 物料信息定义升级脚本（4.1 资源分配管理 - 物料信息定义）
-- 日期：2026-06-05
-- 内容：sp_materile 新增字段（来源/材质/提前期/安全库存/图片/备注）
--      + 字典（material_type 补充、material_source、material_texture、ORDER_UNIT 补充）
--      + 菜单（生产数据中心 → 物料信息定义）+ 管理员授权
-- 说明：可重复执行（INFORMATION_SCHEMA 列存在判断 / INSERT ... NOT EXISTS / INSERT IGNORE）
-- ============================================================

-- ----------------------------
-- 1. sp_materile 新增列（MySQL 不支持 ADD COLUMN IF NOT EXISTS，用 INFORMATION_SCHEMA 守卫）
-- ----------------------------

-- 物料来源：SELF=自制 OUT=外购
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND COLUMN_NAME = 'mat_source');
SET @sql := IF(@col = 0,
    'ALTER TABLE `sp_materile` ADD COLUMN `mat_source` varchar(16) NULL DEFAULT NULL COMMENT ''物料来源 SELF自制 OUT外购'' AFTER `model`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 材质
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND COLUMN_NAME = 'texture');
SET @sql := IF(@col = 0,
    'ALTER TABLE `sp_materile` ADD COLUMN `texture` varchar(32) NULL DEFAULT NULL COMMENT ''材质'' AFTER `mat_source`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 物料需求提前期(天)，不可为0，默认1
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND COLUMN_NAME = 'lead_time');
SET @sql := IF(@col = 0,
    'ALTER TABLE `sp_materile` ADD COLUMN `lead_time` int NOT NULL DEFAULT 1 COMMENT ''物料需求提前期(天)，至少1'' AFTER `texture`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 安全库存，可为0
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND COLUMN_NAME = 'safety_stock');
SET @sql := IF(@col = 0,
    'ALTER TABLE `sp_materile` ADD COLUMN `safety_stock` int NOT NULL DEFAULT 0 COMMENT ''安全库存'' AFTER `lead_time`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 图片地址（多张，逗号分隔的相对路径）
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND COLUMN_NAME = 'image_urls');
SET @sql := IF(@col = 0,
    'ALTER TABLE `sp_materile` ADD COLUMN `image_urls` varchar(2000) NULL DEFAULT NULL COMMENT ''物料图片，多张逗号分隔的相对路径'' AFTER `safety_stock`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 备注信息
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
             WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_materile' AND COLUMN_NAME = 'remark');
SET @sql := IF(@col = 0,
    'ALTER TABLE `sp_materile` ADD COLUMN `remark` varchar(500) NULL DEFAULT NULL COMMENT ''备注信息'' AFTER `image_urls`',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ----------------------------
-- 2. 字典 sp_sys_dict
-- ----------------------------

-- 2.1 material_type 补充：产品=PRODUCT、标准件=STD、其他=OTHER、原材料=RAW
--     （保留既有 成品FG/半成品PG/组件COMP/零件PART，BOM 层级逻辑依赖其 code）
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '产品' name, 'PRODUCT' value, 'material_type' type, '物料类型-产品' descr, 6 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '标准件', 'STD', 'material_type', '物料类型-标准件', 7, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '其他',  'OTHER', 'material_type', '物料类型-其他', 8, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '原材料', 'RAW', 'material_type', '物料类型-原材料', 9, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'material_type' AND d.value = t.value);

-- 2.2 物料来源 material_source：自制=SELF、外购=OUT
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '自制' name, 'SELF' value, 'material_source' type, '物料来源-自制' descr, 1 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '外购', 'OUT', 'material_source', '物料来源-外购', 2, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'material_source' AND d.value = t.value);

-- 2.3 材质 material_texture：铝=AL、铁=IRON、纸质=PAPER、其他=OTHER
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT * FROM (
  SELECT REPLACE(UUID(),'-','') id, '铝' name, 'AL' value, 'material_texture' type, '材质-铝' descr, 1 sort_num, '""' parent_id, '0' is_deleted, NOW() ct, 'admin' cu, NOW() ut, 'admin' uu
  UNION ALL SELECT REPLACE(UUID(),'-',''), '铁',   'IRON',  'material_texture', '材质-铁', 2, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '纸质', 'PAPER', 'material_texture', '材质-纸质', 3, '""', '0', NOW(), 'admin', NOW(), 'admin'
  UNION ALL SELECT REPLACE(UUID(),'-',''), '其他', 'OTHER', 'material_texture', '材质-其他', 4, '""', '0', NOW(), 'admin', NOW(), 'admin'
) t
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'material_texture' AND d.value = t.value);

-- 2.4 计量单位 ORDER_UNIT 补充：套=SET
INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT REPLACE(UUID(),'-',''), '套', 'SET', 'ORDER_UNIT', '生产单位', 3, '""', '0', NOW(), 'admin', NOW(), 'admin'
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'ORDER_UNIT' AND d.value = 'SET');

-- ----------------------------
-- 3. 菜单：生产数据中心 → 物料信息定义
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('prod_data_center', 'prodDataCenter', '生产数据中心', '#',                          '1',                '2', 8, '0', 'user:add', 'fa fa-database',     '生产数据中心', NOW(), 'admin', NOW(), 'admin'),
('mat_info_def',     'matInfoDef',     '物料信息定义', '/basedata/materile/list-ui', 'prod_data_center', '3', 1, '0', 'user:add', 'fa fa-info-circle', '物料信息定义', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 4. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('prod_data_center', 'mat_info_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );

-- ============================================================
-- 产品零部件定义升级脚本（4.2 BOM与组件数据管理）
-- 日期：2026-06-06
-- 内容：新增 sp_component_def + 菜单（产品数据中心 → 零部件定义）+ 管理员授权
-- ============================================================

CREATE TABLE IF NOT EXISTS `sp_component_def` (
  `id`              varchar(64)  NOT NULL                COMMENT '主键ID',
  `product_name`    varchar(128) NOT NULL                COMMENT '产品名称（手工输入）',
  `component_code`  varchar(32)  NOT NULL                COMMENT '零部件编号 BOM000001',
  `component_name`  varchar(128) NOT NULL                COMMENT '零部件名称',
  `component_type`  varchar(16)  NOT NULL DEFAULT 'COMP' COMMENT '零部件类型 PG=半成品 COMP=组件',
  `remark`          varchar(500) DEFAULT NULL            COMMENT '备注信息',
  `is_deleted`      char(1)      NOT NULL DEFAULT '0'    COMMENT '状态 0正常 1删除 2禁用',
  `create_time`     datetime     NOT NULL                COMMENT '创建时间',
  `create_username` varchar(64)  NOT NULL                COMMENT '创建人',
  `update_time`     datetime     NOT NULL                COMMENT '最后更新时间',
  `update_username` varchar(64)  NOT NULL                COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_component_code` (`component_code`),
  KEY `idx_component_product` (`product_name`),
  KEY `idx_component_product_name` (`product_name`, `component_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='产品零部件定义';

UPDATE `sp_sys_menu` SET `name` = '产品数据中心', `icon` = 'fa fa-cubes' WHERE `id` = '15';

INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('component_def', 'componentDef', '零部件定义', '/technology/component/list-ui', '15', '3', 1, '0', 'user:add', 'fa fa-cubes', '零部件定义', NOW(), 'admin', NOW(), 'admin');

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin', '888888')
  AND m.id IN ('component_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_002', m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_menu` m
WHERE m.id IN ('component_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = 'r_mes_002' AND srm.menu_id = m.id
  );


-- ============================================================
-- [13] source: desktop-process-demo-upgrade-20260606.sql
-- ============================================================
-- 台式电脑主机工艺流程演示数据

INSERT INTO `sp_processing_unit`
(`id`, `unit_code`, `unit_name`, `unit_type`, `description`, `status`, `is_deleted`,
 `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('jg_unit_001', 'JG000001', '电脑组装单元', 'person', '台式电脑主机装配演示加工单元', '0', '0',
 NOW(), 'admin', NOW(), 'admin')
ON DUPLICATE KEY UPDATE
 `unit_name` = VALUES(`unit_name`),
 `unit_type` = VALUES(`unit_type`),
 `description` = VALUES(`description`),
 `status` = VALUES(`status`),
 `is_deleted` = VALUES(`is_deleted`),
 `update_time` = NOW(),
 `update_username` = 'admin';

INSERT INTO `sp_oper`
(`id`, `oper`, `oper_desc`, `unit_id`, `oper_hours`, `manu_cycle`, `gen_plan`, `remark`,
 `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('op_gx000002', 'GX000002', '主板装配作业工序', 'jg_unit_001', 1, 2, 'Y', '主板电路板、CPU、内存条装配为台式电脑主板',
 NOW(), 'admin', NOW(), 'admin'),
('op_gx000003', 'GX000003', '机箱组装作业工序', 'jg_unit_001', 1, 2, 'Y', '电源、机箱装配为台式电脑机箱',
 NOW(), 'admin', NOW(), 'admin'),
('op_gx000008', 'GX000008', '主机装配作业', 'jg_unit_001', 1, 2, 'Y', '台式电脑主板与台式电脑机箱装配为台式电脑主机半成品',
 NOW(), 'admin', NOW(), 'admin')
ON DUPLICATE KEY UPDATE
 `oper` = VALUES(`oper`),
 `oper_desc` = VALUES(`oper_desc`),
 `unit_id` = VALUES(`unit_id`),
 `oper_hours` = VALUES(`oper_hours`),
 `manu_cycle` = VALUES(`manu_cycle`),
 `gen_plan` = VALUES(`gen_plan`),
 `remark` = VALUES(`remark`),
 `update_time` = NOW(),
 `update_username` = 'admin';

INSERT INTO `sp_materile`
(`id`, `materiel`, `materiel_desc`, `unit`, `product_group`, `mat_type`, `model`, `size`,
 `flow_id`, `flow_desc`, `is_deleted`, `mat_source`, `texture`, `lead_time`, `safety_stock`,
 `image_urls`, `remark`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('mat_pc_host', 'PC_HOST', '台式电脑主机', '台', '台式电脑', 'FG', 'DESKTOP-HOST', '', NULL, NULL, '0', 'SELF', '', 1, 0, NULL, '工艺流程演示成品', NOW(), 'admin', NOW(), 'admin'),
('mat_pc_host_half', 'PC_HOST_HALF', '台式电脑主机半成品', '台', '台式电脑', 'PG', 'DESKTOP-HOST-HALF', '', NULL, NULL, '0', 'SELF', '', 1, 0, NULL, '主机装配工序产出', NOW(), 'admin', NOW(), 'admin'),
('mat_mainboard_unit', 'MAINBOARD_UNIT', '主板单元', '件', '台式电脑', 'COMP', 'MAINBOARD-UNIT', '', NULL, NULL, '0', 'SELF', '', 1, 0, NULL, '主板装配工序产出', NOW(), 'admin', NOW(), 'admin'),
('mat_case_unit', 'CASE_UNIT', '机箱单元', '件', '台式电脑', 'COMP', 'CASE-UNIT', '', NULL, NULL, '0', 'SELF', '', 1, 0, NULL, '机箱组装工序产出', NOW(), 'admin', NOW(), 'admin'),
('mat_pcb', 'PCB_BOARD', '主板电路板', '件', '台式电脑', 'PART', 'PCB-ATX', '', NULL, NULL, '0', 'OUT', 'FR-4', 1, 0, NULL, '主板单元零件', NOW(), 'admin', NOW(), 'admin'),
('mat_cpu', 'CPU', 'CPU', '颗', '台式电脑', 'PART', 'CPU-DEMO', '', NULL, NULL, '0', 'OUT', '', 1, 0, NULL, '主板单元零件', NOW(), 'admin', NOW(), 'admin'),
('mat_ram', 'MEMORY', '内存条', '条', '台式电脑', 'PART', 'DDR-DEMO', '', NULL, NULL, '0', 'OUT', '', 1, 0, NULL, '主板单元零件', NOW(), 'admin', NOW(), 'admin'),
('mat_power', 'POWER_SUPPLY', '电源', '件', '台式电脑', 'PART', 'PSU-DEMO', '', NULL, NULL, '0', 'OUT', '', 1, 0, NULL, '机箱单元零件', NOW(), 'admin', NOW(), 'admin'),
('mat_case', 'CASE_SHELL', '机箱', '件', '台式电脑', 'PART', 'CASE-DEMO', '', NULL, NULL, '0', 'OUT', '钢板', 1, 0, NULL, '机箱单元零件', NOW(), 'admin', NOW(), 'admin')
ON DUPLICATE KEY UPDATE
 `materiel` = VALUES(`materiel`),
 `materiel_desc` = VALUES(`materiel_desc`),
 `unit` = VALUES(`unit`),
 `product_group` = VALUES(`product_group`),
 `mat_type` = VALUES(`mat_type`),
 `model` = VALUES(`model`),
 `is_deleted` = VALUES(`is_deleted`),
 `mat_source` = VALUES(`mat_source`),
 `texture` = VALUES(`texture`),
 `lead_time` = VALUES(`lead_time`),
 `safety_stock` = VALUES(`safety_stock`),
 `remark` = VALUES(`remark`),
 `update_time` = NOW(),
 `update_username` = 'admin';

INSERT INTO `sp_component_def`
(`id`, `product_name`, `component_code`, `component_name`, `component_type`, `remark`, `is_deleted`,
 `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('comp_pc_host_half', '台式电脑主机', 'PC_HOST_HALF', '台式电脑主机半成品', 'PG', '台式电脑主机一级半成品', '0', NOW(), 'admin', NOW(), 'admin'),
('comp_mainboard_unit', '台式电脑主机', 'MAINBOARD_UNIT', '主板单元', 'COMP', '由主板电路板、CPU、内存条装配', '0', NOW(), 'admin', NOW(), 'admin'),
('comp_case_unit', '台式电脑主机', 'CASE_UNIT', '机箱单元', 'COMP', '由电源、机箱装配', '0', NOW(), 'admin', NOW(), 'admin')
ON DUPLICATE KEY UPDATE
 `product_name` = VALUES(`product_name`),
 `component_code` = VALUES(`component_code`),
 `component_name` = VALUES(`component_name`),
 `component_type` = VALUES(`component_type`),
 `remark` = VALUES(`remark`),
 `is_deleted` = VALUES(`is_deleted`),
 `update_time` = NOW(),
 `update_username` = 'admin';

INSERT INTO `sp_bom`
(`id`, `bom_code`, `materiel_code`, `materiel_desc`, `remark`, `version_number`, `state`, `factory`,
 `is_deleted`, `bom_level`, `lock_status`, `validity`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('bom_pc_host', 'BOM-PC-HOST', 'PC_HOST', '台式电脑主机', '台式电脑主机装配演示BOM', '1', 'pass', 'center', '0', 0, 'locked', '有效', NOW(), 'admin', NOW(), 'admin'),
('bom_pc_host_half', 'BOM-PC-HOST-HALF', 'PC_HOST_HALF', '台式电脑主机半成品', '台式电脑主机半成品BOM', '1', 'pass', 'center', '0', 1, 'locked', '有效', NOW(), 'admin', NOW(), 'admin'),
('bom_mainboard_unit', 'BOM-MAINBOARD-UNIT', 'MAINBOARD_UNIT', '主板单元', '主板单元BOM', '1', 'pass', 'center', '0', 2, 'locked', '有效', NOW(), 'admin', NOW(), 'admin'),
('bom_case_unit', 'BOM-CASE-UNIT', 'CASE_UNIT', '机箱单元', '机箱单元BOM', '1', 'pass', 'center', '0', 2, 'locked', '有效', NOW(), 'admin', NOW(), 'admin')
ON DUPLICATE KEY UPDATE
 `bom_code` = VALUES(`bom_code`),
 `materiel_code` = VALUES(`materiel_code`),
 `materiel_desc` = VALUES(`materiel_desc`),
 `remark` = VALUES(`remark`),
 `version_number` = VALUES(`version_number`),
 `state` = VALUES(`state`),
 `factory` = VALUES(`factory`),
 `is_deleted` = VALUES(`is_deleted`),
 `bom_level` = VALUES(`bom_level`),
 `lock_status` = VALUES(`lock_status`),
 `validity` = VALUES(`validity`),
 `update_time` = NOW(),
 `update_username` = 'admin';

INSERT INTO `sp_bom_item`
(`id`, `bom_head_id`, `materiel_item_code`, `materiel_item_desc`, `line_no`, `item_num`, `item_unit`,
 `oper_typer`, `child_bom_id`, `item_mat_type`, `create_time`, `create_username`, `update_time`, `update_username`)
VALUES
('bom_item_host_half', 'bom_pc_host', 'PC_HOST_HALF', '台式电脑主机半成品', '10', 1, '台', '主机装配', 'bom_pc_host_half', 'PG', NOW(), 'admin', NOW(), 'admin'),
('bom_item_half_mainboard', 'bom_pc_host_half', 'MAINBOARD_UNIT', '主板单元', '10', 1, '件', '主板装配', 'bom_mainboard_unit', 'COMP', NOW(), 'admin', NOW(), 'admin'),
('bom_item_half_case', 'bom_pc_host_half', 'CASE_UNIT', '机箱单元', '20', 1, '件', '机箱装配', 'bom_case_unit', 'COMP', NOW(), 'admin', NOW(), 'admin'),
('bom_item_main_pcb', 'bom_mainboard_unit', 'PCB_BOARD', '主板电路板', '10', 1, '件', '主板装配', NULL, 'PART', NOW(), 'admin', NOW(), 'admin'),
('bom_item_main_cpu', 'bom_mainboard_unit', 'CPU', 'CPU', '20', 1, '颗', '主板装配', NULL, 'PART', NOW(), 'admin', NOW(), 'admin'),
('bom_item_main_ram', 'bom_mainboard_unit', 'MEMORY', '内存条', '30', 1, '条', '主板装配', NULL, 'PART', NOW(), 'admin', NOW(), 'admin'),
('bom_item_case_power', 'bom_case_unit', 'POWER_SUPPLY', '电源', '10', 1, '件', '机箱装配', NULL, 'PART', NOW(), 'admin', NOW(), 'admin'),
('bom_item_case_shell', 'bom_case_unit', 'CASE_SHELL', '机箱', '20', 1, '件', '机箱装配', NULL, 'PART', NOW(), 'admin', NOW(), 'admin')
ON DUPLICATE KEY UPDATE
 `bom_head_id` = VALUES(`bom_head_id`),
 `materiel_item_code` = VALUES(`materiel_item_code`),
 `materiel_item_desc` = VALUES(`materiel_item_desc`),
 `line_no` = VALUES(`line_no`),
 `item_num` = VALUES(`item_num`),
 `item_unit` = VALUES(`item_unit`),
 `oper_typer` = VALUES(`oper_typer`),
 `child_bom_id` = VALUES(`child_bom_id`),
 `item_mat_type` = VALUES(`item_mat_type`),
 `update_time` = NOW(),
 `update_username` = 'admin';

-- ============================================================
-- [17] source: menu-order-upgrade-20260608.sql
-- Final sidebar order cleanup. Keep this near the end so it wins over older upgrade sections.
-- ============================================================
UPDATE `sp_sys_menu` SET `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '1';
UPDATE `sp_sys_menu` SET `sort_num` = 90, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '2';
UPDATE `sp_sys_menu` SET `sort_num` = 99, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '3';

UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE5B7A5E889BAE7AEA1E79086 USING utf8mb4),
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `id` = '15';

UPDATE `sp_sys_menu`
SET `name` = 'matInfoDefHidden',
    `parent_id` = 'legacy_hidden',
    `sort_num` = 99,
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `id` = 'mat_info_def';

UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE59FBAE7A180E695B0E68DAEE4B8ADE5BF83 USING utf8mb4),
    `parent_id` = '1', `grade` = '2', `sort_num` = 1, `icon` = 'fa fa-database',
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `id` = 'base_data_center';

UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE4BAA7E59381E695B0E68DAEE4B8ADE5BF83 USING utf8mb4),
    `parent_id` = '1', `grade` = '2', `sort_num` = 2, `icon` = 'fa fa-cubes',
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `id` = 'prod_data_center';

UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE5B7A5E889BAE7AEA1E79086 USING utf8mb4),
    `parent_id` = '1', `grade` = '2', `sort_num` = 3, `icon` = 'fa fa-wrench',
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `id` = '15';

UPDATE `sp_sys_menu` SET `sort_num` = 4, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '12';
UPDATE `sp_sys_menu` SET `sort_num` = 5, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '16';
UPDATE `sp_sys_menu` SET `sort_num` = 6, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '14';
UPDATE `sp_sys_menu` SET `sort_num` = 7, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '17';
UPDATE `sp_sys_menu` SET `sort_num` = 99, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '10';

UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE789A9E69699E4BFA1E681AFE5AE9AE4B989 USING utf8mb4),
    `parent_id` = 'prod_data_center', `grade` = '3', `sort_num` = 1, `icon` = 'fa fa-microchip',
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `id` = '131';
UPDATE `sp_sys_menu` SET `parent_id` = 'prod_data_center', `grade` = '3', `sort_num` = 2, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'component_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'prod_data_center', `grade` = '3', `sort_num` = 3, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '152';
UPDATE `sp_sys_menu` SET `parent_id` = 'legacy_hidden', `sort_num` = 99, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'mat_info_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'legacy_hidden', `sort_num` = 99, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '13';

UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'banzu_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 2, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'bianzu_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 3, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'cangku_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 4, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '133';
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 5, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '132';

UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '153';
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 2, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '151';
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 3, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '154';
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 4, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '155';
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 5, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '156';

UPDATE `sp_sys_menu` SET `parent_id` = '12', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '121';
UPDATE `sp_sys_menu`
SET `name` = CONVERT(0x534EE9809AE794A8E8BF87E7A88BE98787E99B86 USING utf8mb4),
    `url` = '/wip/sn-process/list-ui', `parent_id` = '16', `grade` = '3', `sort_num` = 1,
    `icon` = 'fa fa-barcode', `update_time` = NOW(), `update_username` = 'admin'
WHERE `id` = '161';
UPDATE `sp_sys_menu` SET `parent_id` = '14', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '141';
UPDATE `sp_sys_menu` SET `parent_id` = '17', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '171';

UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '101';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 2, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '102';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 3, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '103';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 4, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '104';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), srm.role_id, '131', NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role_menu` srm
WHERE srm.menu_id = 'mat_info_def'
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` target
    WHERE target.role_id = srm.role_id AND target.menu_id = '131'
  );

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin', '888888')
  AND m.id IN (
    '1', 'base_data_center', 'prod_data_center', '15', '12', '16', '14', '17', '10',
    'banzu_def', 'bianzu_def', 'cangku_def', '133', '132',
    '131', 'component_def', '152',
    '153', '151', '154', '155', '156',
    '121', '161', '141', '171',
    '101', '102', '103', '104'
  )
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );

-- Final sidebar order requested on 2026-06-12.
UPDATE `sp_sys_menu`
SET `parent_id` = '1',
    `grade` = '2',
    `sort_num` = CASE `id`
        WHEN '10' THEN 1
        WHEN 'base_data_center' THEN 2
        WHEN 'prod_data_center' THEN 3
        WHEN '15' THEN 4
        WHEN 'warehouse_management_center' THEN 5
        WHEN 'workflow_tool' THEN 6
        WHEN 'production_order_center' THEN 7
        WHEN '12' THEN 8
        WHEN '16' THEN 9
        WHEN '14' THEN 10
        WHEN '17' THEN 11
        WHEN 'llm_center' THEN 12
        ELSE `sort_num`
    END,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` IN (
    '10',
    'base_data_center',
    'prod_data_center',
    '15',
    'warehouse_management_center',
    'workflow_tool',
    'production_order_center',
    '12',
    '16',
    '14',
    '17',
    'llm_center'
);

UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE5B7A5E889BAE7AEA1E79086E4B8ADE5BF83 USING utf8mb4),
    `descr` = CONVERT(0xE5B7A5E889BAE7AEA1E79086E4B8ADE5BF83 USING utf8mb4),
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '15';

SET FOREIGN_KEY_CHECKS = 1;
