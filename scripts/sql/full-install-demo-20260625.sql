-- ============================================================
-- MES 完整演示一键安装脚本 (full-install-demo-20260625.sql)
-- 用途: 全新电脑「从0」一次性导入 = 自动建库 + 全部表结构(框架) + 演示数据
-- 含: 基础库(MySQL-20210225) + 截至 2026-06-24 的全部结构/菜单升级 + 0614 优化版演示数据
-- 导入: mysql --default-character-set=utf8mb4 -u root -p < scripts/sql/full-install-demo-20260625.sql
-- 说明: 内容幂等可重复执行; 含 DELIMITER 存储过程段, 必须用 mysql 命令行客户端导入(勿用 JDBC/部分 GUI 多语句)
-- 目标库: sparchetype-test (dev 默认 profile 连接此库, 见 application-dev.yml)
--        生产 pro profile 用 sparchetype, 部署生产时把下面建库/USE 的库名改掉即可
-- 已有库版本升级请勿执行本文件, 改为按日期顺序执行各 *-upgrade-*.sql 增量脚本
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS `sparchetype-test` CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `sparchetype-test`;



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
INSERT INTO `sp_sys_menu` VALUES ('105', 'basedata', '基础数据配置平台', '/basedata/manager/list-ui', '10', '3', 5, '0', 'user:add', 'fa fa-cog', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
INSERT INTO `sp_sys_menu` VALUES ('106', 'basedatamanager', '基础数据维护', '/basedata/manager/item/list-ui', '10', '3', 6, '0', 'user:add', 'fa fa-database', '', '2019-10-18 11:18:29', 'SongPeng', '2019-10-18 11:18:29', 'SongPeng');
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

-- 菜单锁定状态：0正常 1锁定（锁定的菜单不在导航中显示）
ALTER TABLE `sp_sys_menu`
  ADD COLUMN `state` tinyint NOT NULL DEFAULT 0 COMMENT '状态 0正常 1锁定';

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
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
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
-- Table structure for sp_table_manager
-- ----------------------------
DROP TABLE IF EXISTS `sp_table_manager`;
CREATE TABLE `sp_table_manager`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `table_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表名称',
  `table_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表描述',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `permission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '\"\"' COMMENT '授权(多个用逗号分隔，如：sys:menu:list,sys:menu:create)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `index1`(`table_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '主数据通用管理' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_table_manager
-- ----------------------------
INSERT INTO `sp_table_manager` VALUES ('1283020801696837633', 'sp_bom', '', '2020-07-14 20:49:31', 'admin', '2020-07-14 20:49:31', 'admin', '0', '\"\"');

-- ----------------------------
-- Table structure for sp_table_manager_item
-- ----------------------------
DROP TABLE IF EXISTS `sp_table_manager_item`;
CREATE TABLE `sp_table_manager_item`  (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `table_name_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表名称id',
  `field` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字段',
  `field_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '字段描述',
  `must_fill` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否必填',
  `sort_num` int(11) NOT NULL COMMENT '排序',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime(0) NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '主数据基础数据明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sp_table_manager_item
-- ----------------------------
INSERT INTO `sp_table_manager_item` VALUES ('1283020801742974978', '1283020801696837633', 'materiel_desc', '888', 'Y', 1, '2020-07-14 20:49:31', 'admin', '2020-07-14 20:49:31', 'admin');

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
-- [fix] 确保「系统管理员」角色(code=888888)存在, 且 admin 用户归属该角色
-- 原因: 基础库 MySQL-20210225.sql 不含 888888 角色; 而其后各功能升级脚本
--       一律把新菜单授权给 r.code='888888'(生产订单中心/LLM/数字孪生/库存/
--       已交付订单/数据大屏 等)。若该角色缺失或 admin 未归属, 这些新菜单将
--       无人可见。本块注入在基础库之后、各升级脚本之前, 使下游所有 888888
--       授权正确落库; 菜单隐藏(按 menu_id 删除授权)仍照常生效, 不会复活已隐藏菜单。
-- 幂等: 角色/映射均带 NOT EXISTS 守卫, 可重复执行。
-- ============================================================
-- 注意: 本块注入在基础库之后、role-upgrade-20260526.sql 之前, 此时 sp_sys_role
--       仅有基础列(尚无 sort_num/is_system_role 等), 故只插入基础列; 缺省列在
--       role-upgrade 执行 ADD COLUMN ... DEFAULT 时自动取默认值(sort_num=0/is_system_role='0')。
INSERT INTO `sp_sys_role`
  (`id`,`name`,`code`,`descr`,`is_deleted`,
   `create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'r_sys_admin_888888','系统管理员','888888','系统管理员','0',
       NOW(),'admin',NOW(),'admin'
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_role` WHERE `code`='888888');

INSERT INTO `sp_sys_user_role`
  (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'ur_admin_888888','1184019107907227649', r.`id`, NOW(),'admin',NOW(),'admin'
FROM `sp_sys_role` r
WHERE r.`code`='888888'
  AND EXISTS (SELECT 1 FROM `sp_sys_user` u WHERE u.`id`='1184019107907227649')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_user_role` ur
    WHERE ur.`user_id`='1184019107907227649' AND ur.`role_id`=r.`id`
  );


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
  MODIFY COLUMN `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用';

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
FROM sp_sys_menu WHERE code IN ('currency', 'materiel', 'matdef');

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
-- [10] source: component-definition-upgrade-20260606.sql
-- ============================================================
-- ============================================================
-- 产品零部件定义升级脚本（4.2 BOM与组件数据管理）
-- 日期：2026-06-06
-- 内容：新增 sp_component_def + 菜单（产品数据中心 → 零部件定义）+ 管理员授权
-- 说明：可重复执行（CREATE TABLE IF NOT EXISTS / INSERT IGNORE / NOT EXISTS）
-- ============================================================

-- ----------------------------
-- 1. 零部件定义 sp_component_def
-- ----------------------------
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

-- ----------------------------
-- 2. 菜单：产品数据中心 → 零部件定义
-- ----------------------------
UPDATE `sp_sys_menu` SET `name` = '产品数据中心', `icon` = 'fa fa-cubes' WHERE `id` = '15';

INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('component_def', 'componentDef', '零部件定义', '/technology/component/list-ui', '15', '3', 1, '0', 'user:add', 'fa fa-cubes', '零部件定义', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 3. 给系统管理员（role code = 'admin' / '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin', '888888')
  AND m.id IN ('component_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );

-- 工艺员角色授权零部件定义
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), 'r_mes_002', m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_menu` m
WHERE m.id IN ('component_def')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = 'r_mes_002' AND srm.menu_id = m.id
  );



-- ============================================================
-- [11] source: product-bom-menu-upgrade-20260606.sql
-- ============================================================
-- ============================================================
-- 产品BOM管理入口替换脚本
-- 日期：2026-06-06
-- 内容：复用原工艺BOM菜单入口，将显示名称替换为产品BOM管理
-- ============================================================

UPDATE `sp_sys_menu`
SET `name` = '产品BOM管理',
    `descr` = '产品BOM管理',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '152'
  AND `url` = '/technology/bom/list-ui';



-- ============================================================
-- [12] source: component-product-name-normalize-20260606.sql
-- ============================================================
-- ============================================================
-- 零部件定义产品名称规范化脚本
-- 日期：2026-06-06
-- 内容：修正产品名称末尾误带 ? / ？ 的历史数据
-- ============================================================

UPDATE `sp_component_def`
SET `product_name` = TRIM(TRAILING '？' FROM TRIM(TRAILING '?' FROM TRIM(`product_name`))),
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `product_name` LIKE '%?'
   OR `product_name` LIKE '%？';



-- ============================================================
-- [13] source: oper-definition-upgrade-20260606.sql
-- ============================================================
-- ============================================================
-- 工序信息定义业务规则兜底升级
-- 创建时间: 2026-06-06
-- 内容:
--   1) 检查 sp_oper.oper 是否存在重复编号
--   2) 在无重复数据时补充工序编号唯一索引 uk_sp_oper_oper
-- ============================================================

-- 如下查询返回数据时，请先清理重复工序编号，再执行本脚本。
SELECT `oper`, COUNT(*) AS duplicate_count
FROM `sp_oper`
WHERE `oper` IS NOT NULL AND `oper` <> ''
GROUP BY `oper`
HAVING COUNT(*) > 1;

SET @duplicate_oper_count := (
  SELECT COUNT(*)
  FROM (
    SELECT `oper`
    FROM `sp_oper`
    WHERE `oper` IS NOT NULL AND `oper` <> ''
    GROUP BY `oper`
    HAVING COUNT(*) > 1
  ) t
);

SET @oper_index_count := (
  SELECT COUNT(*)
  FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'sp_oper'
    AND INDEX_NAME = 'uk_sp_oper_oper'
);

SET @oper_index_sql := CASE
  WHEN @duplicate_oper_count > 0 THEN
    'SELECT ''存在重复工序编号，请先清理 sp_oper.oper 后再创建唯一索引'' AS message'
  WHEN @oper_index_count > 0 THEN
    'SELECT ''uk_sp_oper_oper 已存在，无需重复创建'' AS message'
  ELSE
    'ALTER TABLE `sp_oper` ADD UNIQUE KEY `uk_sp_oper_oper` (`oper`)'
END;

PREPARE stmt FROM @oper_index_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;



-- ============================================================
-- [14] source: inventory-upgrade-20260608.sql
-- ============================================================
-- ============================================================
-- 库存管理升级脚本
-- 日期：2026-06-08
-- 内容：建表 sp_inventory（库位+物料+数量）+ 菜单（基础数据中心 → 库存管理）+ 管理员授权
-- 说明：可重复执行（IF NOT EXISTS / INSERT IGNORE / NOT EXISTS 子查询）
--       库存供「数字仿真3D仓库」按真实数据放置货物盒
-- 执行示例：mysql --default-character-set=utf8mb4 -u root -p sparchetype < inventory-upgrade-20260608.sql
-- ============================================================

-- ----------------------------
-- 1. 库存表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_inventory` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `warehouse_id` varchar(64) NOT NULL COMMENT '所属库房ID',
  `location_id` varchar(64) NOT NULL COMMENT '所属库位ID',
  `materiel_id` varchar(64) NOT NULL COMMENT '物料ID',
  `batch_no` varchar(128) DEFAULT NULL COMMENT '批号',
  `qty` decimal(18,4) DEFAULT '0.0000' COMMENT '数量',
  `unit` varchar(32) DEFAULT NULL COMMENT '单位（保存时从物料带出）',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_warehouse` (`warehouse_id`),
  KEY `idx_location` (`location_id`),
  KEY `idx_materiel` (`materiel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存表';

-- ----------------------------
-- 2. 菜单：挂到已存在的「基础数据中心」父菜单（base_data_center）下
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('inventory_mgmt', 'inventoryMgmt', '库存管理', '/basedata/inventory/list-ui', 'base_data_center', '3', 3, '0', 'user:add', 'fa fa-archive', '库存管理', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 3. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('inventory_mgmt')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );



-- ============================================================
-- [15] source: material-type-raw-upgrade-20260608.sql
-- ============================================================
-- ============================================================
-- 物料类型字典补充脚本
-- 日期：2026-06-08
-- 内容：物料信息定义 → 物料类型新增“原材料”
-- 说明：可重复执行；已存在 RAW 时不会重复插入
-- ============================================================

INSERT INTO `sp_sys_dict`
  (`id`, `name`, `value`, `type`, `descr`, `sort_num`, `parent_id`, `is_deleted`,
   `create_time`, `create_username`, `update_time`, `update_username`)
SELECT REPLACE(UUID(),'-',''), '原材料', 'RAW', 'material_type', '物料类型-原材料', 9, '""', '0',
       NOW(), 'admin', NOW(), 'admin'
FROM DUAL
WHERE NOT EXISTS (
  SELECT 1 FROM `sp_sys_dict` d WHERE d.type = 'material_type' AND d.value = 'RAW'
);



-- ============================================================
-- [16] source: bom-menu-move-20260608.sql
-- ============================================================
-- ============================================================
-- 产品BOM管理菜单迁移脚本
-- 日期：2026-06-08
-- 内容：
--   1) 将"产品BOM管理"(id=152) 从"产品数据中心"移至"工艺管理"
--   2) 放在"工序信息定义"下方、原"工艺路线管理"上方
--   3) 工艺管理下其余子菜单排序顺延
--   4) 确保管理员角色持有该菜单的授权
-- 此脚本可重复执行（幂等）。
-- ============================================================

-- 1. 将 产品BOM管理 从 产品数据中心 移至 工艺管理，排在 工序信息定义 之后
UPDATE `sp_sys_menu`
SET `parent_id` = '15',
    `grade` = '3',
    `sort_num` = 2,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '152'
  AND `parent_id` = 'prod_data_center';

UPDATE `sp_sys_menu`
SET `parent_id` = '15',
    `grade` = '3',
    `sort_num` = 2,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '152'
  AND `parent_id` = '15';

-- 2. 工艺管理下其余子菜单排序顺延
--    工序信息定义 (153) 保持 sort=1
--    工艺路线管理 (151): 2 → 3
--    工艺流程管理 (154): 3 → 4
--    工艺内容编制 (155): 4 → 5
--    产品工艺查询 (156):  5 → 6

UPDATE `sp_sys_menu`
SET `sort_num` = 1,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '153'
  AND `parent_id` = '15';

UPDATE `sp_sys_menu`
SET `sort_num` = 3,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '151'
  AND `parent_id` = '15';

UPDATE `sp_sys_menu`
SET `sort_num` = 4,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '154'
  AND `parent_id` = '15';

UPDATE `sp_sys_menu`
SET `sort_num` = 5,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '155'
  AND `parent_id` = '15';

UPDATE `sp_sys_menu`
SET `sort_num` = 6,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '156'
  AND `parent_id` = '15';

-- 3. 确保超级管理员角色持有 产品BOM管理 的菜单授权
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, '152', NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
WHERE r.code IN ('admin', '888888')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm
    WHERE srm.role_id = r.id AND srm.menu_id = '152'
  );

-- 4. 同时确保管理员角色也持有 工序信息定义 的授权（位于同一父菜单下）
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, '153', NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
WHERE r.code IN ('admin', '888888')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm
    WHERE srm.role_id = r.id AND srm.menu_id = '153'
  );


-- ============================================================
-- [17] source: menu-order-upgrade-20260608.sql
-- ============================================================
-- ============================================================
-- MES sidebar menu order cleanup
-- Date: 2026-06-08
-- Content:
--   1) Keep the primary MES module first and push legacy empty roots back
--   2) Organize the left sidebar by MES workflow
--   3) Consolidate material/product/process entries into clearer groups
-- This script is idempotent.
-- ============================================================

-- Top header modules
UPDATE `sp_sys_menu` SET `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '1';
UPDATE `sp_sys_menu` SET `sort_num` = 90, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '2';
UPDATE `sp_sys_menu` SET `sort_num` = 99, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '3';

-- Free the unique menu-name slot before naming prod_data_center.
UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE5B7A5E889BAE7AEA1E79086 USING utf8mb4),
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '15';

UPDATE `sp_sys_menu`
SET `name` = 'matInfoDefHidden',
    `parent_id` = 'legacy_hidden',
    `sort_num` = 99,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = 'mat_info_def';

-- Main sidebar module order under "currency"
UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE59FBAE7A180E695B0E68DAEE4B8ADE5BF83 USING utf8mb4),
    `parent_id` = '1',
    `grade` = '2',
    `sort_num` = 1,
    `icon` = 'fa fa-database',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = 'base_data_center';

UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE4BAA7E59381E695B0E68DAEE4B8ADE5BF83 USING utf8mb4),
    `parent_id` = '1',
    `grade` = '2',
    `sort_num` = 2,
    `icon` = 'fa fa-cubes',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = 'prod_data_center';

UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE5B7A5E889BAE7AEA1E79086 USING utf8mb4),
    `parent_id` = '1',
    `grade` = '2',
    `sort_num` = 3,
    `icon` = 'fa fa-wrench',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '15';

UPDATE `sp_sys_menu` SET `sort_num` = 4, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '12';
UPDATE `sp_sys_menu` SET `sort_num` = 5, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '16';
UPDATE `sp_sys_menu` SET `sort_num` = 6, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '14';
UPDATE `sp_sys_menu` SET `sort_num` = 7, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '17';
UPDATE `sp_sys_menu` SET `sort_num` = 99, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '10';

-- Move legacy material/equipment leaves into the new data centers.
UPDATE `sp_sys_menu`
SET `name` = CONVERT(0xE789A9E69699E4BFA1E681AFE5AE9AE4B989 USING utf8mb4),
    `parent_id` = 'prod_data_center',
    `grade` = '3',
    `sort_num` = 1,
    `icon` = 'fa fa-microchip',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '131';

UPDATE `sp_sys_menu` SET `parent_id` = 'prod_data_center', `grade` = '3', `sort_num` = 2, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'component_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'prod_data_center', `grade` = '3', `sort_num` = 3, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '152';
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 4, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '133';

-- Keep the newer duplicate material item out of the rendered tree; roles using it are bridged to the canonical item below.
UPDATE `sp_sys_menu`
SET `parent_id` = 'legacy_hidden',
    `sort_num` = 99,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = 'mat_info_def';

-- Hide the old material directory once its leaves have moved.
UPDATE `sp_sys_menu`
SET `parent_id` = 'legacy_hidden',
    `sort_num` = 99,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '13';

-- Base data center children
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'banzu_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 2, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'bianzu_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 3, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'cangku_def';
UPDATE `sp_sys_menu` SET `parent_id` = 'base_data_center', `grade` = '3', `sort_num` = 5, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '132';

-- Process management children
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '153';
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 2, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '151';
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 3, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '154';
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 4, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '155';
UPDATE `sp_sys_menu` SET `parent_id` = '15', `grade` = '3', `sort_num` = 5, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '156';

-- Plan, WIP, digital children
UPDATE `sp_sys_menu` SET `parent_id` = '12', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '121';
UPDATE `sp_sys_menu`
SET `name` = CONVERT(0x534EE9809AE794A8E8BF87E7A88BE98787E99B86 USING utf8mb4),
    `url` = '/wip/sn-process/list-ui',
    `parent_id` = '16',
    `grade` = '3',
    `sort_num` = 1,
    `icon` = 'fa fa-barcode',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = '161';
UPDATE `sp_sys_menu` SET `parent_id` = '14', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '141';
UPDATE `sp_sys_menu` SET `parent_id` = '17', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '171';

-- System management children
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 1, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '101';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 2, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '102';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 3, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '103';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 4, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '104';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 5, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '105';
UPDATE `sp_sys_menu` SET `parent_id` = '10', `grade` = '3', `sort_num` = 6, `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = '106';

-- Bridge role authorization from the hidden duplicate material menu to the canonical material menu.
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), srm.role_id, '131', NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role_menu` srm
WHERE srm.menu_id = 'mat_info_def'
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` target
    WHERE target.role_id = srm.role_id AND target.menu_id = '131'
  );

-- Make sure super administrators can see the full normalized sidebar.
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
    '101', '102', '103', '104', '105', '106'
  )
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );



-- ============================================================
-- [18] source: order-approval-upgrade-20260608.sql
-- ============================================================
-- ============================================================
-- Production order designer and production manager approval workflow
-- Date: 2026-06-08
-- Content:
--   1) Add designer and approval fields to sp_order
--   2) Treat statue=1 as created/pending approval and statue=2 as approved
--   3) Grant the work-order release menu to production managers for approval
-- This script is idempotent.
-- ============================================================

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'designer_id'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `designer_id` varchar(64) DEFAULT NULL COMMENT ''Designer user ID'' AFTER `statue`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'designer_name'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `designer_name` varchar(64) DEFAULT NULL COMMENT ''Designer name'' AFTER `designer_id`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'approve_user_id'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `approve_user_id` varchar(64) DEFAULT NULL COMMENT ''Approver user ID'' AFTER `designer_name`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'approve_username'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `approve_username` varchar(64) DEFAULT NULL COMMENT ''Approver name'' AFTER `approve_user_id`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'approve_time'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `approve_time` varchar(32) DEFAULT NULL COMMENT ''Approval time'' AFTER `approve_username`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'work_status'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `work_status` varchar(32) NOT NULL DEFAULT ''NOT_STARTED'' COMMENT ''Work start status'' AFTER `approve_time`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'work_start_time'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `work_start_time` varchar(32) DEFAULT NULL COMMENT ''Work start time'' AFTER `work_status`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE `sp_order`
SET `designer_name` = `create_username`
WHERE (`designer_name` IS NULL OR `designer_name` = '')
  AND `create_username` IS NOT NULL
  AND `create_username` <> '';

ALTER TABLE `sp_order`
  MODIFY COLUMN `statue` tinyint(255) NULL DEFAULT NULL COMMENT '1 created/pending approval, 2 approved, 3 ended, 4 terminated';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('productionManagerRole', 'warehouseManagerRole')
  AND m.code IN ('currency', 'order', 'orderRelease')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );



-- ============================================================
-- [19] source: processing-unit-status-upgrade-20260608.sql
-- ============================================================
-- 加工单元状态语义调整：0正常 2异常
-- 旧版本状态为 1启用 0停用；仅当仍是旧字段注释时，将启用转为正常、停用转为异常。

SELECT COLUMN_COMMENT
INTO @sp_processing_unit_status_comment
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'sp_processing_unit'
  AND COLUMN_NAME = 'status';

SET @sp_processing_unit_status_sql = IF(
    @sp_processing_unit_status_comment LIKE '%1启用 0停用%',
    'UPDATE `sp_processing_unit`
        SET `status` = CASE
            WHEN `status` = ''1'' OR `status` IS NULL OR `status` = '''' THEN ''0''
            WHEN `status` = ''0'' THEN ''2''
            ELSE `status`
        END',
    'UPDATE `sp_processing_unit`
        SET `status` = ''0''
        WHERE `status` = ''1'' OR `status` IS NULL OR `status` = '''''
);

PREPARE stmt FROM @sp_processing_unit_status_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

ALTER TABLE `sp_processing_unit`
    MODIFY COLUMN `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态 0正常 2异常';



-- ============================================================
-- [20] source: sn-process-collect-upgrade-20260608.sql
-- ============================================================
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



-- ============================================================
-- [21] source: remove-tablemanager-20260608.sql
-- ============================================================
-- ============================================================
-- 移除「基础数据配置平台」+「基础数据维护」通用主数据模块
-- 菜单 id：105（基础数据配置平台）、106（基础数据维护）
-- 物理表：sp_table_manager、sp_table_manager_item
-- 执行方式：mysql --default-character-set=utf8mb4 ... < remove-tablemanager-20260608.sql
-- 可重复执行
-- ============================================================

-- 1. 收回角色对这两个菜单的授权
DELETE FROM `sp_sys_role_menu` WHERE `menu_id` IN ('105', '106');

-- 2. 删除菜单
DELETE FROM `sp_sys_menu` WHERE `id` IN ('105', '106');

-- 3. 删除该模块专用的物理表（仅本功能使用，删除不影响其它模块）
DROP TABLE IF EXISTS `sp_table_manager_item`;
DROP TABLE IF EXISTS `sp_table_manager`;



-- ============================================================
-- [22] source: dashboard-screen-upgrade-20260609.sql
-- ============================================================
-- ============================================================
-- 智能制造数据中心（数据大屏）升级脚本
-- 日期：2026-06-09
-- 内容：在「数字化平台」（菜单 id=14）下新增菜单「智能制造数据中心」+ 管理员授权
-- 说明：
--   1. 仅新增菜单，不改动原有「智慧大屏」(id=141 → planDemo) 菜单与页面。
--   2. 大屏数据全部来自真实业务表，无需建表，故本脚本只注册菜单。
--   3. 可重复执行（INSERT IGNORE / NOT EXISTS 子查询）。
--   导入务必带字符集，避免中文乱码：
--   mysql --default-character-set=utf8mb4 -uroot -p sparchetype < dashboard-screen-upgrade-20260609.sql
-- ============================================================

-- ----------------------------
-- 1. 菜单：挂到已存在的「数字化平台」父菜单（id=14）下
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('mes_data_center', 'mesDataCenter', '智能制造数据中心', '/digitization/dashboard/screen-ui', '14', '3', 2, '0', 'user:add', 'fa fa-line-chart', '智能制造数据中心', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 2. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id = 'mes_data_center'
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );



-- ============================================================
-- [23] source: llm-assistant-upgrade-20260609.sql
-- ============================================================
-- ============================================================
-- 大模型智能助手（智能数据助手 + AI 生成 BOM）升级脚本
-- 日期：2026-06-09
-- 内容：建表 sp_llm_conversation / sp_llm_message + 菜单（智能助手中心 → 智能数据助手 / AI生成BOM）+ 管理员授权
-- 说明：可重复执行（IF NOT EXISTS / INSERT IGNORE / NOT EXISTS 子查询）
-- 执行务必带字符集：mysql --default-character-set=utf8mb4 ... < 本脚本
-- ============================================================

-- ----------------------------
-- 1. 会话表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_llm_conversation` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `title` varchar(255) DEFAULT NULL COMMENT '会话标题（首条提问摘要）',
  `user_id` varchar(64) DEFAULT NULL COMMENT '所属用户ID',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='智能助手会话表';

-- ----------------------------
-- 2. 会话消息表
-- ----------------------------
CREATE TABLE IF NOT EXISTS `sp_llm_message` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `conversation_id` varchar(64) NOT NULL COMMENT '所属会话ID',
  `role` varchar(20) NOT NULL COMMENT '角色 user/assistant',
  `content` longtext COMMENT '消息内容',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_conv` (`conversation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='智能助手会话消息表';

-- ----------------------------
-- 3. 菜单：智能助手中心（父） + 智能数据助手 / AI生成BOM（子）
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('llm_center',  'llmCenter',  '智能助手中心', '#',                  '1',          '2', 20, '0', 'user:add', 'fa fa-magic',     '智能助手中心', NOW(), 'admin', NOW(), 'admin'),
('llm_chat',    'llmChat',    '智能数据助手', '/llm/chat/chat-ui',  'llm_center', '3', 1,  '0', 'user:add', 'fa fa-comments',  '智能数据助手', NOW(), 'admin', NOW(), 'admin'),
('llm_bom_gen', 'llmBomGen',  'AI生成BOM',   '/llm/bom-gen/gen-ui', 'llm_center', '3', 2,  '0', 'user:add', 'fa fa-sitemap',   'AI辅助生成BOM', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 4. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id IN ('llm_center', 'llm_chat', 'llm_bom_gen')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );



-- ============================================================
-- [24] source: menu-role-flatten-upgrade-20260609.sql
-- ============================================================
-- ============================================================
-- MES 菜单层级扁平化：移除「权限管理」目录，角色管理直接上挂
-- Date: 2026-06-09
-- 说明：
--   原结构 系统管理(10) → 权限管理(menu_perm_mgr) → 角色管理(103)。
--   「权限管理」目录唯一子节点就是「角色管理」，层级冗余。
--   本脚本将「角色管理」直接挂到「系统管理」下并删除该空目录。
-- 本脚本幂等，可重复执行。
-- ============================================================

-- 1) 角色管理(103) 上移到 系统管理(10) 下，占据原「权限管理」的 sort 3 槽位
UPDATE `sp_sys_menu`
SET `parent_id` = '10', `grade` = '3', `sort_num` = 3,
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `id` = '103';

-- 2) 删除「权限管理」目录的角色授权（角色管理 103 的授权独立存在，不受影响）
DELETE FROM `sp_sys_role_menu` WHERE `menu_id` = 'menu_perm_mgr';

-- 3) 删除「权限管理」空目录本身（已无子节点，物理删除安全）
DELETE FROM `sp_sys_menu` WHERE `id` = 'menu_perm_mgr';



-- ============================================================
-- [25] source: ai-bom-wizard-upgrade-20260610.sql
-- ============================================================
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



-- ============================================================
-- [26] source: production-order-center-upgrade-20260611.sql
-- ============================================================
-- ============================================================
-- 生产计划中心升级脚本
-- Date: 2026-06-11
-- Content:
--   1) 将“生产订单中心”升级为“生产计划中心”。
--   2) 将“订单计划管理”升级为“生产订单录入”。
--   3) 新增生产计划下发、生产工单查询、设备作业派工、员工作业派工菜单。
--   4) 新增设备作业派工结果表 sp_order_oper_equipment_assign。
-- ============================================================

CREATE TABLE IF NOT EXISTS `sp_production_order` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `order_no` varchar(64) NOT NULL COMMENT '生产订单编号',
  `source_type` varchar(16) NOT NULL COMMENT '订单类型 DEMAND需求订单 FORECAST预测订单',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '客户名称',
  `customer_group` varchar(128) DEFAULT NULL COMMENT '客户分组',
  `external_no` varchar(128) DEFAULT NULL COMMENT '外部订单号',
  `sales_contract_no` varchar(128) DEFAULT NULL COMMENT '销售合同号',
  `business_type` varchar(64) DEFAULT NULL COMMENT '业务类型',
  `order_date` varchar(32) DEFAULT NULL COMMENT '订单日期',
  `settlement_currency` varchar(32) DEFAULT NULL COMMENT '结算币种',
  `transport_mode` varchar(64) DEFAULT NULL COMMENT '运输方式',
  `payment_terms` varchar(128) DEFAULT NULL COMMENT '付款方式',
  `tax_rate` varchar(32) DEFAULT NULL COMMENT '税率',
  `receiver_name` varchar(64) DEFAULT NULL COMMENT '收货人',
  `receiver_phone` varchar(64) DEFAULT NULL COMMENT '收货人电话',
  `receiver_address` varchar(255) DEFAULT NULL COMMENT '收货地址',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `status` varchar(32) NOT NULL DEFAULT 'DRAFT' COMMENT '兼容状态',
  `approval_status` varchar(32) NOT NULL DEFAULT 'DRAFT' COMMENT '审核状态',
  `operation_status` varchar(32) NOT NULL DEFAULT 'NONE' COMMENT '下发状态',
  `creation_method` varchar(32) NOT NULL DEFAULT 'MANUAL' COMMENT '创建方式 MANUAL/EXCEL/ERP',
  `scheduling_method` varchar(32) NOT NULL DEFAULT 'REVERSE' COMMENT '排产方式 FORWARD/REVERSE',
  `erp_source_no` varchar(128) DEFAULT NULL COMMENT 'ERP来源单号',
  `erp_sync_time` varchar(32) DEFAULT NULL COMMENT 'ERP同步时间',
  `is_deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '软删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sp_production_order_no` (`order_no`),
  KEY `idx_sp_production_order_status` (`approval_status`, `operation_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生产计划中心-生产订单主表';

CREATE TABLE IF NOT EXISTS `sp_production_order_item` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `order_id` varchar(64) NOT NULL COMMENT '生产订单ID',
  `product_materiel` varchar(128) NOT NULL COMMENT '产品物料编码',
  `product_name` varchar(255) NOT NULL COMMENT '产品名称',
  `bom_id` varchar(64) DEFAULT NULL COMMENT 'BOM ID',
  `bom_code` varchar(128) DEFAULT NULL COMMENT 'BOM编码',
  `bom_version` varchar(64) DEFAULT NULL COMMENT 'BOM版本',
  `model` varchar(128) DEFAULT NULL COMMENT '型号',
  `specification` varchar(128) DEFAULT NULL COMMENT '规格',
  `qty` int NOT NULL DEFAULT 0 COMMENT '需求数量',
  `unit_price` decimal(12,2) DEFAULT NULL COMMENT '单价',
  `configuration` varchar(500) DEFAULT NULL COMMENT '配置要求',
  `plan_delivery_date` varchar(32) DEFAULT NULL COMMENT '计划交付日期',
  `plan_start_date` varchar(32) DEFAULT NULL COMMENT '计划开工日期',
  `lead_time_days` int NOT NULL DEFAULT 1 COMMENT '提前期(工作日)',
  `target_capacity` decimal(10,2) NOT NULL DEFAULT 5.00 COMMENT '目标产能',
  `computed_start_date` varchar(32) DEFAULT NULL COMMENT '系统建议开工日期',
  `computed_delivery_date` varchar(32) DEFAULT NULL COMMENT '系统预计交付日期',
  `adjust_note` varchar(500) DEFAULT NULL COMMENT '调整说明',
  `work_order_id` varchar(64) DEFAULT NULL COMMENT '生产工单ID',
  `work_order_code` varchar(64) DEFAULT NULL COMMENT '生产工单编号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `idx_sp_production_order_item_order` (`order_id`),
  KEY `idx_sp_production_order_item_product` (`product_materiel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生产计划中心-订单明细';

CREATE TABLE IF NOT EXISTS `sp_production_order_oper_plan` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `order_id` varchar(64) NOT NULL COMMENT '生产订单ID',
  `order_item_id` varchar(64) NOT NULL COMMENT '生产订单明细ID',
  `order_no` varchar(64) DEFAULT NULL COMMENT '生产订单编号',
  `product_materiel` varchar(128) DEFAULT NULL COMMENT '产品物料编码',
  `product_name` varchar(255) DEFAULT NULL COMMENT '产品名称',
  `flow_id` varchar(64) DEFAULT NULL COMMENT '工艺路线ID',
  `oper_id` varchar(64) DEFAULT NULL COMMENT '工序ID',
  `oper` varchar(128) DEFAULT NULL COMMENT '工序编码',
  `oper_desc` varchar(255) DEFAULT NULL COMMENT '工序名称',
  `sort_num` int DEFAULT NULL COMMENT '工序顺序',
  `unit_id` varchar(64) DEFAULT NULL COMMENT '加工单元',
  `plan_start_time` varchar(32) DEFAULT NULL COMMENT '计划开始时间',
  `plan_end_time` varchar(32) DEFAULT NULL COMMENT '计划结束时间',
  `duration_hours` decimal(12,2) DEFAULT NULL COMMENT '计划工时',
  `duration_source` varchar(32) DEFAULT NULL COMMENT '工时来源',
  `schedule_method` varchar(32) DEFAULT NULL COMMENT '排产方式',
  `calc_remark` varchar(500) DEFAULT NULL COMMENT '计算说明',
  `is_deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '软删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  KEY `idx_po_oper_plan_order` (`order_id`),
  KEY `idx_po_oper_plan_item` (`order_item_id`),
  KEY `idx_po_oper_plan_oper` (`oper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生产计划中心-工序排产明细';

CREATE TABLE IF NOT EXISTS `sp_order_oper_equipment_assign` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `order_id` varchar(64) DEFAULT NULL COMMENT '生产工单ID',
  `order_code` varchar(64) DEFAULT NULL COMMENT '生产工单编号',
  `production_order_id` varchar(64) NOT NULL COMMENT '生产订单ID',
  `order_item_id` varchar(64) NOT NULL COMMENT '生产订单明细ID',
  `oper_plan_id` varchar(64) NOT NULL COMMENT '工序计划ID',
  `oper_id` varchar(64) DEFAULT NULL COMMENT '工序ID',
  `oper` varchar(128) DEFAULT NULL COMMENT '工序编码',
  `oper_desc` varchar(255) DEFAULT NULL COMMENT '工序名称',
  `sort_num` int DEFAULT NULL COMMENT '工序顺序',
  `unit_id` varchar(64) DEFAULT NULL COMMENT '加工单元ID',
  `equipment_id` varchar(64) DEFAULT NULL COMMENT '设备ID',
  `equipment_code` varchar(128) DEFAULT NULL COMMENT '设备编号',
  `equipment_name` varchar(255) DEFAULT NULL COMMENT '设备名称',
  `status` varchar(32) NOT NULL DEFAULT 'WAIT' COMMENT '派工状态 WAIT/ASSIGNED',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `is_deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '软删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `update_username` varchar(64) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_equipment_assign_plan` (`oper_plan_id`),
  KEY `idx_equipment_assign_order` (`production_order_id`),
  KEY `idx_equipment_assign_equipment` (`equipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='生产计划中心-设备作业派工';

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

CALL sp_add_column_if_missing('sp_production_order', 'approval_status', 'ALTER TABLE sp_production_order ADD COLUMN approval_status varchar(32) NOT NULL DEFAULT ''DRAFT'' COMMENT ''审核状态'' AFTER status');
CALL sp_add_column_if_missing('sp_production_order', 'operation_status', 'ALTER TABLE sp_production_order ADD COLUMN operation_status varchar(32) NOT NULL DEFAULT ''NONE'' COMMENT ''下发状态'' AFTER approval_status');
CALL sp_add_column_if_missing('sp_production_order', 'creation_method', 'ALTER TABLE sp_production_order ADD COLUMN creation_method varchar(32) NOT NULL DEFAULT ''MANUAL'' COMMENT ''创建方式'' AFTER operation_status');
CALL sp_add_column_if_missing('sp_production_order', 'scheduling_method', 'ALTER TABLE sp_production_order ADD COLUMN scheduling_method varchar(32) NOT NULL DEFAULT ''REVERSE'' COMMENT ''排产方式'' AFTER creation_method');
CALL sp_add_column_if_missing('sp_production_order', 'erp_source_no', 'ALTER TABLE sp_production_order ADD COLUMN erp_source_no varchar(128) DEFAULT NULL COMMENT ''ERP来源单号'' AFTER scheduling_method');
CALL sp_add_column_if_missing('sp_production_order', 'erp_sync_time', 'ALTER TABLE sp_production_order ADD COLUMN erp_sync_time varchar(32) DEFAULT NULL COMMENT ''ERP同步时间'' AFTER erp_source_no');
CALL sp_add_column_if_missing('sp_production_order_item', 'bom_id', 'ALTER TABLE sp_production_order_item ADD COLUMN bom_id varchar(64) DEFAULT NULL COMMENT ''BOM ID'' AFTER product_name');
CALL sp_add_column_if_missing('sp_production_order_item', 'bom_code', 'ALTER TABLE sp_production_order_item ADD COLUMN bom_code varchar(128) DEFAULT NULL COMMENT ''BOM编码'' AFTER bom_id');
CALL sp_add_column_if_missing('sp_production_order_item', 'bom_version', 'ALTER TABLE sp_production_order_item ADD COLUMN bom_version varchar(64) DEFAULT NULL COMMENT ''BOM版本'' AFTER bom_code');
DROP PROCEDURE IF EXISTS `sp_add_column_if_missing`;

INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
SELECT 'production_order_center', 'productionOrderCenter', '生产计划中心', '#', '1', '2', 3, '0', 'productionOrder:view', 'fa fa-calendar-check-o', '生产计划中心', NOW(), 'admin', NOW(), 'admin'
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_menu` WHERE `id` = 'production_order_center');

UPDATE `sp_sys_menu`
SET `name` = '生产计划中心', `descr` = '生产计划中心', `url` = '#', `parent_id` = '1',
    `grade` = '2', `sort_num` = 3, `icon` = 'fa fa-calendar-check-o',
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `id` = 'production_order_center';

INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
SELECT 'production_order_plan', 'productionOrderPlan', '生产订单录入', '/production-order/plan/list-ui', 'production_order_center', '3', 1, '0', 'productionOrder:plan', 'fa fa-pencil-square-o', '生产订单录入', NOW(), 'admin', NOW(), 'admin'
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_menu` WHERE `id` = 'production_order_plan');

UPDATE `sp_sys_menu`
SET `name` = '生产订单录入', `descr` = '生产订单录入', `url` = '/production-order/plan/list-ui',
    `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 1,
    `permission` = 'productionOrder:plan', `icon` = 'fa fa-pencil-square-o',
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `id` = 'production_order_plan';

INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
SELECT menu_id, menu_code, menu_name, menu_url, 'production_order_center', '3', menu_sort, '0', menu_permission, menu_icon, menu_name, NOW(), 'admin', NOW(), 'admin'
FROM (
  SELECT 'production_equipment_dispatch' menu_id, 'productionEquipmentDispatch' menu_code, '设备作业派工' menu_name, '/production-order/equipment-dispatch/list-ui' menu_url, 2 menu_sort, 'productionOrder:equipmentDispatch' menu_permission, 'fa fa-cogs' menu_icon
  UNION ALL SELECT 'production_employee_dispatch', 'productionEmployeeDispatch', '员工作业派工', '/production-order/employee-dispatch/list-ui', 3, 'productionOrder:employeeDispatch', 'fa fa-users'
  UNION ALL SELECT 'production_plan_dispatch', 'productionPlanDispatch', '生产计划下发', '/production-order/dispatch/list-ui', 7, 'productionOrder:dispatch', 'fa fa-send'
  UNION ALL SELECT 'production_work_order_query', 'productionWorkOrderQuery', '生产工单查询', '/production-order/work-order/list-ui', 8, 'productionOrder:workOrder', 'fa fa-list-alt'
) menus
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_menu` sm WHERE sm.`id` = menus.menu_id);

UPDATE `sp_sys_menu` SET `name` = '设备作业派工', `descr` = '设备作业派工', `url` = '/production-order/equipment-dispatch/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 2, `permission` = 'productionOrder:equipmentDispatch', `icon` = 'fa fa-cogs', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'production_equipment_dispatch';
UPDATE `sp_sys_menu` SET `name` = '员工作业派工', `descr` = '员工作业派工', `url` = '/production-order/employee-dispatch/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 3, `permission` = 'productionOrder:employeeDispatch', `icon` = 'fa fa-users', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'production_employee_dispatch';
UPDATE `sp_sys_menu` SET `name` = '生产计划下发', `descr` = '生产计划下发', `url` = '/production-order/dispatch/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 7, `permission` = 'productionOrder:dispatch', `icon` = 'fa fa-send', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'production_plan_dispatch';
UPDATE `sp_sys_menu` SET `name` = '生产工单查询', `descr` = '生产工单查询', `url` = '/production-order/work-order/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 8, `permission` = 'productionOrder:workOrder', `icon` = 'fa fa-list-alt', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'production_work_order_query';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin', '888888', 'productionPlannerRole', 'productionManagerRole')
  AND m.id IN ('production_order_center', 'production_order_plan', 'production_plan_dispatch',
               'production_work_order_query', 'production_equipment_dispatch', 'production_employee_dispatch')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );



-- ============================================================
-- [27] source: workflow-control-upgrade-20260611.sql
-- ============================================================
-- ============================================================
-- 流程管控模块升级脚本
-- Date: 2026-06-11
-- Content:
--   1) 新增轻量工作流分类、模型、定义、实例、任务、事件表
--   2) 新增菜单：流程管控 / 流程分类管理 / 流程模型设计 / 流程定义管理 / 流程实例管理 / 流程任务管理
--   3) 初始化“生产流程 / prod”和“生产订单审批流程”
-- ============================================================

CREATE TABLE IF NOT EXISTS `sp_workflow_category` (
  `id` varchar(64) NOT NULL,
  `parent_id` varchar(64) DEFAULT '0',
  `category_name` varchar(128) NOT NULL,
  `category_code` varchar(64) NOT NULL,
  `sort_num` int NOT NULL DEFAULT 30,
  `status` varchar(16) NOT NULL DEFAULT '0',
  `remark` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_workflow_category_code` (`category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程分类';

CREATE TABLE IF NOT EXISTS `sp_workflow_model` (
  `id` varchar(64) NOT NULL,
  `category_id` varchar(64) NOT NULL,
  `model_code` varchar(64) NOT NULL,
  `model_name` varchar(128) NOT NULL,
  `business_type` varchar(64) NOT NULL,
  `node_json` text NOT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'draft',
  `remark` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_workflow_model_code` (`model_code`),
  KEY `idx_workflow_model_category` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程模型';

CREATE TABLE IF NOT EXISTS `sp_workflow_definition` (
  `id` varchar(64) NOT NULL,
  `model_id` varchar(64) NOT NULL,
  `category_id` varchar(64) NOT NULL,
  `definition_code` varchar(64) NOT NULL,
  `definition_name` varchar(128) NOT NULL,
  `business_type` varchar(64) NOT NULL,
  `version_no` int NOT NULL DEFAULT 1,
  `node_json` text NOT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'active',
  `publish_time` varchar(32) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_workflow_def_business` (`business_type`, `status`),
  KEY `idx_workflow_def_code` (`definition_code`, `version_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程定义';

CREATE TABLE IF NOT EXISTS `sp_workflow_instance` (
  `id` varchar(64) NOT NULL,
  `definition_id` varchar(64) NOT NULL,
  `business_type` varchar(64) NOT NULL,
  `business_id` varchar(64) NOT NULL,
  `business_code` varchar(128) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'running',
  `current_node_key` varchar(64) DEFAULT NULL,
  `current_node_name` varchar(128) DEFAULT NULL,
  `start_user_id` varchar(64) DEFAULT NULL,
  `start_username` varchar(64) DEFAULT NULL,
  `start_time` varchar(32) DEFAULT NULL,
  `end_time` varchar(32) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_workflow_inst_business` (`business_type`, `business_id`),
  KEY `idx_workflow_inst_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程实例';

CREATE TABLE IF NOT EXISTS `sp_workflow_task` (
  `id` varchar(64) NOT NULL,
  `instance_id` varchar(64) NOT NULL,
  `definition_id` varchar(64) NOT NULL,
  `business_type` varchar(64) NOT NULL,
  `business_id` varchar(64) NOT NULL,
  `business_code` varchar(128) DEFAULT NULL,
  `task_name` varchar(128) NOT NULL,
  `node_key` varchar(64) NOT NULL,
  `node_name` varchar(128) NOT NULL,
  `assignee_type` varchar(32) NOT NULL,
  `assignee_id` varchar(64) NOT NULL,
  `assignee_name` varchar(128) DEFAULT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'todo',
  `action` varchar(32) DEFAULT NULL,
  `opinion` varchar(500) DEFAULT NULL,
  `start_time` varchar(32) DEFAULT NULL,
  `complete_time` varchar(32) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_workflow_task_inst` (`instance_id`),
  KEY `idx_workflow_task_assignee` (`assignee_type`, `assignee_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程任务';

CREATE TABLE IF NOT EXISTS `sp_workflow_event` (
  `id` varchar(64) NOT NULL,
  `definition_id` varchar(64) NOT NULL,
  `node_key` varchar(64) NOT NULL,
  `event_type` varchar(32) NOT NULL,
  `action_code` varchar(64) NOT NULL,
  `action_name` varchar(128) DEFAULT NULL,
  `status` varchar(16) NOT NULL DEFAULT '0',
  `sort_num` int NOT NULL DEFAULT 1,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_workflow_event_node` (`definition_id`, `node_key`, `event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程事件模板';

CREATE TABLE IF NOT EXISTS `sp_workflow_event_log` (
  `id` varchar(64) NOT NULL,
  `definition_id` varchar(64) DEFAULT NULL,
  `instance_id` varchar(64) DEFAULT NULL,
  `task_id` varchar(64) DEFAULT NULL,
  `event_type` varchar(32) DEFAULT NULL,
  `action_code` varchar(64) DEFAULT NULL,
  `result_status` varchar(32) DEFAULT NULL,
  `result_msg` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_workflow_event_log_inst` (`instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程事件日志';

INSERT IGNORE INTO `sp_sys_menu`
(`id`,`code`,`name`,`url`,`parent_id`,`grade`,`sort_num`,`type`,`permission`,`icon`,`descr`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('workflow_tool','workflowTool','流程配置工具','#','1','2',4,'0','user:add','fa fa-sitemap','流程配置工具',NOW(),'admin',NOW(),'admin'),
('workflow_handle','workflowHandle','流程办理','/workflow/handle/list-ui','workflow_tool','3',1,'0','user:add','fa fa-check-square-o','流程办理',NOW(),'admin',NOW(),'admin'),
('workflow_control','workflowControl','流程管控','#','workflow_tool','3',2,'0','user:add','fa fa-random','流程管控',NOW(),'admin',NOW(),'admin'),
('workflow_category','workflowCategory','流程分类管理','/workflow/category/list-ui','workflow_control','4',1,'0','user:add','fa fa-tags','流程分类管理',NOW(),'admin',NOW(),'admin'),
('workflow_model','workflowModel','流程模型设计','/workflow/model/list-ui','workflow_control','4',2,'0','user:add','fa fa-object-group','流程模型设计',NOW(),'admin',NOW(),'admin'),
('workflow_definition','workflowDefinition','流程定义管理','/workflow/definition/list-ui','workflow_control','4',3,'0','user:add','fa fa-code-fork','流程定义管理',NOW(),'admin',NOW(),'admin'),
('workflow_instance','workflowInstance','流程实例管理','/workflow/instance/list-ui','workflow_control','4',4,'0','user:add','fa fa-history','流程实例管理',NOW(),'admin',NOW(),'admin'),
('workflow_task','workflowTask','流程任务管理','/workflow/task/list-ui','workflow_control','4',5,'0','user:add','fa fa-check-square-o','流程任务管理',NOW(),'admin',NOW(),'admin');

UPDATE `sp_sys_menu`
SET `parent_id` = '1',
    `grade` = '2',
    `sort_num` = 4,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = 'workflow_tool';

UPDATE `sp_sys_menu`
SET `sort_num` = CASE `id`
        WHEN '12' THEN 5
        WHEN '16' THEN 6
        WHEN '14' THEN 7
        WHEN '17' THEN 8
        ELSE `sort_num`
    END,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` IN ('12','16','14','17');

UPDATE `sp_sys_menu`
SET `parent_id` = 'workflow_tool',
    `grade` = '3',
    `sort_num` = 2,
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = 'workflow_control';

UPDATE `sp_sys_menu`
SET `code` = 'workflowHandle',
    `name` = '流程办理',
    `url` = '/workflow/handle/list-ui',
    `parent_id` = 'workflow_tool',
    `grade` = '3',
    `sort_num` = 1,
    `icon` = 'fa fa-check-square-o',
    `descr` = '流程办理',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `id` = 'workflow_handle';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin','888888','productionManagerRole','warehouseManagerRole')
  AND m.id IN ('workflow_tool','workflow_handle','workflow_control','workflow_category','workflow_model','workflow_definition','workflow_instance','workflow_task')
  AND NOT EXISTS (SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id);

SET @workflow_node_json = '[{"nodeKey":"start","nodeName":"订单提交","nodeType":"start"},{"nodeKey":"order_approve","nodeName":"生产订单审批","nodeType":"approval","assigneeType":"role","assigneeId":"productionManagerRole","assigneeName":"生产主管","events":[{"eventType":"complete","actionCode":"ORDER_APPROVE","actionName":"订单审批通过"}]},{"nodeKey":"end","nodeName":"审批完成","nodeType":"end"}]';

INSERT IGNORE INTO `sp_workflow_category`
(`id`,`parent_id`,`category_name`,`category_code`,`sort_num`,`status`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`)
VALUES ('wf_cat_prod','0','生产流程','prod',30,'0','生产订单审批与生产流程管控默认分类',NOW(),'admin',NOW(),'admin');

INSERT IGNORE INTO `sp_workflow_model`
(`id`,`category_id`,`model_code`,`model_name`,`business_type`,`node_json`,`status`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`)
VALUES ('wf_model_order_approval','wf_cat_prod','order_approval','生产订单审批流程','ORDER_APPROVAL',@workflow_node_json,'published','订单创建后由生产/仓储管理角色审批，审批通过后工单进入已审批状态',NOW(),'admin',NOW(),'admin');

INSERT IGNORE INTO `sp_workflow_definition`
(`id`,`model_id`,`category_id`,`definition_code`,`definition_name`,`business_type`,`version_no`,`node_json`,`status`,`publish_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`)
VALUES ('wf_def_order_approval_v1','wf_model_order_approval','wf_cat_prod','order_approval','生产订单审批流程','ORDER_APPROVAL',1,@workflow_node_json,'active',DATE_FORMAT(NOW(),'%Y-%m-%d %H:%i:%s'),'默认生产订单审批流程',NOW(),'admin',NOW(),'admin');

INSERT IGNORE INTO `sp_workflow_event`
(`id`,`definition_id`,`node_key`,`event_type`,`action_code`,`action_name`,`status`,`sort_num`,`create_time`,`create_username`,`update_time`,`update_username`)
VALUES ('wf_event_order_approve','wf_def_order_approval_v1','order_approve','complete','ORDER_APPROVE','订单审批通过','0',1,NOW(),'admin',NOW(),'admin');

UPDATE `sp_workflow_model`
SET `node_json` = REPLACE(REPLACE(`node_json`, 'warehouseManagerRole', 'productionManagerRole'), '仓储/生产管理角色', '生产主管'),
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `model_code` = 'order_approval' AND `node_json` LIKE '%warehouseManagerRole%';

UPDATE `sp_workflow_definition`
SET `node_json` = REPLACE(REPLACE(`node_json`, 'warehouseManagerRole', 'productionManagerRole'), '仓储/生产管理角色', '生产主管'),
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `definition_code` = 'order_approval' AND `node_json` LIKE '%warehouseManagerRole%';

UPDATE `sp_workflow_task`
SET `assignee_id` = 'productionManagerRole',
    `assignee_name` = '生产主管',
    `update_time` = NOW(), `update_username` = 'admin'
WHERE `business_type` = 'ORDER_APPROVAL'
  AND `assignee_id` = 'warehouseManagerRole'
  AND `status` = 'todo';



-- ============================================================
-- [28] source: workflow-form-upgrade-20260611.sql
-- ============================================================
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



-- ============================================================
-- [29] source: material-requirement-plan-upgrade-20260612-fixed.sql
-- ============================================================
-- MRP upgrade (clean version, original has encoding corruption in COMMENT strings)

CREATE TABLE IF NOT EXISTS `sp_material_requirement_plan` (
  `id` varchar(64) NOT NULL,
  `production_order_id` varchar(64) NOT NULL,
  `production_order_no` varchar(64) DEFAULT NULL,
  `order_item_id` varchar(64) DEFAULT NULL,
  `product_serial_no` varchar(128) DEFAULT NULL,
  `product_materiel` varchar(128) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `material_id` varchar(64) DEFAULT NULL,
  `material_code` varchar(128) NOT NULL,
  `material_name` varchar(255) DEFAULT NULL,
  `material_type` varchar(32) DEFAULT NULL,
  `material_source` varchar(32) DEFAULT NULL,
  `unit` varchar(32) DEFAULT NULL,
  `bom_level` int DEFAULT NULL,
  `bom_path` varchar(1000) DEFAULT NULL,
  `gross_requirement` decimal(16,2) NOT NULL DEFAULT 0.00,
  `available_stock` decimal(16,2) NOT NULL DEFAULT 0.00,
  `safety_stock` decimal(16,2) NOT NULL DEFAULT 0.00,
  `net_requirement` decimal(16,2) NOT NULL DEFAULT 0.00,
  `requirement_date` varchar(32) DEFAULT NULL,
  `lead_time_days` int NOT NULL DEFAULT 1,
  `release_date` varchar(32) DEFAULT NULL,
  `delivery_status` varchar(32) NOT NULL DEFAULT 'WAIT',
  `inbound_status` varchar(32) NOT NULL DEFAULT 'NONE',
  `inbound_request_id` varchar(64) DEFAULT NULL,
  `inbound_request_no` varchar(64) DEFAULT NULL,
  `outbound_status` varchar(32) NOT NULL DEFAULT 'NONE',
  `outbound_request_id` varchar(64) DEFAULT NULL,
  `outbound_request_no` varchar(64) DEFAULT NULL,
  `calc_batch_no` varchar(64) DEFAULT NULL,
  `calc_time` varchar(32) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_mrp_order` (`production_order_id`, `is_deleted`),
  KEY `idx_mrp_material_date` (`material_code`, `requirement_date`),
  KEY `idx_mrp_status` (`delivery_status`, `inbound_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物料需求计划明细';

CREATE TABLE IF NOT EXISTS `sp_material_inbound_request` (
  `id` varchar(64) NOT NULL,
  `request_no` varchar(64) NOT NULL,
  `production_order_id` varchar(64) DEFAULT NULL,
  `production_order_no` varchar(64) DEFAULT NULL,
  `source_batch_no` varchar(64) DEFAULT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'GENERATED',
  `item_count` int NOT NULL DEFAULT 0,
  `total_net_qty` decimal(16,2) NOT NULL DEFAULT 0.00,
  `remark` varchar(500) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_inbound_request_no` (`request_no`),
  KEY `idx_material_inbound_request_order` (`production_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物料入库申请单主表';

CREATE TABLE IF NOT EXISTS `sp_material_inbound_request_item` (
  `id` varchar(64) NOT NULL,
  `request_id` varchar(64) NOT NULL,
  `request_no` varchar(64) DEFAULT NULL,
  `plan_id` varchar(64) NOT NULL,
  `production_order_id` varchar(64) DEFAULT NULL,
  `production_order_no` varchar(64) DEFAULT NULL,
  `material_id` varchar(64) DEFAULT NULL,
  `material_code` varchar(128) DEFAULT NULL,
  `material_name` varchar(255) DEFAULT NULL,
  `unit` varchar(32) DEFAULT NULL,
  `request_qty` decimal(16,2) NOT NULL DEFAULT 0.00,
  `requirement_date` varchar(32) DEFAULT NULL,
  `release_date` varchar(32) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_inbound_item_plan` (`plan_id`),
  KEY `idx_material_inbound_item_request` (`request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='物料入库申请单明细';

-- 补充 outbound 字段（幂等）
SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_status');
SET @sql := IF(@col = 0, 'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_status` varchar(32) NOT NULL DEFAULT ''NONE'' AFTER `inbound_request_no`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_request_id');
SET @sql := IF(@col = 0, 'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_id` varchar(64) DEFAULT NULL AFTER `outbound_status`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col := (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_request_no');
SET @sql := IF(@col = 0, 'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_no` varchar(64) DEFAULT NULL AFTER `outbound_request_id`', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 菜单注册
INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
SELECT menu_id, menu_code, menu_name, menu_url, 'production_order_center', '3', menu_sort, '0', menu_permission, menu_icon, menu_name, NOW(), 'admin', NOW(), 'admin'
FROM (
  SELECT 'material_requirement_plan' menu_id, 'materialRequirementPlan' menu_code, '物料需求计划(明细)' menu_name, '/production-order/material-plan/list-ui' menu_url, 4 menu_sort, 'productionOrder:materialPlan' menu_permission, 'fa fa-cubes' menu_icon
  UNION ALL SELECT 'material_requirement_week', 'materialRequirementWeek', '物料需求计划(查询)', '/production-order/material-plan/week-ui', 5, 'productionOrder:materialPlanWeek', 'fa fa-calendar'
  UNION ALL SELECT 'material_inbound_request', 'materialInboundRequest', '入库申请单', '/production-order/material-plan/inbound-request/list-ui', 6, 'productionOrder:inboundRequest', 'fa fa-archive'
) menus
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_menu` sm WHERE sm.`id` = menus.menu_id);

UPDATE `sp_sys_menu` SET `name` = '物料需求计划(明细)', `descr` = '物料需求计划明细', `url` = '/production-order/material-plan/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 4, `permission` = 'productionOrder:materialPlan', `icon` = 'fa fa-cubes', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'material_requirement_plan';
UPDATE `sp_sys_menu` SET `name` = '物料需求计划(查询)', `descr` = '物料需求计划查询', `url` = '/production-order/material-plan/week-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 5, `permission` = 'productionOrder:materialPlanWeek', `icon` = 'fa fa-calendar', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'material_requirement_week';
UPDATE `sp_sys_menu` SET `name` = '入库申请单', `descr` = '入库申请单', `url` = '/production-order/material-plan/inbound-request/list-ui', `parent_id` = 'production_order_center', `grade` = '3', `sort_num` = 6, `permission` = 'productionOrder:inboundRequest', `icon` = 'fa fa-archive', `update_time` = NOW(), `update_username` = 'admin' WHERE `id` = 'material_inbound_request';

-- 角色授权
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin', '888888', 'productionPlannerRole', 'productionManagerRole', 'warehouseManagerRole')
  AND m.id IN ('material_requirement_plan', 'material_requirement_week', 'material_inbound_request')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );



-- ============================================================
-- [30] source: order-complete-delivery-upgrade-20260612.sql
-- ============================================================
-- ============================================================
-- Work order complete and delivery lifecycle
-- Date: 2026-06-12
-- Content:
--   1) Add completion and delivery status columns to sp_order
--   2) Rename Plan Management > Work Order Release to Work Order Management
--   3) Add delivered work order history menu
-- This script is idempotent.
-- ============================================================

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'complete_status'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `complete_status` varchar(32) NOT NULL DEFAULT ''WAIT'' COMMENT ''完工状态 WAIT/COMPLETED'' AFTER `work_start_time`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'complete_time'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `complete_time` varchar(32) DEFAULT NULL COMMENT ''完工时间'' AFTER `complete_status`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'complete_username'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `complete_username` varchar(64) DEFAULT NULL COMMENT ''完工操作人'' AFTER `complete_time`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'delivery_status'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `delivery_status` varchar(32) NOT NULL DEFAULT ''WAIT'' COMMENT ''交付状态 WAIT/DELIVERED'' AFTER `complete_username`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'delivery_time'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `delivery_time` varchar(32) DEFAULT NULL COMMENT ''交付时间'' AFTER `delivery_status`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND COLUMN_NAME = 'delivery_username'
);
SET @ddl := IF(@col_exists = 0,
  'ALTER TABLE `sp_order` ADD COLUMN `delivery_username` varchar(64) DEFAULT NULL COMMENT ''交付操作人'' AFTER `delivery_time`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND INDEX_NAME = 'idx_order_complete_status'
);
SET @ddl := IF(@idx_exists = 0,
  'CREATE INDEX `idx_order_complete_status` ON `sp_order` (`complete_status`)',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_order' AND INDEX_NAME = 'idx_order_delivery_status'
);
SET @ddl := IF(@idx_exists = 0,
  'CREATE INDEX `idx_order_delivery_status` ON `sp_order` (`delivery_status`)',
  'SELECT 1'
);
PREPARE stmt FROM @ddl; EXECUTE stmt; DEALLOCATE PREPARE stmt;

UPDATE `sp_sys_menu`
SET `name` = '工单管理',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `code` = 'orderRelease';

INSERT INTO `sp_sys_menu`
(`id`, `code`, `name`, `url`, `parent_id`, `grade`, `sort_num`, `type`, `permission`, `icon`, `descr`, `create_time`, `create_username`, `update_time`, `update_username`)
SELECT 'orderDelivered', 'orderDelivered', '已交付工单', '/order/delivered/list-ui', '12', '3', 2, '0', 'user:add', 'fa fa-check-square-o', '已交付工单', NOW(), 'admin', NOW(), 'admin'
WHERE NOT EXISTS (
  SELECT 1 FROM `sp_sys_menu` WHERE `id` = 'orderDelivered' OR `code` = 'orderDelivered'
);

UPDATE `sp_sys_menu`
SET `name` = '已交付工单',
    `url` = '/order/delivered/list-ui',
    `parent_id` = '12',
    `grade` = '3',
    `sort_num` = 2,
    `icon` = 'fa fa-check-square-o',
    `update_time` = NOW(),
    `update_username` = 'admin'
WHERE `code` = 'orderDelivered';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('888888', 'productionPlannerRole', 'planManagerRole', 'productionManagerRole', 'warehouseManagerRole')
  AND m.code IN ('orderRelease', 'orderDelivered')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );



-- ============================================================
-- [31] source: sidebar-order-upgrade-20260612.sql
-- ============================================================
-- ============================================================
-- MES sidebar menu order cleanup
-- Date: 2026-06-12
-- Content:
--   1) Reorder the first-level sidebar menus under "currency"
--   2) Rename "process management" to "process management center"
-- This script is idempotent.
-- ============================================================

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



-- ============================================================
-- [32] source: warehouse-management-center-upgrade-20260612.sql
-- ============================================================
-- Warehouse Management Center upgrade.
-- Creates unified warehouse request/transaction tables, inventory stock status, and menus.

CREATE TABLE IF NOT EXISTS `sp_warehouse_request` (
  `id` varchar(64) NOT NULL,
  `request_no` varchar(64) NOT NULL,
  `business_type` varchar(32) NOT NULL,
  `source_type` varchar(32) DEFAULT NULL,
  `source_id` varchar(64) DEFAULT NULL,
  `source_no` varchar(64) DEFAULT NULL,
  `warehouse_id` varchar(64) DEFAULT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'WAIT_CONFIRM',
  `item_count` int NOT NULL DEFAULT 0,
  `total_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `apply_username` varchar(64) DEFAULT NULL,
  `apply_time` varchar(32) DEFAULT NULL,
  `confirm_username` varchar(64) DEFAULT NULL,
  `confirm_time` varchar(32) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_warehouse_request_no` (`request_no`),
  KEY `idx_warehouse_request_type_status` (`business_type`,`status`),
  KEY `idx_warehouse_request_source` (`source_type`,`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='warehouse inbound/outbound request header';

CREATE TABLE IF NOT EXISTS `sp_warehouse_request_item` (
  `id` varchar(64) NOT NULL,
  `request_id` varchar(64) NOT NULL,
  `material_id` varchar(64) NOT NULL,
  `material_code` varchar(128) DEFAULT NULL,
  `material_name` varchar(255) DEFAULT NULL,
  `warehouse_id` varchar(64) DEFAULT NULL,
  `location_id` varchar(64) DEFAULT NULL,
  `batch_no` varchar(128) DEFAULT NULL,
  `request_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `confirmed_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `unit` varchar(32) DEFAULT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'WAIT_CONFIRM',
  `source_item_id` varchar(64) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_warehouse_request_item_req` (`request_id`),
  KEY `idx_warehouse_request_item_src` (`source_item_id`),
  KEY `idx_warehouse_request_item_stock` (`warehouse_id`,`location_id`,`material_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='warehouse inbound/outbound request item';

CREATE TABLE IF NOT EXISTS `sp_warehouse_transaction` (
  `id` varchar(64) NOT NULL,
  `transaction_no` varchar(64) NOT NULL,
  `request_id` varchar(64) DEFAULT NULL,
  `request_no` varchar(64) DEFAULT NULL,
  `request_item_id` varchar(64) DEFAULT NULL,
  `direction` varchar(8) NOT NULL,
  `business_type` varchar(32) NOT NULL,
  `warehouse_id` varchar(64) NOT NULL,
  `location_id` varchar(64) NOT NULL,
  `material_id` varchar(64) NOT NULL,
  `batch_no` varchar(128) DEFAULT NULL,
  `qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `before_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `after_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `operator_username` varchar(64) DEFAULT NULL,
  `operate_time` varchar(32) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_warehouse_transaction_no` (`transaction_no`),
  KEY `idx_warehouse_transaction_req` (`request_no`),
  KEY `idx_warehouse_transaction_stock` (`warehouse_id`,`location_id`,`material_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='warehouse stock transaction';

SET @has_col := (
  SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_inventory' AND COLUMN_NAME = 'stock_status'
);
SET @ddl := IF(@has_col = 0,
  'ALTER TABLE `sp_inventory` ADD COLUMN `stock_status` varchar(32) NOT NULL DEFAULT ''AVAILABLE'' AFTER `unit`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
UPDATE `sp_inventory` SET `stock_status` = 'AVAILABLE' WHERE `stock_status` IS NULL OR `stock_status` = '';

INSERT INTO `sp_sys_menu`
(`id`,`code`,`name`,`url`,`parent_id`,`grade`,`sort_num`,`type`,`permission`,`icon`,`descr`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT menu_id, menu_code, menu_name, menu_url, menu_parent, menu_grade, menu_sort, '0', menu_permission, menu_icon, menu_name, NOW(), 'admin', NOW(), 'admin'
FROM (
  SELECT 'warehouse_management_center' menu_id, 'warehouseManagementCenter' menu_code, '库房管理中心' menu_name, '#' menu_url, '1' menu_parent, '2' menu_grade, 4 menu_sort, 'warehouse:view' menu_permission, 'fa fa-industry' menu_icon
  UNION ALL SELECT 'warehouse_manual_in_apply','warehouseManualInApply','手工入库申请','/warehouse/manual-inbound/apply/list-ui','warehouse_management_center','3',1,'warehouse:manualIn:apply','fa fa-sign-in'
  UNION ALL SELECT 'warehouse_manual_in_confirm','warehouseManualInConfirm','手工入库确认','/warehouse/manual-inbound/confirm/list-ui','warehouse_management_center','3',2,'warehouse:manualIn:confirm','fa fa-check-square-o'
  UNION ALL SELECT 'warehouse_plan_in_confirm','warehousePlanInConfirm','计划入库确认','/warehouse/plan-inbound/confirm/list-ui','warehouse_management_center','3',3,'warehouse:planIn:confirm','fa fa-archive'
  UNION ALL SELECT 'warehouse_manual_out_apply','warehouseManualOutApply','手工出库申请','/warehouse/manual-outbound/apply/list-ui','warehouse_management_center','3',4,'warehouse:manualOut:apply','fa fa-sign-out'
  UNION ALL SELECT 'warehouse_manual_out_confirm','warehouseManualOutConfirm','手工出库确认','/warehouse/manual-outbound/confirm/list-ui','warehouse_management_center','3',5,'warehouse:manualOut:confirm','fa fa-check'
  UNION ALL SELECT 'warehouse_kitting_out_confirm','warehouseKittingOutConfirm','配套出库确认','/warehouse/kitting-outbound/confirm/list-ui','warehouse_management_center','3',6,'warehouse:kittingOut:confirm','fa fa-cubes'
  UNION ALL SELECT 'warehouse_inventory_detail','warehouseInventoryDetail','库存明细查询','/warehouse/inventory/detail/list-ui','warehouse_management_center','3',7,'warehouse:inventory:detail','fa fa-list'
  UNION ALL SELECT 'warehouse_transaction','warehouseTransaction','出入流水查询','/warehouse/transaction/list-ui','warehouse_management_center','3',9,'warehouse:transaction','fa fa-exchange'
) menus
WHERE NOT EXISTS (SELECT 1 FROM `sp_sys_menu` sm WHERE sm.`id` = menus.menu_id);

DELETE FROM `sp_sys_role_menu` WHERE `menu_id` = 'warehouse_ledger';
DELETE FROM `sp_sys_menu` WHERE `id` = 'warehouse_ledger';

INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code IN ('admin', '888888', 'warehouseManagerRole', 'productionManagerRole')
  AND m.id IN ('warehouse_management_center','warehouse_manual_in_apply','warehouse_manual_in_confirm',
               'warehouse_plan_in_confirm','warehouse_manual_out_apply','warehouse_manual_out_confirm',
               'warehouse_kitting_out_confirm','warehouse_inventory_detail','warehouse_transaction')
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );

CREATE TABLE IF NOT EXISTS `sp_warehouse_request_allocation` (
  `id` varchar(64) NOT NULL,
  `request_id` varchar(64) NOT NULL,
  `request_item_id` varchar(64) NOT NULL,
  `inventory_id` varchar(64) NOT NULL,
  `warehouse_id` varchar(64) NOT NULL,
  `location_id` varchar(64) NOT NULL,
  `material_id` varchar(64) NOT NULL,
  `batch_no` varchar(128) DEFAULT NULL,
  `qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `before_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `after_qty` decimal(18,4) NOT NULL DEFAULT 0.0000,
  `allocation_rule` varchar(32) NOT NULL DEFAULT 'FIFO',
  `status` varchar(32) NOT NULL DEFAULT 'CONFIRMED',
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_wh_alloc_req` (`request_id`),
  KEY `idx_wh_alloc_item` (`request_item_id`),
  KEY `idx_wh_alloc_stock` (`inventory_id`,`material_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='warehouse request FIFO allocation';

SET @has_col := (
  SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_status'
);
SET @ddl := IF(@has_col = 0,
  'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_status` varchar(32) NOT NULL DEFAULT ''NONE'' AFTER `inbound_request_no`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_col := (
  SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_request_id'
);
SET @ddl := IF(@has_col = 0,
  'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_id` varchar(64) DEFAULT NULL AFTER `outbound_status`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @has_col := (
  SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sp_material_requirement_plan' AND COLUMN_NAME = 'outbound_request_no'
);
SET @ddl := IF(@has_col = 0,
  'ALTER TABLE `sp_material_requirement_plan` ADD COLUMN `outbound_request_no` varchar(64) DEFAULT NULL AFTER `outbound_request_id`',
  'SELECT 1'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

UPDATE `sp_material_requirement_plan`
SET `outbound_status` = 'NONE'
WHERE `outbound_status` IS NULL OR `outbound_status` = '';

UPDATE `sp_sys_menu` SET `name`='库房管理中心', `descr`='库房管理中心' WHERE `id`='warehouse_management_center';
UPDATE `sp_sys_menu` SET `name`='手工入库申请', `descr`='手工入库申请' WHERE `id`='warehouse_manual_in_apply';
UPDATE `sp_sys_menu` SET `name`='手工入库确认', `descr`='手工入库确认' WHERE `id`='warehouse_manual_in_confirm';
UPDATE `sp_sys_menu` SET `name`='计划入库确认', `descr`='计划入库确认' WHERE `id`='warehouse_plan_in_confirm';
UPDATE `sp_sys_menu` SET `name`='手工出库申请', `descr`='手工出库申请' WHERE `id`='warehouse_manual_out_apply';
UPDATE `sp_sys_menu` SET `name`='手工出库确认', `descr`='手工出库确认' WHERE `id`='warehouse_manual_out_confirm';
UPDATE `sp_sys_menu` SET `name`='配套出库确认', `descr`='配套出库确认' WHERE `id`='warehouse_kitting_out_confirm';
UPDATE `sp_sys_menu` SET `name`='库存明细查询', `descr`='库存明细查询' WHERE `id`='warehouse_inventory_detail';
UPDATE `sp_sys_menu` SET `name`='出入库流水查询', `descr`='出入库流水查询' WHERE `id`='warehouse_transaction';



-- ============================================================
-- [33] source: work-order-change-upgrade-20260612.sql
-- ============================================================
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



-- ============================================================
-- [34] source: production-order-leadtime-upgrade-20260613.sql
-- ============================================================
-- =============================================================================
-- 生产订单录入「排产运算」修复：提前期改为开工前备料提前期
-- 新增明细级「建议备料日」字段 material_ready_date = 生产开工日 − 备料提前期(工作日)
-- 幂等：INFORMATION_SCHEMA 判列存在；可重复执行。
-- 执行：mysql --default-character-set=utf8mb4 -u root -p sparchetype < production-order-leadtime-upgrade-20260613.sql
-- =============================================================================

-- sp_production_order_item 增加 material_ready_date 列（建议备料日）
SET @col_exists := (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'sp_production_order_item'
      AND COLUMN_NAME = 'material_ready_date'
);
SET @ddl := IF(@col_exists = 0,
    'ALTER TABLE `sp_production_order_item` ADD COLUMN `material_ready_date` varchar(32) DEFAULT NULL AFTER `computed_delivery_date`',
    'SELECT 1');
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;



-- ============================================================
-- [35] source: digital-production-line-upgrade-20260624.sql
-- ============================================================
-- ============================================================
-- 数字孪生生产线（3D 浅色大屏）升级脚本
-- 日期：2026-06-24
-- 内容：在「黑科数字孪生」（菜单 id=17）下新增菜单「数字孪生生产线」+ 管理员授权
-- 说明：
--   1. 仅新增菜单，不改动原有「数字仿真3D仓库」(id=171 → 3DProject) 菜单与页面。
--   2. 产线工位/指标全部来自真实业务表（生产订单、SN 工序采集），空数据时后端回退演示数据，无需建表，故本脚本只注册菜单。
--   3. 可重复执行（INSERT IGNORE / NOT EXISTS 子查询）。
--   导入务必带字符集，避免中文乱码：
--   mysql --default-character-set=utf8mb4 -uroot -p sparchetype < digital-production-line-upgrade-20260624.sql
-- ============================================================

-- ----------------------------
-- 1. 菜单：挂到已存在的「黑科数字孪生」父菜单（id=17）下
-- ----------------------------
INSERT IGNORE INTO `sp_sys_menu`
(id, code, name, url, parent_id, grade, sort_num, type, permission, icon, descr, create_time, create_username, update_time, update_username) VALUES
('172', 'DigitalProductionLine', '数字孪生生产线', '/digital/production-line/line-ui', '17', '3', 2, '0', 'user:add', 'fa fa-industry', '数字孪生生产线', NOW(), 'admin', NOW(), 'admin');

-- ----------------------------
-- 2. 给系统管理员（role code = '888888'）授权新菜单
-- ----------------------------
INSERT INTO `sp_sys_role_menu` (id, role_id, menu_id, create_time, create_username, update_time, update_username)
SELECT REPLACE(UUID(),'-',''), r.id, m.id, NOW(), 'admin', NOW(), 'admin'
FROM `sp_sys_role` r
CROSS JOIN `sp_sys_menu` m
WHERE r.code = '888888'
  AND m.id = '172'
  AND NOT EXISTS (
    SELECT 1 FROM `sp_sys_role_menu` srm WHERE srm.role_id = r.id AND srm.menu_id = m.id
  );



-- ============================================================
-- [demo] source: demo-data-optimized-manufacturing-20260614.sql
-- ============================================================
-- ============================================================
-- Demo data: optimized manufacturing walkthrough
-- Date: 2026-06-14
--
-- What this script provides:
--   1) One complete started manufacturing flow for DPC_HOST.
--      BOMs are locked/pass/有效, process routes are locked/completed,
--      the production order is approved, assigned, dispatched, and started.
--   2) One ASSIGNED-stage DPC_HOST order (approved + equipment/staff assigned,
--      work order statue=2, MRP net=0). It stops before dispatch so the
--      equipment-dispatch / employee-dispatch / plan-release pages are not empty
--      (those queues exclude DISPATCHED orders, so the order in 1) cannot fill them).
--   3) One complete master-data flow for IOT_TERMINAL whose BOM is still draft.
--      No work order, MRP, warehouse execution, or SN data is fabricated for it.
--
-- Precondition:
--   Run the schema upgrade scripts through the 2026-06-13 generation first.
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================
-- 0. Clean only this demo dataset.
-- ============================================================
DELETE FROM `sp_workflow_event_log` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_workflow_task` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_workflow_instance` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_warehouse_transaction` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_warehouse_request_allocation` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_warehouse_request_item` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_warehouse_request` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_material_inbound_request_item` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_material_inbound_request` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_material_requirement_plan` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_sn_process_record` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_order_oper_assign` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_order_oper_equipment_assign` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_production_order_oper_plan` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_production_order_item` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_production_order` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_order` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_inventory` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_process_material_rel` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_process_equipment_rel` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_process_content` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_process_route` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_flow_oper_relation` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_flow` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_oper` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_processing_unit_team` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_processing_unit` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_equipment_group_device` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_equipment_group` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_equipment` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_team_employee` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_team` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_warehouse_location` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_warehouse` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_bom_item` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_bom` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_component_def` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_materile` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_sys_user_role` WHERE `id` LIKE 'demo\_%';
DELETE FROM `sp_sys_user` WHERE `id` LIKE 'demo_user\_%';
DELETE FROM `sp_sys_department` WHERE `id` LIKE 'demo_dept\_%';

-- ============================================================
-- 1. Organization and users.
-- Password plaintext for all demo users: 123456
-- Hash algorithm: Shiro Md5Hash(password, username, 3).
-- ============================================================
INSERT INTO `sp_sys_department`
(`id`,`parent_id`,`name`,`sort_num`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_dept_mfg','0','演示制造中心',10,'0',NOW(),'admin',NOW(),'admin'),
('demo_dept_tech','demo_dept_mfg','演示工艺部',10,'0',NOW(),'admin',NOW(),'admin'),
('demo_dept_plan','demo_dept_mfg','演示计划部',20,'0',NOW(),'admin',NOW(),'admin'),
('demo_dept_prod','demo_dept_mfg','演示生产部',30,'0',NOW(),'admin',NOW(),'admin'),
('demo_dept_wh','demo_dept_mfg','演示仓储部',40,'0',NOW(),'admin',NOW(),'admin'),
('demo_dept_qc','demo_dept_mfg','演示质量部',50,'0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `parent_id`=VALUES(`parent_id`),`name`=VALUES(`name`),`sort_num`=VALUES(`sort_num`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_sys_user`
(`id`,`name`,`username`,`password`,`dept_id`,`email`,`mobile`,`tel`,`sex`,`birthday`,`pic_id`,`id_card`,`hobby`,`province`,`city`,`district`,`street`,`street_number`,`descr`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_user_tech_01','林工艺','demo_tech_01','74d696fb7bde6536616b251aacb817eb','demo_dept_tech','demo_tech_01@example.com','13966010001','','1',NULL,'','','','江苏省','苏州市','工业园区','','','产品工艺维护','0',NOW(),'admin',NOW(),'admin'),
('demo_user_tech_02','周工艺','demo_tech_02','c8d3f27e6474d590f69aabdd26cf0fc5','demo_dept_tech','demo_tech_02@example.com','13966010002','','0',NULL,'','','','江苏省','苏州市','工业园区','','','BOM与工艺路线维护','0',NOW(),'admin',NOW(),'admin'),
('demo_user_plan_01','何计划','demo_plan_01','130f4d2a54b8cb1d30338e44b4fc2c61','demo_dept_plan','demo_plan_01@example.com','13966010003','','1',NULL,'','','','江苏省','苏州市','工业园区','','','生产计划员','0',NOW(),'admin',NOW(),'admin'),
('demo_user_plan_02','许计划','demo_plan_02','097f3cb2d7e8d6c551d72e2f3b3a36cd','demo_dept_plan','demo_plan_02@example.com','13966010004','','0',NULL,'','','','江苏省','苏州市','工业园区','','','计划排产','0',NOW(),'admin',NOW(),'admin'),
('demo_user_mgr_01','陈主管','demo_mgr_01','1f8cce526bd2dd17ccf7a48eb93622eb','demo_dept_prod','demo_mgr_01@example.com','13966010005','','1',NULL,'','','','江苏省','苏州市','工业园区','','','生产主管','0',NOW(),'admin',NOW(),'admin'),
('demo_user_mgr_02','赵主管','demo_mgr_02','f5a3245b2b80063c1636e61d03d45380','demo_dept_prod','demo_mgr_02@example.com','13966010006','','0',NULL,'','','','江苏省','苏州市','工业园区','','','现场主管','0',NOW(),'admin',NOW(),'admin'),
('demo_user_op_01','王装配','demo_op_01','81e18c64b229759babc91e02ef9c569c','demo_dept_prod','demo_op_01@example.com','13966010007','','1',NULL,'','','','江苏省','苏州市','工业园区','','','主板装配作业员','0',NOW(),'admin',NOW(),'admin'),
('demo_user_op_02','李总装','demo_op_02','cebd012c89ae56ae7be681a7c874b3b5','demo_dept_prod','demo_op_02@example.com','13966010008','','1',NULL,'','','','江苏省','苏州市','工业园区','','','总装作业员','0',NOW(),'admin',NOW(),'admin'),
('demo_user_op_03','刘测试','demo_op_03','81203ca80a7c61ec80062846fe0bfedc','demo_dept_prod','demo_op_03@example.com','13966010009','','0',NULL,'','','','江苏省','苏州市','工业园区','','','测试作业员','0',NOW(),'admin',NOW(),'admin'),
('demo_user_wh_01','吴仓储','demo_wh_01','b623fbf215ad3daac5c7956e056c79a6','demo_dept_wh','demo_wh_01@example.com','13966010010','','1',NULL,'','','','江苏省','苏州市','工业园区','','','原料仓管理员','0',NOW(),'admin',NOW(),'admin'),
('demo_user_wh_02','郑仓储','demo_wh_02','d691630dde4e27fb84169f05c01ac13e','demo_dept_wh','demo_wh_02@example.com','13966010011','','0',NULL,'','','','江苏省','苏州市','工业园区','','','成品仓管理员','0',NOW(),'admin',NOW(),'admin'),
('demo_user_qc_01','孙质检','demo_qc_01','bf0a5c3fa130127f7741674159a4916d','demo_dept_qc','demo_qc_01@example.com','13966010012','','0',NULL,'','','','江苏省','苏州市','工业园区','','','质量检验员','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`),`password`=VALUES(`password`),`dept_id`=VALUES(`dept_id`),`email`=VALUES(`email`),`mobile`=VALUES(`mobile`),`descr`=VALUES(`descr`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_tech_01','demo_user_tech_01',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='technologyRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_tech_02','demo_user_tech_02',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='technologyRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_plan_01','demo_user_plan_01',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionPlannerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_plan_02','demo_user_plan_02',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionPlannerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_mgr_01','demo_user_mgr_01',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionManagerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_mgr_02','demo_user_mgr_02',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionManagerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_op_01','demo_user_op_01',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionOperatorRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_op_02','demo_user_op_02',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionOperatorRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_op_03','demo_user_op_03',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='productionOperatorRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_wh_01','demo_user_wh_01',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='warehouseManagerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_wh_02','demo_user_wh_02',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='warehouseManagerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();
INSERT INTO `sp_sys_user_role` (`id`,`user_id`,`role_id`,`create_time`,`create_username`,`update_time`,`update_username`)
SELECT 'demo_ur_qc_01','demo_user_qc_01',r.id,NOW(),'admin',NOW(),'admin' FROM `sp_sys_role` r WHERE r.code='qualityManagerRole'
ON DUPLICATE KEY UPDATE `user_id`=VALUES(`user_id`),`role_id`=VALUES(`role_id`),`update_time`=NOW();

-- ============================================================
-- 2. Teams, equipment, warehouses, and locations.
-- ============================================================
INSERT INTO `sp_team`
(`id`,`team_code`,`team_name`,`team_desc`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_team_board','DEMO-TM-BOARD','演示主板装配班组','负责台式电脑主板单元装配','完整制造流程','0',NOW(),'admin',NOW(),'admin'),
('demo_team_final','DEMO-TM-FINAL','演示总装测试班组','负责整机总装、测试、包装','完整制造流程','0',NOW(),'admin',NOW(),'admin'),
('demo_team_iot','DEMO-TM-IOT','演示物联终端班组','负责工业采集终端试制准备','BOM未定版流程','0',NOW(),'admin',NOW(),'admin'),
('demo_team_wh','DEMO-TM-WH','演示仓储班组','负责演示物料收发存','仓库演示','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `team_code`=VALUES(`team_code`),`team_name`=VALUES(`team_name`),`team_desc`=VALUES(`team_desc`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_team_employee`
(`id`,`team_id`,`user_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_te_board_01','demo_team_board','demo_user_op_01','主板装配主操','0',NOW(),'admin',NOW(),'admin'),
('demo_te_board_02','demo_team_board','demo_user_qc_01','主板过程检验','0',NOW(),'admin',NOW(),'admin'),
('demo_te_final_01','demo_team_final','demo_user_op_02','总装主操','0',NOW(),'admin',NOW(),'admin'),
('demo_te_final_02','demo_team_final','demo_user_op_03','功能测试主操','0',NOW(),'admin',NOW(),'admin'),
('demo_te_iot_01','demo_team_iot','demo_user_tech_02','试制工艺支持','0',NOW(),'admin',NOW(),'admin'),
('demo_te_wh_01','demo_team_wh','demo_user_wh_01','原料仓发料','0',NOW(),'admin',NOW(),'admin'),
('demo_te_wh_02','demo_team_wh','demo_user_wh_02','成品仓接收','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `team_id`=VALUES(`team_id`),`user_id`=VALUES(`user_id`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_equipment`
(`id`,`equipment_code`,`equipment_name`,`equipment_model`,`purpose`,`spec`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_eq_smt','DEMO-EQ-001','桌面贴装工作站','SMT-LITE-01','主板元件装配','ESD工作台+扭矩工具','1','0',NOW(),'admin',NOW(),'admin'),
('demo_eq_torque','DEMO-EQ-002','智能扭矩电批','TORQUE-200','机箱紧固','0.2-2.0N.m','1','0',NOW(),'admin',NOW(),'admin'),
('demo_eq_burn','DEMO-EQ-003','整机老化测试架','BURN-24H','整机老化与稳定性测试','24小时老化位','1','0',NOW(),'admin',NOW(),'admin'),
('demo_eq_pack','DEMO-EQ-004','自动贴标包装台','PACK-LABEL-01','标签打印与包装','标签+称重','1','0',NOW(),'admin',NOW(),'admin'),
('demo_eq_iot_fixture','DEMO-EQ-005','物联终端测试夹具','IOT-FIX-01','工业采集终端试制夹具','多通道采集','1','0',NOW(),'admin',NOW(),'admin'),
('demo_eq_scanner','DEMO-EQ-006','无线扫码枪','SCAN-2D','SN采集','2D barcode','1','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `equipment_code`=VALUES(`equipment_code`),`equipment_name`=VALUES(`equipment_name`),`equipment_model`=VALUES(`equipment_model`),`purpose`=VALUES(`purpose`),`spec`=VALUES(`spec`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_equipment_group`
(`id`,`group_code`,`group_name`,`group_desc`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_eg_assembly','DEMO-EG-ASM','演示装配设备组','主板、机箱、总装设备','完整制造流程','0',NOW(),'admin',NOW(),'admin'),
('demo_eg_test','DEMO-EG-TEST','演示测试包装设备组','老化测试、扫码、包装设备','完整制造流程','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `group_code`=VALUES(`group_code`),`group_name`=VALUES(`group_name`),`group_desc`=VALUES(`group_desc`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_equipment_group_device`
(`id`,`group_id`,`equipment_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_egd_smt','demo_eg_assembly','demo_eq_smt','主板装配','0',NOW(),'admin',NOW(),'admin'),
('demo_egd_torque','demo_eg_assembly','demo_eq_torque','机箱与总装紧固','0',NOW(),'admin',NOW(),'admin'),
('demo_egd_burn','demo_eg_test','demo_eq_burn','整机测试','0',NOW(),'admin',NOW(),'admin'),
('demo_egd_pack','demo_eg_test','demo_eq_pack','包装贴标','0',NOW(),'admin',NOW(),'admin'),
('demo_egd_scanner','demo_eg_test','demo_eq_scanner','SN采集','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `group_id`=VALUES(`group_id`),`equipment_id`=VALUES(`equipment_id`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse`
(`id`,`warehouse_code`,`warehouse_name`,`warehouse_type`,`warehouse_desc`,`spec_group`,`spec_row`,`spec_layer`,`spec_column`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wh_raw','DEMO-RM','演示原材料仓','1','电子件、结构件原材料仓',2,2,2,2,'完整制造流程发料仓','0',NOW(),'admin',NOW(),'admin'),
('demo_wh_line','DEMO-LINE','演示线边仓','3','产线齐套与过程周转仓',1,2,2,2,'生产线边仓','0',NOW(),'admin',NOW(),'admin'),
('demo_wh_fg','DEMO-FG','演示成品仓','2','成品与半成品仓',1,2,2,2,'成品入库仓','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `warehouse_code`=VALUES(`warehouse_code`),`warehouse_name`=VALUES(`warehouse_name`),`warehouse_type`=VALUES(`warehouse_type`),`warehouse_desc`=VALUES(`warehouse_desc`),`spec_group`=VALUES(`spec_group`),`spec_row`=VALUES(`spec_row`),`spec_layer`=VALUES(`spec_layer`),`spec_column`=VALUES(`spec_column`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_location`
(`id`,`warehouse_id`,`location_code`,`group_no`,`row_no`,`layer_no`,`column_no`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_loc_raw_01','demo_wh_raw','DEMO-RM-A-01-01-01',1,1,1,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_raw_02','demo_wh_raw','DEMO-RM-A-01-01-02',1,1,1,2,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_raw_03','demo_wh_raw','DEMO-RM-A-01-02-01',1,1,2,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_raw_04','demo_wh_raw','DEMO-RM-A-01-02-02',1,1,2,2,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_line_01','demo_wh_line','DEMO-LINE-A-01-01-01',1,1,1,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_line_02','demo_wh_line','DEMO-LINE-A-01-01-02',1,1,1,2,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_fg_01','demo_wh_fg','DEMO-FG-A-01-01-01',1,1,1,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_loc_fg_02','demo_wh_fg','DEMO-FG-A-01-01-02',1,1,1,2,'0','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `warehouse_id`=VALUES(`warehouse_id`),`location_code`=VALUES(`location_code`),`group_no`=VALUES(`group_no`),`row_no`=VALUES(`row_no`),`layer_no`=VALUES(`layer_no`),`column_no`=VALUES(`column_no`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 3. Materials and component definitions.
-- ============================================================
INSERT INTO `sp_materile`
(`id`,`materiel`,`materiel_desc`,`unit`,`product_group`,`mat_type`,`model`,`size`,`flow_id`,`flow_desc`,`is_deleted`,`mat_source`,`texture`,`lead_time`,`safety_stock`,`image_urls`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_mat_dpc_host','DPC_HOST','台式电脑主机','台','演示台式电脑','FG','DPC-HOST-A','标准机箱','demo_flow_dpc_host','台式电脑主机完整装配流程','0','SELF','',1,5,NULL,'完整制造流程成品',NOW(),'admin',NOW(),'admin'),
('demo_mat_dpc_half','DPC_HOST_HALF','台式电脑主机半成品','台','演示台式电脑','PG','DPC-HALF-A','','demo_flow_dpc_host','主机半成品装配流程','0','SELF','',1,5,NULL,'总装前半成品',NOW(),'admin',NOW(),'admin'),
('demo_mat_dpc_board','DPC_MAINBOARD_UNIT','台式电脑主板单元','件','演示台式电脑','COMP','DPC-MB-A','','demo_flow_dpc_host','主板单元装配流程','0','SELF','',1,10,NULL,'主板组件',NOW(),'admin',NOW(),'admin'),
('demo_mat_dpc_case_unit','DPC_CASE_UNIT','台式电脑机箱单元','件','演示台式电脑','COMP','DPC-CASE-A','','demo_flow_dpc_host','机箱单元装配流程','0','SELF','',1,10,NULL,'机箱组件',NOW(),'admin',NOW(),'admin'),
('demo_mat_pcb','DPC_PCB','台式电脑主板PCB','件','演示台式电脑','PART','PCB-ATX-DEMO','','','','0','OUT','FR-4',2,20,NULL,'主板单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_cpu','DPC_CPU','台式电脑CPU','颗','演示台式电脑','PART','CPU-DEMO','','','','0','OUT','',3,20,NULL,'主板单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_ram','DPC_MEMORY','台式电脑内存条','条','演示台式电脑','PART','DDR-DEMO','','','','0','OUT','',2,20,NULL,'主板单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_ssd','DPC_SSD','台式电脑固态硬盘','块','演示台式电脑','PART','SSD-512G-DEMO','','','','0','OUT','',2,20,NULL,'主板单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_power','DPC_POWER_SUPPLY','台式电脑电源','件','演示台式电脑','PART','PSU-DEMO','','','','0','OUT','',2,10,NULL,'机箱单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_case_shell','DPC_CASE_SHELL','台式电脑机箱外壳','件','演示台式电脑','PART','CASE-DEMO','','','','0','OUT','钢板',2,10,NULL,'机箱单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_fan','DPC_COOLING_FAN','台式电脑散热风扇','件','演示台式电脑','PART','FAN-DEMO','','','','0','OUT','',2,10,NULL,'机箱单元原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_terminal','IOT_TERMINAL','工业采集终端','台','演示工业终端','FG','IOT-T100','','demo_flow_iot_terminal','工业采集终端试制流程','0','SELF','',4,3,NULL,'BOM未定版成品',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_control','IOT_CONTROL_UNIT','工业采集终端控制单元','件','演示工业终端','COMP','IOT-CTRL','','demo_flow_iot_terminal','控制单元试制流程','0','SELF','',3,5,NULL,'BOM未定版组件',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_shell','IOT_SHELL_UNIT','工业采集终端壳体单元','件','演示工业终端','COMP','IOT-SHELL','','demo_flow_iot_terminal','壳体单元试制流程','0','SELF','',3,5,NULL,'BOM未定版组件',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_mcu','IOT_MCU','工业采集MCU','颗','演示工业终端','PART','MCU-DEMO','','','','0','OUT','',10,20,NULL,'BOM未定版原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_sensor','IOT_SENSOR','工业采集传感器','颗','演示工业终端','PART','SENSOR-DEMO','','','','0','OUT','',7,20,NULL,'BOM未定版原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_lcd','IOT_LCD','工业终端显示屏','块','演示工业终端','PART','LCD-DEMO','','','','0','OUT','',6,10,NULL,'BOM未定版原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_shell_part','IOT_TERMINAL_SHELL','工业终端外壳','件','演示工业终端','PART','IOT-SHELL-PART','','','','0','OUT','铝合金',5,10,NULL,'BOM未定版原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_battery','IOT_BATTERY','工业终端备用电池','块','演示工业终端','PART','BAT-DEMO','','','','0','OUT','',5,10,NULL,'BOM未定版原材料',NOW(),'admin',NOW(),'admin'),
('demo_mat_iot_wire','IOT_WIRE_HARNESS','工业终端线束','套','演示工业终端','PART','WIRE-DEMO','','','','0','OUT','铜芯',4,10,NULL,'BOM未定版原材料',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `materiel_desc`=VALUES(`materiel_desc`),`unit`=VALUES(`unit`),`product_group`=VALUES(`product_group`),`mat_type`=VALUES(`mat_type`),`model`=VALUES(`model`),`flow_id`=VALUES(`flow_id`),`flow_desc`=VALUES(`flow_desc`),`is_deleted`=VALUES(`is_deleted`),`mat_source`=VALUES(`mat_source`),`texture`=VALUES(`texture`),`lead_time`=VALUES(`lead_time`),`safety_stock`=VALUES(`safety_stock`),`remark`=VALUES(`remark`),`update_time`=NOW();

INSERT INTO `sp_component_def`
(`id`,`product_name`,`component_code`,`component_name`,`component_type`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_comp_dpc_half','台式电脑主机','DPC_HOST_HALF','台式电脑主机半成品','PG','完整制造流程半成品','0',NOW(),'admin',NOW(),'admin'),
('demo_comp_dpc_board','台式电脑主机','DPC_MAINBOARD_UNIT','台式电脑主板单元','COMP','完整制造流程主板组件','0',NOW(),'admin',NOW(),'admin'),
('demo_comp_dpc_case','台式电脑主机','DPC_CASE_UNIT','台式电脑机箱单元','COMP','完整制造流程机箱组件','0',NOW(),'admin',NOW(),'admin'),
('demo_comp_iot_control','工业采集终端','IOT_CONTROL_UNIT','工业采集终端控制单元','COMP','草稿BOM控制组件','0',NOW(),'admin',NOW(),'admin'),
('demo_comp_iot_shell','工业采集终端','IOT_SHELL_UNIT','工业采集终端壳体单元','COMP','草稿BOM壳体组件','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `product_name`=VALUES(`product_name`),`component_code`=VALUES(`component_code`),`component_name`=VALUES(`component_name`),`component_type`=VALUES(`component_type`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 4. BOMs. DPC is locked; IOT remains draft.
-- ============================================================
INSERT INTO `sp_bom`
(`id`,`bom_code`,`materiel_code`,`materiel_desc`,`remark`,`version_number`,`state`,`factory`,`is_deleted`,`bom_level`,`lock_status`,`validity`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_bom_dpc_host','BOM-DPC-HOST-V1','DPC_HOST','台式电脑主机','完整制造流程成品BOM','1','pass','center','0',0,'locked','有效',NOW(),'admin',NOW(),'admin'),
('demo_bom_dpc_half','BOM-DPC-HALF-V1','DPC_HOST_HALF','台式电脑主机半成品','完整制造流程半成品BOM','1','pass','center','0',1,'locked','有效',NOW(),'admin',NOW(),'admin'),
('demo_bom_dpc_board','BOM-DPC-BOARD-V1','DPC_MAINBOARD_UNIT','台式电脑主板单元','完整制造流程主板单元BOM','1','pass','center','0',2,'locked','有效',NOW(),'admin',NOW(),'admin'),
('demo_bom_dpc_case','BOM-DPC-CASE-V1','DPC_CASE_UNIT','台式电脑机箱单元','完整制造流程机箱单元BOM','1','pass','center','0',2,'locked','有效',NOW(),'admin',NOW(),'admin'),
('demo_bom_iot_terminal','BOM-IOT-TERMINAL-DRAFT','IOT_TERMINAL','工业采集终端','基础数据齐全，BOM未定版','0.1','creat','center','0',0,'draft','未生效',NOW(),'admin',NOW(),'admin'),
('demo_bom_iot_control','BOM-IOT-CONTROL-DRAFT','IOT_CONTROL_UNIT','工业采集终端控制单元','子BOM草稿，待工艺确认','0.1','creat','center','0',2,'draft','未生效',NOW(),'admin',NOW(),'admin'),
('demo_bom_iot_shell','BOM-IOT-SHELL-DRAFT','IOT_SHELL_UNIT','工业采集终端壳体单元','子BOM草稿，待结构确认','0.1','creat','center','0',2,'draft','未生效',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `bom_code`=VALUES(`bom_code`),`materiel_code`=VALUES(`materiel_code`),`materiel_desc`=VALUES(`materiel_desc`),`remark`=VALUES(`remark`),`version_number`=VALUES(`version_number`),`state`=VALUES(`state`),`factory`=VALUES(`factory`),`is_deleted`=VALUES(`is_deleted`),`bom_level`=VALUES(`bom_level`),`lock_status`=VALUES(`lock_status`),`validity`=VALUES(`validity`),`update_time`=NOW();

INSERT INTO `sp_bom_item`
(`id`,`bom_head_id`,`materiel_item_code`,`materiel_item_desc`,`line_no`,`item_num`,`item_unit`,`oper_typer`,`child_bom_id`,`item_mat_type`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_bom_item_dpc_host_half','demo_bom_dpc_host','DPC_HOST_HALF','台式电脑主机半成品','10',1,'台','总装','demo_bom_dpc_half','PG',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_half_board','demo_bom_dpc_half','DPC_MAINBOARD_UNIT','台式电脑主板单元','10',1,'件','主板装配','demo_bom_dpc_board','COMP',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_half_case','demo_bom_dpc_half','DPC_CASE_UNIT','台式电脑机箱单元','20',1,'件','机箱装配','demo_bom_dpc_case','COMP',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_pcb','demo_bom_dpc_board','DPC_PCB','台式电脑主板PCB','10',1,'件','主板装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_cpu','demo_bom_dpc_board','DPC_CPU','台式电脑CPU','20',1,'颗','主板装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_ram','demo_bom_dpc_board','DPC_MEMORY','台式电脑内存条','30',1,'条','主板装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_ssd','demo_bom_dpc_board','DPC_SSD','台式电脑固态硬盘','40',1,'块','主板装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_power','demo_bom_dpc_case','DPC_POWER_SUPPLY','台式电脑电源','10',1,'件','机箱装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_shell','demo_bom_dpc_case','DPC_CASE_SHELL','台式电脑机箱外壳','20',1,'件','机箱装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_dpc_fan','demo_bom_dpc_case','DPC_COOLING_FAN','台式电脑散热风扇','30',1,'件','机箱装配',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_control','demo_bom_iot_terminal','IOT_CONTROL_UNIT','工业采集终端控制单元','10',1,'件','控制单元试制','demo_bom_iot_control','COMP',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_shell','demo_bom_iot_terminal','IOT_SHELL_UNIT','工业采集终端壳体单元','20',1,'件','壳体试制','demo_bom_iot_shell','COMP',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_mcu','demo_bom_iot_control','IOT_MCU','工业采集MCU','10',1,'颗','控制板试制',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_sensor','demo_bom_iot_control','IOT_SENSOR','工业采集传感器','20',2,'颗','控制板试制',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_lcd','demo_bom_iot_control','IOT_LCD','工业终端显示屏','30',1,'块','控制板试制',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_shell_part','demo_bom_iot_shell','IOT_TERMINAL_SHELL','工业终端外壳','10',1,'件','壳体试制',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_battery','demo_bom_iot_shell','IOT_BATTERY','工业终端备用电池','20',1,'块','壳体试制',NULL,'PART',NOW(),'admin',NOW(),'admin'),
('demo_bom_item_iot_wire','demo_bom_iot_shell','IOT_WIRE_HARNESS','工业终端线束','30',1,'套','壳体试制',NULL,'PART',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `bom_head_id`=VALUES(`bom_head_id`),`materiel_item_code`=VALUES(`materiel_item_code`),`materiel_item_desc`=VALUES(`materiel_item_desc`),`line_no`=VALUES(`line_no`),`item_num`=VALUES(`item_num`),`item_unit`=VALUES(`item_unit`),`oper_typer`=VALUES(`oper_typer`),`child_bom_id`=VALUES(`child_bom_id`),`item_mat_type`=VALUES(`item_mat_type`),`update_time`=NOW();

-- ============================================================
-- 5. Processing units, operations, and flows.
-- ============================================================
INSERT INTO `sp_processing_unit`
(`id`,`unit_code`,`unit_name`,`unit_type`,`description`,`std_capacity`,`has_edge_warehouse`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_unit_board','DEMO-U-BOARD','演示主板装配单元','person','主板元件装配与自检',20,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_unit_case','DEMO-U-CASE','演示机箱装配单元','person','机箱、电源、风扇装配',20,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_unit_final','DEMO-U-FINAL','演示整机总装单元','person','主板单元与机箱单元总装',20,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_unit_test','DEMO-U-TEST','演示整机测试单元','device','整机老化与功能测试',20,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_unit_pack','DEMO-U-PACK','演示包装入库单元','person','包装贴标与成品入库',20,1,'0','0',NOW(),'admin',NOW(),'admin'),
('demo_unit_iot','DEMO-U-IOT','演示工业终端试制单元','person','工业采集终端草稿BOM试制准备',10,1,'0','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `unit_code`=VALUES(`unit_code`),`unit_name`=VALUES(`unit_name`),`unit_type`=VALUES(`unit_type`),`description`=VALUES(`description`),`std_capacity`=VALUES(`std_capacity`),`has_edge_warehouse`=VALUES(`has_edge_warehouse`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_processing_unit_team`
(`id`,`unit_id`,`team_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_put_board','demo_unit_board','demo_team_board','主板装配单元对应班组','0',NOW(),'admin',NOW(),'admin'),
('demo_put_case','demo_unit_case','demo_team_final','机箱装配由总装班组负责','0',NOW(),'admin',NOW(),'admin'),
('demo_put_final','demo_unit_final','demo_team_final','整机总装单元对应班组','0',NOW(),'admin',NOW(),'admin'),
('demo_put_test','demo_unit_test','demo_team_final','测试单元对应班组','0',NOW(),'admin',NOW(),'admin'),
('demo_put_pack','demo_unit_pack','demo_team_wh','包装入库协同仓储班组','0',NOW(),'admin',NOW(),'admin'),
('demo_put_iot','demo_unit_iot','demo_team_iot','工业终端试制班组','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `unit_id`=VALUES(`unit_id`),`team_id`=VALUES(`team_id`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_oper`
(`id`,`oper`,`oper_desc`,`unit_id`,`oper_hours`,`manu_cycle`,`gen_plan`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_op_dpc_board','DPC-OP-010','主板单元装配','demo_unit_board',1.50,2.00,'Y','完整流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_dpc_case','DPC-OP-020','机箱单元装配','demo_unit_case',1.00,1.50,'Y','完整流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_dpc_final','DPC-OP-030','整机总装','demo_unit_final',1.20,1.50,'Y','完整流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_dpc_test','DPC-OP-040','整机老化测试','demo_unit_test',2.00,2.50,'Y','完整流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_dpc_pack','DPC-OP-050','包装入库','demo_unit_pack',0.60,1.00,'Y','完整流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_iot_control','IOT-OP-010','控制单元试制','demo_unit_iot',2.00,3.00,'Y','BOM未定版流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_iot_shell','IOT-OP-020','壳体单元试制','demo_unit_iot',1.50,2.00,'Y','BOM未定版流程工序',NOW(),'admin',NOW(),'admin'),
('demo_op_iot_test','IOT-OP-030','整机联调试制','demo_unit_iot',2.50,3.00,'Y','BOM未定版流程工序',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`unit_id`=VALUES(`unit_id`),`oper_hours`=VALUES(`oper_hours`),`manu_cycle`=VALUES(`manu_cycle`),`gen_plan`=VALUES(`gen_plan`),`remark`=VALUES(`remark`),`update_time`=NOW();

INSERT INTO `sp_flow`
(`id`,`flow`,`flow_desc`,`process`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_flow_dpc_host','DPC-FLOW-001','台式电脑主机完整装配流程','主板单元装配->机箱单元装配->整机总装->整机老化测试->包装入库',NOW(),'admin',NOW(),'admin'),
('demo_flow_iot_terminal','IOT-FLOW-DRAFT','工业采集终端试制流程','控制单元试制->壳体单元试制->整机联调试制',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `flow`=VALUES(`flow`),`flow_desc`=VALUES(`flow_desc`),`process`=VALUES(`process`),`update_time`=NOW();

INSERT INTO `sp_flow_oper_relation`
(`id`,`flow_id`,`flow`,`per_oper_id`,`per_oper`,`oper_id`,`oper`,`next_oper_id`,`next_oper`,`sort_num`,`oper_type`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_for_dpc_010','demo_flow_dpc_host','DPC-FLOW-001',NULL,NULL,'demo_op_dpc_board','DPC-OP-010','demo_op_dpc_case','DPC-OP-020',10,'firstOper',NOW(),'admin',NOW(),'admin'),
('demo_for_dpc_020','demo_flow_dpc_host','DPC-FLOW-001','demo_op_dpc_board','DPC-OP-010','demo_op_dpc_case','DPC-OP-020','demo_op_dpc_final','DPC-OP-030',20,NULL,NOW(),'admin',NOW(),'admin'),
('demo_for_dpc_030','demo_flow_dpc_host','DPC-FLOW-001','demo_op_dpc_case','DPC-OP-020','demo_op_dpc_final','DPC-OP-030','demo_op_dpc_test','DPC-OP-040',30,NULL,NOW(),'admin',NOW(),'admin'),
('demo_for_dpc_040','demo_flow_dpc_host','DPC-FLOW-001','demo_op_dpc_final','DPC-OP-030','demo_op_dpc_test','DPC-OP-040','demo_op_dpc_pack','DPC-OP-050',40,NULL,NOW(),'admin',NOW(),'admin'),
('demo_for_dpc_050','demo_flow_dpc_host','DPC-FLOW-001','demo_op_dpc_test','DPC-OP-040','demo_op_dpc_pack','DPC-OP-050',NULL,NULL,50,'lastOper',NOW(),'admin',NOW(),'admin'),
('demo_for_iot_010','demo_flow_iot_terminal','IOT-FLOW-DRAFT',NULL,NULL,'demo_op_iot_control','IOT-OP-010','demo_op_iot_shell','IOT-OP-020',10,'firstOper',NOW(),'admin',NOW(),'admin'),
('demo_for_iot_020','demo_flow_iot_terminal','IOT-FLOW-DRAFT','demo_op_iot_control','IOT-OP-010','demo_op_iot_shell','IOT-OP-020','demo_op_iot_test','IOT-OP-030',20,NULL,NOW(),'admin',NOW(),'admin'),
('demo_for_iot_030','demo_flow_iot_terminal','IOT-FLOW-DRAFT','demo_op_iot_shell','IOT-OP-020','demo_op_iot_test','IOT-OP-030',NULL,NULL,30,'lastOper',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `flow_id`=VALUES(`flow_id`),`flow`=VALUES(`flow`),`per_oper_id`=VALUES(`per_oper_id`),`per_oper`=VALUES(`per_oper`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`next_oper_id`=VALUES(`next_oper_id`),`next_oper`=VALUES(`next_oper`),`sort_num`=VALUES(`sort_num`),`oper_type`=VALUES(`oper_type`),`update_time`=NOW();

-- ============================================================
-- 6. Locked DPC process route and work instructions.
-- No IOT process route is inserted because its BOM is not locked.
-- ============================================================
INSERT INTO `sp_process_route`
(`id`,`bom_id`,`bom_item_id`,`route_code`,`parent_route_id`,`node_name`,`materiel_code`,`oper_id`,`seq_no`,`lock_status`,`edit_status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_route_dpc_root','demo_bom_dpc_host',NULL,'NGY_3_DPC_HOST',NULL,'台式电脑主机','DPC_HOST','demo_op_dpc_pack',50,'locked','completed','0',NOW(),'admin',NOW(),'admin'),
('demo_route_dpc_half','demo_bom_dpc_host','demo_bom_item_dpc_host_half','NGY_3_DPC_HOST_001','demo_route_dpc_root','台式电脑主机半成品','DPC_HOST_HALF','demo_op_dpc_final',30,'locked','completed','0',NOW(),'admin',NOW(),'admin'),
('demo_route_dpc_board','demo_bom_dpc_host','demo_bom_item_dpc_half_board','NGY_3_DPC_HOST_001_001','demo_route_dpc_half','台式电脑主板单元','DPC_MAINBOARD_UNIT','demo_op_dpc_board',10,'locked','completed','0',NOW(),'admin',NOW(),'admin'),
('demo_route_dpc_case','demo_bom_dpc_host','demo_bom_item_dpc_half_case','NGY_3_DPC_HOST_001_002','demo_route_dpc_half','台式电脑机箱单元','DPC_CASE_UNIT','demo_op_dpc_case',20,'locked','completed','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `bom_id`=VALUES(`bom_id`),`bom_item_id`=VALUES(`bom_item_id`),`route_code`=VALUES(`route_code`),`parent_route_id`=VALUES(`parent_route_id`),`node_name`=VALUES(`node_name`),`materiel_code`=VALUES(`materiel_code`),`oper_id`=VALUES(`oper_id`),`seq_no`=VALUES(`seq_no`),`lock_status`=VALUES(`lock_status`),`edit_status`=VALUES(`edit_status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_process_content`
(`id`,`route_id`,`content_text`,`require_text`,`need_check`,`precaution_text`,`tech_doc_desc`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_pc_board','demo_route_dpc_board','装配PCB、CPU、内存、SSD并完成目检。','ESD防护到位，CPU针脚无弯曲，内存卡扣闭合。','Y','禁止裸手接触金手指。','DPC-SOP-010 主板单元装配作业指导书',NOW(),'admin',NOW(),'admin'),
('demo_pc_case','demo_route_dpc_case','安装电源、机箱外壳与散热风扇。','电源线束固定，风扇方向正确。','Y','扭矩按工艺卡执行。','DPC-SOP-020 机箱单元装配作业指导书',NOW(),'admin',NOW(),'admin'),
('demo_pc_half','demo_route_dpc_half','将主板单元装入机箱单元并接线。','线束不压伤，接口全部插紧。','Y','走线避开风扇叶片。','DPC-SOP-030 整机总装作业指导书',NOW(),'admin',NOW(),'admin'),
('demo_pc_root','demo_route_dpc_root','完成老化、贴标、包装、入库确认。','SN标签一致，包装附件齐套。','Y','老化不合格不得入库。','DPC-SOP-050 包装入库作业指导书',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `route_id`=VALUES(`route_id`),`content_text`=VALUES(`content_text`),`require_text`=VALUES(`require_text`),`need_check`=VALUES(`need_check`),`precaution_text`=VALUES(`precaution_text`),`tech_doc_desc`=VALUES(`tech_doc_desc`),`update_time`=NOW();

INSERT INTO `sp_process_equipment_rel`
(`id`,`route_id`,`equipment_id`,`req_qty`,`remark`,`create_time`,`create_username`) VALUES
('demo_per_board_smt','demo_route_dpc_board','demo_eq_smt',1,'主板装配工作站',NOW(),'admin'),
('demo_per_case_torque','demo_route_dpc_case','demo_eq_torque',1,'机箱装配扭矩工具',NOW(),'admin'),
('demo_per_half_torque','demo_route_dpc_half','demo_eq_torque',1,'整机总装扭矩工具',NOW(),'admin'),
('demo_per_root_burn','demo_route_dpc_root','demo_eq_burn',1,'整机老化测试架',NOW(),'admin'),
('demo_per_root_pack','demo_route_dpc_root','demo_eq_pack',1,'包装贴标设备',NOW(),'admin')
ON DUPLICATE KEY UPDATE `route_id`=VALUES(`route_id`),`equipment_id`=VALUES(`equipment_id`),`req_qty`=VALUES(`req_qty`),`remark`=VALUES(`remark`);

INSERT INTO `sp_process_material_rel`
(`id`,`route_id`,`materiel_id`,`req_qty`,`remark`,`create_time`,`create_username`) VALUES
('demo_pmr_board_pcb','demo_route_dpc_board','demo_mat_pcb',1,'主板PCB',NOW(),'admin'),
('demo_pmr_board_cpu','demo_route_dpc_board','demo_mat_cpu',1,'CPU',NOW(),'admin'),
('demo_pmr_board_ram','demo_route_dpc_board','demo_mat_ram',1,'内存条',NOW(),'admin'),
('demo_pmr_board_ssd','demo_route_dpc_board','demo_mat_ssd',1,'固态硬盘',NOW(),'admin'),
('demo_pmr_case_power','demo_route_dpc_case','demo_mat_power',1,'电源',NOW(),'admin'),
('demo_pmr_case_shell','demo_route_dpc_case','demo_mat_case_shell',1,'机箱外壳',NOW(),'admin'),
('demo_pmr_case_fan','demo_route_dpc_case','demo_mat_fan',1,'散热风扇',NOW(),'admin')
ON DUPLICATE KEY UPDATE `route_id`=VALUES(`route_id`),`materiel_id`=VALUES(`materiel_id`),`req_qty`=VALUES(`req_qty`),`remark`=VALUES(`remark`);

-- ============================================================
-- 7. Inventory after confirmed kitting-out for DPC order.
-- Before issuing, each DPC raw material had 120 units. The order issued 20.
-- ============================================================
INSERT INTO `sp_inventory`
(`id`,`warehouse_id`,`location_id`,`materiel_id`,`batch_no`,`qty`,`unit`,`stock_status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_inv_pcb','demo_wh_raw','demo_loc_raw_01','demo_mat_pcb','DPC-RM-20260601',100.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_cpu','demo_wh_raw','demo_loc_raw_01','demo_mat_cpu','DPC-RM-20260601',100.0000,'颗','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_ram','demo_wh_raw','demo_loc_raw_02','demo_mat_ram','DPC-RM-20260601',100.0000,'条','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_ssd','demo_wh_raw','demo_loc_raw_02','demo_mat_ssd','DPC-RM-20260601',100.0000,'块','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_power','demo_wh_raw','demo_loc_raw_03','demo_mat_power','DPC-RM-20260601',100.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_case_shell','demo_wh_raw','demo_loc_raw_03','demo_mat_case_shell','DPC-RM-20260601',100.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_fan','demo_wh_raw','demo_loc_raw_04','demo_mat_fan','DPC-RM-20260601',100.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_iot_mcu','demo_wh_raw','demo_loc_raw_04','demo_mat_iot_mcu','IOT-RM-20260601',50.0000,'颗','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_iot_sensor','demo_wh_raw','demo_loc_raw_04','demo_mat_iot_sensor','IOT-RM-20260601',80.0000,'颗','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_iot_shell','demo_wh_raw','demo_loc_raw_03','demo_mat_iot_shell_part','IOT-RM-20260601',40.0000,'件','AVAILABLE','0',NOW(),'admin',NOW(),'admin'),
('demo_inv_dpc_finished','demo_wh_fg','demo_loc_fg_01','demo_mat_dpc_host','DPC-FG-20260614',20.0000,'台','AVAILABLE','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`materiel_id`=VALUES(`materiel_id`),`batch_no`=VALUES(`batch_no`),`qty`=VALUES(`qty`),`unit`=VALUES(`unit`),`stock_status`=VALUES(`stock_status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 8. Production order: DPC complete/started, IOT draft only.
-- ============================================================
INSERT INTO `sp_production_order`
(`id`,`order_no`,`source_type`,`customer_name`,`customer_group`,`external_no`,`sales_contract_no`,`business_type`,`order_date`,`settlement_currency`,`transport_mode`,`payment_terms`,`tax_rate`,`receiver_name`,`receiver_phone`,`receiver_address`,`remark`,`status`,`approval_status`,`operation_status`,`creation_method`,`scheduling_method`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_po_dpc','DD-DEMO-20260614-001','DEMAND','演示客户-华东智造','华东大客户','EXT-DEMO-DPC-001','HT-DEMO-DPC-001','普通销售','2026-06-14','人民币','公路运输','月结30天','不含税','王采购','13866010001','上海市浦东新区演示路1号','完整制造流程：已审批、已派工、已下发、已开工','CONFIRMED','APPROVED','DISPATCHED','MANUAL','REVERSE','0',NOW(),'admin',NOW(),'admin'),
('demo_po_iot','DD-DEMO-20260614-002','DEMAND','演示客户-北方能源','能源行业客户','EXT-DEMO-IOT-001','HT-DEMO-IOT-001','试制订单','2026-06-14','人民币','公路运输','预付30%','不含税','李采购','13866010002','北京市海淀区演示路2号','基础数据齐全，但BOM未定版；仅演示草稿录入','DRAFT','DRAFT','NONE','MANUAL','REVERSE','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `customer_name`=VALUES(`customer_name`),`customer_group`=VALUES(`customer_group`),`external_no`=VALUES(`external_no`),`sales_contract_no`=VALUES(`sales_contract_no`),`business_type`=VALUES(`business_type`),`order_date`=VALUES(`order_date`),`remark`=VALUES(`remark`),`status`=VALUES(`status`),`approval_status`=VALUES(`approval_status`),`operation_status`=VALUES(`operation_status`),`creation_method`=VALUES(`creation_method`),`scheduling_method`=VALUES(`scheduling_method`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order`
(`id`,`order_code`,`order_description`,`qty`,`order_type`,`flow_id`,`materiel`,`materiel_desc`,`plan_start_time`,`plan_end_time`,`statue`,`designer_id`,`designer_name`,`approve_user_id`,`approve_username`,`approve_time`,`remark`,`work_status`,`work_start_time`,`complete_status`,`complete_time`,`complete_username`,`delivery_status`,`delivery_time`,`delivery_username`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wo_dpc','GD-DEMO-20260614-001','DD-DEMO-20260614-001 / 台式电脑主机',20,'P','demo_flow_dpc_host','DPC_HOST','台式电脑主机','2026-06-14 08:00:00','2026-06-18 17:00:00',5,'demo_user_plan_01','何计划','demo_user_mgr_01','陈主管','2026-06-14 09:00:00','DPC complete workflow: dispatched, started, completed and delivered','STARTED','2026-06-14 10:00:00','COMPLETED','2026-06-18 17:10:00','demo_wh_02','DELIVERED','2026-06-18 17:30:00','demo_wh_02',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_code`=VALUES(`order_code`),`order_description`=VALUES(`order_description`),`qty`=VALUES(`qty`),`order_type`=VALUES(`order_type`),`flow_id`=VALUES(`flow_id`),`materiel`=VALUES(`materiel`),`materiel_desc`=VALUES(`materiel_desc`),`plan_start_time`=VALUES(`plan_start_time`),`plan_end_time`=VALUES(`plan_end_time`),`statue`=VALUES(`statue`),`designer_id`=VALUES(`designer_id`),`designer_name`=VALUES(`designer_name`),`approve_user_id`=VALUES(`approve_user_id`),`approve_username`=VALUES(`approve_username`),`approve_time`=VALUES(`approve_time`),`remark`=VALUES(`remark`),`work_status`=VALUES(`work_status`),`work_start_time`=VALUES(`work_start_time`),`complete_status`=VALUES(`complete_status`),`complete_time`=VALUES(`complete_time`),`complete_username`=VALUES(`complete_username`),`delivery_status`=VALUES(`delivery_status`),`delivery_time`=VALUES(`delivery_time`),`delivery_username`=VALUES(`delivery_username`),`update_time`=NOW();

INSERT INTO `sp_production_order_item`
(`id`,`order_id`,`product_materiel`,`product_name`,`bom_id`,`bom_code`,`bom_version`,`model`,`specification`,`qty`,`unit_price`,`configuration`,`plan_delivery_date`,`plan_start_date`,`lead_time_days`,`target_capacity`,`computed_start_date`,`computed_delivery_date`,`material_ready_date`,`adjust_note`,`work_order_id`,`work_order_code`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_poi_dpc','demo_po_dpc','DPC_HOST','台式电脑主机','demo_bom_dpc_host','BOM-DPC-HOST-V1','1','DPC-HOST-A','标准配置',20,3999.00,'i5/16G/512G/标准机箱','2026-06-18','2026-06-14',1,20.00,'2026-06-14','2026-06-18','2026-06-14',NULL,'demo_wo_dpc','GD-DEMO-20260614-001',NOW(),'admin',NOW(),'admin'),
('demo_poi_iot','demo_po_iot','IOT_TERMINAL','工业采集终端','demo_bom_iot_terminal','BOM-IOT-TERMINAL-DRAFT','0.1','IOT-T100','草稿配置',12,1899.00,'4G/多通道采集/备用电池','2026-07-05','2026-06-26',4,6.00,'2026-06-26','2026-07-05',NULL,'BOM未定版，暂不生成工单',NULL,NULL,NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`bom_id`=VALUES(`bom_id`),`bom_code`=VALUES(`bom_code`),`bom_version`=VALUES(`bom_version`),`model`=VALUES(`model`),`specification`=VALUES(`specification`),`qty`=VALUES(`qty`),`unit_price`=VALUES(`unit_price`),`configuration`=VALUES(`configuration`),`plan_delivery_date`=VALUES(`plan_delivery_date`),`plan_start_date`=VALUES(`plan_start_date`),`lead_time_days`=VALUES(`lead_time_days`),`target_capacity`=VALUES(`target_capacity`),`computed_start_date`=VALUES(`computed_start_date`),`computed_delivery_date`=VALUES(`computed_delivery_date`),`material_ready_date`=VALUES(`material_ready_date`),`adjust_note`=VALUES(`adjust_note`),`work_order_id`=VALUES(`work_order_id`),`work_order_code`=VALUES(`work_order_code`),`update_time`=NOW();

INSERT INTO `sp_production_order_oper_plan`
(`id`,`order_id`,`order_item_id`,`order_no`,`product_materiel`,`product_name`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`plan_start_time`,`plan_end_time`,`duration_hours`,`duration_source`,`schedule_method`,`calc_remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_pop_dpc_010','demo_po_dpc','demo_poi_dpc','DD-DEMO-20260614-001','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'demo_unit_board','2026-06-14 08:00:00','2026-06-14 12:00:00',4.00,'MANUAL','REVERSE','演示排产：主板单元', '0',NOW(),'admin',NOW(),'admin'),
('demo_pop_dpc_020','demo_po_dpc','demo_poi_dpc','DD-DEMO-20260614-001','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'demo_unit_case','2026-06-14 13:00:00','2026-06-15 10:00:00',5.00,'MANUAL','REVERSE','演示排产：机箱单元','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_dpc_030','demo_po_dpc','demo_poi_dpc','DD-DEMO-20260614-001','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_final','DPC-OP-030','整机总装',30,'demo_unit_final','2026-06-15 10:00:00','2026-06-16 12:00:00',10.00,'MANUAL','REVERSE','演示排产：整机总装','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_dpc_040','demo_po_dpc','demo_poi_dpc','DD-DEMO-20260614-001','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'demo_unit_test','2026-06-16 13:00:00','2026-06-18 10:00:00',13.00,'MANUAL','REVERSE','演示排产：整机测试','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_dpc_050','demo_po_dpc','demo_poi_dpc','DD-DEMO-20260614-001','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'demo_unit_pack','2026-06-18 10:00:00','2026-06-18 17:00:00',7.00,'MANUAL','REVERSE','演示排产：包装入库','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_item_id`=VALUES(`order_item_id`),`order_no`=VALUES(`order_no`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`flow_id`=VALUES(`flow_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`plan_start_time`=VALUES(`plan_start_time`),`plan_end_time`=VALUES(`plan_end_time`),`duration_hours`=VALUES(`duration_hours`),`duration_source`=VALUES(`duration_source`),`schedule_method`=VALUES(`schedule_method`),`calc_remark`=VALUES(`calc_remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order_oper_equipment_assign`
(`id`,`order_id`,`order_code`,`production_order_id`,`order_item_id`,`oper_plan_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`equipment_id`,`equipment_code`,`equipment_name`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_ooea_dpc_010','demo_wo_dpc','GD-DEMO-20260614-001','demo_po_dpc','demo_poi_dpc','demo_pop_dpc_010','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'demo_unit_board','demo_eq_smt','DEMO-EQ-001','桌面贴装工作站','ASSIGNED','主板单元设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_dpc_020','demo_wo_dpc','GD-DEMO-20260614-001','demo_po_dpc','demo_poi_dpc','demo_pop_dpc_020','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'demo_unit_case','demo_eq_torque','DEMO-EQ-002','智能扭矩电批','ASSIGNED','机箱装配设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_dpc_030','demo_wo_dpc','GD-DEMO-20260614-001','demo_po_dpc','demo_poi_dpc','demo_pop_dpc_030','demo_op_dpc_final','DPC-OP-030','整机总装',30,'demo_unit_final','demo_eq_torque','DEMO-EQ-002','智能扭矩电批','ASSIGNED','总装设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_dpc_040','demo_wo_dpc','GD-DEMO-20260614-001','demo_po_dpc','demo_poi_dpc','demo_pop_dpc_040','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'demo_unit_test','demo_eq_burn','DEMO-EQ-003','整机老化测试架','ASSIGNED','测试设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_dpc_050','demo_wo_dpc','GD-DEMO-20260614-001','demo_po_dpc','demo_poi_dpc','demo_pop_dpc_050','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'demo_unit_pack','demo_eq_pack','DEMO-EQ-004','自动贴标包装台','ASSIGNED','包装设备已派工','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_code`=VALUES(`order_code`),`production_order_id`=VALUES(`production_order_id`),`order_item_id`=VALUES(`order_item_id`),`oper_plan_id`=VALUES(`oper_plan_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`equipment_id`=VALUES(`equipment_id`),`equipment_code`=VALUES(`equipment_code`),`equipment_name`=VALUES(`equipment_name`),`status`=VALUES(`status`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order_oper_assign`
(`id`,`order_id`,`order_code`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`team_id`,`user_id`,`user_name`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_ooa_dpc_010','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'demo_unit_board','demo_team_board','demo_user_op_01','王装配','1','主板装配已开工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_dpc_020','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'demo_unit_case','demo_team_final','demo_user_op_02','李总装','1','机箱装配已开工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_dpc_030','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_final','DPC-OP-030','整机总装',30,'demo_unit_final','demo_team_final','demo_user_op_02','李总装','1','整机总装已开工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_dpc_040','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'demo_unit_test','demo_team_final','demo_user_op_03','刘测试','1','整机测试已开工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_dpc_050','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'demo_unit_pack','demo_team_wh','demo_user_wh_02','郑仓储','1','包装入库已开工','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_code`=VALUES(`order_code`),`flow_id`=VALUES(`flow_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`team_id`=VALUES(`team_id`),`user_id`=VALUES(`user_id`),`user_name`=VALUES(`user_name`),`status`=VALUES(`status`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

-- ============================================================
-- 9. MRP and confirmed kitting-out for DPC order.
-- ============================================================
INSERT INTO `sp_material_requirement_plan`
(`id`,`production_order_id`,`production_order_no`,`order_item_id`,`product_serial_no`,`product_materiel`,`product_name`,`material_id`,`material_code`,`material_name`,`material_type`,`material_source`,`unit`,`bom_level`,`bom_path`,`gross_requirement`,`available_stock`,`safety_stock`,`net_requirement`,`requirement_date`,`lead_time_days`,`release_date`,`delivery_status`,`inbound_status`,`inbound_request_id`,`inbound_request_no`,`outbound_status`,`outbound_request_id`,`outbound_request_no`,`calc_batch_no`,`calc_time`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_mrp_dpc_pcb','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_pcb','DPC_PCB','台式电脑主板PCB','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_PCB',20.00,120.00,20.00,0.00,'2026-06-14',2,'2026-06-12','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_dpc_cpu','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_cpu','DPC_CPU','台式电脑CPU','PART','OUT','颗',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_CPU',20.00,120.00,20.00,0.00,'2026-06-14',3,'2026-06-11','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_dpc_ram','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_ram','DPC_MEMORY','台式电脑内存条','PART','OUT','条',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_MEMORY',20.00,120.00,20.00,0.00,'2026-06-14',2,'2026-06-12','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_dpc_ssd','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_ssd','DPC_SSD','台式电脑固态硬盘','PART','OUT','块',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_SSD',20.00,120.00,20.00,0.00,'2026-06-14',2,'2026-06-12','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_dpc_power','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_power','DPC_POWER_SUPPLY','台式电脑电源','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_CASE_UNIT>DPC_POWER_SUPPLY',20.00,120.00,10.00,0.00,'2026-06-14',2,'2026-06-12','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_dpc_shell','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_case_shell','DPC_CASE_SHELL','台式电脑机箱外壳','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_CASE_UNIT>DPC_CASE_SHELL',20.00,120.00,10.00,0.00,'2026-06-14',2,'2026-06-12','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_dpc_fan','demo_po_dpc','DD-DEMO-20260614-001','demo_poi_dpc','DD-DEMO-20260614-001-SN001','DPC_HOST','台式电脑主机','demo_mat_fan','DPC_COOLING_FAN','台式电脑散热风扇','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_CASE_UNIT>DPC_COOLING_FAN',20.00,120.00,10.00,0.00,'2026-06-14',2,'2026-06-12','RELEASED','NONE',NULL,NULL,'CONFIRMED','demo_wr_kit_dpc','WKO-DEMO-20260614-001','MRP-DEMO-DPC-20260614','2026-06-14 08:20:00','库存充足，已齐套出库','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `production_order_id`=VALUES(`production_order_id`),`production_order_no`=VALUES(`production_order_no`),`order_item_id`=VALUES(`order_item_id`),`product_serial_no`=VALUES(`product_serial_no`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`material_id`=VALUES(`material_id`),`material_code`=VALUES(`material_code`),`material_name`=VALUES(`material_name`),`material_type`=VALUES(`material_type`),`material_source`=VALUES(`material_source`),`unit`=VALUES(`unit`),`bom_level`=VALUES(`bom_level`),`bom_path`=VALUES(`bom_path`),`gross_requirement`=VALUES(`gross_requirement`),`available_stock`=VALUES(`available_stock`),`safety_stock`=VALUES(`safety_stock`),`net_requirement`=VALUES(`net_requirement`),`requirement_date`=VALUES(`requirement_date`),`lead_time_days`=VALUES(`lead_time_days`),`release_date`=VALUES(`release_date`),`delivery_status`=VALUES(`delivery_status`),`inbound_status`=VALUES(`inbound_status`),`outbound_status`=VALUES(`outbound_status`),`outbound_request_id`=VALUES(`outbound_request_id`),`outbound_request_no`=VALUES(`outbound_request_no`),`calc_batch_no`=VALUES(`calc_batch_no`),`calc_time`=VALUES(`calc_time`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_request`
(`id`,`request_no`,`business_type`,`source_type`,`source_id`,`source_no`,`warehouse_id`,`status`,`item_count`,`total_qty`,`apply_username`,`apply_time`,`confirm_username`,`confirm_time`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wr_kit_dpc','WKO-DEMO-20260614-001','KITTING_OUT','MRP','demo_po_dpc','DD-DEMO-20260614-001','demo_wh_raw','CONFIRMED',7,140.0000,'demo_wh_01','2026-06-14 08:30:00','demo_wh_01','2026-06-14 09:10:00','完整制造流程齐套出库，支持工单开工','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_no`=VALUES(`request_no`),`business_type`=VALUES(`business_type`),`source_type`=VALUES(`source_type`),`source_id`=VALUES(`source_id`),`source_no`=VALUES(`source_no`),`warehouse_id`=VALUES(`warehouse_id`),`status`=VALUES(`status`),`item_count`=VALUES(`item_count`),`total_qty`=VALUES(`total_qty`),`apply_username`=VALUES(`apply_username`),`apply_time`=VALUES(`apply_time`),`confirm_username`=VALUES(`confirm_username`),`confirm_time`=VALUES(`confirm_time`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_request_item`
(`id`,`request_id`,`material_id`,`material_code`,`material_name`,`warehouse_id`,`location_id`,`batch_no`,`request_qty`,`confirmed_qty`,`unit`,`status`,`source_item_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wri_pcb','demo_wr_kit_dpc','demo_mat_pcb','DPC_PCB','台式电脑主板PCB','demo_wh_raw','demo_loc_raw_01','DPC-RM-20260601',20.0000,20.0000,'件','CONFIRMED','demo_mrp_dpc_pcb','齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_wri_cpu','demo_wr_kit_dpc','demo_mat_cpu','DPC_CPU','台式电脑CPU','demo_wh_raw','demo_loc_raw_01','DPC-RM-20260601',20.0000,20.0000,'颗','CONFIRMED','demo_mrp_dpc_cpu','齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_wri_ram','demo_wr_kit_dpc','demo_mat_ram','DPC_MEMORY','台式电脑内存条','demo_wh_raw','demo_loc_raw_02','DPC-RM-20260601',20.0000,20.0000,'条','CONFIRMED','demo_mrp_dpc_ram','齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_wri_ssd','demo_wr_kit_dpc','demo_mat_ssd','DPC_SSD','台式电脑固态硬盘','demo_wh_raw','demo_loc_raw_02','DPC-RM-20260601',20.0000,20.0000,'块','CONFIRMED','demo_mrp_dpc_ssd','齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_wri_power','demo_wr_kit_dpc','demo_mat_power','DPC_POWER_SUPPLY','台式电脑电源','demo_wh_raw','demo_loc_raw_03','DPC-RM-20260601',20.0000,20.0000,'件','CONFIRMED','demo_mrp_dpc_power','齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_wri_shell','demo_wr_kit_dpc','demo_mat_case_shell','DPC_CASE_SHELL','台式电脑机箱外壳','demo_wh_raw','demo_loc_raw_03','DPC-RM-20260601',20.0000,20.0000,'件','CONFIRMED','demo_mrp_dpc_shell','齐套出库','0',NOW(),'admin',NOW(),'admin'),
('demo_wri_fan','demo_wr_kit_dpc','demo_mat_fan','DPC_COOLING_FAN','台式电脑散热风扇','demo_wh_raw','demo_loc_raw_04','DPC-RM-20260601',20.0000,20.0000,'件','CONFIRMED','demo_mrp_dpc_fan','齐套出库','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_id`=VALUES(`request_id`),`material_id`=VALUES(`material_id`),`material_code`=VALUES(`material_code`),`material_name`=VALUES(`material_name`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`batch_no`=VALUES(`batch_no`),`request_qty`=VALUES(`request_qty`),`confirmed_qty`=VALUES(`confirmed_qty`),`unit`=VALUES(`unit`),`status`=VALUES(`status`),`source_item_id`=VALUES(`source_item_id`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_request_allocation`
(`id`,`request_id`,`request_item_id`,`inventory_id`,`warehouse_id`,`location_id`,`material_id`,`batch_no`,`qty`,`before_qty`,`after_qty`,`allocation_rule`,`status`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wra_pcb','demo_wr_kit_dpc','demo_wri_pcb','demo_inv_pcb','demo_wh_raw','demo_loc_raw_01','demo_mat_pcb','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('demo_wra_cpu','demo_wr_kit_dpc','demo_wri_cpu','demo_inv_cpu','demo_wh_raw','demo_loc_raw_01','demo_mat_cpu','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('demo_wra_ram','demo_wr_kit_dpc','demo_wri_ram','demo_inv_ram','demo_wh_raw','demo_loc_raw_02','demo_mat_ram','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('demo_wra_ssd','demo_wr_kit_dpc','demo_wri_ssd','demo_inv_ssd','demo_wh_raw','demo_loc_raw_02','demo_mat_ssd','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('demo_wra_power','demo_wr_kit_dpc','demo_wri_power','demo_inv_power','demo_wh_raw','demo_loc_raw_03','demo_mat_power','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('demo_wra_shell','demo_wr_kit_dpc','demo_wri_shell','demo_inv_case_shell','demo_wh_raw','demo_loc_raw_03','demo_mat_case_shell','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin'),
('demo_wra_fan','demo_wr_kit_dpc','demo_wri_fan','demo_inv_fan','demo_wh_raw','demo_loc_raw_04','demo_mat_fan','DPC-RM-20260601',20.0000,120.0000,100.0000,'FIFO','CONFIRMED','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_id`=VALUES(`request_id`),`request_item_id`=VALUES(`request_item_id`),`inventory_id`=VALUES(`inventory_id`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`material_id`=VALUES(`material_id`),`batch_no`=VALUES(`batch_no`),`qty`=VALUES(`qty`),`before_qty`=VALUES(`before_qty`),`after_qty`=VALUES(`after_qty`),`allocation_rule`=VALUES(`allocation_rule`),`status`=VALUES(`status`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_transaction`
(`id`,`transaction_no`,`request_id`,`request_no`,`request_item_id`,`direction`,`business_type`,`warehouse_id`,`location_id`,`material_id`,`batch_no`,`qty`,`before_qty`,`after_qty`,`operator_username`,`operate_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wtx_pcb','WO-DEMO-20260614-001','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_pcb','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_01','demo_mat_pcb','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑主板PCB齐套出库',NOW(),'admin',NOW(),'admin'),
('demo_wtx_cpu','WO-DEMO-20260614-002','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_cpu','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_01','demo_mat_cpu','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑CPU齐套出库',NOW(),'admin',NOW(),'admin'),
('demo_wtx_ram','WO-DEMO-20260614-003','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_ram','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_02','demo_mat_ram','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑内存条齐套出库',NOW(),'admin',NOW(),'admin'),
('demo_wtx_ssd','WO-DEMO-20260614-004','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_ssd','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_02','demo_mat_ssd','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑固态硬盘齐套出库',NOW(),'admin',NOW(),'admin'),
('demo_wtx_power','WO-DEMO-20260614-005','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_power','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_03','demo_mat_power','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑电源齐套出库',NOW(),'admin',NOW(),'admin'),
('demo_wtx_shell','WO-DEMO-20260614-006','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_shell','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_03','demo_mat_case_shell','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑机箱外壳齐套出库',NOW(),'admin',NOW(),'admin'),
('demo_wtx_fan','WO-DEMO-20260614-007','demo_wr_kit_dpc','WKO-DEMO-20260614-001','demo_wri_fan','OUT','KITTING_OUT','demo_wh_raw','demo_loc_raw_04','demo_mat_fan','DPC-RM-20260601',20.0000,120.0000,100.0000,'demo_wh_01','2026-06-14 09:10:00','台式电脑散热风扇齐套出库',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `transaction_no`=VALUES(`transaction_no`),`request_id`=VALUES(`request_id`),`request_no`=VALUES(`request_no`),`request_item_id`=VALUES(`request_item_id`),`direction`=VALUES(`direction`),`business_type`=VALUES(`business_type`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`material_id`=VALUES(`material_id`),`batch_no`=VALUES(`batch_no`),`qty`=VALUES(`qty`),`before_qty`=VALUES(`before_qty`),`after_qty`=VALUES(`after_qty`),`operator_username`=VALUES(`operator_username`),`operate_time`=VALUES(`operate_time`),`remark`=VALUES(`remark`),`update_time`=NOW();

INSERT INTO `sp_warehouse_request`
(`id`,`request_no`,`business_type`,`source_type`,`source_id`,`source_no`,`warehouse_id`,`status`,`item_count`,`total_qty`,`apply_username`,`apply_time`,`confirm_username`,`confirm_time`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wr_fg_dpc','WIN-DEMO-20260618-001','MANUAL_IN','WORK_ORDER','demo_wo_dpc','GD-DEMO-20260614-001','demo_wh_fg','CONFIRMED',1,20.0000,'demo_wh_02','2026-06-18 17:00:00','demo_wh_02','2026-06-18 17:10:00','DPC finished goods inbound','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_no`=VALUES(`request_no`),`business_type`=VALUES(`business_type`),`source_type`=VALUES(`source_type`),`source_id`=VALUES(`source_id`),`source_no`=VALUES(`source_no`),`warehouse_id`=VALUES(`warehouse_id`),`status`=VALUES(`status`),`item_count`=VALUES(`item_count`),`total_qty`=VALUES(`total_qty`),`apply_username`=VALUES(`apply_username`),`apply_time`=VALUES(`apply_time`),`confirm_username`=VALUES(`confirm_username`),`confirm_time`=VALUES(`confirm_time`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_request_item`
(`id`,`request_id`,`material_id`,`material_code`,`material_name`,`warehouse_id`,`location_id`,`batch_no`,`request_qty`,`confirmed_qty`,`unit`,`status`,`source_item_id`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wri_fg_dpc','demo_wr_fg_dpc','demo_mat_dpc_host','DPC_HOST','DPC_HOST','demo_wh_fg','demo_loc_fg_01','DPC-FG-20260614',20.0000,20.0000,'pcs','CONFIRMED','demo_poi_dpc','finished goods inbound','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `request_id`=VALUES(`request_id`),`material_id`=VALUES(`material_id`),`material_code`=VALUES(`material_code`),`material_name`=VALUES(`material_name`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`batch_no`=VALUES(`batch_no`),`request_qty`=VALUES(`request_qty`),`confirmed_qty`=VALUES(`confirmed_qty`),`unit`=VALUES(`unit`),`status`=VALUES(`status`),`source_item_id`=VALUES(`source_item_id`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_warehouse_transaction`
(`id`,`transaction_no`,`request_id`,`request_no`,`request_item_id`,`direction`,`business_type`,`warehouse_id`,`location_id`,`material_id`,`batch_no`,`qty`,`before_qty`,`after_qty`,`operator_username`,`operate_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wtx_dpc_fg_in','WI-DEMO-20260618-001','demo_wr_fg_dpc','WIN-DEMO-20260618-001','demo_wri_fg_dpc','IN','MANUAL_IN','demo_wh_fg','demo_loc_fg_01','demo_mat_dpc_host','DPC-FG-20260614',20.0000,0.0000,20.0000,'demo_wh_02','2026-06-18 17:10:00','DPC finished goods inbound',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `transaction_no`=VALUES(`transaction_no`),`request_id`=VALUES(`request_id`),`request_no`=VALUES(`request_no`),`request_item_id`=VALUES(`request_item_id`),`direction`=VALUES(`direction`),`business_type`=VALUES(`business_type`),`warehouse_id`=VALUES(`warehouse_id`),`location_id`=VALUES(`location_id`),`material_id`=VALUES(`material_id`),`batch_no`=VALUES(`batch_no`),`qty`=VALUES(`qty`),`before_qty`=VALUES(`before_qty`),`after_qty`=VALUES(`after_qty`),`operator_username`=VALUES(`operator_username`),`operate_time`=VALUES(`operate_time`),`remark`=VALUES(`remark`),`update_time`=NOW();

-- ============================================================
-- 10. Started WIP/SN collection and completed approval trace.
-- ============================================================
INSERT INTO `sp_sn_process_record`
(`id`,`sn`,`order_id`,`order_code`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`step_no`,`status`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_sn_dpc_001_010','DPC202606140001','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'OK','首台主板装配完成',NOW(),'demo_op_01',NOW(),'demo_op_01'),
('demo_sn_dpc_001_020','DPC202606140001','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'OK','首台机箱装配完成',NOW(),'demo_op_02',NOW(),'demo_op_02'),
('demo_sn_dpc_001_030','DPC202606140001','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_final','DPC-OP-030','整机总装',30,'OK','首台整机总装完成',NOW(),'demo_op_02',NOW(),'demo_op_02'),
('demo_sn_dpc_001_040','DPC202606140001','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'OK','首台老化测试通过',NOW(),'demo_op_03',NOW(),'demo_op_03'),
('demo_sn_dpc_001_050','DPC202606140001','demo_wo_dpc','GD-DEMO-20260614-001','demo_flow_dpc_host','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'OK','首台包装完成，待批量完工入库',NOW(),'demo_wh_02',NOW(),'demo_wh_02')
ON DUPLICATE KEY UPDATE `sn`=VALUES(`sn`),`order_id`=VALUES(`order_id`),`order_code`=VALUES(`order_code`),`flow_id`=VALUES(`flow_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`step_no`=VALUES(`step_no`),`status`=VALUES(`status`),`remark`=VALUES(`remark`),`update_time`=NOW();

INSERT INTO `sp_workflow_instance`
(`id`,`definition_id`,`business_type`,`business_id`,`business_code`,`title`,`status`,`current_node_key`,`current_node_name`,`start_user_id`,`start_username`,`start_time`,`end_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wfi_dpc_approval','wf_def_order_approval_v1','ORDER_APPROVAL','demo_wo_dpc','GD-DEMO-20260614-001','生产订单审批-GD-DEMO-20260614-001','completed','end','审批完成','demo_user_plan_01','何计划','2026-06-14 08:40:00','2026-06-14 09:00:00','演示生产主管审批通过',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `definition_id`=VALUES(`definition_id`),`business_type`=VALUES(`business_type`),`business_id`=VALUES(`business_id`),`business_code`=VALUES(`business_code`),`title`=VALUES(`title`),`status`=VALUES(`status`),`current_node_key`=VALUES(`current_node_key`),`current_node_name`=VALUES(`current_node_name`),`start_user_id`=VALUES(`start_user_id`),`start_username`=VALUES(`start_username`),`start_time`=VALUES(`start_time`),`end_time`=VALUES(`end_time`),`remark`=VALUES(`remark`),`update_time`=NOW();

INSERT INTO `sp_workflow_task`
(`id`,`instance_id`,`definition_id`,`business_type`,`business_id`,`business_code`,`task_name`,`node_key`,`node_name`,`assignee_type`,`assignee_id`,`assignee_name`,`status`,`action`,`opinion`,`start_time`,`complete_time`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wft_dpc_approval','demo_wfi_dpc_approval','wf_def_order_approval_v1','ORDER_APPROVAL','demo_wo_dpc','GD-DEMO-20260614-001','生产订单审批','order_approve','生产订单审批','role','productionManagerRole','生产主管','done','approve','同意，按演示计划开工','2026-06-14 08:40:00','2026-06-14 09:00:00',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `instance_id`=VALUES(`instance_id`),`definition_id`=VALUES(`definition_id`),`business_type`=VALUES(`business_type`),`business_id`=VALUES(`business_id`),`business_code`=VALUES(`business_code`),`task_name`=VALUES(`task_name`),`node_key`=VALUES(`node_key`),`node_name`=VALUES(`node_name`),`assignee_type`=VALUES(`assignee_type`),`assignee_id`=VALUES(`assignee_id`),`assignee_name`=VALUES(`assignee_name`),`status`=VALUES(`status`),`action`=VALUES(`action`),`opinion`=VALUES(`opinion`),`start_time`=VALUES(`start_time`),`complete_time`=VALUES(`complete_time`),`update_time`=NOW();

INSERT INTO `sp_workflow_event_log`
(`id`,`definition_id`,`instance_id`,`task_id`,`event_type`,`action_code`,`result_status`,`result_msg`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wfel_dpc_order_approve','wf_def_order_approval_v1','demo_wfi_dpc_approval','demo_wft_dpc_approval','complete','ORDER_APPROVE','success','order status synced to approved',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `definition_id`=VALUES(`definition_id`),`instance_id`=VALUES(`instance_id`),`task_id`=VALUES(`task_id`),`event_type`=VALUES(`event_type`),`action_code`=VALUES(`action_code`),`result_status`=VALUES(`result_status`),`result_msg`=VALUES(`result_msg`),`update_time`=NOW();

-- ============================================================
-- 11. ASSIGNED-stage DPC order to fill the assign/release queues.
--   approval_status=APPROVED, operation_status=ASSIGNED, work order statue=2.
--   Equipment + staff are fully assigned and MRP net=0, so the order shows up on
--   设备派工 / 员工派工 / 生产计划下发 and can be dispatched in the UI.
-- ============================================================
INSERT INTO `sp_production_order`
(`id`,`order_no`,`source_type`,`customer_name`,`customer_group`,`external_no`,`sales_contract_no`,`business_type`,`order_date`,`settlement_currency`,`transport_mode`,`payment_terms`,`tax_rate`,`receiver_name`,`receiver_phone`,`receiver_address`,`remark`,`status`,`approval_status`,`operation_status`,`creation_method`,`scheduling_method`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_po_dpc_assign','DD-DEMO-20260614-003','DEMAND','演示客户-华南智联','华南大客户','EXT-DEMO-DPC-002','HT-DEMO-DPC-002','普通销售','2026-06-14','人民币','公路运输','月结30天','不含税','张采购','13866010003','广州市天河区演示路3号','完整制造流程：已审批、设备/员工派工完成，待生产计划下发（用于派工/下发演示）','CONFIRMED','APPROVED','ASSIGNED','MANUAL','REVERSE','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `customer_name`=VALUES(`customer_name`),`customer_group`=VALUES(`customer_group`),`external_no`=VALUES(`external_no`),`sales_contract_no`=VALUES(`sales_contract_no`),`business_type`=VALUES(`business_type`),`order_date`=VALUES(`order_date`),`remark`=VALUES(`remark`),`status`=VALUES(`status`),`approval_status`=VALUES(`approval_status`),`operation_status`=VALUES(`operation_status`),`creation_method`=VALUES(`creation_method`),`scheduling_method`=VALUES(`scheduling_method`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order`
(`id`,`order_code`,`order_description`,`qty`,`order_type`,`flow_id`,`materiel`,`materiel_desc`,`plan_start_time`,`plan_end_time`,`statue`,`designer_id`,`designer_name`,`approve_user_id`,`approve_username`,`approve_time`,`remark`,`work_status`,`work_start_time`,`complete_status`,`complete_time`,`complete_username`,`delivery_status`,`delivery_time`,`delivery_username`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wo_dpc_assign','GD-DEMO-20260614-002','DD-DEMO-20260614-003 / 台式电脑主机',10,'P','demo_flow_dpc_host','DPC_HOST','台式电脑主机','2026-06-20 08:00:00','2026-06-24 17:00:00',2,'demo_user_plan_02','许计划','demo_user_mgr_01','陈主管','2026-06-14 11:00:00','已审批通过，设备/员工派工完成，待生产计划下发','NOT_STARTED',NULL,'WAIT',NULL,NULL,'WAIT',NULL,NULL,NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_code`=VALUES(`order_code`),`order_description`=VALUES(`order_description`),`qty`=VALUES(`qty`),`order_type`=VALUES(`order_type`),`flow_id`=VALUES(`flow_id`),`materiel`=VALUES(`materiel`),`materiel_desc`=VALUES(`materiel_desc`),`plan_start_time`=VALUES(`plan_start_time`),`plan_end_time`=VALUES(`plan_end_time`),`statue`=VALUES(`statue`),`designer_id`=VALUES(`designer_id`),`designer_name`=VALUES(`designer_name`),`approve_user_id`=VALUES(`approve_user_id`),`approve_username`=VALUES(`approve_username`),`approve_time`=VALUES(`approve_time`),`remark`=VALUES(`remark`),`work_status`=VALUES(`work_status`),`complete_status`=VALUES(`complete_status`),`delivery_status`=VALUES(`delivery_status`),`update_time`=NOW();

INSERT INTO `sp_production_order_item`
(`id`,`order_id`,`product_materiel`,`product_name`,`bom_id`,`bom_code`,`bom_version`,`model`,`specification`,`qty`,`unit_price`,`configuration`,`plan_delivery_date`,`plan_start_date`,`lead_time_days`,`target_capacity`,`computed_start_date`,`computed_delivery_date`,`material_ready_date`,`adjust_note`,`work_order_id`,`work_order_code`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_poi_dpc_assign','demo_po_dpc_assign','DPC_HOST','台式电脑主机','demo_bom_dpc_host','BOM-DPC-HOST-V1','1','DPC-HOST-A','标准配置',10,3999.00,'i5/16G/512G/标准机箱','2026-06-24','2026-06-20',1,20.00,'2026-06-20','2026-06-24','2026-06-20',NULL,'demo_wo_dpc_assign','GD-DEMO-20260614-002',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`bom_id`=VALUES(`bom_id`),`bom_code`=VALUES(`bom_code`),`bom_version`=VALUES(`bom_version`),`model`=VALUES(`model`),`specification`=VALUES(`specification`),`qty`=VALUES(`qty`),`unit_price`=VALUES(`unit_price`),`configuration`=VALUES(`configuration`),`plan_delivery_date`=VALUES(`plan_delivery_date`),`plan_start_date`=VALUES(`plan_start_date`),`lead_time_days`=VALUES(`lead_time_days`),`target_capacity`=VALUES(`target_capacity`),`computed_start_date`=VALUES(`computed_start_date`),`computed_delivery_date`=VALUES(`computed_delivery_date`),`material_ready_date`=VALUES(`material_ready_date`),`work_order_id`=VALUES(`work_order_id`),`work_order_code`=VALUES(`work_order_code`),`update_time`=NOW();

INSERT INTO `sp_production_order_oper_plan`
(`id`,`order_id`,`order_item_id`,`order_no`,`product_materiel`,`product_name`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`plan_start_time`,`plan_end_time`,`duration_hours`,`duration_source`,`schedule_method`,`calc_remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_pop_assign_010','demo_po_dpc_assign','demo_poi_dpc_assign','DD-DEMO-20260614-003','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'demo_unit_board','2026-06-20 08:00:00','2026-06-20 12:00:00',4.00,'MANUAL','REVERSE','演示排产：主板单元','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_assign_020','demo_po_dpc_assign','demo_poi_dpc_assign','DD-DEMO-20260614-003','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'demo_unit_case','2026-06-20 13:00:00','2026-06-21 10:00:00',5.00,'MANUAL','REVERSE','演示排产：机箱单元','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_assign_030','demo_po_dpc_assign','demo_poi_dpc_assign','DD-DEMO-20260614-003','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_final','DPC-OP-030','整机总装',30,'demo_unit_final','2026-06-21 10:00:00','2026-06-22 12:00:00',10.00,'MANUAL','REVERSE','演示排产：整机总装','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_assign_040','demo_po_dpc_assign','demo_poi_dpc_assign','DD-DEMO-20260614-003','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'demo_unit_test','2026-06-22 13:00:00','2026-06-24 10:00:00',13.00,'MANUAL','REVERSE','演示排产：整机测试','0',NOW(),'admin',NOW(),'admin'),
('demo_pop_assign_050','demo_po_dpc_assign','demo_poi_dpc_assign','DD-DEMO-20260614-003','DPC_HOST','台式电脑主机','demo_flow_dpc_host','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'demo_unit_pack','2026-06-24 10:00:00','2026-06-24 17:00:00',7.00,'MANUAL','REVERSE','演示排产：包装入库','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_item_id`=VALUES(`order_item_id`),`order_no`=VALUES(`order_no`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`flow_id`=VALUES(`flow_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`plan_start_time`=VALUES(`plan_start_time`),`plan_end_time`=VALUES(`plan_end_time`),`duration_hours`=VALUES(`duration_hours`),`duration_source`=VALUES(`duration_source`),`schedule_method`=VALUES(`schedule_method`),`calc_remark`=VALUES(`calc_remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order_oper_equipment_assign`
(`id`,`order_id`,`order_code`,`production_order_id`,`order_item_id`,`oper_plan_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`equipment_id`,`equipment_code`,`equipment_name`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_ooea_assign_010','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_po_dpc_assign','demo_poi_dpc_assign','demo_pop_assign_010','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'demo_unit_board','demo_eq_smt','DEMO-EQ-001','桌面贴装工作站','ASSIGNED','主板单元设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_assign_020','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_po_dpc_assign','demo_poi_dpc_assign','demo_pop_assign_020','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'demo_unit_case','demo_eq_torque','DEMO-EQ-002','智能扭矩电批','ASSIGNED','机箱装配设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_assign_030','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_po_dpc_assign','demo_poi_dpc_assign','demo_pop_assign_030','demo_op_dpc_final','DPC-OP-030','整机总装',30,'demo_unit_final','demo_eq_torque','DEMO-EQ-002','智能扭矩电批','ASSIGNED','总装设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_assign_040','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_po_dpc_assign','demo_poi_dpc_assign','demo_pop_assign_040','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'demo_unit_test','demo_eq_burn','DEMO-EQ-003','整机老化测试架','ASSIGNED','测试设备已派工','0',NOW(),'admin',NOW(),'admin'),
('demo_ooea_assign_050','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_po_dpc_assign','demo_poi_dpc_assign','demo_pop_assign_050','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'demo_unit_pack','demo_eq_pack','DEMO-EQ-004','自动贴标包装台','ASSIGNED','包装设备已派工','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_code`=VALUES(`order_code`),`production_order_id`=VALUES(`production_order_id`),`order_item_id`=VALUES(`order_item_id`),`oper_plan_id`=VALUES(`oper_plan_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`equipment_id`=VALUES(`equipment_id`),`equipment_code`=VALUES(`equipment_code`),`equipment_name`=VALUES(`equipment_name`),`status`=VALUES(`status`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_order_oper_assign`
(`id`,`order_id`,`order_code`,`flow_id`,`oper_id`,`oper`,`oper_desc`,`sort_num`,`unit_id`,`team_id`,`user_id`,`user_name`,`status`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_ooa_assign_010','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_flow_dpc_host','demo_op_dpc_board','DPC-OP-010','主板单元装配',10,'demo_unit_board','demo_team_board','demo_user_op_01','王装配','1','主板装配已派工待下发','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_assign_020','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_flow_dpc_host','demo_op_dpc_case','DPC-OP-020','机箱单元装配',20,'demo_unit_case','demo_team_final','demo_user_op_02','李总装','1','机箱装配已派工待下发','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_assign_030','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_flow_dpc_host','demo_op_dpc_final','DPC-OP-030','整机总装',30,'demo_unit_final','demo_team_final','demo_user_op_02','李总装','1','整机总装已派工待下发','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_assign_040','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_flow_dpc_host','demo_op_dpc_test','DPC-OP-040','整机老化测试',40,'demo_unit_test','demo_team_final','demo_user_op_03','刘测试','1','整机测试已派工待下发','0',NOW(),'admin',NOW(),'admin'),
('demo_ooa_assign_050','demo_wo_dpc_assign','GD-DEMO-20260614-002','demo_flow_dpc_host','demo_op_dpc_pack','DPC-OP-050','包装入库',50,'demo_unit_pack','demo_team_wh','demo_user_wh_02','郑仓储','1','包装入库已派工待下发','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `order_id`=VALUES(`order_id`),`order_code`=VALUES(`order_code`),`flow_id`=VALUES(`flow_id`),`oper_id`=VALUES(`oper_id`),`oper`=VALUES(`oper`),`oper_desc`=VALUES(`oper_desc`),`sort_num`=VALUES(`sort_num`),`unit_id`=VALUES(`unit_id`),`team_id`=VALUES(`team_id`),`user_id`=VALUES(`user_id`),`user_name`=VALUES(`user_name`),`status`=VALUES(`status`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_material_requirement_plan`
(`id`,`production_order_id`,`production_order_no`,`order_item_id`,`product_serial_no`,`product_materiel`,`product_name`,`material_id`,`material_code`,`material_name`,`material_type`,`material_source`,`unit`,`bom_level`,`bom_path`,`gross_requirement`,`available_stock`,`safety_stock`,`net_requirement`,`requirement_date`,`lead_time_days`,`release_date`,`delivery_status`,`inbound_status`,`inbound_request_id`,`inbound_request_no`,`outbound_status`,`outbound_request_id`,`outbound_request_no`,`calc_batch_no`,`calc_time`,`remark`,`is_deleted`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_mrp_assign_pcb','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_pcb','DPC_PCB','台式电脑主板PCB','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_PCB',10.00,100.00,20.00,0.00,'2026-06-20',2,'2026-06-18','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_assign_cpu','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_cpu','DPC_CPU','台式电脑CPU','PART','OUT','颗',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_CPU',10.00,100.00,20.00,0.00,'2026-06-20',3,'2026-06-17','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_assign_ram','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_ram','DPC_MEMORY','台式电脑内存条','PART','OUT','条',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_MEMORY',10.00,100.00,20.00,0.00,'2026-06-20',2,'2026-06-18','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_assign_ssd','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_ssd','DPC_SSD','台式电脑固态硬盘','PART','OUT','块',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_MAINBOARD_UNIT>DPC_SSD',10.00,100.00,20.00,0.00,'2026-06-20',2,'2026-06-18','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_assign_power','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_power','DPC_POWER_SUPPLY','台式电脑电源','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_CASE_UNIT>DPC_POWER_SUPPLY',10.00,100.00,10.00,0.00,'2026-06-20',2,'2026-06-18','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_assign_shell','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_case_shell','DPC_CASE_SHELL','台式电脑机箱外壳','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_CASE_UNIT>DPC_CASE_SHELL',10.00,100.00,10.00,0.00,'2026-06-20',2,'2026-06-18','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin'),
('demo_mrp_assign_fan','demo_po_dpc_assign','DD-DEMO-20260614-003','demo_poi_dpc_assign','DD-DEMO-20260614-003-SN001','DPC_HOST','台式电脑主机','demo_mat_fan','DPC_COOLING_FAN','台式电脑散热风扇','PART','OUT','件',2,'BOM-DPC-HOST-V1>DPC_HOST_HALF>DPC_CASE_UNIT>DPC_COOLING_FAN',10.00,100.00,10.00,0.00,'2026-06-20',2,'2026-06-18','RELEASED','NONE',NULL,NULL,'NONE',NULL,NULL,'MRP-DEMO-DPC2-20260614','2026-06-14 11:20:00','库存充足，净需求为0','0',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `production_order_id`=VALUES(`production_order_id`),`production_order_no`=VALUES(`production_order_no`),`order_item_id`=VALUES(`order_item_id`),`product_serial_no`=VALUES(`product_serial_no`),`product_materiel`=VALUES(`product_materiel`),`product_name`=VALUES(`product_name`),`material_id`=VALUES(`material_id`),`material_code`=VALUES(`material_code`),`material_name`=VALUES(`material_name`),`material_type`=VALUES(`material_type`),`material_source`=VALUES(`material_source`),`unit`=VALUES(`unit`),`bom_level`=VALUES(`bom_level`),`bom_path`=VALUES(`bom_path`),`gross_requirement`=VALUES(`gross_requirement`),`available_stock`=VALUES(`available_stock`),`safety_stock`=VALUES(`safety_stock`),`net_requirement`=VALUES(`net_requirement`),`requirement_date`=VALUES(`requirement_date`),`lead_time_days`=VALUES(`lead_time_days`),`release_date`=VALUES(`release_date`),`delivery_status`=VALUES(`delivery_status`),`inbound_status`=VALUES(`inbound_status`),`outbound_status`=VALUES(`outbound_status`),`calc_batch_no`=VALUES(`calc_batch_no`),`calc_time`=VALUES(`calc_time`),`remark`=VALUES(`remark`),`is_deleted`=VALUES(`is_deleted`),`update_time`=NOW();

INSERT INTO `sp_workflow_instance`
(`id`,`definition_id`,`business_type`,`business_id`,`business_code`,`title`,`status`,`current_node_key`,`current_node_name`,`start_user_id`,`start_username`,`start_time`,`end_time`,`remark`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wfi_assign_approval','wf_def_order_approval_v1','ORDER_APPROVAL','demo_wo_dpc_assign','GD-DEMO-20260614-002','生产订单审批-GD-DEMO-20260614-002','completed','end','审批完成','demo_user_plan_02','许计划','2026-06-14 10:40:00','2026-06-14 11:00:00','演示生产主管审批通过',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `definition_id`=VALUES(`definition_id`),`business_type`=VALUES(`business_type`),`business_id`=VALUES(`business_id`),`business_code`=VALUES(`business_code`),`title`=VALUES(`title`),`status`=VALUES(`status`),`current_node_key`=VALUES(`current_node_key`),`current_node_name`=VALUES(`current_node_name`),`start_user_id`=VALUES(`start_user_id`),`start_username`=VALUES(`start_username`),`start_time`=VALUES(`start_time`),`end_time`=VALUES(`end_time`),`remark`=VALUES(`remark`),`update_time`=NOW();

INSERT INTO `sp_workflow_task`
(`id`,`instance_id`,`definition_id`,`business_type`,`business_id`,`business_code`,`task_name`,`node_key`,`node_name`,`assignee_type`,`assignee_id`,`assignee_name`,`status`,`action`,`opinion`,`start_time`,`complete_time`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wft_assign_approval','demo_wfi_assign_approval','wf_def_order_approval_v1','ORDER_APPROVAL','demo_wo_dpc_assign','GD-DEMO-20260614-002','生产订单审批','order_approve','生产订单审批','role','productionManagerRole','生产主管','done','approve','同意，按演示计划派工','2026-06-14 10:40:00','2026-06-14 11:00:00',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `instance_id`=VALUES(`instance_id`),`definition_id`=VALUES(`definition_id`),`business_type`=VALUES(`business_type`),`business_id`=VALUES(`business_id`),`business_code`=VALUES(`business_code`),`task_name`=VALUES(`task_name`),`node_key`=VALUES(`node_key`),`node_name`=VALUES(`node_name`),`assignee_type`=VALUES(`assignee_type`),`assignee_id`=VALUES(`assignee_id`),`assignee_name`=VALUES(`assignee_name`),`status`=VALUES(`status`),`action`=VALUES(`action`),`opinion`=VALUES(`opinion`),`start_time`=VALUES(`start_time`),`complete_time`=VALUES(`complete_time`),`update_time`=NOW();

INSERT INTO `sp_workflow_event_log`
(`id`,`definition_id`,`instance_id`,`task_id`,`event_type`,`action_code`,`result_status`,`result_msg`,`create_time`,`create_username`,`update_time`,`update_username`) VALUES
('demo_wfel_assign_order_approve','wf_def_order_approval_v1','demo_wfi_assign_approval','demo_wft_assign_approval','complete','ORDER_APPROVE','success','order status synced to approved',NOW(),'admin',NOW(),'admin')
ON DUPLICATE KEY UPDATE `definition_id`=VALUES(`definition_id`),`instance_id`=VALUES(`instance_id`),`task_id`=VALUES(`task_id`),`event_type`=VALUES(`event_type`),`action_code`=VALUES(`action_code`),`result_status`=VALUES(`result_status`),`result_msg`=VALUES(`result_msg`),`update_time`=NOW();

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- Post-run verification queries.
-- Expected:
--   locked_dpc_bom_count = 4
--   bad_dpc_route_count = 0
--   completed_dpc_work_order_count = 1
--   dpc_sn_record_count >= 4
--   dpc_approval_event_log_count = 1
--   dpc_fg_in_transaction_count = 1
--   dpc_finished_goods_qty = 20.0000
--   dpc_gross_kitting_qty_match = 1
--   draft_iot_bom_count = 3
--   iot_work_order_link_count = 0
--   iot_execution_data_count = 0
--   demo_user_count = 12
--   users_without_role_count = 0
--   assign_stage_ready_count = 1   (APPROVED + ASSIGNED, work order statue=2)
--   assign_stage_full_assign_count = 5  (every oper plan has equipment + staff)
--   assign_stage_mrp_blocking_count = 0  (no net>0 row missing CONFIRMED outbound)
-- ============================================================
SELECT COUNT(*) AS locked_dpc_bom_count
FROM `sp_bom`
WHERE `id` IN ('demo_bom_dpc_host','demo_bom_dpc_half','demo_bom_dpc_board','demo_bom_dpc_case')
  AND `lock_status`='locked' AND `state`='pass' AND `validity`='有效';

SELECT COUNT(*) AS bad_dpc_route_count
FROM `sp_process_route`
WHERE `id` LIKE 'demo_route_dpc\_%'
  AND (`lock_status`<>'locked' OR `edit_status`<>'completed' OR `oper_id` IS NULL OR `oper_id`='');

SELECT COUNT(*) AS completed_dpc_work_order_count
FROM `sp_order`
WHERE `id`='demo_wo_dpc'
  AND `statue`=5
  AND `work_status`='STARTED'
  AND `complete_status`='COMPLETED'
  AND `delivery_status`='DELIVERED';

SELECT COUNT(*) AS dpc_sn_record_count
FROM `sp_sn_process_record`
WHERE `order_id`='demo_wo_dpc';

SELECT COUNT(*) AS dpc_approval_event_log_count
FROM `sp_workflow_event_log`
WHERE `id`='demo_wfel_dpc_order_approve'
  AND `instance_id`='demo_wfi_dpc_approval'
  AND `task_id`='demo_wft_dpc_approval'
  AND `action_code`='ORDER_APPROVE'
  AND `result_status`='success';

SELECT COUNT(*) AS dpc_fg_in_transaction_count
FROM `sp_warehouse_transaction`
WHERE `id`='demo_wtx_dpc_fg_in'
  AND `direction`='IN'
  AND `business_type`='MANUAL_IN'
  AND `qty`=20.0000
  AND `before_qty`=0.0000
  AND `after_qty`=20.0000;

SELECT `qty` AS dpc_finished_goods_qty
FROM `sp_inventory`
WHERE `id`='demo_inv_dpc_finished';

SELECT CASE
  WHEN
    (SELECT COALESCE(SUM(`request_qty`),0) FROM `sp_warehouse_request_item` WHERE `request_id`='demo_wr_kit_dpc')
    =
    (SELECT COALESCE(SUM(`gross_requirement`),0) FROM `sp_material_requirement_plan` WHERE `production_order_id`='demo_po_dpc')
  THEN 1 ELSE 0 END AS dpc_gross_kitting_qty_match;

SELECT COUNT(*) AS draft_iot_bom_count
FROM `sp_bom`
WHERE `id` IN ('demo_bom_iot_terminal','demo_bom_iot_control','demo_bom_iot_shell')
  AND `lock_status`='draft' AND `state`='creat' AND `validity`='未生效';

SELECT COUNT(*) AS iot_work_order_link_count
FROM `sp_production_order_item`
WHERE `id`='demo_poi_iot' AND (`work_order_id` IS NOT NULL OR `work_order_code` IS NOT NULL);

SELECT
  (SELECT COUNT(*) FROM `sp_order` WHERE `id` LIKE 'demo\_%' AND `materiel`='IOT_TERMINAL') +
  (SELECT COUNT(*) FROM `sp_material_requirement_plan` WHERE `production_order_id`='demo_po_iot') +
  (SELECT COUNT(*) FROM `sp_sn_process_record` WHERE `order_id` LIKE 'demo_iot\_%') AS iot_execution_data_count;

SELECT COUNT(*) AS demo_user_count
FROM `sp_sys_user`
WHERE `id` LIKE 'demo_user\_%';

SELECT COUNT(*) AS users_without_role_count
FROM `sp_sys_user` u
WHERE u.`id` LIKE 'demo_user\_%'
  AND NOT EXISTS (SELECT 1 FROM `sp_sys_user_role` ur WHERE ur.`user_id`=u.`id`);

-- The ASSIGNED-stage order must be APPROVED + ASSIGNED and its work order approved (statue>=2)
-- so it shows on 设备派工 / 员工派工 / 生产计划下发.
SELECT COUNT(*) AS assign_stage_ready_count
FROM `sp_production_order` po
JOIN `sp_order` wo ON wo.`id`='demo_wo_dpc_assign'
WHERE po.`id`='demo_po_dpc_assign'
  AND po.`approval_status`='APPROVED'
  AND po.`operation_status`='ASSIGNED'
  AND wo.`statue`>=2;

-- Every operation plan of the ASSIGNED order has both equipment and staff assigned.
SELECT COUNT(*) AS assign_stage_full_assign_count
FROM `sp_production_order_oper_plan` p
WHERE p.`order_id`='demo_po_dpc_assign'
  AND p.`is_deleted`='0'
  AND EXISTS (SELECT 1 FROM `sp_order_oper_equipment_assign` e
              WHERE e.`oper_plan_id`=p.`id` AND e.`is_deleted`='0' AND e.`equipment_id`<>'')
  AND EXISTS (SELECT 1 FROM `sp_order_oper_assign` a
              WHERE a.`order_id`='demo_wo_dpc_assign' AND a.`oper_id`=p.`oper_id`
                AND a.`is_deleted`='0' AND a.`user_id`<>'');

-- No MRP row blocks dispatch (net>0 without a CONFIRMED outbound).
SELECT COUNT(*) AS assign_stage_mrp_blocking_count
FROM `sp_material_requirement_plan`
WHERE `production_order_id`='demo_po_dpc_assign'
  AND `is_deleted`='0'
  AND `net_requirement`>0
  AND `outbound_status`<>'CONFIRMED';


-- ============================================================
-- 安装结束
-- ============================================================
SET FOREIGN_KEY_CHECKS = 1;
