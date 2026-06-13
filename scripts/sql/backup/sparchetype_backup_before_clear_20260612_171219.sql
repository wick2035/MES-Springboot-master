-- MySQL dump 10.13  Distrib 9.4.0, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: sparchetype
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `sparchetype`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sparchetype` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sparchetype`;

--
-- Table structure for table `sp_bom`
--

DROP TABLE IF EXISTS `sp_bom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_bom` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `bom_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'bom编号',
  `materiel_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '物料ID',
  `materiel_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '物料描述',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '备注',
  `version_number` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '版本号',
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'BOM状态 creat创建 pass审核通过 ',
  `factory` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '工厂',
  `bom_level` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'BOM层级: 0=成品BOM 1=半成品BOM 2=组件BOM',
  `lock_status` varchar(10) NOT NULL DEFAULT 'draft' COMMENT '定版标识: draft=草稿 locked=已定版',
  `validity` varchar(10) NOT NULL DEFAULT '有效' COMMENT '有效性: 有效/无效',
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='BOM主信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_bom`
--

LOCK TABLES `sp_bom` WRITE;
/*!40000 ALTER TABLE `sp_bom` DISABLE KEYS */;
INSERT INTO `sp_bom` VALUES ('1268447170115383298','bbbbb','t002','t002','','1',NULL,NULL,0,'draft','有效','0','2020-06-04 15:39:07','admin','2020-07-16 11:17:20','admin'),('1268811409925582850','0001','2019001','电子元件','','1',NULL,NULL,0,'draft','有效','0','2020-06-05 15:46:28','admin','2020-07-16 13:30:08','admin'),('1270189758686146562','测试','123','123','','1',NULL,NULL,0,'draft','有效','0','2020-06-09 11:03:32','admin','2020-07-04 15:32:47','admin'),('1272019534564536322','打算','123','123','','1',NULL,NULL,0,'draft','有效','2','2020-06-14 12:14:25','admin','2020-07-09 15:10:38','admin'),('1272783744282112002','阿斯顿发送到','t002','t002','','1',NULL,NULL,0,'draft','有效','0','2020-06-16 14:51:06','admin','2020-06-16 14:51:06','admin'),('1276415594372247554','77','123','123','','1',NULL,NULL,0,'draft','有效','0','2020-06-26 15:22:47','admin','2020-07-08 15:30:46','admin'),('1276535719725346818','001','123','123','','1',NULL,NULL,0,'draft','有效','0','2020-06-26 23:20:07','admin','2020-06-26 23:20:07','admin'),('1277125952237973506','A0001','t002','t002','','1',NULL,NULL,0,'draft','有效','0','2020-06-28 14:25:30','admin','2020-06-28 14:25:30','admin'),('1277599659653836802','Y001','Y001','Y001','','1',NULL,NULL,0,'draft','有效','0','2020-06-29 21:47:50','admin','2020-06-29 21:47:50','admin'),('1278528374608998401','dc001','Y001','Y001','','1',NULL,NULL,0,'draft','有效','0','2020-07-02 11:18:13','admin','2020-07-02 11:18:13','admin'),('1280124062753075202','11111','002-2918','曲轴','11111','1',NULL,NULL,0,'draft','有效','0','2020-07-06 20:58:55','admin','2020-07-06 20:58:55','admin'),('1281490436289179649','001','002-2918','曲轴','','1',NULL,NULL,0,'draft','有效','0','2020-07-10 15:28:24','admin','2020-07-10 15:28:24','admin'),('1283634934423203842','333','2019001','电子元件','','1',NULL,NULL,0,'draft','有效','0','2020-07-16 13:29:52','admin','2020-07-16 13:29:52','admin'),('2063155876606779394','1111','000001','成品测试','','1','creat',NULL,0,'draft','有效','0','2026-06-06 15:07:47','admin','2026-06-06 15:07:47','admin'),('2063163796086071298','111','000001','成品测试','','1','creat',NULL,0,'draft','有效','2','2026-06-06 15:39:15','admin','2026-06-06 15:39:35','admin'),('2063164632233156609','1233','000001','成品测试','','2','creat',NULL,0,'draft','有效','0','2026-06-06 15:42:35','admin','2026-06-06 15:42:35','admin'),('2063198631693393922','1','000001','成品测试','','1','creat',NULL,0,'draft','有效','0','2026-06-06 17:57:41','admin','2026-06-06 17:58:06','admin'),('2063207792384679938','BOM-MB_001','BOM000005','主板单元','','1','pass',NULL,2,'locked','有效','0','2026-06-06 18:34:05','admin','2026-06-06 18:50:50','admin'),('2063212544791158785','BOM000006','BOM000006','机箱单元','','1','pass',NULL,2,'locked','有效','0','2026-06-06 18:52:58','admin','2026-06-06 18:53:10','admin'),('2063213856354213890','BOM-MB-001','BOM000013','主板单元','','1','pass',NULL,2,'locked','有效','0','2026-06-06 18:58:11','admin','2026-06-06 18:58:18','admin'),('2063214043659247618','BOM-CASE-001','BOM000016','机箱单元','','1','pass',NULL,2,'locked','有效','0','2026-06-06 18:58:55','admin','2026-06-06 18:58:58','admin'),('2063219924794875906','BOM-HALF-001','BOM000015','台式电脑主机半成品','','1','pass',NULL,1,'locked','有效','0','2026-06-06 19:22:18','admin','2026-06-06 19:22:27','admin'),('2063220298813546498','BOM-PC-001','M000006','台式电脑主机','','1','pass',NULL,0,'locked','有效','0','2026-06-06 19:23:47','admin','2026-06-06 19:23:52','admin'),('2063236321256247298','BOM000021','BOM000021','盖子','','1','pass',NULL,2,'locked','有效','0','2026-06-06 20:27:27','admin','2026-06-06 20:28:07','admin'),('2063236581701554178','BOM000022','BOM000022','底座','','1','pass',NULL,2,'locked','有效','0','2026-06-06 20:28:29','admin','2026-06-06 20:28:34','admin'),('2063236716397432833','BOM000023','BOM000023','半成品杯子','','1','pass',NULL,1,'locked','有效','0','2026-06-06 20:29:01','admin','2026-06-06 20:29:10','admin'),('2063237203217715201','BOM-0001','M000009','杯子','','1','pass',NULL,0,'locked','有效','0','2026-06-06 20:30:57','admin','2026-06-06 20:31:00','admin'),('2063889661587709954','BOM000022222','BOM000021','盖子','','1','creat',NULL,2,'draft','有效','1','2026-06-08 15:43:35','admin','2026-06-08 19:05:01','admin');
/*!40000 ALTER TABLE `sp_bom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_bom_item`
--

DROP TABLE IF EXISTS `sp_bom_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_bom_item` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `bom_head_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'bom编号',
  `materiel_item_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料ID',
  `materiel_item_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料描述',
  `line_no` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '行号',
  `item_num` decimal(10,0) DEFAULT '0' COMMENT '用量',
  `item_unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '子项基本单位',
  `oper_typer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '所属工序类型',
  `child_bom_id` varchar(64) DEFAULT NULL COMMENT '子BOM ID (当子项是组件/半成品时关联sp_bom.id)',
  `item_mat_type` varchar(10) DEFAULT NULL COMMENT '子项物料类型 FG/PG/COMP/PART',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_bom_item_child_bom_id` (`child_bom_id`),
  KEY `idx_bom_item_bom_head_id` (`bom_head_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='BOM子项表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_bom_item`
--

LOCK TABLES `sp_bom_item` WRITE;
/*!40000 ALTER TABLE `sp_bom_item` DISABLE KEYS */;
INSERT INTO `sp_bom_item` VALUES ('2063211977561874433','2063207792384679938','M000001','主板电路版','1',1,'个','',NULL,'FG','2026-06-06 18:50:43','admin','2026-06-06 18:50:43','admin'),('2063211977603817474','2063207792384679938','M000003','内存条','2',1,'个','',NULL,'FG','2026-06-06 18:50:43','admin','2026-06-06 18:50:43','admin'),('2063211977616400386','2063207792384679938','M000002','CPU','3',1,'个','',NULL,'FG','2026-06-06 18:50:43','admin','2026-06-06 18:50:43','admin'),('2063212544812130306','2063212544791158785','M000004','电源','1',1,'个','',NULL,'FG','2026-06-06 18:52:58','admin','2026-06-06 18:52:58','admin'),('2063212544824713218','2063212544791158785','M000005','机箱','2',1,'个','',NULL,'FG','2026-06-06 18:52:58','admin','2026-06-06 18:52:58','admin'),('2063213856446488577','2063213856354213890','M000001','主板电路版','1',1,'个','',NULL,'FG','2026-06-06 18:58:11','admin','2026-06-06 18:58:11','admin'),('2063213856471654402','2063213856354213890','M000002','CPU','2',1,'个','',NULL,'FG','2026-06-06 18:58:11','admin','2026-06-06 18:58:11','admin'),('2063213856484237313','2063213856354213890','M000003','内存条','3',1,'个','',NULL,'FG','2026-06-06 18:58:11','admin','2026-06-06 18:58:11','admin'),('2063214043688607745','2063214043659247618','M000004','电源','1',1,'个','',NULL,'FG','2026-06-06 18:58:55','admin','2026-06-06 18:58:55','admin'),('2063214043692802050','2063214043659247618','M000005','机箱','2',1,'个','',NULL,'FG','2026-06-06 18:58:55','admin','2026-06-06 18:58:55','admin'),('2063219924857790465','2063219924794875906','BOM000016','机箱单元','1',1,'个','','2063214043659247618','COMP','2026-06-06 19:22:18','admin','2026-06-06 19:22:18','admin'),('2063219924857790466','2063219924794875906','BOM000013','主板单元','2',1,'个','','2063213856354213890','COMP','2026-06-06 19:22:18','admin','2026-06-06 19:22:18','admin'),('2063220298876461058','2063220298813546498','BOM000015','台式电脑主机半成品','1',1,'个','','2063219924794875906','PG','2026-06-06 19:23:47','admin','2026-06-06 19:23:47','admin'),('2063236321319161858','2063236321256247298','M000007','贴纸','1',1,'个','',NULL,'FG','2026-06-06 20:27:27','admin','2026-06-06 20:27:27','admin'),('2063236581701554179','2063236581701554178','M000008','防热垫','1',1,'个','',NULL,'FG','2026-06-06 20:28:29','admin','2026-06-06 20:28:29','admin'),('2063236716464541698','2063236716397432833','BOM000021','盖子','1',1,'个','','2063236321256247298','COMP','2026-06-06 20:29:01','admin','2026-06-06 20:29:01','admin'),('2063236716464541699','2063236716397432833','BOM000022','底座','2',1,'个','','2063236581701554178','COMP','2026-06-06 20:29:01','admin','2026-06-06 20:29:01','admin'),('2063237203217715202','2063237203217715201','BOM000023','半成品杯子','1',1,'个','','2063236716397432833','PG','2026-06-06 20:30:57','admin','2026-06-06 20:30:57','admin'),('2063889661587709955','2063889661587709954','M000008','防热垫','1',1,'','',NULL,'FG','2026-06-08 15:43:35','admin','2026-06-08 15:43:35','admin'),('2063889661650624514','2063889661587709954','M000003','内存条','2',1,'','',NULL,'PART','2026-06-08 15:43:35','admin','2026-06-08 15:43:35','admin');
/*!40000 ALTER TABLE `sp_bom_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_component_def`
--

DROP TABLE IF EXISTS `sp_component_def`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_component_def` (
  `id` varchar(64) NOT NULL COMMENT '??ID',
  `product_name` varchar(128) NOT NULL COMMENT '??????????',
  `component_code` varchar(32) NOT NULL COMMENT '????? BOM000001',
  `component_name` varchar(128) NOT NULL COMMENT '?????',
  `component_type` varchar(16) NOT NULL DEFAULT 'COMP' COMMENT '????? PG=??? COMP=??',
  `remark` varchar(500) DEFAULT NULL COMMENT '????',
  `is_deleted` char(1) NOT NULL DEFAULT '0' COMMENT '?? 0?? 1?? 2??',
  `create_time` datetime NOT NULL COMMENT '????',
  `create_username` varchar(64) NOT NULL COMMENT '???',
  `update_time` datetime NOT NULL COMMENT '??????',
  `update_username` varchar(64) NOT NULL COMMENT '?????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_component_code` (`component_code`),
  KEY `idx_component_product` (`product_name`),
  KEY `idx_component_product_name` (`product_name`,`component_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='???????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_component_def`
--

LOCK TABLES `sp_component_def` WRITE;
/*!40000 ALTER TABLE `sp_component_def` DISABLE KEYS */;
INSERT INTO `sp_component_def` VALUES ('2063135799379505154','1111','BOM000001','111','COMP','2122','0','2026-06-06 13:48:00','admin','2026-06-06 13:48:00','admin'),('2063143554978951169','1111','BOM000002','1111','COMP','','0','2026-06-06 14:18:50','admin','2026-06-06 14:20:07','admin'),('2063144638334119937','12345','BOM000003','12345','COMP','','0','2026-06-06 14:23:08','admin','2026-06-06 14:23:08','admin'),('2063144665295106050','3124341334','BOM000004','31231242','COMP','','0','2026-06-06 14:23:14','admin','2026-06-06 14:23:14','admin'),('2063144958040748034','成品测试','BOM000005','主板单元','COMP','','0','2026-06-06 14:24:24','admin','2026-06-06 14:24:24','admin'),('2063145033357864961','成品测试','BOM000006','机箱单元','COMP','','0','2026-06-06 14:24:42','admin','2026-06-06 14:24:42','admin'),('2063146292538257409','成品测试','BOM000007','11111','COMP','','0','2026-06-06 14:29:42','admin','2026-06-06 14:29:42','admin'),('2063146628661391362','成品测试','BOM000008','1111','COMP','','0','2026-06-06 14:31:02','admin','2026-06-06 14:40:01','admin'),('2063162483151478786','成品测试','BOM000009','12324','COMP','','0','2026-06-06 15:34:02','admin','2026-06-06 15:34:02','admin'),('2063192330871513089','台式电脑主机半成品','BOM000010','台式电脑主机半成品','PG','','1','2026-06-06 17:32:39','admin','2026-06-06 18:55:44','admin'),('2063192397577723905','主板单元','BOM000011','主板单元','COMP','','1','2026-06-06 17:32:55','admin','2026-06-06 18:55:35','admin'),('2063192440279932929','机箱单元','BOM000012','机箱单元','COMP','','1','2026-06-06 17:33:05','admin','2026-06-06 18:55:33','admin'),('2063197348085374978','台式电脑主机','BOM000013','主板单元','COMP','','0','2026-06-06 17:52:35','admin','2026-06-06 18:21:15','admin'),('2063197412610547713','11','BOM000014','1','COMP','','1','2026-06-06 17:52:50','admin','2026-06-06 18:55:17','admin'),('2063199251808657410','台式电脑主机','BOM000015','台式电脑主机半成品','PG','','0','2026-06-06 18:00:09','admin','2026-06-06 18:00:09','admin'),('2063205465657450497','台式电脑主机','BOM000016','机箱单元','COMP','','0','2026-06-06 18:24:50','admin','2026-06-06 18:24:50','admin'),('2063207309947445250','台式电脑主机','BOM000017','主板电路板','COMP','','1','2026-06-06 18:32:10','admin','2026-06-06 18:55:29','admin'),('2063207356076400642','台式电脑主机','BOM000018','CPU','COMP','','1','2026-06-06 18:32:21','admin','2026-06-06 18:55:26','admin'),('2063207405103620097','台式电脑主机','BOM000019','内存条','COMP','','1','2026-06-06 18:32:33','admin','2026-06-06 18:55:24','admin'),('2063208327640784897','主板单元','BOM000020','CPU','COMP','','1','2026-06-06 18:36:13','admin','2026-06-06 18:55:10','admin'),('2063234599913885698','杯子','BOM000021','盖子','COMP','','0','2026-06-06 20:20:36','admin','2026-06-06 20:20:36','admin'),('2063234666733342722','杯子','BOM000022','底座','COMP','','0','2026-06-06 20:20:52','admin','2026-06-06 20:20:52','admin'),('2063234807980724225','杯子','BOM000023','半成品杯子','PG','','0','2026-06-06 20:21:26','admin','2026-06-06 20:21:26','admin');
/*!40000 ALTER TABLE `sp_component_def` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_equipment`
--

DROP TABLE IF EXISTS `sp_equipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_equipment` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `equipment_code` varchar(32) NOT NULL COMMENT '设备编号 EQ000001',
  `equipment_name` varchar(128) NOT NULL COMMENT '设备名称',
  `equipment_model` varchar(128) DEFAULT NULL COMMENT '设备规格/型号',
  `purpose` varchar(255) DEFAULT NULL COMMENT '设备用途',
  `spec` varchar(255) DEFAULT NULL COMMENT '设定条件',
  `status` char(1) NOT NULL DEFAULT '1' COMMENT '状态 1启用 0停用',
  `is_deleted` char(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_equipment_code` (`equipment_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='设备主数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_equipment`
--

LOCK TABLES `sp_equipment` WRITE;
/*!40000 ALTER TABLE `sp_equipment` DISABLE KEYS */;
INSERT INTO `sp_equipment` VALUES ('eq_001','EQ000001','吊车','123','物料搬运','','1','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('eq_002','EQ000002','主板测试夹具','GJ-PCB-01','主板安装与测试的夹具','','1','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('eq_003','EQ000003','瓶体夹具','','瓶体加工夹具','','1','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('eq_004','EQ000004','手指套','','装配防护','防静电','1','0','2026-06-06 12:31:50','admin','2026-06-08 18:55:41','admin'),('eq_005','EQ000005','静电环','OWS20A','装配防静电','','1','0','2026-06-06 12:31:50','admin','2026-06-08 18:55:43','admin');
/*!40000 ALTER TABLE `sp_equipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_equipment_group`
--

DROP TABLE IF EXISTS `sp_equipment_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_equipment_group` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='设备编组表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_equipment_group`
--

LOCK TABLES `sp_equipment_group` WRITE;
/*!40000 ALTER TABLE `sp_equipment_group` DISABLE KEYS */;
INSERT INTO `sp_equipment_group` VALUES ('2063879217309376513','C-01','1','11111','','0','2026-06-08 15:02:05','admin','2026-06-08 15:06:51','admin'),('2063880469011324929','C-02','2','222','','0','2026-06-08 15:07:04','admin','2026-06-08 16:40:52','admin');
/*!40000 ALTER TABLE `sp_equipment_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_equipment_group_device`
--

DROP TABLE IF EXISTS `sp_equipment_group_device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_equipment_group_device` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='编组设备关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_equipment_group_device`
--

LOCK TABLES `sp_equipment_group_device` WRITE;
/*!40000 ALTER TABLE `sp_equipment_group_device` DISABLE KEYS */;
INSERT INTO `sp_equipment_group_device` VALUES ('2063879637402476546','2063879217309376513','eq_001',NULL,'0','2026-06-08 15:03:45','admin','2026-06-08 15:03:45','admin'),('2063879859859972098','2063879217309376513','eq_002',NULL,'0','2026-06-08 15:04:38','admin','2026-06-08 15:04:38','admin'),('2063880499340337154','2063880469011324929','eq_004',NULL,'0','2026-06-08 15:07:11','admin','2026-06-08 15:07:11','admin'),('2063880499340337155','2063880469011324929','eq_005',NULL,'0','2026-06-08 15:07:11','admin','2026-06-08 15:07:11','admin'),('2063937720155758593','2063879217309376513','eq_003',NULL,'0','2026-06-08 18:54:33','admin','2026-06-08 18:54:33','admin'),('2063937751663370242','2063880469011324929','eq_001',NULL,'0','2026-06-08 18:54:41','admin','2026-06-08 18:54:41','admin'),('2063937751717896193','2063880469011324929','eq_002',NULL,'0','2026-06-08 18:54:41','admin','2026-06-08 18:54:41','admin');
/*!40000 ALTER TABLE `sp_equipment_group_device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_factroy`
--

DROP TABLE IF EXISTS `sp_factroy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_factroy` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `factory` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `factory_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='工厂表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_factroy`
--

LOCK TABLES `sp_factroy` WRITE;
/*!40000 ALTER TABLE `sp_factroy` DISABLE KEYS */;
INSERT INTO `sp_factroy` VALUES ('1336542027055136','center','中心工厂123','2020-03-12 15:22:02','admin','2020-03-13 10:15:54','admin'),('1336542142398496','123','你好','2020-03-12 15:22:37','admin','2020-03-12 15:22:37','admin'),('1336542951899168','ABC','ABC','2020-03-12 15:29:03','admin','2020-03-12 15:29:03','admin'),('1336850679595040','测试数据12','测试数据12','2020-03-14 08:14:39','admin','2020-03-14 08:14:39','admin'),('1336856843124768','测试数据2','测试数据2','2020-03-14 09:03:38','admin','2020-03-14 09:03:38','admin'),('1336858327908384','你好','你好123','2020-03-14 09:15:26','admin','2020-03-14 09:17:30','admin'),('1336858648772640','订单','的','2020-03-14 09:17:59','admin','2020-03-14 09:17:59','admin'),('1336873681158176','we','wewe','2020-03-14 11:17:27','admin','2020-03-14 11:17:27','admin'),('1336873716809760','ds','sdsdds','2020-03-14 11:17:44','admin','2020-03-14 11:17:44','admin');
/*!40000 ALTER TABLE `sp_factroy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_flow`
--

DROP TABLE IF EXISTS `sp_flow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_flow` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `flow` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程',
  `flow_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '线体描述',
  `process` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '流程绘制 A——>B——>C',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='流程表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_flow`
--

LOCK TABLES `sp_flow` WRITE;
/*!40000 ALTER TABLE `sp_flow` DISABLE KEYS */;
INSERT INTO `sp_flow` VALUES ('1274977236873883649','666','666','装配工序->测试工序->集成测试工序->封胶工序->清洗工序->包装工序','2020-06-22 16:07:16','admin','2020-07-20 20:49:33','admin'),('1275430361590116354','002','111','装配工序->包装工序','2020-06-23 22:07:49','admin','2020-06-23 22:07:49','admin'),('1275430501520486401','111','222','测试工序->焊接','2020-06-23 22:08:23','admin','2020-07-16 09:01:20','admin'),('1277125413169246210','asfds','sdfsd','装配工序->测试工序->封胶工序','2020-06-28 14:23:21','admin','2020-07-20 22:08:39','admin'),('1277176874674663425','A01','A01','装配工序->测试工序','2020-06-28 17:47:50','admin','2020-07-18 20:02:47','admin'),('1277600512544583681','A001','A001','装配工序->测试工序->包装工序','2020-06-29 21:51:14','admin','2020-06-29 21:51:14','admin'),('1278145622063689729','1212','1212','装配工序->包装工序','2020-07-01 09:57:18','admin','2020-07-01 09:57:18','admin'),('1278528234456330242','dc001','斗车','装配工序->测试工序->包装工序','2020-07-02 11:17:40','admin','2020-07-02 11:17:40','admin'),('1279942838902304770','000005','0005','装配工序->包装工序','2020-07-06 08:58:48','admin','2020-07-06 08:59:11','admin'),('1285142116192968706','1234','12222','装配工序->集成测试工序->封胶工序','2020-07-20 17:18:52','admin','2020-07-20 17:18:52','admin');
/*!40000 ALTER TABLE `sp_flow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_flow_oper_relation`
--

DROP TABLE IF EXISTS `sp_flow_oper_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_flow_oper_relation` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `flow_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程ID',
  `flow` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '流程代码',
  `per_oper_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '前道工序ID',
  `per_oper` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '前道工序代码',
  `oper_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '当前工序ID',
  `oper` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '当前工序\r\n',
  `next_oper_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '下道工序ID',
  `next_oper` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '下道工序',
  `sort_num` int NOT NULL COMMENT '排序',
  `oper_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '工序类型（首道工序firstOper;最后一道工序lastOper）',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `flow_id_index` (`flow_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='流程与工序关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_flow_oper_relation`
--

LOCK TABLES `sp_flow_oper_relation` WRITE;
/*!40000 ALTER TABLE `sp_flow_oper_relation` DISABLE KEYS */;
INSERT INTO `sp_flow_oper_relation` VALUES ('1267713369412186113','1267713369349271553','1111','','','1336864489340960','ASY-01','1336864537575456','TST-02',1,NULL,'2020-06-02 15:03:15','admin','2020-06-02 15:03:15','admin'),('1267713369412186114','1267713369349271553','1111','1336864489340960','ASY-01','1336864537575456','TST-02','','',2,NULL,'2020-06-02 15:03:15','admin','2020-06-02 15:03:15','admin'),('1267788592622841858','1267788592555732994','01','','','1336864489340960','ASY-01','1336864537575456','TST-02',1,NULL,'2020-06-02 20:02:10','admin','2020-06-02 20:02:10','admin'),('1267788592622841859','1267788592555732994','01','1336864489340960','ASY-01','1336864537575456','TST-02','1336864575324192','APK-01',2,NULL,'2020-06-02 20:02:10','admin','2020-06-02 20:02:10','admin'),('1267788592622841860','1267788592555732994','01','1336864537575456','TST-02','1336864575324192','APK-01','1336864613072928','TST-01',3,NULL,'2020-06-02 20:02:10','admin','2020-06-02 20:02:10','admin'),('1267788592622841861','1267788592555732994','01','1336864575324192','APK-01','1336864613072928','TST-01','','',4,NULL,'2020-06-02 20:02:10','admin','2020-06-02 20:02:10','admin'),('1267990052920864770','1265284426327371778','1','','','1336864489340960','ASY-01','1336864537575456','TST-02',1,NULL,'2020-06-03 09:22:41','admin','2020-06-03 09:22:41','admin'),('1267990052920864771','1265284426327371778','1','1336864489340960','ASY-01','1336864537575456','TST-02','1336868507484192','JS-01',2,NULL,'2020-06-03 09:22:41','admin','2020-06-03 09:22:41','admin'),('1267990052920864772','1265284426327371778','1','1336864537575456','TST-02','1336868507484192','JS-01','1336864575324192','APK-01',3,NULL,'2020-06-03 09:22:41','admin','2020-06-03 09:22:41','admin'),('1267990052920864773','1265284426327371778','1','1336868507484192','JS-01','1336864575324192','APK-01','','',4,NULL,'2020-06-03 09:22:41','admin','2020-06-03 09:22:41','admin'),('1267990103424479234','1265589028092358657','1111','','','1336864489340960','ASY-01','1336864575324192','APK-01',1,NULL,'2020-06-03 09:22:53','admin','2020-06-03 09:22:53','admin'),('1267990103424479235','1265589028092358657','1111','1336864489340960','ASY-01','1336864575324192','APK-01','1337248255574048','RK-01',2,NULL,'2020-06-03 09:22:53','admin','2020-06-03 09:22:53','admin'),('1267990103424479236','1265589028092358657','1111','1336864575324192','APK-01','1337248255574048','RK-01','1336868360683552','HJ-01',3,NULL,'2020-06-03 09:22:53','admin','2020-06-03 09:22:53','admin'),('1267990103424479237','1265589028092358657','1111','1337248255574048','RK-01','1336868360683552','HJ-01','','',4,NULL,'2020-06-03 09:22:53','admin','2020-06-03 09:22:53','admin'),('1268001010259046402','1268001010166771713','22','','','1336864489340960','ASY-01','1336864537575456','TST-02',1,NULL,'2020-06-03 10:06:14','admin','2020-06-03 10:06:14','admin'),('1268001010259046403','1268001010166771713','22','1336864489340960','ASY-01','1336864537575456','TST-02','1336864575324192','APK-01',2,NULL,'2020-06-03 10:06:14','admin','2020-06-03 10:06:14','admin'),('1268001010259046404','1268001010166771713','22','1336864537575456','TST-02','1336864575324192','APK-01','1336864613072928','TST-01',3,NULL,'2020-06-03 10:06:14','admin','2020-06-03 10:06:14','admin'),('1268001010259046405','1268001010166771713','22','1336864575324192','APK-01','1336864613072928','TST-01','1336868360683552','HJ-01',4,NULL,'2020-06-03 10:06:14','admin','2020-06-03 10:06:14','admin'),('1268001010259046406','1268001010166771713','22','1336864613072928','TST-01','1336868360683552','HJ-01','1336868452958240','FJ-01',5,NULL,'2020-06-03 10:06:14','admin','2020-06-03 10:06:14','admin'),('1268001010259046407','1268001010166771713','22','1336868360683552','HJ-01','1336868452958240','FJ-01','1336868507484192','JS-01',6,NULL,'2020-06-03 10:06:14','admin','2020-06-03 10:06:14','admin'),('1268001010259046408','1268001010166771713','22','1336868452958240','FJ-01','1336868507484192','JS-01','1336868562010144','QX-01',7,NULL,'2020-06-03 10:06:14','admin','2020-06-03 10:06:14','admin'),('1268001010259046409','1268001010166771713','22','1336868507484192','JS-01','1336868562010144','QX-01','1337248255574048','RK-01',8,NULL,'2020-06-03 10:06:14','admin','2020-06-03 10:06:14','admin'),('1268001010259046410','1268001010166771713','22','1336868562010144','QX-01','1337248255574048','RK-01','','',9,NULL,'2020-06-03 10:06:14','admin','2020-06-03 10:06:14','admin'),('1270229560290684929','1268552781134016513','撒大声','','','1336864489340960','ASY-01','1336864575324192','APK-01',1,NULL,'2020-06-09 13:41:42','admin','2020-06-09 13:41:42','admin'),('1270229560290684930','1268552781134016513','撒大声','1336864489340960','ASY-01','1336864575324192','APK-01','1336864613072928','TST-01',2,NULL,'2020-06-09 13:41:42','admin','2020-06-09 13:41:42','admin'),('1270229560290684931','1268552781134016513','撒大声','1336864575324192','APK-01','1336864613072928','TST-01','','',3,NULL,'2020-06-09 13:41:42','admin','2020-06-09 13:41:42','admin'),('1270954114197729281','1270954114151591937','121','','','1336864489340960','ASY-01','1336864575324192','APK-01',1,NULL,'2020-06-11 13:40:49','admin','2020-06-11 13:40:49','admin'),('1270954114197729282','1270954114151591937','121','1336864489340960','ASY-01','1336864575324192','APK-01','','',2,NULL,'2020-06-11 13:40:49','admin','2020-06-11 13:40:49','admin'),('1270954292094939138','1270954193277136898','222222','','','1336864537575456','TST-02','1336868360683552','HJ-01',1,NULL,'2020-06-11 13:41:31','admin','2020-06-11 13:41:31','admin'),('1270954292094939139','1270954193277136898','222222','1336864537575456','TST-02','1336868360683552','HJ-01','','',2,NULL,'2020-06-11 13:41:31','admin','2020-06-11 13:41:31','admin'),('1275430361636253697','1275430361590116354','002','','','1336864489340960','ASY-01','1336864575324192','APK-01',1,NULL,'2020-06-23 22:07:49','admin','2020-06-23 22:07:49','admin'),('1275430361636253698','1275430361590116354','002','1336864489340960','ASY-01','1336864575324192','APK-01','','',2,NULL,'2020-06-23 22:07:49','admin','2020-06-23 22:07:49','admin'),('1277600512599109634','1277600512544583681','A001','','','1336864489340960','ASY-01','1336864537575456','TST-02',1,NULL,'2020-06-29 21:51:14','admin','2020-06-29 21:51:14','admin'),('1277600512599109635','1277600512544583681','A001','1336864489340960','ASY-01','1336864537575456','TST-02','1336864575324192','APK-01',2,NULL,'2020-06-29 21:51:14','admin','2020-06-29 21:51:14','admin'),('1277600512599109636','1277600512544583681','A001','1336864537575456','TST-02','1336864575324192','APK-01','','',3,NULL,'2020-06-29 21:51:14','admin','2020-06-29 21:51:14','admin'),('1278145622248239105','1278145622063689729','1212','','','1336864489340960','ASY-01','1336864575324192','APK-01',1,NULL,'2020-07-01 09:57:18','admin','2020-07-01 09:57:18','admin'),('1278145622248239106','1278145622063689729','1212','1336864489340960','ASY-01','1336864575324192','APK-01','','',2,NULL,'2020-07-01 09:57:18','admin','2020-07-01 09:57:18','admin'),('1278528234506661890','1278528234456330242','dc001','','','1336864489340960','ASY-01','1336864537575456','TST-02',1,NULL,'2020-07-02 11:17:40','admin','2020-07-02 11:17:40','admin'),('1278528234506661891','1278528234456330242','dc001','1336864489340960','ASY-01','1336864537575456','TST-02','1336864575324192','APK-01',2,NULL,'2020-07-02 11:17:40','admin','2020-07-02 11:17:40','admin'),('1278528234506661892','1278528234456330242','dc001','1336864537575456','TST-02','1336864575324192','APK-01','','',3,NULL,'2020-07-02 11:17:40','admin','2020-07-02 11:17:40','admin'),('1279942938785460225','1279942838902304770','000005','','','1336864489340960','ASY-01','1336864575324192','APK-01',1,NULL,'2020-07-06 08:59:11','admin','2020-07-06 08:59:11','admin'),('1279942938785460226','1279942838902304770','000005','1336864489340960','ASY-01','1336864575324192','APK-01','','',2,NULL,'2020-07-06 08:59:11','admin','2020-07-06 08:59:11','admin'),('1283567357256773634','1275430501520486401','111','','','1336864537575456','TST-02','1336868360683552','HJ-01',1,NULL,'2020-07-16 09:01:20','admin','2020-07-16 09:01:20','admin'),('1283567357256773635','1275430501520486401','111','1336864537575456','TST-02','1336868360683552','HJ-01','','',2,NULL,'2020-07-16 09:01:20','admin','2020-07-16 09:01:20','admin'),('1284458592561508353','1277176874674663425','A01','','','1336864489340960','ASY-01','1336864537575456','TST-02',1,NULL,'2020-07-18 20:02:47','admin','2020-07-18 20:02:47','admin'),('1284458592561508354','1277176874674663425','A01','1336864489340960','ASY-01','1336864537575456','TST-02','','',2,NULL,'2020-07-18 20:02:47','admin','2020-07-18 20:02:47','admin'),('1285142116356546562','1285142116192968706','1234','','','1336864489340960','ASY-01','1336864613072928','TST-01',1,NULL,'2020-07-20 17:18:52','admin','2020-07-20 17:18:52','admin'),('1285142116385906690','1285142116192968706','1234','1336864489340960','ASY-01','1336864613072928','TST-01','1336868452958240','FJ-01',2,NULL,'2020-07-20 17:18:52','admin','2020-07-20 17:18:52','admin'),('1285142116385906691','1285142116192968706','1234','1336864613072928','TST-01','1336868452958240','FJ-01','','',3,NULL,'2020-07-20 17:18:52','admin','2020-07-20 17:18:52','admin'),('1285195135865544705','1274977236873883649','666','','','1336864489340960','ASY-01','1336864537575456','TST-02',1,NULL,'2020-07-20 20:49:33','admin','2020-07-20 20:49:33','admin'),('1285195135865544706','1274977236873883649','666','1336864489340960','ASY-01','1336864537575456','TST-02','1336864613072928','TST-01',2,NULL,'2020-07-20 20:49:33','admin','2020-07-20 20:49:33','admin'),('1285195135865544707','1274977236873883649','666','1336864537575456','TST-02','1336864613072928','TST-01','1336868452958240','FJ-01',3,NULL,'2020-07-20 20:49:33','admin','2020-07-20 20:49:33','admin'),('1285195135865544708','1274977236873883649','666','1336864613072928','TST-01','1336868452958240','FJ-01','1336868562010144','QX-01',4,NULL,'2020-07-20 20:49:33','admin','2020-07-20 20:49:33','admin'),('1285195135865544709','1274977236873883649','666','1336868452958240','FJ-01','1336868562010144','QX-01','1336864575324192','APK-01',5,NULL,'2020-07-20 20:49:33','admin','2020-07-20 20:49:33','admin'),('1285195135865544710','1274977236873883649','666','1336868562010144','QX-01','1336864575324192','APK-01','','',6,NULL,'2020-07-20 20:49:33','admin','2020-07-20 20:49:33','admin'),('1285215041575149569','1277125413169246210','asfds','','','1336864489340960','ASY-01','1336864537575456','TST-02',1,NULL,'2020-07-20 22:08:39','admin','2020-07-20 22:08:39','admin'),('1285215041575149570','1277125413169246210','asfds','1336864489340960','ASY-01','1336864537575456','TST-02','1336868452958240','FJ-01',2,NULL,'2020-07-20 22:08:39','admin','2020-07-20 22:08:39','admin'),('1285215041575149571','1277125413169246210','asfds','1336864537575456','TST-02','1336868452958240','FJ-01','','',3,NULL,'2020-07-20 22:08:39','admin','2020-07-20 22:08:39','admin');
/*!40000 ALTER TABLE `sp_flow_oper_relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_inventory`
--

DROP TABLE IF EXISTS `sp_inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_inventory` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `warehouse_id` varchar(64) NOT NULL COMMENT '所属库房ID',
  `location_id` varchar(64) NOT NULL COMMENT '所属库位ID',
  `materiel_id` varchar(64) NOT NULL COMMENT '物料ID',
  `batch_no` varchar(128) DEFAULT NULL COMMENT '批号',
  `qty` decimal(18,4) DEFAULT '0.0000' COMMENT '数量',
  `unit` varchar(32) DEFAULT NULL COMMENT '单位（保存时从物料带出）',
  `stock_status` varchar(32) NOT NULL DEFAULT 'AVAILABLE',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_warehouse` (`warehouse_id`),
  KEY `idx_location` (`location_id`),
  KEY `idx_materiel` (`materiel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='库存表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_inventory`
--

LOCK TABLES `sp_inventory` WRITE;
/*!40000 ALTER TABLE `sp_inventory` DISABLE KEYS */;
INSERT INTO `sp_inventory` VALUES ('2065324776744292353','2063882874474029057','2063882874599858177','2063211773064388609','',11111.0000,'','AVAILABLE','0','2026-06-12 14:46:13','admin','2026-06-12 14:46:13','admin'),('2065328054941097985','2063883558099443714','2063883558099443715','2063220154210721794','',11111.0000,'','AVAILABLE','0','2026-06-12 14:59:15','admin','2026-06-12 14:59:15','admin'),('2065328088742993922','2063882874474029057','2063882874599858178','2063211621905866753','IR2026061239732',0.0000,'','AVAILABLE','0','2026-06-12 14:59:23','admin','2026-06-12 16:23:48','admin'),('2065328168384438273','2063883246932418562','2063883246995333121','2063211773064388609','IR2026061241093',0.0000,'','AVAILABLE','0','2026-06-12 14:59:42','admin','2026-06-12 15:52:26','admin'),('2065328204434481153','2063883246932418562','2063883246995333122','2063211829855264770','IR2026061242556',16.0000,'','AVAILABLE','0','2026-06-12 14:59:51','admin','2026-06-12 14:59:51','admin'),('2065328229302509569','2063882874474029057','2063882874599858179','2063212207153881089','IR2026061243971',13.0000,'','AVAILABLE','0','2026-06-12 14:59:56','admin','2026-06-12 14:59:56','admin'),('2065328250651516930','2063883246932418562','2063883246995333123','2063212256785080322','IR2026061245281',14.0000,'','AVAILABLE','0','2026-06-12 15:00:02','admin','2026-06-12 15:00:02','admin');
/*!40000 ALTER TABLE `sp_inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_line`
--

DROP TABLE IF EXISTS `sp_line`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_line` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `line` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '线体',
  `line_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '线体描述',
  `process_section` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '工序段代号',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='线体表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_line`
--

LOCK TABLES `sp_line` WRITE;
/*!40000 ALTER TABLE `sp_line` DISABLE KEYS */;
INSERT INTO `sp_line` VALUES ('1336867983196192','WZY-ASY-01','装配线体01线','从vv','2020-03-14 10:32:10','admin','2020-06-14 02:20:09','admin'),('1336868041916448','WZY-TEST-01','测试01线体','TST','2020-03-14 10:32:38','admin','2020-03-14 10:32:38','admin'),('1336868662673440','WZY-DC-01','电池组装01线','ASY','2020-03-14 10:37:34','admin','2020-06-16 11:47:04','admin');
/*!40000 ALTER TABLE `sp_line` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_llm_conversation`
--

DROP TABLE IF EXISTS `sp_llm_conversation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_llm_conversation` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='智能助手会话表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_llm_conversation`
--

LOCK TABLES `sp_llm_conversation` WRITE;
/*!40000 ALTER TABLE `sp_llm_conversation` DISABLE KEYS */;
/*!40000 ALTER TABLE `sp_llm_conversation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_llm_message`
--

DROP TABLE IF EXISTS `sp_llm_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_llm_message` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='智能助手会话消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_llm_message`
--

LOCK TABLES `sp_llm_message` WRITE;
/*!40000 ALTER TABLE `sp_llm_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `sp_llm_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_material_inbound_request`
--

DROP TABLE IF EXISTS `sp_material_inbound_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_material_inbound_request` (
  `id` varchar(64) NOT NULL,
  `request_no` varchar(64) NOT NULL,
  `production_order_id` varchar(64) DEFAULT NULL,
  `production_order_no` varchar(64) DEFAULT NULL,
  `source_batch_no` varchar(64) DEFAULT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'GENERATED',
  `item_count` int NOT NULL DEFAULT '0',
  `total_net_qty` decimal(16,2) NOT NULL DEFAULT '0.00',
  `remark` varchar(500) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_material_inbound_request_no` (`request_no`),
  KEY `idx_material_inbound_request_order` (`production_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='material inbound request header';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_material_inbound_request`
--

LOCK TABLES `sp_material_inbound_request` WRITE;
/*!40000 ALTER TABLE `sp_material_inbound_request` DISABLE KEYS */;
INSERT INTO `sp_material_inbound_request` VALUES ('2065270710248980482','IR2026061282868','2065088372913311745','SO2026061110246','MRP20260612110947879','GENERATED',1,1.00,'由MRP物料需求计划生成','0','2026-06-12 11:11:23','admin','2026-06-12 11:11:23','admin'),('2065298190892580865','IR2026061234764','2065088372913311745','SO2026061110246','MRP20260612110947879','GENERATED',1,1.00,'由MRP物料需求计划生成','0','2026-06-12 13:00:35','admin','2026-06-12 13:00:35','admin'),('2065298203123171329','IR2026061237676','2065088372913311745','SO2026061110246','MRP20260612110947879','GENERATED',1,1.00,'由MRP物料需求计划生成','0','2026-06-12 13:00:38','admin','2026-06-12 13:00:38','admin'),('2065298211784409089','IR2026061239732','2065088372913311745','SO2026061110246','MRP20260612110947879','CONFIRMED',1,112.00,'由MRP物料需求计划生成','0','2026-06-12 13:00:40','admin','2026-06-12 14:59:23','admin'),('2065298217488662529','IR2026061241093','2065088372913311745','SO2026061110246','MRP20260612110947879','CONFIRMED',1,1.00,'由MRP物料需求计划生成','0','2026-06-12 13:00:41','admin','2026-06-12 14:59:42','admin'),('2065298223620734977','IR2026061242556','2065088372913311745','SO2026061110246','MRP20260612110947879','CONFIRMED',1,16.00,'由MRP物料需求计划生成','0','2026-06-12 13:00:43','admin','2026-06-12 14:59:51','admin'),('2065298229555675137','IR2026061243971','2065088372913311745','SO2026061110246','MRP20260612110947879','CONFIRMED',1,13.00,'由MRP物料需求计划生成','0','2026-06-12 13:00:44','admin','2026-06-12 14:59:56','admin'),('2065298235037630465','IR2026061245281','2065088372913311745','SO2026061110246','MRP20260612110947879','CONFIRMED',1,14.00,'由MRP物料需求计划生成','0','2026-06-12 13:00:45','admin','2026-06-12 15:00:02','admin');
/*!40000 ALTER TABLE `sp_material_inbound_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_material_inbound_request_item`
--

DROP TABLE IF EXISTS `sp_material_inbound_request_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_material_inbound_request_item` (
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
  `request_qty` decimal(16,2) NOT NULL DEFAULT '0.00',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='material inbound request item';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_material_inbound_request_item`
--

LOCK TABLES `sp_material_inbound_request_item` WRITE;
/*!40000 ALTER TABLE `sp_material_inbound_request_item` DISABLE KEYS */;
INSERT INTO `sp_material_inbound_request_item` VALUES ('2065270710311895041','2065270710248980482','IR2026061282868','2065270312717041669','2065088372913311745','SO2026061110246',NULL,'BOM000013','主板单元','个',1.00,'2026-06-14','2026-06-12',NULL,'0','2026-06-12 11:11:23','admin','2026-06-12 11:11:23','admin'),('2065298190955495426','2065298190892580865','IR2026061234764','2065270312717041665','2065088372913311745','SO2026061110246',NULL,'BOM000015','台式电脑主机半成品','个',1.00,'2026-06-14','2026-06-12',NULL,'0','2026-06-12 13:00:35','admin','2026-06-12 13:00:35','admin'),('2065298203123171330','2065298203123171329','IR2026061237676','2065270312717041666','2065088372913311745','SO2026061110246',NULL,'BOM000016','机箱单元','个',1.00,'2026-06-14','2026-06-12',NULL,'0','2026-06-12 13:00:38','admin','2026-06-12 13:00:38','admin'),('2065298211784409090','2065298211784409089','IR2026061239732','2065270312754790402','2065088372913311745','SO2026061110246','2063211621905866753','M000001','主板电路版','个',112.00,'2026-06-14','2026-06-12',NULL,'0','2026-06-12 13:00:40','admin','2026-06-12 13:00:40','admin'),('2065298217488662530','2065298217488662529','IR2026061241093','2065270312754790403','2065088372913311745','SO2026061110246','2063211773064388609','M000002','CPU','个',1.00,'2026-06-14','2026-06-12',NULL,'0','2026-06-12 13:00:41','admin','2026-06-12 13:00:41','admin'),('2065298223620734978','2065298223620734977','IR2026061242556','2065270312754790404','2065088372913311745','SO2026061110246','2063211829855264770','M000003','内存条','个',16.00,'2026-06-14','2026-06-12',NULL,'0','2026-06-12 13:00:43','admin','2026-06-12 13:00:43','admin'),('2065298229555675138','2065298229555675137','IR2026061243971','2065270312717041667','2065088372913311745','SO2026061110246','2063212207153881089','M000004','电源','个',13.00,'2026-06-14','2026-06-12',NULL,'0','2026-06-12 13:00:44','admin','2026-06-12 13:00:44','admin'),('2065298235037630466','2065298235037630465','IR2026061245281','2065270312717041668','2065088372913311745','SO2026061110246','2063212256785080322','M000005','机箱','个',14.00,'2026-06-14','2026-06-12',NULL,'0','2026-06-12 13:00:45','admin','2026-06-12 13:00:45','admin');
/*!40000 ALTER TABLE `sp_material_inbound_request_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_material_requirement_plan`
--

DROP TABLE IF EXISTS `sp_material_requirement_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_material_requirement_plan` (
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
  `gross_requirement` decimal(16,2) NOT NULL DEFAULT '0.00',
  `available_stock` decimal(16,2) NOT NULL DEFAULT '0.00',
  `safety_stock` decimal(16,2) NOT NULL DEFAULT '0.00',
  `net_requirement` decimal(16,2) NOT NULL DEFAULT '0.00',
  `requirement_date` varchar(32) DEFAULT NULL,
  `lead_time_days` int NOT NULL DEFAULT '1',
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
  KEY `idx_mrp_order` (`production_order_id`,`is_deleted`),
  KEY `idx_mrp_material_date` (`material_code`,`requirement_date`),
  KEY `idx_mrp_status` (`delivery_status`,`inbound_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='material requirement plan detail';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_material_requirement_plan`
--

LOCK TABLES `sp_material_requirement_plan` WRITE;
/*!40000 ALTER TABLE `sp_material_requirement_plan` DISABLE KEYS */;
INSERT INTO `sp_material_requirement_plan` VALUES ('2065270312717041665','2065088372913311745','SO2026061110246','2065088372988809218','SO2026061110246-SN001','M000006','台式电脑主机',NULL,'BOM000015','台式电脑主机半成品',NULL,NULL,'个',1,'BOM-PC-001(M000006) > BOM000015',1.00,0.00,0.00,1.00,'2026-06-14',1,'2026-06-12','RELEASED','GENERATED','2065298190892580865','IR2026061234764','NONE',NULL,NULL,'MRP20260612110947879','2026-06-12 11:09:47',NULL,'0','2026-06-12 11:09:48','admin','2026-06-12 13:00:35','admin'),('2065270312717041666','2065088372913311745','SO2026061110246','2065088372988809218','SO2026061110246-SN001','M000006','台式电脑主机',NULL,'BOM000016','机箱单元',NULL,NULL,'个',2,'BOM-PC-001(M000006) > BOM000015 > BOM000016',1.00,0.00,0.00,1.00,'2026-06-14',1,'2026-06-12','RELEASED','GENERATED','2065298203123171329','IR2026061237676','NONE',NULL,NULL,'MRP20260612110947879','2026-06-12 11:09:47',NULL,'0','2026-06-12 11:09:48','admin','2026-06-12 13:00:38','admin'),('2065270312717041667','2065088372913311745','SO2026061110246','2065088372988809218','SO2026061110246-SN001','M000006','台式电脑主机','2063212207153881089','M000004','电源','FG','OUT','个',3,'BOM-PC-001(M000006) > BOM000015 > BOM000016 > M000004',1.00,0.00,12.00,13.00,'2026-06-14',1,'2026-06-12','RELEASED','GENERATED','2065298229555675137','IR2026061243971','NONE',NULL,NULL,'MRP20260612110947879','2026-06-12 11:09:47',NULL,'0','2026-06-12 11:09:48','admin','2026-06-12 13:00:44','admin'),('2065270312717041668','2065088372913311745','SO2026061110246','2065088372988809218','SO2026061110246-SN001','M000006','台式电脑主机','2063212256785080322','M000005','机箱','FG','OUT','个',3,'BOM-PC-001(M000006) > BOM000015 > BOM000016 > M000005',1.00,0.00,13.00,14.00,'2026-06-14',1,'2026-06-12','RELEASED','GENERATED','2065298235037630465','IR2026061245281','NONE',NULL,NULL,'MRP20260612110947879','2026-06-12 11:09:47',NULL,'0','2026-06-12 11:09:48','admin','2026-06-12 13:00:45','admin'),('2065270312717041669','2065088372913311745','SO2026061110246','2065088372988809218','SO2026061110246-SN001','M000006','台式电脑主机',NULL,'BOM000013','主板单元',NULL,NULL,'个',2,'BOM-PC-001(M000006) > BOM000015 > BOM000013',1.00,0.00,0.00,1.00,'2026-06-14',1,'2026-06-12','RELEASED','GENERATED','2065270710248980482','IR2026061282868','NONE',NULL,NULL,'MRP20260612110947879','2026-06-12 11:09:47',NULL,'0','2026-06-12 11:09:48','admin','2026-06-12 11:11:23','admin'),('2065270312754790402','2065088372913311745','SO2026061110246','2065088372988809218','SO2026061110246-SN001','M000006','台式电脑主机','2063211621905866753','M000001','主板电路版','PART','OUT','个',3,'BOM-PC-001(M000006) > BOM000015 > BOM000013 > M000001',1.00,0.00,111.00,112.00,'2026-06-14',1,'2026-06-12','RELEASED','GENERATED','2065298211784409089','IR2026061239732','CONFIRMED','2065349229603815425','KO20260612-29024600','MRP20260612110947879','2026-06-12 11:09:47',NULL,'0','2026-06-12 11:09:48','admin','2026-06-12 16:23:48','admin'),('2065270312754790403','2065088372913311745','SO2026061110246','2065088372988809218','SO2026061110246-SN001','M000006','台式电脑主机','2063211773064388609','M000002','CPU','PART','OUT','个',3,'BOM-PC-001(M000006) > BOM000015 > BOM000013 > M000002',1.00,0.00,0.00,1.00,'2026-06-14',1,'2026-06-12','RELEASED','GENERATED','2065298217488662529','IR2026061241093','NONE',NULL,NULL,'MRP20260612110947879','2026-06-12 11:09:47',NULL,'0','2026-06-12 11:09:48','admin','2026-06-12 13:00:41','admin'),('2065270312754790404','2065088372913311745','SO2026061110246','2065088372988809218','SO2026061110246-SN001','M000006','台式电脑主机','2063211829855264770','M000003','内存条','PART','OUT','个',3,'BOM-PC-001(M000006) > BOM000015 > BOM000013 > M000003',1.00,0.00,15.00,16.00,'2026-06-14',1,'2026-06-12','RELEASED','GENERATED','2065298223620734977','IR2026061242556','NONE',NULL,NULL,'MRP20260612110947879','2026-06-12 11:09:47',NULL,'0','2026-06-12 11:09:48','admin','2026-06-12 13:00:43','admin');
/*!40000 ALTER TABLE `sp_material_requirement_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_materile`
--

DROP TABLE IF EXISTS `sp_materile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_materile` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `materiel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '物料编码',
  `materiel_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '物料描述',
  `unit` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '基本单位',
  `product_group` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '产品组',
  `mat_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料类型',
  `model` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '型号',
  `mat_source` varchar(16) DEFAULT NULL COMMENT '物料来源 SELF自制 OUT外购',
  `texture` varchar(32) DEFAULT NULL COMMENT '材质',
  `lead_time` int NOT NULL DEFAULT '1' COMMENT '物料需求提前期(天)，至少1',
  `safety_stock` int NOT NULL DEFAULT '0' COMMENT '安全库存',
  `image_urls` varchar(2000) DEFAULT NULL COMMENT '物料图片，多张逗号分隔的相对路径',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `size` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '尺寸',
  `flow_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '流程',
  `flow_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '流程描述',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='基础物料表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_materile`
--

LOCK TABLES `sp_materile` WRITE;
/*!40000 ALTER TABLE `sp_materile` DISABLE KEYS */;
INSERT INTO `sp_materile` VALUES ('1284051625900748801','000001','成品测试','件','产品1组','FG','大',NULL,NULL,1,0,NULL,NULL,'8*8','1279942838902304770','0005','2020-07-17 17:05:39','admin','2020-07-21 08:32:19','admin','0'),('2063211621905866753','M000001','主板电路版','',NULL,'PART','中','OUT','OTHER',1,111,'','',NULL,NULL,NULL,'2026-06-06 18:49:18','admin','2026-06-08 15:22:44','admin','0'),('2063211773064388609','M000002','CPU','',NULL,'PART','小','OUT','OTHER',1,0,'','',NULL,NULL,NULL,'2026-06-06 18:49:54','admin','2026-06-08 15:23:02','admin','0'),('2063211829855264770','M000003','内存条','',NULL,'PART','小','OUT','OTHER',1,15,'','',NULL,NULL,NULL,'2026-06-06 18:50:08','admin','2026-06-08 15:23:17','admin','0'),('2063212207153881089','M000004','电源','',NULL,'FG','中','OUT','OTHER',1,12,'','',NULL,NULL,NULL,'2026-06-06 18:51:37','admin','2026-06-08 15:23:37','admin','0'),('2063212256785080322','M000005','机箱','',NULL,'FG','大','OUT','OTHER',1,13,'','',NULL,NULL,NULL,'2026-06-06 18:51:49','admin','2026-06-08 15:23:26','admin','0'),('2063220154210721794','M000006','台式电脑主机','',NULL,'FG','大','SELF','OTHER',1,4,'','',NULL,NULL,NULL,'2026-06-06 19:23:12','admin','2026-06-08 15:23:53','admin','0'),('2063235129545428994','M000007','贴纸','',NULL,'FG','小','OUT','',1,0,'','',NULL,NULL,NULL,'2026-06-06 20:22:43','admin','2026-06-06 20:22:43','admin','0'),('2063235229227257858','M000008','防热垫','',NULL,'FG','中','OUT','OTHER',1,9,'','',NULL,NULL,NULL,'2026-06-06 20:23:06','admin','2026-06-08 15:23:10','admin','0'),('2063236968777093121','M000009','杯子','',NULL,'FG','大','SELF','OTHER',1,15,'','',NULL,NULL,NULL,'2026-06-06 20:30:01','admin','2026-06-08 15:22:50','admin','0');
/*!40000 ALTER TABLE `sp_materile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_oper`
--

DROP TABLE IF EXISTS `sp_oper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_oper` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `oper` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '工序\r\n',
  `oper_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '工序描述',
  `unit_id` varchar(64) DEFAULT NULL COMMENT '加工单元ID',
  `oper_hours` decimal(8,2) DEFAULT '0.00' COMMENT '工序工时(h)',
  `manu_cycle` decimal(8,2) DEFAULT '0.00' COMMENT '制造周期(h)',
  `gen_plan` char(1) DEFAULT 'Y' COMMENT '是否生成生产计划 Y是 N否',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_sp_oper_oper` (`oper`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='工序表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_oper`
--

LOCK TABLES `sp_oper` WRITE;
/*!40000 ALTER TABLE `sp_oper` DISABLE KEYS */;
INSERT INTO `sp_oper` VALUES ('1336864489340960','ASY-01','装配工序','jg_unit_002',2.00,2.00,'Y','','2020-03-14 10:04:24','admin','2026-06-12 16:33:24','admin'),('1336864537575456','TST-02','测试工序','jg_unit_002',99.00,99.00,'Y','','2020-03-14 10:04:47','admin','2026-06-06 20:35:19','admin'),('1336864575324192','APK-01','包装工序','jg_unit_002',2.00,3.00,'Y','','2020-03-14 10:05:05','admin','2026-06-12 16:33:14','admin'),('1336864613072928','TST-01','集成测试工序','2063235743255990273',2.00,2.00,'Y','','2020-03-14 10:05:23','admin','2026-06-12 16:35:34','admin'),('1336868360683552','HJ-01','焊接','jg_unit_002',2.00,2.00,'Y','','2020-03-14 10:35:10','admin','2026-06-12 16:32:53','admin'),('1336868452958240','FJ-01','封胶工序','jg_unit_002',2.00,2.00,'Y','','2020-03-14 10:35:54','admin','2026-06-12 16:32:43','admin'),('1336868507484192','JS-01','加酸工序','jg_unit_002',1.00,2.00,'Y','','2020-03-14 10:36:20','admin','2026-06-12 16:32:33','admin'),('1336868562010144','QX-01','清洗工序','jg_unit_002',1.00,2.00,'Y','','2020-03-14 10:36:46','admin','2026-06-12 16:32:20','admin'),('1337248255574048','RK-01','入库工序','jg_unit_002',1.00,2.00,'Y','','2020-03-16 12:54:18','admin','2026-06-11 23:03:42','admin'),('2063160747498151938','GX000001','123','jg_unit_001',1.00,2.00,'Y','','2026-06-06 15:27:09','admin','2026-06-06 15:27:09','admin'),('2063162784759685122','GX000002','主板装配作业工序','jg_unit_002',1.00,2.00,'Y','','2026-06-06 15:35:14','admin','2026-06-06 18:07:09','admin'),('2063201114801053697','GX000003','机箱组装作业工序','jg_unit_001',1.00,2.00,'Y','','2026-06-06 18:07:33','admin','2026-06-06 18:07:33','admin'),('2063201259852668930','GX000004','主机装配作业','jg_unit_001',1.00,2.00,'Y','','2026-06-06 18:08:07','admin','2026-06-06 18:08:07','admin'),('2063235850017804289','GX000005','盖子组装','2063235743255990273',1.00,2.00,'Y','','2026-06-06 20:25:34','admin','2026-06-06 20:25:34','admin'),('2063235919366426625','GX000006','底座组装','2063235743255990273',1.00,2.00,'Y','','2026-06-06 20:25:51','admin','2026-06-06 20:25:51','admin'),('2063236108395319297','GX000007','杯子半成品组装','2063235743255990273',1.00,2.00,'Y','','2026-06-06 20:26:36','admin','2026-06-06 20:26:36','admin'),('2063981392448569345','GX000008','111','2063235743255990273',1.00,2.00,'Y','','2026-06-08 21:48:06','admin','2026-06-11 23:03:25','admin');
/*!40000 ALTER TABLE `sp_oper` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_order`
--

DROP TABLE IF EXISTS `sp_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_order` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `order_code` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '工单编号',
  `order_description` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '工单描述',
  `qty` int DEFAULT NULL COMMENT '工单数量',
  `order_type` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '订单类型 P 量产 A验证 F返工 ',
  `flow_id` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '流程ID',
  `materiel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '物料编码',
  `materiel_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '物料描述',
  `plan_start_time` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL COMMENT '计划开始时间',
  `plan_end_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '计划结束时间',
  `statue` tinyint DEFAULT NULL COMMENT '1 created/pending approval, 2 approved, 3 ended, 4 terminated',
  `designer_id` varchar(64) DEFAULT NULL COMMENT 'Designer user ID',
  `designer_name` varchar(64) DEFAULT NULL COMMENT 'Designer name',
  `approve_user_id` varchar(64) DEFAULT NULL COMMENT 'Approver user ID',
  `approve_username` varchar(64) DEFAULT NULL COMMENT 'Approver name',
  `approve_time` varchar(32) DEFAULT NULL COMMENT 'Approval time',
  `work_status` varchar(32) NOT NULL DEFAULT 'NOT_STARTED' COMMENT 'Work start status',
  `work_start_time` varchar(32) DEFAULT NULL COMMENT 'Work start time',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_order`
--

LOCK TABLES `sp_order` WRITE;
/*!40000 ALTER TABLE `sp_order` DISABLE KEYS */;
INSERT INTO `sp_order` VALUES ('2063887156128604161','WO20260608153255','111',111,'P','1278145622063689729','M000006','台式电脑主机','2026-06-11 00:00:00','2026-06-27 00:00:00',2,NULL,'admin','1184019107907227649','超级管理员','2026-06-08 18:40:06','NOT_STARTED',NULL,NULL,'2026-06-08 15:33:38','admin','2026-06-08 18:40:23','admin'),('2063934238090706946','WO20260608184028','11',11,'P','1279942838902304770','M000004','电源','2026-06-08 00:00:00','2026-06-24 00:00:00',2,'1184019107907227649','超级管理员','1184019107907227649','超级管理员','2026-06-08 18:40:54','NOT_STARTED',NULL,NULL,'2026-06-08 18:40:43','admin','2026-06-08 18:40:54','admin'),('2065054397568204802','WO20260611205149890','SO202606117192 / 台式电脑主机',1,'P','2063220298813546498','M000006','台式电脑主机','2026-06-14 00:00:00','2026-06-16 00:00:00',2,'1184019107907227649','超级管理员','1184019107907227649','超级管理员','2026-06-11 22:58:23','NOT_STARTED',NULL,NULL,'2026-06-11 20:51:50','admin','2026-06-11 22:58:23','admin'),('2065055980813107202','WO20260611205807366','FC2026061167198 / 杯子',1,'P','2063237203217715201','M000009','杯子','2026-06-11 00:00:00','2026-06-15 00:00:00',2,'1184019107907227649','超级管理员','1184019107907227649','超级管理员','2026-06-12 10:24:47','NOT_STARTED',NULL,NULL,'2026-06-11 20:58:07','admin','2026-06-12 10:24:48','admin'),('2065079596011352066','WO20260611223157668','SO202606115594 / 台式电脑主机',1,'P','2063220298813546498','M000006','台式电脑主机','2026-06-14 00:00:00','2026-06-16 00:00:00',2,'1184019107907227649','超级管理员','1184019107907227649','超级管理员','2026-06-11 22:58:21','NOT_STARTED',NULL,NULL,'2026-06-11 22:31:58','admin','2026-06-11 22:58:22','admin'),('2065085549542739970','WO20260611225537101','SO2026061134640 / 台式电脑主机',1,'P','2063220298813546498','M000006','台式电脑主机','2026-06-14 00:00:00','2026-06-16 00:00:00',2,'1184019107907227649','超级管理员','1184019107907227649','超级管理员','2026-06-11 22:58:19','NOT_STARTED',NULL,NULL,'2026-06-11 22:55:37','admin','2026-06-11 22:58:20','admin'),('2065088388130246658','WO20260611230653874','SO2026061110246 / 台式电脑主机',1,'P','2063220298813546498','M000006','台式电脑主机','2026-06-14 00:00:00','2026-06-16 00:00:00',2,'1184019107907227649','超级管理员','1184019107907227649','超级管理员','2026-06-11 23:16:17','NOT_STARTED',NULL,NULL,'2026-06-11 23:06:54','admin','2026-06-11 23:16:17','admin'),('2065296773423349761','WO20260612125456802','SO2026061253964 / 台式电脑主机',1,'P','2063220298813546498','M000006','台式电脑主机','2026-06-10 00:00:00','2026-06-12 00:00:00',5,'1184019107907227649','超级管理员','1184019107907227649','超级管理员','2026-06-12 12:55:41','STARTED','2026-06-12 16:44:20',NULL,'2026-06-12 12:54:57','admin','2026-06-12 16:44:20','admin');
/*!40000 ALTER TABLE `sp_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_order_oper_assign`
--

DROP TABLE IF EXISTS `sp_order_oper_assign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_order_oper_assign` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `order_id` varchar(64) NOT NULL COMMENT '工单ID',
  `order_code` varchar(64) DEFAULT NULL COMMENT '工单编号',
  `flow_id` varchar(64) DEFAULT NULL COMMENT '工艺路线ID',
  `oper_id` varchar(64) NOT NULL COMMENT '工序ID',
  `oper` varchar(32) DEFAULT NULL COMMENT '工序编码',
  `oper_desc` varchar(255) DEFAULT NULL COMMENT '工序名称',
  `sort_num` int DEFAULT NULL COMMENT '工序顺序',
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
  KEY `idx_assign_user_status` (`user_id`,`status`),
  KEY `idx_assign_oper` (`oper_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工单工序人员分配表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_order_oper_assign`
--

LOCK TABLES `sp_order_oper_assign` WRITE;
/*!40000 ALTER TABLE `sp_order_oper_assign` DISABLE KEYS */;
INSERT INTO `sp_order_oper_assign` VALUES ('2065087898600443905','2065054397568204802','WO20260611205149890','2063220298813546498','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','2063881155841187842','1184009088826392578','宋鹏','0','','0','2026-06-11 23:04:57','admin','2026-06-11 23:04:57','admin'),('2065089541354131458','2065079596011352066','WO20260611223157668','2063220298813546498','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','2063881155841187842','2063899616759824386','张三','0','','0','2026-06-11 23:11:29','admin','2026-06-11 23:11:29','admin'),('2065298561891352578','2065296773423349761','WO20260612125456802','2063220298813546498','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','2063881155841187842','1184010472443396098','猴子','0','','0','2026-06-12 13:02:03','admin','2026-06-12 13:02:03','admin'),('2065298581881405442','2065296773423349761','WO20260612125456802','2063220298813546498','2063201114801053697','GX000003','机箱组装作业工序',3,'jg_unit_001','2063881155841187842','1276512902757724162','小明','0','','0','2026-06-12 13:02:08','admin','2026-06-12 13:02:08','admin'),('2065298589049470977','2065296773423349761','WO20260612125456802','2063220298813546498','1337248255574048','RK-01','入库工序',4,'jg_unit_002','2063873079603978241','1184019107907227649','超级管理员','0','','0','2026-06-12 13:02:10','admin','2026-06-12 13:02:10','admin'),('2065298595655499777','2065296773423349761','WO20260612125456802','2063220298813546498','2063162784759685122','GX000002','主板装配作业工序',6,'jg_unit_002','2063873079603978241','1184019107907227649','超级管理员','0','','0','2026-06-12 13:02:11','admin','2026-06-12 13:02:11','admin'),('2065352371963760642','2065088388130246658','WO20260611230653874','2063220298813546498','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','2063881155841187842','1266201180838801409','cassman','0','','0','2026-06-12 16:35:53','admin','2026-06-12 16:35:53','admin'),('2065352385360367617','2065088388130246658','WO20260611230653874','2063220298813546498','2063201114801053697','GX000003','机箱组装作业工序',3,'jg_unit_001','2063881155841187842','1266201180838801409','cassman','0','','0','2026-06-12 16:35:56','admin','2026-06-12 16:35:56','admin'),('2065354400698294273','2065296773423349761','WO20260612125456802','2063220298813546498','1336864613072928','TST-01','集成测试工序',1,'2063235743255990273','2063873079603978241','1184009088826392578','宋鹏','0','','0','2026-06-12 16:43:56','admin','2026-06-12 16:43:56','admin'),('2065354415793594369','2065088388130246658','WO20260611230653874','2063220298813546498','1336864613072928','TST-01','集成测试工序',1,'2063235743255990273','2063873079603978241','1184009088826392578','宋鹏','0','','0','2026-06-12 16:44:00','admin','2026-06-12 16:44:00','admin');
/*!40000 ALTER TABLE `sp_order_oper_assign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_order_oper_equipment_assign`
--

DROP TABLE IF EXISTS `sp_order_oper_equipment_assign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_order_oper_equipment_assign` (
  `id` varchar(64) NOT NULL,
  `order_id` varchar(64) DEFAULT NULL,
  `order_code` varchar(64) DEFAULT NULL,
  `production_order_id` varchar(64) DEFAULT NULL,
  `order_item_id` varchar(64) DEFAULT NULL,
  `oper_plan_id` varchar(64) NOT NULL,
  `oper_id` varchar(64) DEFAULT NULL,
  `oper` varchar(64) DEFAULT NULL,
  `oper_desc` varchar(255) DEFAULT NULL,
  `sort_num` int DEFAULT NULL,
  `unit_id` varchar(64) DEFAULT NULL,
  `equipment_id` varchar(64) DEFAULT NULL,
  `equipment_code` varchar(64) DEFAULT NULL,
  `equipment_name` varchar(128) DEFAULT NULL,
  `status` varchar(16) NOT NULL DEFAULT 'WAIT',
  `remark` varchar(255) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_equipment_assign_plan` (`oper_plan_id`),
  KEY `idx_equipment_assign_order` (`order_id`),
  KEY `idx_equipment_assign_equipment` (`equipment_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='operation equipment assignment';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_order_oper_equipment_assign`
--

LOCK TABLES `sp_order_oper_equipment_assign` WRITE;
/*!40000 ALTER TABLE `sp_order_oper_equipment_assign` DISABLE KEYS */;
INSERT INTO `sp_order_oper_equipment_assign` VALUES ('2065086938805276673','2065054397568204802','WO20260611205149890','2065054386243584001','2065054386415550465','2065054386532990978','1336864613072928','TST-01','集成测试工序',1,NULL,'eq_001','EQ000001','吊车','ASSIGNED','','0','2026-06-11 23:01:08','admin','2026-06-11 23:01:08','admin'),('2065086949051961345','2065054397568204802','WO20260611205149890','2065054386243584001','2065054386415550465','2065054386545573890','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','eq_001','EQ000001','吊车','ASSIGNED','','0','2026-06-11 23:01:11','admin','2026-06-11 23:01:11','admin'),('2065086960183644162','2065054397568204802','WO20260611205149890','2065054386243584001','2065054386415550465','2065054386553962498','2063201114801053697','GX000003','机箱组装作业工序',3,'jg_unit_001','eq_004','EQ000004','手指套','ASSIGNED','','0','2026-06-11 23:01:13','admin','2026-06-11 23:01:13','admin'),('2065086975333470210','2065054397568204802','WO20260611205149890','2065054386243584001','2065054386415550465','2065054386616877057','1337248255574048','RK-01','入库工序',9,NULL,'eq_002','EQ000002','主板测试夹具','ASSIGNED','','0','2026-06-11 23:01:17','admin','2026-06-11 23:01:17','admin'),('2065086989476663298','2065054397568204802','WO20260611205149890','2065054386243584001','2065054386415550465','2065054386583322625','2063162784759685122','GX000002','主板装配作业工序',6,'jg_unit_002','eq_002','EQ000002','主板测试夹具','ASSIGNED','','0','2026-06-11 23:01:20','admin','2026-06-11 23:01:20','admin'),('2065087142694588417','2065054397568204802','WO20260611205149890','2065054386243584001','2065054386415550465','2065054386562351106','1337248255574048','RK-01','入库工序',4,NULL,'eq_001','EQ000001','吊车','ASSIGNED','','0','2026-06-11 23:01:57','admin','2026-06-11 23:01:57','admin'),('2065087156095389698','2065054397568204802','WO20260611205149890','2065054386243584001','2065054386415550465','2065054386600099841','1337248255574048','RK-01','入库工序',7,NULL,'eq_001','EQ000001','吊车','ASSIGNED','','0','2026-06-11 23:02:00','admin','2026-06-11 23:02:00','admin'),('2065087167050911746','2065054397568204802','WO20260611205149890','2065054386243584001','2065054386415550465','2065054386608488449','1337248255574048','RK-01','入库工序',8,NULL,'eq_001','EQ000001','吊车','ASSIGNED','','0','2026-06-11 23:02:03','admin','2026-06-11 23:02:03','admin'),('2065087178153234434','2065054397568204802','WO20260611205149890','2065054386243584001','2065054386415550465','2065054386566545410','1337248255574048','RK-01','入库工序',5,NULL,'eq_001','EQ000001','吊车','ASSIGNED','','0','2026-06-11 23:02:05','admin','2026-06-11 23:02:05','admin'),('2065089176172859394','2065079596011352066','WO20260611223157668','2065079545897807873','2065079546019442690','2065079546174631937','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','eq_002','EQ000002','主板测试夹具','ASSIGNED','','0','2026-06-11 23:10:02','admin','2026-06-11 23:10:02','admin'),('2065089204790595585','2065079596011352066','WO20260611223157668','2065079545897807873','2065079546019442690','2065079546162049026','1336864613072928','TST-01','集成测试工序',1,NULL,'eq_002','EQ000002','主板测试夹具','ASSIGNED','','0','2026-06-11 23:10:09','admin','2026-06-11 23:10:09','admin'),('2065298351681224706','2065296773423349761','WO20260612125456802','2065296593726783489','2065296593789698050','2065296593919721474','1336864613072928','TST-01','集成测试工序',1,NULL,'eq_001','EQ000001','吊车','ASSIGNED','','0','2026-06-12 13:01:13','admin','2026-06-12 13:01:13','admin'),('2065298363093925889','2065296773423349761','WO20260612125456802','2065296593726783489','2065296593789698050','2065296593919721475','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','eq_001','EQ000001','吊车','ASSIGNED','','0','2026-06-12 13:01:16','admin','2026-06-12 13:01:16','admin'),('2065298374720536577','2065296773423349761','WO20260612125456802','2065296593726783489','2065296593789698050','2065296593919721476','2063201114801053697','GX000003','机箱组装作业工序',3,'jg_unit_001','eq_001','EQ000001','吊车','ASSIGNED','','0','2026-06-12 13:01:19','admin','2026-06-12 13:01:19','admin'),('2065298388175863810','2065296773423349761','WO20260612125456802','2065296593726783489','2065296593789698050','2065296593919721477','1337248255574048','RK-01','入库工序',4,'jg_unit_002','eq_002','EQ000002','主板测试夹具','ASSIGNED','','0','2026-06-12 13:01:22','admin','2026-06-12 13:01:22','admin'),('2065298403837394946','2065296773423349761','WO20260612125456802','2065296593726783489','2065296593789698050','2065296593919721478','1337248255574048','RK-01','入库工序',5,'jg_unit_002','eq_004','EQ000004','手指套','ASSIGNED','','0','2026-06-12 13:01:26','admin','2026-06-12 13:01:26','admin'),('2065298416936206337','2065296773423349761','WO20260612125456802','2065296593726783489','2065296593789698050','2065296593919721479','2063162784759685122','GX000002','主板装配作业工序',6,'jg_unit_002','eq_003','EQ000003','瓶体夹具','ASSIGNED','','0','2026-06-12 13:01:29','admin','2026-06-12 13:01:29','admin'),('2065298430269898754','2065296773423349761','WO20260612125456802','2065296593726783489','2065296593789698050','2065296593919721480','1337248255574048','RK-01','入库工序',7,'jg_unit_002','eq_001','EQ000001','吊车','ASSIGNED','','0','2026-06-12 13:01:32','admin','2026-06-12 13:01:32','admin'),('2065298445797212161','2065296773423349761','WO20260612125456802','2065296593726783489','2065296593789698050','2065296593919721481','1337248255574048','RK-01','入库工序',8,'jg_unit_002','eq_004','EQ000004','手指套','ASSIGNED','','0','2026-06-12 13:01:36','admin','2026-06-12 13:01:36','admin'),('2065298456408801282','2065296773423349761','WO20260612125456802','2065296593726783489','2065296593789698050','2065296593919721482','1337248255574048','RK-01','入库工序',9,'jg_unit_002','eq_003','EQ000003','瓶体夹具','ASSIGNED','','0','2026-06-12 13:01:38','admin','2026-06-12 13:01:38','admin'),('2065298471260831745','2065088388130246658','WO20260611230653874','2065088372913311745','2065088372988809218','2065088373068500993','1336864613072928','TST-01','集成测试工序',1,NULL,'eq_004','EQ000004','手指套','ASSIGNED','','0','2026-06-12 13:01:42','admin','2026-06-12 13:01:42','admin'),('2065298495365496834','2065088388130246658','WO20260611230653874','2065088372913311745','2065088372988809218','2065088373076889602','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','eq_003','EQ000003','瓶体夹具','ASSIGNED','','0','2026-06-12 13:01:47','admin','2026-06-12 13:01:47','admin'),('2065298515103891458','2065088388130246658','WO20260611230653874','2065088372913311745','2065088372988809218','2065088373085278210','2063201114801053697','GX000003','机箱组装作业工序',3,'jg_unit_001','eq_001','EQ000001','吊车','ASSIGNED','','0','2026-06-12 13:01:52','admin','2026-06-12 13:01:52','admin');
/*!40000 ALTER TABLE `sp_order_oper_equipment_assign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_process_content`
--

DROP TABLE IF EXISTS `sp_process_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_process_content` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `route_id` varchar(64) NOT NULL COMMENT '工艺ID FK sp_process_route',
  `content_text` text COMMENT '工序内容文本',
  `require_text` text COMMENT '工序要求文本',
  `need_check` char(1) NOT NULL DEFAULT 'Y' COMMENT '是否需要检验',
  `precaution_text` text COMMENT '注意事项文本',
  `tech_doc_desc` varchar(500) DEFAULT NULL COMMENT '技术文档描述',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_route_id` (`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工艺内容编制主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_process_content`
--

LOCK TABLES `sp_process_content` WRITE;
/*!40000 ALTER TABLE `sp_process_content` DISABLE KEYS */;
INSERT INTO `sp_process_content` VALUES ('2063234128159543298','2063232882535141378','132312313','231312414','Y','12312313414','1111','2026-06-06 20:18:44','admin','2026-06-06 20:37:26','admin'),('2063238355514658818','2063232882535141379',NULL,NULL,'Y',NULL,NULL,'2026-06-06 20:35:32','admin','2026-06-06 20:35:32','admin'),('2063889875635625986','2063232882665164805',NULL,NULL,'Y',NULL,NULL,'2026-06-08 15:44:26','admin','2026-06-08 15:44:26','admin');
/*!40000 ALTER TABLE `sp_process_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_process_equipment_rel`
--

DROP TABLE IF EXISTS `sp_process_equipment_rel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_process_equipment_rel` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `route_id` varchar(64) NOT NULL COMMENT '工艺ID',
  `equipment_id` varchar(64) NOT NULL COMMENT '设备ID',
  `req_qty` int NOT NULL DEFAULT '1' COMMENT '需求数量',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `idx_route_id` (`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工艺-工装设备关联';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_process_equipment_rel`
--

LOCK TABLES `sp_process_equipment_rel` WRITE;
/*!40000 ALTER TABLE `sp_process_equipment_rel` DISABLE KEYS */;
INSERT INTO `sp_process_equipment_rel` VALUES ('2063238791609028609','2063232882535141378','eq_001',1,'','2026-06-06 20:37:16','admin'),('2063238791663554561','2063232882535141378','eq_002',1,'','2026-06-06 20:37:16','admin'),('2063238791663554562','2063232882535141378','eq_003',1,'','2026-06-06 20:37:16','admin'),('2063238791663554563','2063232882535141378','eq_004',1,'','2026-06-06 20:37:16','admin');
/*!40000 ALTER TABLE `sp_process_equipment_rel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_process_file`
--

DROP TABLE IF EXISTS `sp_process_file`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_process_file` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `route_id` varchar(64) NOT NULL COMMENT '工艺ID',
  `file_type` varchar(32) NOT NULL COMMENT 'CONTENT_IMG/REQ_IMG/PREC_IMG/TECH_IMG/TECH_ATTACH',
  `file_path` varchar(500) NOT NULL COMMENT '相对路径（不含access-prefix）',
  `original_name` varchar(255) NOT NULL COMMENT '原始文件名',
  `file_size` bigint NOT NULL DEFAULT '0' COMMENT '文件大小（字节）',
  `sort_no` int NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `idx_route_type` (`route_id`,`file_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工艺内容文件附件';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_process_file`
--

LOCK TABLES `sp_process_file` WRITE;
/*!40000 ALTER TABLE `sp_process_file` DISABLE KEYS */;
INSERT INTO `sp_process_file` VALUES ('2063238785208520706','2063232882535141378','CONTENT_IMG','2026/06/06/4438302628394ee19890645a640906bd.jpg','123.jpg',765481,0,'2026-06-06 20:37:14','admin'),('2063238787410530306','2063232882535141378','REQ_IMG','2026/06/06/a939b0f6d8c54fe98fbff3d4facefae7.jpg','123.jpg',765481,0,'2026-06-06 20:37:15','admin'),('2063238789373464577','2063232882535141378','PREC_IMG','2026/06/06/bd0ec207c51c480e86a40de4d0eccac6.jpg','123.jpg',765481,0,'2026-06-06 20:37:15','admin'),('2063238834365763586','2063232882535141378','TECH_IMG','2026/06/06/17920b7446004ae0b727c4139d27c8c8.jpg','123.jpg',765481,0,'2026-06-06 20:37:26','admin'),('2063238834365763587','2063232882535141378','TECH_ATTACH','2026/06/06/ea61c99da2384768978f11fa6f0712ba.docx','23计科三班刘煜23219111344实验六.docx',660196,0,'2026-06-06 20:37:26','admin');
/*!40000 ALTER TABLE `sp_process_file` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_process_material_rel`
--

DROP TABLE IF EXISTS `sp_process_material_rel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_process_material_rel` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `route_id` varchar(64) NOT NULL COMMENT '工艺ID',
  `materiel_id` varchar(64) NOT NULL COMMENT '物料ID',
  `req_qty` decimal(12,3) NOT NULL DEFAULT '1.000' COMMENT '需求数量',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  PRIMARY KEY (`id`),
  KEY `idx_route_id` (`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='工艺-备料清单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_process_material_rel`
--

LOCK TABLES `sp_process_material_rel` WRITE;
/*!40000 ALTER TABLE `sp_process_material_rel` DISABLE KEYS */;
INSERT INTO `sp_process_material_rel` VALUES ('2063238836777488386','2063232882535141378','2063220154210721794',1.000,'','2026-06-06 20:37:26','admin'),('2063238836777488387','2063232882535141378','2063212256785080322',1.000,'','2026-06-06 20:37:26','admin'),('2063238836777488388','2063232882535141378','2063212207153881089',1.000,'','2026-06-06 20:37:26','admin'),('2063238836777488389','2063232882535141378','2063211829855264770',1.000,'','2026-06-06 20:37:26','admin'),('2063238836777488390','2063232882535141378','2063211773064388609',1.000,'','2026-06-06 20:37:26','admin'),('2063238836840402945','2063232882535141378','2063211621905866753',1.000,'','2026-06-06 20:37:26','admin');
/*!40000 ALTER TABLE `sp_process_material_rel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_process_route`
--

DROP TABLE IF EXISTS `sp_process_route`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_process_route` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `bom_id` varchar(64) NOT NULL COMMENT '所属BOM',
  `bom_item_id` varchar(64) DEFAULT NULL COMMENT 'BOM节点ID（空表示根产品节点）',
  `route_code` varchar(128) NOT NULL COMMENT '工艺编号 NGY_3_M000003_001_001',
  `parent_route_id` varchar(64) DEFAULT NULL COMMENT '上级工艺ID',
  `node_name` varchar(128) NOT NULL COMMENT '节点名称（冗余便于显示）',
  `materiel_code` varchar(64) DEFAULT NULL COMMENT '物料编码（冗余）',
  `oper_id` varchar(64) DEFAULT NULL COMMENT '绑定的工序ID',
  `seq_no` int NOT NULL DEFAULT '30' COMMENT '排序号 30/60/90',
  `lock_status` varchar(10) NOT NULL DEFAULT 'draft' COMMENT 'draft草稿 locked已锁定',
  `edit_status` varchar(10) NOT NULL DEFAULT 'pending' COMMENT 'pending未编制 editing编制中 completed已完成',
  `is_deleted` char(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_route_code` (`route_code`),
  KEY `idx_bom_id` (`bom_id`),
  KEY `idx_parent_route_id` (`parent_route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='产品工艺流程（按BOM节点）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_process_route`
--

LOCK TABLES `sp_process_route` WRITE;
/*!40000 ALTER TABLE `sp_process_route` DISABLE KEYS */;
INSERT INTO `sp_process_route` VALUES ('2063232882535141378','2063220298813546498',NULL,'NGY_3_M000006',NULL,'台式电脑主机','M000006','1336864613072928',30,'locked','completed','0','2026-06-06 20:13:47','admin','2026-06-06 20:37:27','admin'),('2063232882535141379','2063220298813546498','2063220298876461058','NGY_3_M000006_001','2063232882535141378','台式电脑主机半成品','BOM000015','2063201259852668930',30,'locked','pending','0','2026-06-06 20:13:47','admin','2026-06-06 20:18:34','admin'),('2063232882665164802','2063220298813546498','2063219924857790465','NGY_3_M000006_001_001','2063232882535141379','机箱单元','BOM000016','2063201114801053697',30,'locked','pending','0','2026-06-06 20:13:47','admin','2026-06-06 20:18:34','admin'),('2063232882665164803','2063220298813546498','2063214043688607745','NGY_3_M000006_001_001_001','2063232882665164802','电源','M000004','1337248255574048',30,'locked','pending','0','2026-06-06 20:13:47','admin','2026-06-06 20:18:34','admin'),('2063232882665164804','2063220298813546498','2063214043692802050','NGY_3_M000006_001_001_002','2063232882665164802','机箱','M000005','1337248255574048',60,'locked','pending','0','2026-06-06 20:13:47','admin','2026-06-06 20:18:34','admin'),('2063232882665164805','2063220298813546498','2063219924857790466','NGY_3_M000006_001_002','2063232882535141379','主板单元','BOM000013','2063162784759685122',60,'locked','pending','0','2026-06-06 20:13:47','admin','2026-06-06 20:18:34','admin'),('2063232882665164806','2063220298813546498','2063213856446488577','NGY_3_M000006_001_002_001','2063232882665164805','主板电路版','M000001','1337248255574048',30,'locked','pending','0','2026-06-06 20:13:47','admin','2026-06-06 20:18:34','admin'),('2063232882728079362','2063220298813546498','2063213856471654402','NGY_3_M000006_001_002_002','2063232882665164805','CPU','M000002','1337248255574048',60,'locked','pending','0','2026-06-06 20:13:47','admin','2026-06-06 20:18:34','admin'),('2063232882728079363','2063220298813546498','2063213856484237313','NGY_3_M000006_001_002_003','2063232882665164805','内存条','M000003','1337248255574048',90,'locked','pending','0','2026-06-06 20:13:47','admin','2026-06-06 20:18:34','admin'),('2065055684577804290','2063237203217715201',NULL,'NGY_3_M000009',NULL,'杯子','M000009','1336864537575456',30,'locked','pending','0','2026-06-11 20:56:57','admin','2026-06-11 20:57:57','admin'),('2065055684594581505','2063237203217715201','2063237203217715202','NGY_3_M000009_001','2065055684577804290','半成品杯子','BOM000023','2063236108395319297',30,'locked','pending','0','2026-06-11 20:56:57','admin','2026-06-11 20:57:57','admin'),('2065055684607164417','2063237203217715201','2063236716464541698','NGY_3_M000009_001_001','2065055684594581505','盖子','BOM000021','2063235850017804289',30,'locked','pending','0','2026-06-11 20:56:57','admin','2026-06-11 20:57:57','admin'),('2065055684623941633','2063237203217715201','2063236321319161858','NGY_3_M000009_001_001_001','2065055684607164417','贴纸','M000007','1337248255574048',30,'locked','pending','0','2026-06-11 20:56:57','admin','2026-06-11 20:57:57','admin'),('2065055684636524545','2063237203217715201','2063236716464541699','NGY_3_M000009_001_002','2065055684594581505','底座','BOM000022','2063235919366426625',60,'locked','pending','0','2026-06-11 20:56:57','admin','2026-06-11 20:57:57','admin'),('2065055684661690369','2063237203217715201','2063236581701554179','NGY_3_M000009_001_002_001','2065055684636524545','防热垫','M000008','1337248255574048',30,'locked','pending','0','2026-06-11 20:56:57','admin','2026-06-11 20:57:57','admin');
/*!40000 ALTER TABLE `sp_process_route` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_processing_unit`
--

DROP TABLE IF EXISTS `sp_processing_unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_processing_unit` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `unit_code` varchar(32) NOT NULL COMMENT '加工单元编号 JG000001',
  `unit_name` varchar(128) NOT NULL COMMENT '加工单元名称',
  `unit_type` varchar(32) NOT NULL DEFAULT 'person' COMMENT '加工单元类型 person=人员作业单元 device=设备作业单元',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  `std_capacity` decimal(8,2) NOT NULL DEFAULT '8.00' COMMENT '日标准产能(小时)',
  `has_edge_warehouse` char(1) NOT NULL DEFAULT 'N' COMMENT '是否有线边库 Y是 N否',
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '状态 0正常 2异常',
  `is_deleted` char(1) NOT NULL DEFAULT '0' COMMENT '是否删除',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_unit_code` (`unit_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='加工单元主数据';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_processing_unit`
--

LOCK TABLES `sp_processing_unit` WRITE;
/*!40000 ALTER TABLE `sp_processing_unit` DISABLE KEYS */;
INSERT INTO `sp_processing_unit` VALUES ('2063235743255990273','JG000003','杯子组装单元','person','',8.00,'N','0','0','2026-06-06 20:25:09','admin','2026-06-08 18:20:06','admin'),('jg_unit_001','JG000001','电脑组装单元','person','PDF示例-电脑组装作业人员单元',8.00,'N','0','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('jg_unit_002','JG000002','加工单元1','device','PDF示例-轮毂上线工序所属单元',8.00,'N','0','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin');
/*!40000 ALTER TABLE `sp_processing_unit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_processing_unit_team`
--

DROP TABLE IF EXISTS `sp_processing_unit_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_processing_unit_team` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='加工单元班组关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_processing_unit_team`
--

LOCK TABLES `sp_processing_unit_team` WRITE;
/*!40000 ALTER TABLE `sp_processing_unit_team` DISABLE KEYS */;
INSERT INTO `sp_processing_unit_team` VALUES ('2063880989293764609','2063235743255990273','2063873079603978241',NULL,'0','2026-06-08 15:09:08','admin','2026-06-08 15:09:08','admin'),('2063881202725117954','jg_unit_001','2063881155841187842',NULL,'0','2026-06-08 15:09:58','admin','2026-06-08 15:09:58','admin'),('2065087738520637441','jg_unit_002','2063873079603978241',NULL,'0','2026-06-11 23:04:19','admin','2026-06-11 23:04:19','admin');
/*!40000 ALTER TABLE `sp_processing_unit_team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_production_order`
--

DROP TABLE IF EXISTS `sp_production_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_production_order` (
  `id` varchar(64) NOT NULL COMMENT '??ID',
  `order_no` varchar(64) NOT NULL COMMENT '??????',
  `source_type` varchar(16) NOT NULL COMMENT '???? DEMAND???? FORECAST????',
  `customer_name` varchar(128) DEFAULT NULL COMMENT '????',
  `customer_group` varchar(128) DEFAULT NULL COMMENT '????',
  `external_no` varchar(128) DEFAULT NULL COMMENT '????',
  `sales_contract_no` varchar(128) DEFAULT NULL COMMENT '?????',
  `business_type` varchar(64) DEFAULT NULL COMMENT '????',
  `order_date` varchar(32) DEFAULT NULL COMMENT '????',
  `settlement_currency` varchar(32) DEFAULT NULL COMMENT '????',
  `transport_mode` varchar(64) DEFAULT NULL COMMENT '????',
  `payment_terms` varchar(128) DEFAULT NULL COMMENT '????',
  `tax_rate` varchar(32) DEFAULT NULL COMMENT '??',
  `receiver_name` varchar(64) DEFAULT NULL COMMENT '???',
  `receiver_phone` varchar(64) DEFAULT NULL COMMENT '?????',
  `receiver_address` varchar(255) DEFAULT NULL COMMENT '????',
  `remark` varchar(500) DEFAULT NULL COMMENT '??',
  `status` varchar(32) NOT NULL DEFAULT 'DRAFT' COMMENT '?? DRAFT?? CONFIRMED??? WORK_ORDER_CREATED????? CANCELLED???',
  `approval_status` varchar(32) NOT NULL DEFAULT 'DRAFT',
  `operation_status` varchar(32) NOT NULL DEFAULT 'NONE',
  `creation_method` varchar(32) NOT NULL DEFAULT 'MANUAL',
  `scheduling_method` varchar(32) NOT NULL DEFAULT 'REVERSE',
  `erp_source_no` varchar(128) DEFAULT NULL,
  `erp_sync_time` varchar(32) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0' COMMENT '???? 0?? 1??',
  `create_time` datetime NOT NULL COMMENT '????',
  `create_username` varchar(64) DEFAULT NULL COMMENT '???',
  `update_time` datetime NOT NULL COMMENT '??????',
  `update_username` varchar(64) DEFAULT NULL COMMENT '?????',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_sp_production_order_no` (`order_no`),
  KEY `idx_sp_production_order_source` (`source_type`),
  KEY `idx_sp_production_order_customer` (`customer_name`),
  KEY `idx_sp_production_order_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='??????-????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_production_order`
--

LOCK TABLES `sp_production_order` WRITE;
/*!40000 ALTER TABLE `sp_production_order` DISABLE KEYS */;
INSERT INTO `sp_production_order` VALUES ('2065030009619791874','SO2026061195217','DEMAND','111','','','','普通销售','2026-06-11','人民币','','','不含税','','','','','CANCELLED','DRAFT','NONE','MANUAL','REVERSE',NULL,NULL,'1','2026-06-11 19:14:55','admin','2026-06-11 20:23:21','admin'),('2065054386243584001','SO202606117192','DEMAND','客户1','1','','','普通销售','2026-06-11','人民币','专车','','不含税','客户1','19978963254','浙江省温州市温州理工学院','','CONFIRMED','APPROVED','DISPATCHED','MANUAL','REVERSE',NULL,NULL,'0','2026-06-11 20:51:47','admin','2026-06-11 23:01:03','admin'),('2065054637926989825','FC2026061167198','FORECAST','客户1','YCDD-01','','','普通销售','2026-06-11','人民币','专车','','不含税','客户1','19978963254','浙江省温州市温州理工学院','','CONFIRMED','APPROVED','DISPATCHED','MANUAL','FORWARD',NULL,NULL,'0','2026-06-11 20:52:47','admin','2026-06-12 10:25:15','admin'),('2065079545897807873','SO202606115594','DEMAND','KH-01','k-01','','','普通销售','2026-06-11','人民币','专车','','不含税','K','119978963541','浙江省温州市温州理工学院','','CONFIRMED','APPROVED','DISPATCHED','MANUAL','REVERSE',NULL,NULL,'0','2026-06-11 22:31:46','admin','2026-06-11 23:08:53','admin'),('2065085539702902786','SO2026061134640','DEMAND','KH-02','','','','普通销售','2026-06-11','人民币','22','','不含税','K','119978963541','浙江省温州市温州理工学院','','CONFIRMED','APPROVED','DISPATCHED','MANUAL','REVERSE',NULL,NULL,'0','2026-06-11 22:55:35','admin','2026-06-12 10:21:30','admin'),('2065088372913311745','SO2026061110246','DEMAND','KH-03','1','','','普通销售','2026-06-11','人民币','专车','','不含税','K','119978963541','浙江省温州市温州理工学院','','CONFIRMED','APPROVED','WAIT_ASSIGN','MANUAL','REVERSE',NULL,NULL,'0','2026-06-11 23:06:50','admin','2026-06-12 16:44:12','admin'),('2065296593726783489','SO2026061253964','DEMAND','KH-06','K-01','DD-01','DD-02','普通销售','2026-06-12','人民币','专车','','不含税','YY','19999999999','温州理工学院','','CONFIRMED','APPROVED','DISPATCHED','MANUAL','REVERSE',NULL,NULL,'0','2026-06-12 12:54:14','admin','2026-06-12 16:44:09','admin');
/*!40000 ALTER TABLE `sp_production_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_production_order_item`
--

DROP TABLE IF EXISTS `sp_production_order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_production_order_item` (
  `id` varchar(64) NOT NULL COMMENT '??ID',
  `order_id` varchar(64) NOT NULL COMMENT '????ID',
  `product_materiel` varchar(128) NOT NULL COMMENT '??????',
  `product_name` varchar(255) NOT NULL COMMENT '????',
  `bom_id` varchar(64) DEFAULT NULL,
  `bom_code` varchar(128) DEFAULT NULL,
  `bom_version` varchar(64) DEFAULT NULL,
  `model` varchar(128) DEFAULT NULL COMMENT '??',
  `specification` varchar(128) DEFAULT NULL COMMENT '??',
  `qty` int NOT NULL DEFAULT '0' COMMENT '????',
  `unit_price` decimal(12,2) DEFAULT NULL COMMENT '??',
  `configuration` varchar(500) DEFAULT NULL COMMENT '????',
  `plan_delivery_date` varchar(32) DEFAULT NULL COMMENT '??????',
  `plan_start_date` varchar(32) DEFAULT NULL COMMENT '??????',
  `lead_time_days` int NOT NULL DEFAULT '1' COMMENT '???????(?)',
  `target_capacity` decimal(10,2) NOT NULL DEFAULT '5.00' COMMENT '?????(?/?)',
  `computed_start_date` varchar(32) DEFAULT NULL COMMENT '??????????',
  `computed_delivery_date` varchar(32) DEFAULT NULL COMMENT '??????????',
  `adjust_note` varchar(500) DEFAULT NULL COMMENT '????',
  `work_order_id` varchar(64) DEFAULT NULL COMMENT '???????ID',
  `work_order_code` varchar(64) DEFAULT NULL COMMENT '?????????',
  `create_time` datetime NOT NULL COMMENT '????',
  `create_username` varchar(64) DEFAULT NULL COMMENT '???',
  `update_time` datetime NOT NULL COMMENT '??????',
  `update_username` varchar(64) DEFAULT NULL COMMENT '?????',
  PRIMARY KEY (`id`),
  KEY `idx_sp_production_order_item_order` (`order_id`),
  KEY `idx_sp_production_order_item_product` (`product_materiel`),
  KEY `idx_sp_production_order_item_delivery` (`plan_delivery_date`),
  KEY `idx_sp_production_order_item_start` (`plan_start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='??????-????';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_production_order_item`
--

LOCK TABLES `sp_production_order_item` WRITE;
/*!40000 ALTER TABLE `sp_production_order_item` DISABLE KEYS */;
INSERT INTO `sp_production_order_item` VALUES ('2065030009720455169','2065030009619791874','M000003','内存条',NULL,NULL,NULL,'小','',1,NULL,'','2026-06-11','2026-06-02',1,5.00,'2026-06-09','2026-06-11','',NULL,NULL,'2026-06-11 19:14:55','admin','2026-06-11 19:14:55','admin'),('2065054386415550465','2065054386243584001','M000006','台式电脑主机','2063220298813546498','BOM-PC-001','1','大',NULL,1,55.00,'五','2026-06-16','2026-06-11',1,5.00,'2026-06-14','2026-06-16','','2065054397568204802','WO20260611205149890','2026-06-11 20:51:47','admin','2026-06-11 20:51:50','admin'),('2065054637994098689','2065054637926989825','M000009','杯子','2063237203217715201','BOM-0001','1','大',NULL,1,55.00,'五','2026-06-16','2026-06-11',1,5.00,'2026-06-11','2026-06-15','','2065055980813107202','WO20260611205807366','2026-06-11 20:52:47','admin','2026-06-11 20:58:07','admin'),('2065079546019442690','2065079545897807873','M000006','台式电脑主机','2063220298813546498','BOM-PC-001','1','大',NULL,1,8888.00,'','2026-06-16','2026-06-11',1,5.00,'2026-06-14','2026-06-16','','2065079596011352066','WO20260611223157668','2026-06-11 22:31:46','admin','2026-06-11 22:31:58','admin'),('2065085539782594562','2065085539702902786','M000006','台式电脑主机','2063220298813546498','BOM-PC-001','1','大',NULL,1,8888.00,'','2026-06-16','2026-06-11',1,5.00,'2026-06-14','2026-06-16','','2065085549542739970','WO20260611225537101','2026-06-11 22:55:35','admin','2026-06-11 22:55:37','admin'),('2065088372988809218','2065088372913311745','M000006','台式电脑主机','2063220298813546498','BOM-PC-001','1','大',NULL,1,8888.00,'','2026-06-16','2026-06-11',1,5.00,'2026-06-14','2026-06-16','','2065088388130246658','WO20260611230653874','2026-06-11 23:06:50','admin','2026-06-11 23:06:54','admin'),('2065296593789698050','2065296593726783489','M000006','台式电脑主机','2063220298813546498','BOM-PC-001','1','大',NULL,1,11.00,'','2026-06-12','2026-06-03',1,5.00,'2026-06-10','2026-06-12','','2065296773423349761','WO20260612125456802','2026-06-12 12:54:14','admin','2026-06-12 12:54:57','admin');
/*!40000 ALTER TABLE `sp_production_order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_production_order_oper_plan`
--

DROP TABLE IF EXISTS `sp_production_order_oper_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_production_order_oper_plan` (
  `id` varchar(64) NOT NULL,
  `order_id` varchar(64) NOT NULL,
  `order_item_id` varchar(64) NOT NULL,
  `order_no` varchar(64) DEFAULT NULL,
  `product_materiel` varchar(128) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `flow_id` varchar(64) DEFAULT NULL,
  `oper_id` varchar(64) DEFAULT NULL,
  `oper` varchar(128) DEFAULT NULL,
  `oper_desc` varchar(255) DEFAULT NULL,
  `sort_num` int DEFAULT NULL,
  `unit_id` varchar(64) DEFAULT NULL,
  `plan_start_time` varchar(32) DEFAULT NULL,
  `plan_end_time` varchar(32) DEFAULT NULL,
  `duration_hours` decimal(12,2) DEFAULT NULL,
  `duration_source` varchar(32) DEFAULT NULL,
  `schedule_method` varchar(32) DEFAULT NULL,
  `calc_remark` varchar(500) DEFAULT NULL,
  `is_deleted` varchar(1) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_po_oper_plan_order` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='production order operation plan';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_production_order_oper_plan`
--

LOCK TABLES `sp_production_order_oper_plan` WRITE;
/*!40000 ALTER TABLE `sp_production_order_oper_plan` DISABLE KEYS */;
INSERT INTO `sp_production_order_oper_plan` VALUES ('2065054386532990978','2065054386243584001','2065054386415550465','SO202606117192','M000006','台式电脑主机','2063220298813546498','1336864613072928','TST-01','集成测试工序',1,NULL,'2026-06-14 18:54:00','2026-06-14 21:35:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 20:51:47','admin','2026-06-11 20:51:47','admin'),('2065054386545573890','2065054386243584001','2065054386415550465','SO202606117192','M000006','台式电脑主机','2063220298813546498','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','2026-06-14 21:35:00','2026-06-14 23:35:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 20:51:47','admin','2026-06-11 20:51:47','admin'),('2065054386553962498','2065054386243584001','2065054386415550465','SO202606117192','M000006','台式电脑主机','2063220298813546498','2063201114801053697','GX000003','机箱组装作业工序',3,'jg_unit_001','2026-06-14 23:35:00','2026-06-15 01:35:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 20:51:47','admin','2026-06-11 20:51:47','admin'),('2065054386562351106','2065054386243584001','2065054386415550465','SO202606117192','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',4,NULL,'2026-06-15 01:35:00','2026-06-15 04:16:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 20:51:47','admin','2026-06-11 20:51:47','admin'),('2065054386566545410','2065054386243584001','2065054386415550465','SO202606117192','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',5,NULL,'2026-06-15 04:16:00','2026-06-15 06:57:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 20:51:47','admin','2026-06-11 20:51:47','admin'),('2065054386583322625','2065054386243584001','2065054386415550465','SO202606117192','M000006','台式电脑主机','2063220298813546498','2063162784759685122','GX000002','主板装配作业工序',6,'jg_unit_002','2026-06-15 06:57:00','2026-06-15 08:57:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 20:51:47','admin','2026-06-11 20:51:47','admin'),('2065054386600099841','2065054386243584001','2065054386415550465','SO202606117192','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',7,NULL,'2026-06-15 08:57:00','2026-06-15 11:38:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 20:51:47','admin','2026-06-11 20:51:47','admin'),('2065054386608488449','2065054386243584001','2065054386415550465','SO202606117192','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',8,NULL,'2026-06-15 11:38:00','2026-06-15 14:19:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 20:51:47','admin','2026-06-11 20:51:47','admin'),('2065054386616877057','2065054386243584001','2065054386415550465','SO202606117192','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',9,NULL,'2026-06-15 14:19:00','2026-06-15 17:00:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 20:51:47','admin','2026-06-11 20:51:47','admin'),('2065079546162049026','2065079545897807873','2065079546019442690','SO202606115594','M000006','台式电脑主机','2063220298813546498','1336864613072928','TST-01','集成测试工序',1,NULL,'2026-06-14 18:54:00','2026-06-14 21:35:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:31:46','admin','2026-06-11 22:31:46','admin'),('2065079546174631937','2065079545897807873','2065079546019442690','SO202606115594','M000006','台式电脑主机','2063220298813546498','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','2026-06-14 21:35:00','2026-06-14 23:35:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:31:46','admin','2026-06-11 22:31:46','admin'),('2065079546183020546','2065079545897807873','2065079546019442690','SO202606115594','M000006','台式电脑主机','2063220298813546498','2063201114801053697','GX000003','机箱组装作业工序',3,'jg_unit_001','2026-06-14 23:35:00','2026-06-15 01:35:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:31:46','admin','2026-06-11 22:31:46','admin'),('2065079546187214849','2065079545897807873','2065079546019442690','SO202606115594','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',4,NULL,'2026-06-15 01:35:00','2026-06-15 04:16:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:31:46','admin','2026-06-11 22:31:46','admin'),('2065079546199797761','2065079545897807873','2065079546019442690','SO202606115594','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',5,NULL,'2026-06-15 04:16:00','2026-06-15 06:57:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:31:46','admin','2026-06-11 22:31:46','admin'),('2065079546212380674','2065079545897807873','2065079546019442690','SO202606115594','M000006','台式电脑主机','2063220298813546498','2063162784759685122','GX000002','主板装配作业工序',6,'jg_unit_002','2026-06-15 06:57:00','2026-06-15 08:57:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:31:46','admin','2026-06-11 22:31:46','admin'),('2065079546229157890','2065079545897807873','2065079546019442690','SO202606115594','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',7,NULL,'2026-06-15 08:57:00','2026-06-15 11:38:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:31:46','admin','2026-06-11 22:31:46','admin'),('2065079546237546497','2065079545897807873','2065079546019442690','SO202606115594','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',8,NULL,'2026-06-15 11:38:00','2026-06-15 14:19:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:31:46','admin','2026-06-11 22:31:46','admin'),('2065079546241740802','2065079545897807873','2065079546019442690','SO202606115594','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',9,NULL,'2026-06-15 14:19:00','2026-06-15 17:00:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:31:46','admin','2026-06-11 22:31:46','admin'),('2065085539862286338','2065085539702902786','2065085539782594562','SO2026061134640','M000006','台式电脑主机','2063220298813546498','1336864613072928','TST-01','集成测试工序',1,NULL,'2026-06-14 18:54:00','2026-06-14 21:35:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:55:35','admin','2026-06-11 22:55:35','admin'),('2065085539870674946','2065085539702902786','2065085539782594562','SO2026061134640','M000006','台式电脑主机','2063220298813546498','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','2026-06-14 21:35:00','2026-06-14 23:35:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:55:35','admin','2026-06-11 22:55:35','admin'),('2065085539874869249','2065085539702902786','2065085539782594562','SO2026061134640','M000006','台式电脑主机','2063220298813546498','2063201114801053697','GX000003','机箱组装作业工序',3,'jg_unit_001','2026-06-14 23:35:00','2026-06-15 01:35:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:55:35','admin','2026-06-11 22:55:35','admin'),('2065085539879063553','2065085539702902786','2065085539782594562','SO2026061134640','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',4,NULL,'2026-06-15 01:35:00','2026-06-15 04:16:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:55:35','admin','2026-06-11 22:55:35','admin'),('2065085539883257858','2065085539702902786','2065085539782594562','SO2026061134640','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',5,NULL,'2026-06-15 04:16:00','2026-06-15 06:57:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:55:35','admin','2026-06-11 22:55:35','admin'),('2065085539891646465','2065085539702902786','2065085539782594562','SO2026061134640','M000006','台式电脑主机','2063220298813546498','2063162784759685122','GX000002','主板装配作业工序',6,'jg_unit_002','2026-06-15 06:57:00','2026-06-15 08:57:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:55:35','admin','2026-06-11 22:55:35','admin'),('2065085539895840769','2065085539702902786','2065085539782594562','SO2026061134640','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',7,NULL,'2026-06-15 08:57:00','2026-06-15 11:38:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:55:35','admin','2026-06-11 22:55:35','admin'),('2065085539904229378','2065085539702902786','2065085539782594562','SO2026061134640','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',8,NULL,'2026-06-15 11:38:00','2026-06-15 14:19:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:55:35','admin','2026-06-11 22:55:35','admin'),('2065085539908423682','2065085539702902786','2065085539782594562','SO2026061134640','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',9,NULL,'2026-06-15 14:19:00','2026-06-15 17:00:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 22:55:35','admin','2026-06-11 22:55:35','admin'),('2065088373068500993','2065088372913311745','2065088372988809218','SO2026061110246','M000006','台式电脑主机','2063220298813546498','1336864613072928','TST-01','集成测试工序',1,'2063235743255990273','2026-06-14 22:19:00','2026-06-15 01:00:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-11 23:06:50','admin','2026-06-12 16:43:54','admin'),('2065088373076889602','2065088372913311745','2065088372988809218','SO2026061110246','M000006','台式电脑主机','2063220298813546498','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','2026-06-15 01:00:00','2026-06-15 03:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 23:06:50','admin','2026-06-11 23:06:50','admin'),('2065088373085278210','2065088372913311745','2065088372988809218','SO2026061110246','M000006','台式电脑主机','2063220298813546498','2063201114801053697','GX000003','机箱组装作业工序',3,'jg_unit_001','2026-06-15 03:00:00','2026-06-15 05:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 23:06:50','admin','2026-06-11 23:06:50','admin'),('2065088373089472513','2065088372913311745','2065088372988809218','SO2026061110246','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',4,'jg_unit_002','2026-06-15 05:00:00','2026-06-15 07:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 23:06:50','admin','2026-06-11 23:06:50','admin'),('2065088373089472514','2065088372913311745','2065088372988809218','SO2026061110246','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',5,'jg_unit_002','2026-06-15 07:00:00','2026-06-15 09:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 23:06:50','admin','2026-06-11 23:06:50','admin'),('2065088373093666818','2065088372913311745','2065088372988809218','SO2026061110246','M000006','台式电脑主机','2063220298813546498','2063162784759685122','GX000002','主板装配作业工序',6,'jg_unit_002','2026-06-15 09:00:00','2026-06-15 11:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 23:06:50','admin','2026-06-11 23:06:50','admin'),('2065088373102055425','2065088372913311745','2065088372988809218','SO2026061110246','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',7,'jg_unit_002','2026-06-15 11:00:00','2026-06-15 13:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 23:06:50','admin','2026-06-11 23:06:50','admin'),('2065088373106249730','2065088372913311745','2065088372988809218','SO2026061110246','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',8,'jg_unit_002','2026-06-15 13:00:00','2026-06-15 15:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 23:06:50','admin','2026-06-11 23:06:50','admin'),('2065088373106249731','2065088372913311745','2065088372988809218','SO2026061110246','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',9,'jg_unit_002','2026-06-15 15:00:00','2026-06-15 17:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-11 23:06:50','admin','2026-06-11 23:06:50','admin'),('2065296593919721474','2065296593726783489','2065296593789698050','SO2026061253964','M000006','台式电脑主机','2063220298813546498','1336864613072928','TST-01','集成测试工序',1,'2063235743255990273','2026-06-10 22:19:00','2026-06-11 01:00:00',2.67,'CAPACITY','REVERSE','按逆向排产生成，数量1','0','2026-06-12 12:54:14','admin','2026-06-12 16:43:54','admin'),('2065296593919721475','2065296593726783489','2065296593789698050','SO2026061253964','M000006','台式电脑主机','2063220298813546498','2063201259852668930','GX000004','主机装配作业',2,'jg_unit_001','2026-06-11 01:00:00','2026-06-11 03:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-12 12:54:14','admin','2026-06-12 12:54:14','admin'),('2065296593919721476','2065296593726783489','2065296593789698050','SO2026061253964','M000006','台式电脑主机','2063220298813546498','2063201114801053697','GX000003','机箱组装作业工序',3,'jg_unit_001','2026-06-11 03:00:00','2026-06-11 05:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-12 12:54:14','admin','2026-06-12 12:54:14','admin'),('2065296593919721477','2065296593726783489','2065296593789698050','SO2026061253964','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',4,'jg_unit_002','2026-06-11 05:00:00','2026-06-11 07:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-12 12:54:14','admin','2026-06-12 12:54:14','admin'),('2065296593919721478','2065296593726783489','2065296593789698050','SO2026061253964','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',5,'jg_unit_002','2026-06-11 07:00:00','2026-06-11 09:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-12 12:54:14','admin','2026-06-12 12:54:14','admin'),('2065296593919721479','2065296593726783489','2065296593789698050','SO2026061253964','M000006','台式电脑主机','2063220298813546498','2063162784759685122','GX000002','主板装配作业工序',6,'jg_unit_002','2026-06-11 09:00:00','2026-06-11 11:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-12 12:54:14','admin','2026-06-12 12:54:14','admin'),('2065296593919721480','2065296593726783489','2065296593789698050','SO2026061253964','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',7,'jg_unit_002','2026-06-11 11:00:00','2026-06-11 13:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-12 12:54:14','admin','2026-06-12 12:54:14','admin'),('2065296593919721481','2065296593726783489','2065296593789698050','SO2026061253964','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',8,'jg_unit_002','2026-06-11 13:00:00','2026-06-11 15:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-12 12:54:14','admin','2026-06-12 12:54:14','admin'),('2065296593919721482','2065296593726783489','2065296593789698050','SO2026061253964','M000006','台式电脑主机','2063220298813546498','1337248255574048','RK-01','入库工序',9,'jg_unit_002','2026-06-11 15:00:00','2026-06-11 17:00:00',2.00,'MANU_CYCLE','REVERSE','按逆向排产生成，数量1','0','2026-06-12 12:54:14','admin','2026-06-12 12:54:14','admin');
/*!40000 ALTER TABLE `sp_production_order_oper_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_sn_process_record`
--

DROP TABLE IF EXISTS `sp_sn_process_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_sn_process_record` (
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
  KEY `idx_sn_process_sn_order` (`sn`,`order_id`),
  KEY `idx_sn_process_order` (`order_id`),
  KEY `idx_sn_process_oper` (`oper_id`),
  KEY `idx_sn_process_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='SN process collection records';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_sn_process_record`
--

LOCK TABLES `sp_sn_process_record` WRITE;
/*!40000 ALTER TABLE `sp_sn_process_record` DISABLE KEYS */;
INSERT INTO `sp_sn_process_record` VALUES ('2065350984953565186','SN','2065296773423349761','WO20260612125456802','2063220298813546498','1336864613072928','TST-01','集成测试工序',1,'OK','','2026-06-12 16:30:22','admin','2026-06-12 16:30:22','admin'),('2065351067644268545','SN','2063887156128604161','WO20260608153255','1278145622063689729','1336864489340960','ASY-01','装配工序',1,'NG','','2026-06-12 16:30:42','admin','2026-06-12 16:30:42','admin'),('2065354758988324866','SN','2065296773423349761','WO20260612125456802','2063220298813546498','2063201259852668930','GX000004','主机装配作业',2,'OK','','2026-06-12 16:45:22','admin','2026-06-12 16:45:22','admin'),('2065357219404800001','扫描','2065296773423349761','WO20260612125456802','2063220298813546498','1336864613072928','TST-01','集成测试工序',1,'NG','','2026-06-12 16:55:08','admin','2026-06-12 16:55:08','admin'),('2065357245589839873','扫描','2065296773423349761','WO20260612125456802','2063220298813546498','1336864613072928','TST-01','集成测试工序',1,'NG','','2026-06-12 16:55:14','admin','2026-06-12 16:55:14','admin'),('2065357289390956546','扫描','2065296773423349761','WO20260612125456802','2063220298813546498','1336864613072928','TST-01','集成测试工序',1,'OK','','2026-06-12 16:55:25','admin','2026-06-12 16:55:25','admin'),('2065357300061265922','扫描','2065296773423349761','WO20260612125456802','2063220298813546498','2063201259852668930','GX000004','主机装配作业',2,'OK','','2026-06-12 16:55:27','admin','2026-06-12 16:55:27','admin'),('2065357302628179969','扫描','2065296773423349761','WO20260612125456802','2063220298813546498','2063201114801053697','GX000003','机箱组装作业工序',3,'OK','','2026-06-12 16:55:28','admin','2026-06-12 16:55:28','admin');
/*!40000 ALTER TABLE `sp_sn_process_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_sys_department`
--

DROP TABLE IF EXISTS `sp_sys_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_sys_department` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sort_num` int NOT NULL,
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_sys_department`
--

LOCK TABLES `sp_sys_department` WRITE;
/*!40000 ALTER TABLE `sp_sys_department` DISABLE KEYS */;
INSERT INTO `sp_sys_department` VALUES ('2063969323837911041','0','生成部门',1,'0','2026-06-08 21:00:08','admin','2026-06-08 21:00:08','admin');
/*!40000 ALTER TABLE `sp_sys_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_sys_dict`
--

DROP TABLE IF EXISTS `sp_sys_dict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_sys_dict` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标签名',
  `value` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '数据值',
  `type` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '描述',
  `sort_num` int NOT NULL COMMENT '排序（升序）',
  `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '父级id',
  `is_deleted` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_sp_sys_dict_name` (`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统字典表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_sys_dict`
--

LOCK TABLES `sp_sys_dict` WRITE;
/*!40000 ALTER TABLE `sp_sys_dict` DISABLE KEYS */;
INSERT INTO `sp_sys_dict` VALUES ('05d5a9e8655811f1986dbcfce7dfdd0a','原材料','RAW','material_type','物料类型-原材料',9,'\"\"','0','2026-06-11 13:40:15','admin','2026-06-11 13:40:15','admin'),('1337618042191904','成品','FG','material_type','物料类型',2,'\"\"','0','2020-03-18 13:53:06','admin','2020-03-18 13:53:06','admin'),('1337618163826720','半成品','PG','material_type','物料类型',3,'\"\"','0','2020-03-18 13:54:04','admin','2020-03-18 13:54:04','admin'),('1337618837012512','个','PCS','ORDER_UNIT','生产单位',1,'\"\"','0','2020-03-18 13:59:25','admin','2020-03-18 13:59:41','admin'),('1337618939772960','箱','BOX','ORDER_UNIT','生产单位',2,'\"\"','0','2020-03-18 14:00:14','admin','2020-03-18 14:00:14','admin'),('a2fca001616011f19c27bcfce7dfdd0a','组件','COMP','material_type','物料类型-组件',4,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2fca20d616011f19c27bcfce7dfdd0a','零件','PART','material_type','物料类型-零件',5,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a37730c4616011f19c27bcfce7dfdd0a','产品','PRODUCT','material_type','物料类型-产品',6,'\"\"','0','2026-06-06 12:31:51','admin','2026-06-06 12:31:51','admin'),('a3773104616011f19c27bcfce7dfdd0a','标准件','STD','material_type','物料类型-标准件',7,'\"\"','0','2026-06-06 12:31:51','admin','2026-06-06 12:31:51','admin'),('a3773112616011f19c27bcfce7dfdd0a','其他','OTHER','material_type','物料类型-其他',8,'\"\"','0','2026-06-06 12:31:51','admin','2026-06-06 12:31:51','admin'),('a377c1e6616011f19c27bcfce7dfdd0a','自制','SELF','material_source','物料来源-自制',1,'\"\"','0','2026-06-06 12:31:51','admin','2026-06-06 12:31:51','admin'),('a377c219616011f19c27bcfce7dfdd0a','外购','OUT','material_source','物料来源-外购',2,'\"\"','0','2026-06-06 12:31:51','admin','2026-06-06 12:31:51','admin'),('a3781be7616011f19c27bcfce7dfdd0a','铝','AL','material_texture','材质-铝',1,'\"\"','0','2026-06-06 12:31:51','admin','2026-06-06 12:31:51','admin'),('a3781c10616011f19c27bcfce7dfdd0a','铁','IRON','material_texture','材质-铁',2,'\"\"','0','2026-06-06 12:31:51','admin','2026-06-06 12:31:51','admin'),('a3781c1e616011f19c27bcfce7dfdd0a','纸质','PAPER','material_texture','材质-纸质',3,'\"\"','0','2026-06-06 12:31:51','admin','2026-06-06 12:31:51','admin'),('a3781c2a616011f19c27bcfce7dfdd0a','其他','OTHER','material_texture','材质-其他',4,'\"\"','0','2026-06-06 12:31:51','admin','2026-06-06 12:31:51','admin'),('a3787c56616011f19c27bcfce7dfdd0a','套','SET','ORDER_UNIT','生产单位',3,'\"\"','0','2026-06-06 12:31:51','admin','2026-06-06 12:31:51','admin'),('roledict001','员工','employee','user_type','用户类型-员工',1,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('roledict002','管理员','manager','user_type','用户类型-管理员',2,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('roledict011','普通角色','normal','role_category','角色分类-普通角色',1,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('roledict012','系统角色','system','role_category','角色分类-系统角色',2,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('roledict021','全部数据','all','data_scope','数据范围-全部',1,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('roledict022','本部门','dept','data_scope','数据范围-本部门',2,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('roledict023','本部门及子部门','dept_child','data_scope','数据范围-本部门及子部门',3,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('roledict024','仅本人','self','data_scope','数据范围-仅本人',4,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('roledict031','全部业务','all','business_scope','业务范围-全部',1,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('roledict032','本部门业务','dept','business_scope','业务范围-本部门',2,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('roledict033','指定业务模块','specified','business_scope','业务范围-指定模块',3,'\"\"','0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin');
/*!40000 ALTER TABLE `sp_sys_dict` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_sys_menu`
--

DROP TABLE IF EXISTS `sp_sys_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_sys_menu` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单URL',
  `parent_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '父菜单ID，一级菜单设为0',
  `grade` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '层级：1级、2级、3级......',
  `sort_num` int NOT NULL COMMENT '排序',
  `type` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类型：0 目录；1 菜单；2 按钮',
  `permission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '授权(多个用逗号分隔，如：sys:menu:list,sys:menu:create)',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '菜单图标',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '描述',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_sp_sys_menu_name` (`name`) USING BTREE,
  UNIQUE KEY `idx_sp_sys_menu_code` (`code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='系统菜单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_sys_menu`
--

LOCK TABLES `sp_sys_menu` WRITE;
/*!40000 ALTER TABLE `sp_sys_menu` DISABLE KEYS */;
INSERT INTO `sp_sys_menu` VALUES ('1','currency','常规管理','#','0','1',1,'0','user:add','fa fa-address-book','','2019-10-18 11:18:29','SongPeng','2026-06-11 13:55:23','admin'),('10','system','系统管理','#','1','2',1,'0','user:add','fa fa-gears','','2019-10-18 11:18:29','SongPeng','2026-06-12 17:10:22','admin'),('101','menu','菜单管理','/admin/sys/menu/list-ui','10','3',1,'0','user:add','fa fa-bars','','2019-10-18 11:18:29','SongPeng','2026-06-11 13:55:23','admin'),('102','user','用户管理','/admin/sys/user/list-ui','10','3',2,'0','user:add','fa fa-user','','2019-10-18 11:18:29','SongPeng','2026-06-11 13:55:23','admin'),('103','role','角色管理','/admin/sys/role/list-ui','10','3',3,'0','user:add','fa fa-child','','2019-10-18 11:18:29','SongPeng','2026-06-11 13:55:23','admin'),('104','department','部门管理','/admin/sys/department/list-ui','10','3',4,'0','user:add','fa fa-sitemap','','2019-10-18 11:18:29','SongPeng','2026-06-11 13:55:23','admin'),('12','order','计划管理','','1','2',8,'0','user:add','fa fa-calendar','','2019-10-18 11:18:29','Wangziyang','2026-06-12 17:10:22','admin'),('121','orderRelease','工单下达','/order/release/list-ui','12','3',1,'0','user:add','fa fa-flag-o','','2019-10-18 11:18:29','Wangziyang','2026-06-11 13:55:23','admin'),('13','materiel','物料管理','#','legacy_hidden','2',99,'0','user:add','fa fa-cubes','','2019-10-18 11:18:29','Wangziyang','2026-06-11 13:55:23','admin'),('131','matdef','物料信息定义','/basedata/materile/list-ui','prod_data_center','3',1,'0','user:add','fa fa-microchip','','2019-10-18 11:18:29','SongPeng','2026-06-11 13:55:23','admin'),('132','processing_unit','加工单元定义','/basedata/processing-unit/list-ui','base_data_center','3',5,'0','user:add','fa fa-cog','加工单元主数据','2026-06-06 12:31:50','admin','2026-06-11 13:55:23','admin'),('133','equipment','设备','/basedata/equipment/list-ui','base_data_center','3',4,'0','user:add','fa fa-wrench','设备主数据','2026-06-06 12:31:50','admin','2026-06-11 13:55:23','admin'),('14','Digitalplatform','数字化平台','#','1','2',10,'0','user:add','fa fa-pie-chart','','2019-10-18 11:18:29','Wangziyang','2026-06-12 17:10:22','admin'),('141','plandg','智慧大屏','/digitization/plan/plan-ui','14','3',1,'0','user:add','fa fa-desktop','','2019-10-18 11:18:29','SongPeng','2026-06-11 13:55:23','admin'),('15','ProcessManage','工艺管理中心','','1','2',4,'0','user:add','fa fa-wrench','工艺管理中心','2019-10-18 11:18:29','Wangziyang','2026-06-12 17:10:22','admin'),('151','flowProcess','工艺路线管理','/basedata/flow/process/list-ui','15','3',2,'0','user:add','fa fa-retweet','','2019-10-18 11:18:29','Wangziyang','2026-06-11 13:55:23','admin'),('152','bom','工艺BOM管理','/technology/bom/list-ui','prod_data_center','3',3,'0','user:add','fa fa-file-text-o','','2019-10-18 11:18:29','Wangziyang','2026-06-11 13:55:23','admin'),('153','sp_oper_def','工序信息定义','/technology/oper/list-ui','15','3',1,'0','user:add','fa fa-thumb-tack','工序信息定义','2026-06-06 12:31:50','admin','2026-06-11 13:55:23','admin'),('154','process_route','工艺流程管理','/technology/process-route/tree-ui','15','3',3,'0','user:add','fa fa-sitemap','工艺流程管理','2026-06-06 12:31:50','admin','2026-06-11 13:55:23','admin'),('155','process_content','工艺内容编制','/technology/process-content/tree-ui','15','3',4,'0','user:add','fa fa-edit','工艺内容编制','2026-06-06 12:31:50','admin','2026-06-11 13:55:23','admin'),('156','process_query','产品工艺查询','/technology/process-query/tree-ui','15','3',5,'0','user:add','fa fa-search','产品工艺查询','2026-06-06 12:31:50','admin','2026-06-11 13:55:23','admin'),('16','wip','在制品管理','#','1','2',9,'0','user:add','fa fa-industry','','2019-10-18 11:18:29','SongPeng','2026-06-12 17:10:22','admin'),('161','generalSnProcess','SN通用过程采集','/wip/sn-process/list-ui','16','3',1,'0','user:add','fa fa-barcode','','2019-10-18 11:18:29','SongPeng','2026-06-11 13:55:23','admin'),('17','DigitalSimulation','黑科数字孪生','#','1','2',11,'0','user:add','fa fa-ravelry','','2019-10-18 11:18:29','Wangziyang','2026-06-12 17:10:22','admin'),('171','DigitalSimulationFrom','数字仿真3D仓库','/digital/simulation/list-ui','17','3',1,'0','user:add','fa fa-codepen','','2019-10-18 11:18:29','Wangziyang','2026-06-11 13:55:23','admin'),('2','component','OPC操作','#','0','1',90,'0','user:add','fa fa-lemon-o','','2019-10-18 11:18:29','SongPeng','2026-06-11 13:55:23','admin'),('3','other','其他管理','#','0','1',99,'0','user:add','fa fa-slideshare','','2019-10-18 11:18:29','SongPeng','2026-06-11 13:55:23','admin'),('banzu_def','banzuDef','班组员工定义','/basedata/team/list-ui','base_data_center','3',1,'0','user:add','fa fa-users','班组员工定义','2026-06-06 12:31:50','admin','2026-06-11 13:55:23','admin'),('base_data_center','baseDataCenter','基础数据中心','#','1','2',2,'0','user:add','fa fa-database','基础数据中心','2026-06-06 12:31:50','admin','2026-06-12 17:10:22','admin'),('bianzu_def','bianzuDef','编组设备定义','/basedata/equipment-group/list-ui','base_data_center','3',2,'0','user:add','fa fa-wrench','编组设备定义','2026-06-06 12:31:50','admin','2026-06-11 13:55:23','admin'),('cangku_def','cangkuDef','库房库位定义','/basedata/warehouse/list-ui','base_data_center','3',3,'0','user:add','fa fa-cube','库房库位定义','2026-06-06 12:31:51','admin','2026-06-11 13:55:23','admin'),('component_def','componentDef','零部件定义','/technology/component/list-ui','prod_data_center','3',2,'0','user:add','fa fa-cubes','零部件定义','2026-06-06 13:13:28','admin','2026-06-11 13:55:23','admin'),('inventory_mgmt','inventoryMgmt','库存管理','/basedata/inventory/list-ui','base_data_center','3',3,'0','user:add','fa fa-archive','库存管理','2026-06-11 13:55:23','admin','2026-06-11 13:55:23','admin'),('llm_bom_gen','llmBomGen','AI智能建模','/llm/bom-gen/gen-ui','llm_center','3',2,'0','user:add','fa fa-sitemap','AI生成BOM/工艺/工单分步向导','2026-06-11 13:55:23','admin','2026-06-11 13:55:23','admin'),('llm_center','llmCenter','智能助手中心','#','1','2',12,'0','user:add','fa fa-magic','智能助手中心','2026-06-11 13:55:23','admin','2026-06-12 17:10:22','admin'),('llm_chat','llmChat','智能数据助手','/llm/chat/chat-ui','llm_center','3',1,'0','user:add','fa fa-comments','智能数据助手','2026-06-11 13:55:23','admin','2026-06-11 13:55:23','admin'),('mat_info_def','matInfoDef','matInfoDefHidden','/basedata/materile/list-ui','legacy_hidden','3',99,'0','user:add','fa fa-info-circle','物料信息定义','2026-06-06 12:31:51','admin','2026-06-11 13:55:23','admin'),('material_inbound_request','materialInboundRequest','入库申请单','/production-order/material-plan/inbound-request/list-ui','production_order_center','3',6,'0','productionOrder:inboundRequest','fa fa-archive','入库申请单','2026-06-12 10:52:03','admin','2026-06-12 17:10:22','admin'),('material_requirement_plan','materialRequirementPlan','物料需求计划(明细)','/production-order/material-plan/list-ui','production_order_center','3',4,'0','productionOrder:materialPlan','fa fa-cubes','物料需求计划明细','2026-06-12 10:52:03','admin','2026-06-12 17:10:22','admin'),('material_requirement_week','materialRequirementWeek','物料需求计划(按周)','/production-order/material-plan/week-ui','production_order_center','3',5,'0','productionOrder:materialPlanWeek','fa fa-calendar','物料需求计划按周汇总','2026-06-12 10:52:03','admin','2026-06-12 17:10:22','admin'),('mes_data_center','mesDataCenter','智能制造数据中心','/digitization/dashboard/screen-ui','14','3',2,'0','user:add','fa fa-line-chart','智能制造数据中心','2026-06-11 13:55:23','admin','2026-06-11 13:55:23','admin'),('prod_data_center','prodDataCenter','产品数据中心','#','1','2',3,'0','user:add','fa fa-cubes','生产数据中心','2026-06-06 12:31:51','admin','2026-06-12 17:10:22','admin'),('production_employee_dispatch','productionEmployeeDispatch','员工作业派工','/production-order/employee-dispatch/list-ui','production_order_center','3',3,'0','productionOrder:employeeDispatch','fa fa-users','员工作业派工','2026-06-11 22:28:14','admin','2026-06-12 17:10:22','admin'),('production_equipment_dispatch','productionEquipmentDispatch','设备作业派工','/production-order/equipment-dispatch/list-ui','production_order_center','3',2,'0','productionOrder:equipmentDispatch','fa fa-cogs','设备作业派工','2026-06-11 22:28:14','admin','2026-06-12 17:10:22','admin'),('production_order_center','productionOrderCenter','生产计划中心','#','1','2',7,'0','productionOrder:view','fa fa-calendar-check-o','生产计划中心','2026-06-11 19:08:04','admin','2026-06-12 17:10:22','admin'),('production_order_plan','productionOrderPlan','生产订单录入','/production-order/plan/list-ui','production_order_center','3',1,'0','productionOrder:plan','fa fa-pencil-square-o','生产订单录入','2026-06-11 19:08:04','admin','2026-06-12 17:10:22','admin'),('production_plan_dispatch','productionPlanDispatch','生产计划下发','/production-order/dispatch/list-ui','production_order_center','3',7,'0','productionOrder:dispatch','fa fa-send','生产计划下发','2026-06-11 22:28:14','admin','2026-06-12 17:10:22','admin'),('production_work_order_query','productionWorkOrderQuery','生产工单查询','/production-order/work-order/list-ui','production_order_center','3',8,'0','productionOrder:workOrder','fa fa-list-alt','生产工单查询','2026-06-11 22:28:14','admin','2026-06-12 17:10:22','admin'),('warehouse_inventory_detail','warehouseInventoryDetail','库存明细查询','/warehouse/inventory/detail/list-ui','warehouse_management_center','3',7,'0','warehouse:inventory:detail','fa fa-list','库存明细查询','2026-06-12 14:34:17','admin','2026-06-12 17:10:22','admin'),('warehouse_kitting_out_confirm','warehouseKittingOutConfirm','配套出库确认','/warehouse/kitting-outbound/confirm/list-ui','warehouse_management_center','3',6,'0','warehouse:kittingOut:confirm','fa fa-cubes','配套出库确认','2026-06-12 14:34:17','admin','2026-06-12 17:10:22','admin'),('warehouse_ledger','warehouseLedger','库房台账查询','/warehouse/ledger/list-ui','warehouse_management_center','3',8,'0','warehouse:ledger','fa fa-book','库房台账查询','2026-06-12 14:34:17','admin','2026-06-12 17:10:22','admin'),('warehouse_management_center','warehouseManagementCenter','库房管理中心','#','1','2',5,'0','warehouse:view','fa fa-industry','库房管理中心','2026-06-12 14:34:17','admin','2026-06-12 17:10:22','admin'),('warehouse_manual_in_apply','warehouseManualInApply','手工入库申请','/warehouse/manual-inbound/apply/list-ui','warehouse_management_center','3',1,'0','warehouse:manualIn:apply','fa fa-sign-in','手工入库申请','2026-06-12 14:34:17','admin','2026-06-12 17:10:22','admin'),('warehouse_manual_in_confirm','warehouseManualInConfirm','手工入库确认','/warehouse/manual-inbound/confirm/list-ui','warehouse_management_center','3',2,'0','warehouse:manualIn:confirm','fa fa-check-square-o','手工入库确认','2026-06-12 14:34:17','admin','2026-06-12 17:10:22','admin'),('warehouse_manual_out_apply','warehouseManualOutApply','手工出库申请','/warehouse/manual-outbound/apply/list-ui','warehouse_management_center','3',4,'0','warehouse:manualOut:apply','fa fa-sign-out','手工出库申请','2026-06-12 14:34:17','admin','2026-06-12 17:10:22','admin'),('warehouse_manual_out_confirm','warehouseManualOutConfirm','手工出库确认','/warehouse/manual-outbound/confirm/list-ui','warehouse_management_center','3',5,'0','warehouse:manualOut:confirm','fa fa-check','手工出库确认','2026-06-12 14:34:17','admin','2026-06-12 17:10:22','admin'),('warehouse_plan_in_confirm','warehousePlanInConfirm','计划入库确认','/warehouse/plan-inbound/confirm/list-ui','warehouse_management_center','3',3,'0','warehouse:planIn:confirm','fa fa-archive','计划入库确认','2026-06-12 14:34:17','admin','2026-06-12 17:10:22','admin'),('warehouse_transaction','warehouseTransaction','出入库流水查询','/warehouse/transaction/list-ui','warehouse_management_center','3',9,'0','warehouse:transaction','fa fa-exchange','出入库流水查询','2026-06-12 14:34:17','admin','2026-06-12 17:10:22','admin'),('workflow_category','workflowCategory','流程分类管理','/workflow/category/list-ui','workflow_control','4',1,'0','user:add','fa fa-tags','流程分类管理','2026-06-11 15:20:13','admin','2026-06-12 17:10:22','admin'),('workflow_control','workflowControl','流程管控','#','workflow_tool','3',2,'0','user:add','fa fa-random','流程管控','2026-06-11 15:20:13','admin','2026-06-12 17:10:22','admin'),('workflow_definition','workflowDefinition','流程定义管理','/workflow/definition/list-ui','workflow_control','4',3,'0','user:add','fa fa-code-fork','流程定义管理','2026-06-11 15:20:13','admin','2026-06-12 17:10:22','admin'),('workflow_handle','workflowHandle','流程办理','/workflow/handle/list-ui','workflow_tool','3',1,'0','user:add','fa fa-check-square-o','流程办理','2026-06-11 21:23:27','admin','2026-06-12 17:10:22','admin'),('workflow_instance','workflowInstance','流程实例管理','/workflow/instance/list-ui','workflow_control','4',4,'0','user:add','fa fa-history','流程实例管理','2026-06-11 15:20:13','admin','2026-06-12 17:10:22','admin'),('workflow_model','workflowModel','流程模型设计','/workflow/model/list-ui','workflow_control','4',2,'0','user:add','fa fa-object-group','流程模型设计','2026-06-11 15:20:13','admin','2026-06-12 17:10:22','admin'),('workflow_task','workflowTask','流程任务管理','/workflow/task/list-ui','workflow_control','4',5,'0','user:add','fa fa-check-square-o','流程任务管理','2026-06-11 15:20:13','admin','2026-06-12 17:10:22','admin'),('workflow_tool','workflowTool','流程配置工具','#','1','2',6,'0','user:add','fa fa-sitemap','流程配置工具','2026-06-11 15:29:16','admin','2026-06-12 17:10:22','admin');
/*!40000 ALTER TABLE `sp_sys_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_sys_role`
--

DROP TABLE IF EXISTS `sp_sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_sys_role` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `code` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色编码',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '角色描述',
  `sort_num` int NOT NULL DEFAULT '0' COMMENT '排序号',
  `is_system_role` char(1) NOT NULL DEFAULT '0' COMMENT '系统角色(0否1是)',
  `user_type` varchar(32) DEFAULT NULL COMMENT '用户类型',
  `role_category` varchar(32) DEFAULT NULL COMMENT '角色分类',
  `data_scope` varchar(32) DEFAULT NULL COMMENT '数据范围',
  `business_scope` varchar(32) DEFAULT NULL COMMENT '业务范围',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_sp_sys_role_name` (`name`) USING BTREE,
  UNIQUE KEY `idx_sp_sys_role_code` (`code`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='角色表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_sys_role`
--

LOCK TABLES `sp_sys_role` WRITE;
/*!40000 ALTER TABLE `sp_sys_role` DISABLE KEYS */;
INSERT INTO `sp_sys_role` VALUES ('1185025876737396738','超级管理员','admin','超级管理员',0,'0',NULL,NULL,NULL,NULL,'0','2019-10-18 10:52:40','SongPeng','2020-03-13 14:06:43','admin'),('1232532514523213826','体验者123','experience','体验者',0,'0',NULL,NULL,NULL,NULL,'0','2020-02-26 13:07:05','admin','2020-06-03 15:05:59','admin'),('1274963902774620161','12','12','12',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:14:17','admin','2020-06-22 15:14:17','admin'),('1274963930100510721','1212','1212','1212',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:14:23','admin','2020-06-22 15:14:23','admin'),('1274963986383876098','1311','121','111',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:14:37','admin','2020-06-22 15:14:37','admin'),('1274964058609790977','12121212','12121','1212',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:14:54','admin','2020-06-22 15:14:54','admin'),('1274964096777957377','1313','12121212','121212',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:15:03','admin','2020-06-22 15:15:03','admin'),('1274964138322538497','331','1222','22',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:15:13','admin','2026-06-08 16:25:43','admin'),('1274964176301961218','1211','1111','1111',0,'0','employee','normal','本部门','本部门业务','0','2020-06-22 15:15:22','admin','2026-06-08 16:25:38','admin'),('1274964233344495618','443','333','3',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:15:36','admin','2026-06-08 16:26:27','admin'),('1280124406522425346','11','11','11',0,'0',NULL,NULL,'本部门及子部门','全部业务','0','2020-07-06 21:00:17','admin','2026-06-08 18:58:54','admin'),('1281217564303929346','2315','4324','42342',0,'0',NULL,NULL,'全部','全部业务','0','2020-07-09 21:24:06','admin','2026-06-08 16:26:33','admin'),('1336542182244384','王子杨','123','王子杨',0,'0',NULL,NULL,NULL,NULL,'0','2020-03-12 15:22:56','admin','2020-03-12 15:22:56','admin'),('2063895254591418370','张三','11111111','',11,'0','employee','normal',NULL,NULL,'0','2026-06-08 16:05:49','admin','2026-06-08 16:05:49','admin'),('r_mes_001','数据员','baseDataRole','基础数据管理角色，负责物料、基础配置等数据维护',10,'0','employee','normal',NULL,NULL,'0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('r_mes_002','工艺员','technologyRole','产品工艺管理角色，负责BOM和工艺路线维护',20,'0','employee','normal',NULL,NULL,'0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('r_mes_003','生产计划员','productionPlannerRole','生产计划管理角色，负责工单下达和生产计划',30,'0','employee','normal',NULL,NULL,'0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('r_mes_004','生产主管','productionManagerRole','生产及设备管理角色，负责生产计划和设备管理',40,'0','employee','normal',NULL,NULL,'0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('r_mes_005','生产作业员','productionOperatorRole','生产执行角色，负责在制品过程采集和生产执行',50,'0','employee','normal',NULL,NULL,'0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('r_mes_006','库房管理员','warehouseManagerRole','库房管理角色，负责库存和物料出入库管理',60,'0','employee','normal',NULL,NULL,'0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('r_mes_007','质量管理员','qualityManagerRole','质量管理角色，负责质量检验和质量报表',70,'0','employee','normal',NULL,NULL,'0','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin');
/*!40000 ALTER TABLE `sp_sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_sys_role_menu`
--

DROP TABLE IF EXISTS `sp_sys_role_menu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_sys_role_menu` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `role_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色id',
  `menu_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='角色对应的菜单表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_sys_role_menu`
--

LOCK TABLES `sp_sys_role_menu` WRITE;
/*!40000 ALTER TABLE `sp_sys_role_menu` DISABLE KEYS */;
INSERT INTO `sp_sys_role_menu` VALUES ('1','1185025876737396738','1','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('2','1185025876737396738','2','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('2063875828848615425','1281217564303929346','base_data_center','2026-06-08 14:48:37','admin','2026-06-08 14:48:37','admin'),('2063875828848615426','1281217564303929346','banzu_def','2026-06-08 14:48:37','admin','2026-06-08 14:48:37','admin'),('2063875828911529985','1281217564303929346','bianzu_def','2026-06-08 14:48:37','admin','2026-06-08 14:48:37','admin'),('2063875828911529986','1281217564303929346','cangku_def','2026-06-08 14:48:37','admin','2026-06-08 14:48:37','admin'),('2063875828911529987','1281217564303929346','133','2026-06-08 14:48:37','admin','2026-06-08 14:48:37','admin'),('2063875828911529988','1281217564303929346','132','2026-06-08 14:48:37','admin','2026-06-08 14:48:37','admin'),('2063895325479350274','1274964176301961218','1','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325479350275','1274964176301961218','base_data_center','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325479350276','1274964176301961218','banzu_def','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325479350277','1274964176301961218','bianzu_def','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325479350278','1274964176301961218','cangku_def','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325479350279','1274964176301961218','133','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325542264834','1274964176301961218','132','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325542264835','1274964176301961218','prod_data_center','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325542264836','1274964176301961218','131','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325542264837','1274964176301961218','component_def','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325542264838','1274964176301961218','152','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325542264839','1274964176301961218','15','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325542264840','1274964176301961218','153','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325542264841','1274964176301961218','151','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325542264842','1274964176301961218','156','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325542264843','1274964176301961218','12','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325605179394','1274964176301961218','121','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325605179395','1274964176301961218','16','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325605179396','1274964176301961218','161','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325605179397','1274964176301961218','14','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325605179398','1274964176301961218','141','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325605179399','1274964176301961218','17','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325605179400','1274964176301961218','171','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325605179401','1274964176301961218','10','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325605179402','1274964176301961218','101','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325605179403','1274964176301961218','102','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325672288257','1274964176301961218','103','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325672288258','1274964176301961218','104','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063895325672288261','1274964176301961218','2','2026-06-08 16:06:06','admin','2026-06-08 16:06:06','admin'),('2063900537426329601','1274964233344495618','10','2026-06-08 16:26:48','admin','2026-06-08 16:26:48','admin'),('2063900537489244162','1274964233344495618','101','2026-06-08 16:26:48','admin','2026-06-08 16:26:48','admin'),('2063900537489244163','1274964233344495618','102','2026-06-08 16:26:48','admin','2026-06-08 16:26:48','admin'),('2063900537489244165','1274964233344495618','103','2026-06-08 16:26:48','admin','2026-06-08 16:26:48','admin'),('2063900537556353025','1274964233344495618','104','2026-06-08 16:26:48','admin','2026-06-08 16:26:48','admin'),('3','1185025876737396738','3','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('39158f88632611f19c27bcfce7dfdd0a','r_mes_006','12','2026-06-08 18:38:44','admin','2026-06-08 18:38:44','admin'),('39158fbb632611f19c27bcfce7dfdd0a','r_mes_006','121','2026-06-08 18:38:44','admin','2026-06-08 18:38:44','admin'),('4','1185025876737396738','101','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('40bfaeac656711f1986dbcfce7dfdd0a','r_mes_006','workflow_tool','2026-06-11 15:29:16','admin','2026-06-11 15:29:16','admin'),('40bfaf6f656711f1986dbcfce7dfdd0a','1185025876737396738','workflow_tool','2026-06-11 15:29:16','admin','2026-06-11 15:29:16','admin'),('5','1185025876737396738','102','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('6','1185025876737396738','103','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('7','1185025876737396738','104','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('73b868c1616611f19c27bcfce7dfdd0a','r_mes_002','component_def','2026-06-06 13:13:28','admin','2026-06-06 13:13:28','admin'),('99359a7a616611f19c27bcfce7dfdd0a','1185025876737396738','component_def','2026-06-06 13:14:31','admin','2026-06-06 13:14:31','admin'),('a2e55c9b616011f19c27bcfce7dfdd0a','r_mes_001','1','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e55cdd616011f19c27bcfce7dfdd0a','r_mes_001','131','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e55d1a616011f19c27bcfce7dfdd0a','r_mes_001','13','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e55d5a616011f19c27bcfce7dfdd0a','r_mes_001','10','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e5ec81616011f19c27bcfce7dfdd0a','r_mes_002','152','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e5ee13616011f19c27bcfce7dfdd0a','r_mes_002','1','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e5ee66616011f19c27bcfce7dfdd0a','r_mes_002','151','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e5eea8616011f19c27bcfce7dfdd0a','r_mes_002','15','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e6777a616011f19c27bcfce7dfdd0a','r_mes_003','1','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e678e9616011f19c27bcfce7dfdd0a','r_mes_003','12','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e6793b616011f19c27bcfce7dfdd0a','r_mes_003','121','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e71128616011f19c27bcfce7dfdd0a','r_mes_004','1','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e712fd616011f19c27bcfce7dfdd0a','r_mes_004','12','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e7135c616011f19c27bcfce7dfdd0a','r_mes_004','121','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e713a4616011f19c27bcfce7dfdd0a','r_mes_004','141','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e7a67e616011f19c27bcfce7dfdd0a','r_mes_005','1','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e7a7c2616011f19c27bcfce7dfdd0a','r_mes_005','161','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e7a818616011f19c27bcfce7dfdd0a','r_mes_005','16','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e82870616011f19c27bcfce7dfdd0a','r_mes_006','1','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e829ba616011f19c27bcfce7dfdd0a','r_mes_006','131','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e82a0c616011f19c27bcfce7dfdd0a','r_mes_006','13','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e8beef616011f19c27bcfce7dfdd0a','r_mes_007','1','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a2e8c08d616011f19c27bcfce7dfdd0a','r_mes_007','141','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a334a397616011f19c27bcfce7dfdd0a','r_mes_002','153','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a334a3d0616011f19c27bcfce7dfdd0a','r_mes_002','154','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a334a3e9616011f19c27bcfce7dfdd0a','r_mes_002','155','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a334a3ff616011f19c27bcfce7dfdd0a','r_mes_002','156','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a33567ac616011f19c27bcfce7dfdd0a','r_mes_001','132','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('a33567f9616011f19c27bcfce7dfdd0a','r_mes_001','133','2026-06-06 12:31:50','admin','2026-06-06 12:31:50','admin'),('b1014513660911f1986dbcfce7dfdd0a','r_mes_006','material_inbound_request','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b101458b660911f1986dbcfce7dfdd0a','r_mes_003','material_inbound_request','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b1014597660911f1986dbcfce7dfdd0a','r_mes_004','material_inbound_request','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b10145a0660911f1986dbcfce7dfdd0a','1185025876737396738','material_inbound_request','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b101460a660911f1986dbcfce7dfdd0a','r_mes_006','material_requirement_plan','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b1014612660911f1986dbcfce7dfdd0a','r_mes_003','material_requirement_plan','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b1014619660911f1986dbcfce7dfdd0a','r_mes_004','material_requirement_plan','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b1014621660911f1986dbcfce7dfdd0a','1185025876737396738','material_requirement_plan','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b1014643660911f1986dbcfce7dfdd0a','r_mes_006','material_requirement_week','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b101464b660911f1986dbcfce7dfdd0a','r_mes_003','material_requirement_week','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b1014652660911f1986dbcfce7dfdd0a','r_mes_004','material_requirement_week','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b1014659660911f1986dbcfce7dfdd0a','1185025876737396738','material_requirement_week','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b101467a660911f1986dbcfce7dfdd0a','r_mes_006','production_employee_dispatch','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b10146ab660911f1986dbcfce7dfdd0a','r_mes_006','production_equipment_dispatch','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b10146db660911f1986dbcfce7dfdd0a','r_mes_006','production_order_center','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b1014705660911f1986dbcfce7dfdd0a','r_mes_006','production_order_plan','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b101472c660911f1986dbcfce7dfdd0a','r_mes_006','production_plan_dispatch','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b1014754660911f1986dbcfce7dfdd0a','r_mes_006','production_work_order_query','2026-06-12 10:52:03','admin','2026-06-12 10:52:03','admin'),('b727cdbb630211f19c27bcfce7dfdd0a','1185025876737396738','161','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727ce06630211f19c27bcfce7dfdd0a','1185025876737396738','156','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727ce1d630211f19c27bcfce7dfdd0a','1185025876737396738','prod_data_center','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727ce33630211f19c27bcfce7dfdd0a','1185025876737396738','132','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727ce43630211f19c27bcfce7dfdd0a','1185025876737396738','16','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727ce52630211f19c27bcfce7dfdd0a','1185025876737396738','base_data_center','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727ce7d630211f19c27bcfce7dfdd0a','1185025876737396738','121','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727ce90630211f19c27bcfce7dfdd0a','1185025876737396738','153','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727ce9d630211f19c27bcfce7dfdd0a','1185025876737396738','152','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727ceab630211f19c27bcfce7dfdd0a','1185025876737396738','155','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727ceb8630211f19c27bcfce7dfdd0a','1185025876737396738','154','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727cec6630211f19c27bcfce7dfdd0a','1185025876737396738','15','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727ced4630211f19c27bcfce7dfdd0a','1185025876737396738','151','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727cef0630211f19c27bcfce7dfdd0a','1185025876737396738','cangku_def','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727ceff630211f19c27bcfce7dfdd0a','1185025876737396738','171','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727cf0d630211f19c27bcfce7dfdd0a','1185025876737396738','14','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727cf1a630211f19c27bcfce7dfdd0a','1185025876737396738','141','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727cf37630211f19c27bcfce7dfdd0a','1185025876737396738','131','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727cf4b630211f19c27bcfce7dfdd0a','1185025876737396738','banzu_def','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727cf67630211f19c27bcfce7dfdd0a','1185025876737396738','10','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727cf76630211f19c27bcfce7dfdd0a','1185025876737396738','bianzu_def','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727cfa0630211f19c27bcfce7dfdd0a','1185025876737396738','12','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727cfae630211f19c27bcfce7dfdd0a','1185025876737396738','133','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('b727cfd3630211f19c27bcfce7dfdd0a','1185025876737396738','17','2026-06-08 14:24:33','admin','2026-06-08 14:24:33','admin'),('bb337a69659811f1986dbcfce7dfdd0a','r_mes_006','workflow_handle','2026-06-11 21:23:27','admin','2026-06-11 21:23:27','admin'),('bb337a93659811f1986dbcfce7dfdd0a','1185025876737396738','workflow_handle','2026-06-11 21:23:27','admin','2026-06-11 21:23:27','admin'),('bcbab008662811f1986dbcfce7dfdd0a','r_mes_006','warehouse_inventory_detail','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab03c662811f1986dbcfce7dfdd0a','r_mes_004','warehouse_inventory_detail','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab047662811f1986dbcfce7dfdd0a','1185025876737396738','warehouse_inventory_detail','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab075662811f1986dbcfce7dfdd0a','r_mes_006','warehouse_kitting_out_confirm','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab07d662811f1986dbcfce7dfdd0a','r_mes_004','warehouse_kitting_out_confirm','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab085662811f1986dbcfce7dfdd0a','1185025876737396738','warehouse_kitting_out_confirm','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab0a3662811f1986dbcfce7dfdd0a','r_mes_006','warehouse_ledger','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab0ac662811f1986dbcfce7dfdd0a','r_mes_004','warehouse_ledger','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab0b4662811f1986dbcfce7dfdd0a','1185025876737396738','warehouse_ledger','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab0d5662811f1986dbcfce7dfdd0a','r_mes_006','warehouse_management_center','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab0e4662811f1986dbcfce7dfdd0a','r_mes_004','warehouse_management_center','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab0ec662811f1986dbcfce7dfdd0a','1185025876737396738','warehouse_management_center','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab10c662811f1986dbcfce7dfdd0a','r_mes_006','warehouse_manual_in_apply','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab114662811f1986dbcfce7dfdd0a','r_mes_004','warehouse_manual_in_apply','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab11b662811f1986dbcfce7dfdd0a','1185025876737396738','warehouse_manual_in_apply','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab139662811f1986dbcfce7dfdd0a','r_mes_006','warehouse_manual_in_confirm','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab141662811f1986dbcfce7dfdd0a','r_mes_004','warehouse_manual_in_confirm','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab148662811f1986dbcfce7dfdd0a','1185025876737396738','warehouse_manual_in_confirm','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab166662811f1986dbcfce7dfdd0a','r_mes_006','warehouse_manual_out_apply','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab16e662811f1986dbcfce7dfdd0a','r_mes_004','warehouse_manual_out_apply','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab175662811f1986dbcfce7dfdd0a','1185025876737396738','warehouse_manual_out_apply','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab195662811f1986dbcfce7dfdd0a','r_mes_006','warehouse_manual_out_confirm','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab19d662811f1986dbcfce7dfdd0a','r_mes_004','warehouse_manual_out_confirm','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab1a4662811f1986dbcfce7dfdd0a','1185025876737396738','warehouse_manual_out_confirm','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab1c0662811f1986dbcfce7dfdd0a','r_mes_006','warehouse_plan_in_confirm','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab1c8662811f1986dbcfce7dfdd0a','r_mes_004','warehouse_plan_in_confirm','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab1d0662811f1986dbcfce7dfdd0a','1185025876737396738','warehouse_plan_in_confirm','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab1ed662811f1986dbcfce7dfdd0a','r_mes_006','warehouse_transaction','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab1f6662811f1986dbcfce7dfdd0a','r_mes_004','warehouse_transaction','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('bcbab1fd662811f1986dbcfce7dfdd0a','1185025876737396738','warehouse_transaction','2026-06-12 14:34:17','admin','2026-06-12 14:34:17','admin'),('c8166e6e65a111f1986dbcfce7dfdd0a','1185025876737396738','production_employee_dispatch','2026-06-11 22:28:14','admin','2026-06-11 22:28:14','admin'),('c8166ec465a111f1986dbcfce7dfdd0a','1185025876737396738','production_equipment_dispatch','2026-06-11 22:28:14','admin','2026-06-11 22:28:14','admin'),('c8166f1b65a111f1986dbcfce7dfdd0a','1185025876737396738','production_plan_dispatch','2026-06-11 22:28:14','admin','2026-06-11 22:28:14','admin'),('c8166f3965a111f1986dbcfce7dfdd0a','1185025876737396738','production_work_order_query','2026-06-11 22:28:14','admin','2026-06-11 22:28:14','admin'),('d17cb610658511f1986dbcfce7dfdd0a','1185025876737396738','production_order_center','2026-06-11 19:08:04','admin','2026-06-11 19:08:04','admin'),('d17cb685658511f1986dbcfce7dfdd0a','1185025876737396738','production_order_plan','2026-06-11 19:08:04','admin','2026-06-11 19:08:04','admin'),('f6b64acc65a411f1986dbcfce7dfdd0a','r_mes_003','production_employee_dispatch','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6b64afd65a411f1986dbcfce7dfdd0a','r_mes_004','production_employee_dispatch','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6b64b3965a411f1986dbcfce7dfdd0a','r_mes_003','production_equipment_dispatch','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6b64b4265a411f1986dbcfce7dfdd0a','r_mes_004','production_equipment_dispatch','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6b64b6765a411f1986dbcfce7dfdd0a','r_mes_003','production_order_center','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6b64b6f65a411f1986dbcfce7dfdd0a','r_mes_004','production_order_center','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6b64b9165a411f1986dbcfce7dfdd0a','r_mes_003','production_order_plan','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6b64b9a65a411f1986dbcfce7dfdd0a','r_mes_004','production_order_plan','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6b64bc865a411f1986dbcfce7dfdd0a','r_mes_003','production_plan_dispatch','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6b64bd065a411f1986dbcfce7dfdd0a','r_mes_004','production_plan_dispatch','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6b64bf165a411f1986dbcfce7dfdd0a','r_mes_003','production_work_order_query','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6b64bf965a411f1986dbcfce7dfdd0a','r_mes_004','production_work_order_query','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6c0f16865a411f1986dbcfce7dfdd0a','r_mes_004','workflow_category','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6c0f1a465a411f1986dbcfce7dfdd0a','r_mes_004','workflow_control','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6c0f1c965a411f1986dbcfce7dfdd0a','r_mes_004','workflow_definition','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6c0f1eb65a411f1986dbcfce7dfdd0a','r_mes_004','workflow_handle','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6c0f20e65a411f1986dbcfce7dfdd0a','r_mes_004','workflow_instance','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6c0f22f65a411f1986dbcfce7dfdd0a','r_mes_004','workflow_model','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6c0f25165a411f1986dbcfce7dfdd0a','r_mes_004','workflow_task','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('f6c0f27465a411f1986dbcfce7dfdd0a','r_mes_004','workflow_tool','2026-06-11 22:51:01','admin','2026-06-11 22:51:01','admin'),('fcf5204f656511f1986dbcfce7dfdd0a','r_mes_006','workflow_category','2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin'),('fcf521b8656511f1986dbcfce7dfdd0a','1185025876737396738','workflow_category','2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin'),('fcf52257656511f1986dbcfce7dfdd0a','r_mes_006','workflow_control','2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin'),('fcf52261656511f1986dbcfce7dfdd0a','1185025876737396738','workflow_control','2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin'),('fcf52291656511f1986dbcfce7dfdd0a','r_mes_006','workflow_definition','2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin'),('fcf5229b656511f1986dbcfce7dfdd0a','1185025876737396738','workflow_definition','2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin'),('fcf522b9656511f1986dbcfce7dfdd0a','r_mes_006','workflow_instance','2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin'),('fcf522c3656511f1986dbcfce7dfdd0a','1185025876737396738','workflow_instance','2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin'),('fcf522e1656511f1986dbcfce7dfdd0a','r_mes_006','workflow_model','2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin'),('fcf522ea656511f1986dbcfce7dfdd0a','1185025876737396738','workflow_model','2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin'),('fcf52307656511f1986dbcfce7dfdd0a','r_mes_006','workflow_task','2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin'),('fcf5230f656511f1986dbcfce7dfdd0a','1185025876737396738','workflow_task','2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin');
/*!40000 ALTER TABLE `sp_sys_role_menu` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_sys_user`
--

DROP TABLE IF EXISTS `sp_sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_sys_user` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '姓名',
  `username` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `dept_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '部门id',
  `email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '邮箱',
  `mobile` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '手机号',
  `tel` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '固定电话',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '性别(0:女;1:男;2:其他)',
  `birthday` datetime DEFAULT NULL COMMENT '出生年月日',
  `pic_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '图片id，对应sys_file表中的id',
  `id_card` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '身份证',
  `hobby` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '爱好',
  `province` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '省份',
  `city` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '城市',
  `district` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '区县',
  `street` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '街道',
  `street_number` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '门牌号',
  `descr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '""' COMMENT '描述',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `idx_sp_sys_user_username` (`username`) USING BTREE COMMENT '用户名唯一索引',
  UNIQUE KEY `idx_sp_sys_user_mobile` (`mobile`) USING BTREE COMMENT '用户手机号唯一索引',
  KEY `idx_sp_sys_user_email` (`email`) USING BTREE COMMENT '用户邮箱唯一索引',
  KEY `idx_sp_sys_user_id_card` (`id_card`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_sys_user`
--

LOCK TABLES `sp_sys_user` WRITE;
/*!40000 ALTER TABLE `sp_sys_user` DISABLE KEYS */;
INSERT INTO `sp_sys_user` VALUES ('1184009088826392578','宋鹏','iamsongpeng','9d7281eeaebded0b091340cfa658a7e8','','','13776337795','','1',NULL,'','','','','','','','','','0','2019-10-15 15:32:19','SongPeng','2020-02-28 16:44:59','admin'),('1184010472443396098','猴子','monkey','9d7281eeaebded0b091340cfa658a7e8','123','','137763377','','0',NULL,'','','','','','','','','','0','2019-10-15 15:37:52','SongPeng','2020-02-26 15:03:32','admin'),('1184019107907227649','超级管理员','admin','9d7281eeaebded0b091340cfa658a7e8','11','','13776337796','44','0',NULL,'2026/06/11/d243338dc8614b6c8828c487e9887ffd.jpg','66','77','88','99','10','11','12','13','0','2019-10-15 16:12:08','SongPeng','2026-06-11 23:23:25','admin'),('1266201180838801409','cassman','cassman.yang','0302726d276d6b011d85404f2beb14a4','90573703','cassman.yang@qq.com','1111','86195','1','2019-05-21 00:00:00','#sd','45+645+65+6511','swim','sad','dsa','fasd','daf','dsaf','daf','0','2020-05-29 10:54:21','admin','2020-06-02 16:45:25','admin'),('1276512902757724162','小明','xm','a7c3fcdeca8ce6d49d2680eecd5e7431','1','1@qq.com','19298833438','323232','0','1998-09-12 00:00:00','1','1','12','1','1','1','1','1','1','0','2020-06-26 21:49:27','admin','2020-07-07 14:00:52','admin'),('2063876940431450113','张三','asdcf','54ad49cf546af92b9c28e1750b751906','2063969323837911041','111@163.com','19945678965','12345678965','1','2000-04-09 00:00:00','url','','','','','','','','','0','2026-06-08 14:53:02','admin','2026-06-08 21:04:23','admin'),('2063899616759824386','张三','zs20001010','69dff5d756903eaafc6ba7bdb943be76','','','15545678921','010-12345678','0','2000-10-10 00:00:00','','123456789123456','11','11','11','11','11','11','11','0','2026-06-08 16:23:09','admin','2026-06-08 16:23:09','admin'),('2063899732770078722','张三10086','zs20001010111','aad6576c7e31fd2163e611a706d91b96','','','15545678945','010-12345678','0','2000-10-10 00:00:00','','123456789123456','11','11','11','11','11','11','11','0','2026-06-08 16:23:36','admin','2026-06-08 16:23:36','admin');
/*!40000 ALTER TABLE `sp_sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_sys_user_role`
--

DROP TABLE IF EXISTS `sp_sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_sys_user_role` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `user_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户id',
  `role_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色id',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户对应的角色表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_sys_user_role`
--

LOCK TABLES `sp_sys_user_role` WRITE;
/*!40000 ALTER TABLE `sp_sys_user_role` DISABLE KEYS */;
INSERT INTO `sp_sys_user_role` VALUES ('1267739082731270146','1266201180838801409','1336542182244384','2020-06-02 16:45:25','admin','2020-06-02 16:45:25','admin'),('1280381244774002690','1276512902757724162','1232532514523213826','2020-07-07 14:00:52','admin','2020-07-07 14:00:52','admin'),('2063899616839516162','2063899616759824386','r_mes_001','2026-06-08 16:23:09','admin','2026-06-08 16:23:09','admin'),('2063899835673133058','2063899732770078722','r_mes_001','2026-06-08 16:24:01','admin','2026-06-08 16:24:01','admin'),('2063899835736047617','2063899732770078722','r_mes_006','2026-06-08 16:24:01','admin','2026-06-08 16:24:01','admin'),('2063900293133287425','2063899732770078722','1274964176301961218','2026-06-08 16:25:50','admin','2026-06-08 16:25:50','admin'),('2063900309763702785','1266201180838801409','1274964176301961218','2026-06-08 16:25:54','admin','2026-06-08 16:25:54','admin'),('2063900309826617345','1276512902757724162','1274964176301961218','2026-06-08 16:25:54','admin','2026-06-08 16:25:54','admin'),('2063900309826617346','2063899616759824386','1274964176301961218','2026-06-08 16:25:54','admin','2026-06-08 16:25:54','admin'),('2063900309826617347','1184010472443396098','1274964176301961218','2026-06-08 16:25:54','admin','2026-06-08 16:25:54','admin'),('2063900605013344258','2063899732770078722','1281217564303929346','2026-06-08 16:27:04','admin','2026-06-08 16:27:04','admin'),('2063900605013344259','2063899616759824386','1281217564303929346','2026-06-08 16:27:04','admin','2026-06-08 16:27:04','admin'),('2063938865179779073','2063899616759824386','1274964138322538497','2026-06-08 18:59:06','admin','2026-06-08 18:59:06','admin'),('2063938865234305025','2063899732770078722','1274964138322538497','2026-06-08 18:59:06','admin','2026-06-08 18:59:06','admin'),('2063959645603065858','2063899732770078722','1280124406522425346','2026-06-08 20:21:41','admin','2026-06-08 20:21:41','admin'),('2063970394618568706','2063876940431450113','1232532514523213826','2026-06-08 21:04:23','admin','2026-06-08 21:04:23','admin'),('2063970394635345921','2063876940431450113','1274964176301961218','2026-06-08 21:04:23','admin','2026-06-08 21:04:23','admin'),('2063970394643734530','2063876940431450113','1280124406522425346','2026-06-08 21:04:23','admin','2026-06-08 21:04:23','admin'),('2063970394656317441','2063876940431450113','2063895254591418370','2026-06-08 21:04:23','admin','2026-06-08 21:04:23','admin'),('2063970394660511745','2063876940431450113','r_mes_005','2026-06-08 21:04:23','admin','2026-06-08 21:04:23','admin'),('2065055548673966081','1184009088826392578','1232532514523213826','2026-06-11 20:56:24','admin','2026-06-11 20:56:24','admin'),('2065055548699131906','1184009088826392578','1274964176301961218','2026-06-11 20:56:24','admin','2026-06-11 20:56:24','admin'),('2065092742614716418','1184019107907227649','1185025876737396738','2026-06-11 23:24:12','admin','2026-06-11 23:24:12','admin');
/*!40000 ALTER TABLE `sp_sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_team`
--

DROP TABLE IF EXISTS `sp_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_team` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='班组表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_team`
--

LOCK TABLES `sp_team` WRITE;
/*!40000 ALTER TABLE `sp_team` DISABLE KEYS */;
INSERT INTO `sp_team` VALUES ('2063873079603978241','C-01','组装电脑1组','','','0','2026-06-08 14:37:42','admin','2026-06-08 16:40:43','admin'),('2063881155841187842','C-02','组装电脑2组','','','0','2026-06-08 15:09:47','admin','2026-06-08 18:19:18','admin');
/*!40000 ALTER TABLE `sp_team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_team_employee`
--

DROP TABLE IF EXISTS `sp_team_employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_team_employee` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='班组员工关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_team_employee`
--

LOCK TABLES `sp_team_employee` WRITE;
/*!40000 ALTER TABLE `sp_team_employee` DISABLE KEYS */;
INSERT INTO `sp_team_employee` VALUES ('2063873143751663618','2063873079603978241','1184019107907227649',NULL,'0','2026-06-08 14:37:57','admin','2026-06-08 14:37:57','admin'),('2063873143776829442','2063873079603978241','1184009088826392578',NULL,'0','2026-06-08 14:37:57','admin','2026-06-08 14:37:57','admin'),('2063873143776829443','2063873079603978241','1184010472443396098',NULL,'0','2026-06-08 14:37:57','admin','2026-06-08 14:37:57','admin'),('2065087837321662466','2063881155841187842','1184019107907227649',NULL,'0','2026-06-11 23:04:43','admin','2026-06-11 23:04:43','admin'),('2065087837330051074','2063881155841187842','1266201180838801409',NULL,'0','2026-06-11 23:04:43','admin','2026-06-11 23:04:43','admin'),('2065087837334245378','2063881155841187842','1184009088826392578',NULL,'0','2026-06-11 23:04:43','admin','2026-06-11 23:04:43','admin'),('2065087837338439682','2063881155841187842','1184010472443396098',NULL,'0','2026-06-11 23:04:43','admin','2026-06-11 23:04:43','admin'),('2065087837342633985','2063881155841187842','1276512902757724162',NULL,'0','2026-06-11 23:04:43','admin','2026-06-11 23:04:43','admin'),('2065087837346828290','2063881155841187842','2063899616759824386',NULL,'0','2026-06-11 23:04:43','admin','2026-06-11 23:04:43','admin'),('2065087837351022593','2063881155841187842','2063899732770078722',NULL,'0','2026-06-11 23:04:43','admin','2026-06-11 23:04:43','admin');
/*!40000 ALTER TABLE `sp_team_employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_warehouse`
--

DROP TABLE IF EXISTS `sp_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_warehouse` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `warehouse_code` varchar(64) NOT NULL COMMENT '库房编码',
  `warehouse_name` varchar(255) NOT NULL COMMENT '库房名称',
  `warehouse_type` varchar(2) NOT NULL COMMENT '库房类型 1零件库 2产品库',
  `warehouse_desc` varchar(500) DEFAULT NULL COMMENT '库房描述',
  `spec_group` int DEFAULT NULL COMMENT '规格-组',
  `spec_row` int DEFAULT NULL COMMENT '规格-排',
  `spec_layer` int DEFAULT NULL COMMENT '规格-层',
  `spec_column` int DEFAULT NULL COMMENT '规格-列',
  `remark` varchar(500) DEFAULT NULL COMMENT '备注信息',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除 2禁用',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_warehouse_code` (`warehouse_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='库房表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_warehouse`
--

LOCK TABLES `sp_warehouse` WRITE;
/*!40000 ALTER TABLE `sp_warehouse` DISABLE KEYS */;
INSERT INTO `sp_warehouse` VALUES ('2063882874474029057','C-01','电脑主板库','1','',1,1,2,2,NULL,'0','2026-06-08 15:16:37','admin','2026-06-08 15:16:37','admin'),('2063883246932418562','C-02','电脑机箱库','1','',1,1,3,3,NULL,'0','2026-06-08 15:18:06','admin','2026-06-08 15:18:06','admin'),('2063883558099443714','C-03','电脑库','2','',3,3,3,3,NULL,'0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin');
/*!40000 ALTER TABLE `sp_warehouse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_warehouse_location`
--

DROP TABLE IF EXISTS `sp_warehouse_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_warehouse_location` (
  `id` varchar(64) NOT NULL COMMENT '主键',
  `warehouse_id` varchar(64) NOT NULL COMMENT '所属库房ID',
  `location_code` varchar(128) NOT NULL COMMENT '库位编码 如 KF001-1-2-3-4',
  `group_no` int DEFAULT NULL COMMENT '坐标-组',
  `row_no` int DEFAULT NULL COMMENT '坐标-排',
  `layer_no` int DEFAULT NULL COMMENT '坐标-层',
  `column_no` int DEFAULT NULL COMMENT '坐标-列',
  `status` varchar(2) NOT NULL DEFAULT '0' COMMENT '状态 0正常 2禁用',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0正常 1删除',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='库位表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_warehouse_location`
--

LOCK TABLES `sp_warehouse_location` WRITE;
/*!40000 ALTER TABLE `sp_warehouse_location` DISABLE KEYS */;
INSERT INTO `sp_warehouse_location` VALUES ('2063882874599858177','2063882874474029057','C-01-1-1-1-1',1,1,1,1,'0','0','2026-06-08 15:16:37','admin','2026-06-08 15:16:37','admin'),('2063882874599858178','2063882874474029057','C-01-1-1-1-2',1,1,1,2,'0','0','2026-06-08 15:16:37','admin','2026-06-08 15:16:37','admin'),('2063882874599858179','2063882874474029057','C-01-1-1-2-1',1,1,2,1,'0','0','2026-06-08 15:16:37','admin','2026-06-08 15:16:37','admin'),('2063882874599858180','2063882874474029057','C-01-1-1-2-2',1,1,2,2,'0','0','2026-06-08 15:16:37','admin','2026-06-08 15:16:37','admin'),('2063883246995333121','2063883246932418562','C-02-1-1-1-1',1,1,1,1,'0','0','2026-06-08 15:18:06','admin','2026-06-08 15:18:06','admin'),('2063883246995333122','2063883246932418562','C-02-1-1-1-2',1,1,1,2,'0','0','2026-06-08 15:18:06','admin','2026-06-08 15:18:06','admin'),('2063883246995333123','2063883246932418562','C-02-1-1-1-3',1,1,1,3,'0','0','2026-06-08 15:18:06','admin','2026-06-08 15:18:06','admin'),('2063883247062441985','2063883246932418562','C-02-1-1-2-1',1,1,2,1,'0','0','2026-06-08 15:18:06','admin','2026-06-08 15:18:06','admin'),('2063883247062441986','2063883246932418562','C-02-1-1-2-2',1,1,2,2,'0','0','2026-06-08 15:18:06','admin','2026-06-08 15:18:06','admin'),('2063883247062441987','2063883246932418562','C-02-1-1-2-3',1,1,2,3,'0','0','2026-06-08 15:18:06','admin','2026-06-08 15:18:06','admin'),('2063883247062441988','2063883246932418562','C-02-1-1-3-1',1,1,3,1,'0','0','2026-06-08 15:18:06','admin','2026-06-08 15:18:06','admin'),('2063883247062441989','2063883246932418562','C-02-1-1-3-2',1,1,3,2,'0','0','2026-06-08 15:18:06','admin','2026-06-08 15:18:06','admin'),('2063883247062441990','2063883246932418562','C-02-1-1-3-3',1,1,3,3,'0','0','2026-06-08 15:18:06','admin','2026-06-08 15:18:06','admin'),('2063883558099443715','2063883558099443714','C-03-1-1-1-1',1,1,1,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358273','2063883558099443714','C-03-1-1-1-2',1,1,1,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358274','2063883558099443714','C-03-1-1-1-3',1,1,1,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358275','2063883558099443714','C-03-1-1-2-1',1,1,2,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358276','2063883558099443714','C-03-1-1-2-2',1,1,2,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358277','2063883558099443714','C-03-1-1-2-3',1,1,2,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358278','2063883558099443714','C-03-1-1-3-1',1,1,3,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358279','2063883558099443714','C-03-1-1-3-2',1,1,3,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358280','2063883558099443714','C-03-1-1-3-3',1,1,3,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358281','2063883558099443714','C-03-1-2-1-1',1,2,1,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358282','2063883558099443714','C-03-1-2-1-2',1,2,1,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358283','2063883558099443714','C-03-1-2-1-3',1,2,1,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358284','2063883558099443714','C-03-1-2-2-1',1,2,2,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358285','2063883558099443714','C-03-1-2-2-2',1,2,2,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358286','2063883558099443714','C-03-1-2-2-3',1,2,2,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358287','2063883558099443714','C-03-1-2-3-1',1,2,3,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358288','2063883558099443714','C-03-1-2-3-2',1,2,3,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358289','2063883558099443714','C-03-1-2-3-3',1,2,3,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358290','2063883558099443714','C-03-1-3-1-1',1,3,1,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358291','2063883558099443714','C-03-1-3-1-2',1,3,1,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358292','2063883558099443714','C-03-1-3-1-3',1,3,1,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358293','2063883558099443714','C-03-1-3-2-1',1,3,2,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358294','2063883558099443714','C-03-1-3-2-2',1,3,2,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358295','2063883558099443714','C-03-1-3-2-3',1,3,2,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558162358296','2063883558099443714','C-03-1-3-3-1',1,3,3,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467138','2063883558099443714','C-03-1-3-3-2',1,3,3,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467139','2063883558099443714','C-03-1-3-3-3',1,3,3,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467140','2063883558099443714','C-03-2-1-1-1',2,1,1,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467141','2063883558099443714','C-03-2-1-1-2',2,1,1,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467142','2063883558099443714','C-03-2-1-1-3',2,1,1,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467143','2063883558099443714','C-03-2-1-2-1',2,1,2,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467144','2063883558099443714','C-03-2-1-2-2',2,1,2,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467145','2063883558099443714','C-03-2-1-2-3',2,1,2,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467146','2063883558099443714','C-03-2-1-3-1',2,1,3,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467147','2063883558099443714','C-03-2-1-3-2',2,1,3,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467148','2063883558099443714','C-03-2-1-3-3',2,1,3,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467149','2063883558099443714','C-03-2-2-1-1',2,2,1,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467150','2063883558099443714','C-03-2-2-1-2',2,2,1,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467151','2063883558099443714','C-03-2-2-1-3',2,2,1,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467152','2063883558099443714','C-03-2-2-2-1',2,2,2,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467153','2063883558099443714','C-03-2-2-2-2',2,2,2,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467154','2063883558099443714','C-03-2-2-2-3',2,2,2,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467155','2063883558099443714','C-03-2-2-3-1',2,2,3,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467156','2063883558099443714','C-03-2-2-3-2',2,2,3,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467157','2063883558099443714','C-03-2-2-3-3',2,2,3,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467158','2063883558099443714','C-03-2-3-1-1',2,3,1,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467159','2063883558099443714','C-03-2-3-1-2',2,3,1,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467160','2063883558099443714','C-03-2-3-1-3',2,3,1,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467161','2063883558099443714','C-03-2-3-2-1',2,3,2,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467162','2063883558099443714','C-03-2-3-2-2',2,3,2,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467163','2063883558099443714','C-03-2-3-2-3',2,3,2,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467164','2063883558099443714','C-03-2-3-3-1',2,3,3,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467165','2063883558099443714','C-03-2-3-3-2',2,3,3,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467166','2063883558099443714','C-03-2-3-3-3',2,3,3,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467167','2063883558099443714','C-03-3-1-1-1',3,1,1,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467168','2063883558099443714','C-03-3-1-1-2',3,1,1,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467169','2063883558099443714','C-03-3-1-1-3',3,1,1,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467170','2063883558099443714','C-03-3-1-2-1',3,1,2,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467171','2063883558099443714','C-03-3-1-2-2',3,1,2,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467172','2063883558099443714','C-03-3-1-2-3',3,1,2,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467173','2063883558099443714','C-03-3-1-3-1',3,1,3,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558229467174','2063883558099443714','C-03-3-1-3-2',3,1,3,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381698','2063883558099443714','C-03-3-1-3-3',3,1,3,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381699','2063883558099443714','C-03-3-2-1-1',3,2,1,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381700','2063883558099443714','C-03-3-2-1-2',3,2,1,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381701','2063883558099443714','C-03-3-2-1-3',3,2,1,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381702','2063883558099443714','C-03-3-2-2-1',3,2,2,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381703','2063883558099443714','C-03-3-2-2-2',3,2,2,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381704','2063883558099443714','C-03-3-2-2-3',3,2,2,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381705','2063883558099443714','C-03-3-2-3-1',3,2,3,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381706','2063883558099443714','C-03-3-2-3-2',3,2,3,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381707','2063883558099443714','C-03-3-2-3-3',3,2,3,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381708','2063883558099443714','C-03-3-3-1-1',3,3,1,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381709','2063883558099443714','C-03-3-3-1-2',3,3,1,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381710','2063883558099443714','C-03-3-3-1-3',3,3,1,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381711','2063883558099443714','C-03-3-3-2-1',3,3,2,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381712','2063883558099443714','C-03-3-3-2-2',3,3,2,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381713','2063883558099443714','C-03-3-3-2-3',3,3,2,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381714','2063883558099443714','C-03-3-3-3-1',3,3,3,1,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381715','2063883558099443714','C-03-3-3-3-2',3,3,3,2,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin'),('2063883558292381716','2063883558099443714','C-03-3-3-3-3',3,3,3,3,'0','0','2026-06-08 15:19:20','admin','2026-06-08 15:19:20','admin');
/*!40000 ALTER TABLE `sp_warehouse_location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_warehouse_request`
--

DROP TABLE IF EXISTS `sp_warehouse_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_warehouse_request` (
  `id` varchar(64) NOT NULL,
  `request_no` varchar(64) NOT NULL,
  `business_type` varchar(32) NOT NULL,
  `source_type` varchar(32) DEFAULT NULL,
  `source_id` varchar(64) DEFAULT NULL,
  `source_no` varchar(64) DEFAULT NULL,
  `warehouse_id` varchar(64) DEFAULT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'WAIT_CONFIRM',
  `item_count` int NOT NULL DEFAULT '0',
  `total_qty` decimal(18,4) NOT NULL DEFAULT '0.0000',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='warehouse inbound/outbound request header';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_warehouse_request`
--

LOCK TABLES `sp_warehouse_request` WRITE;
/*!40000 ALTER TABLE `sp_warehouse_request` DISABLE KEYS */;
INSERT INTO `sp_warehouse_request` VALUES ('2065324605901901827','IR2026061282868','PLAN_IN','PLAN_INBOUND','2065270710248980482','IR2026061282868',NULL,'WAIT_CONFIRM',1,1.0000,'admin','2026-06-12 11:11:23',NULL,NULL,'生产计划中心生成的计划入库单','0','2026-06-12 14:45:33','admin','2026-06-12 14:45:33','admin'),('2065324627561287682','IR2026061234764','PLAN_IN','PLAN_INBOUND','2065298190892580865','IR2026061234764',NULL,'WAIT_CONFIRM',1,1.0000,'admin','2026-06-12 13:00:35',NULL,NULL,'生产计划中心生成的计划入库单','0','2026-06-12 14:45:38','admin','2026-06-12 14:45:38','admin'),('2065324628341428225','IR2026061237676','PLAN_IN','PLAN_INBOUND','2065298203123171329','IR2026061237676',NULL,'WAIT_CONFIRM',1,1.0000,'admin','2026-06-12 13:00:38',NULL,NULL,'生产计划中心生成的计划入库单','0','2026-06-12 14:45:38','admin','2026-06-12 14:45:38','admin'),('2065324708448440322','MI20260612-57028','MANUAL_IN','MANUAL',NULL,NULL,'2063882874474029057','CONFIRMED',1,11111.0000,'admin','2026-06-12 14:45:57','admin','2026-06-12 14:46:13','','0','2026-06-12 14:45:57','admin','2026-06-12 14:46:13','admin'),('2065324872428949506','KO20260612-96137','KITTING_OUT','MRP','2065088372913311745','SO2026061110246',NULL,'WAIT_CONFIRM',8,159.0000,'system','2026-06-12 14:46:36',NULL,NULL,'物料需求计划生成配套出库','0','2026-06-12 14:46:36','admin','2026-06-12 14:46:36','admin'),('2065324872567361538','KO20260612-96170','KITTING_OUT','MRP','2065088372913311745','SO2026061110246',NULL,'WAIT_CONFIRM',8,159.0000,'system','2026-06-12 14:46:36',NULL,NULL,'物料需求计划生成配套出库','0','2026-06-12 14:46:36','admin','2026-06-12 14:46:36','admin'),('2065328025992011777','MI20260612-47850','MANUAL_IN','MANUAL',NULL,NULL,'2063883558099443714','CONFIRMED',1,11111.0000,'admin','2026-06-12 14:59:07','admin','2026-06-12 14:59:14','','0','2026-06-12 14:59:08','admin','2026-06-12 14:59:15','admin'),('2065328059684855810','IR2026061239732','PLAN_IN','PLAN_INBOUND','2065298211784409089','IR2026061239732',NULL,'CONFIRMED',1,112.0000,'admin','2026-06-12 13:00:40','admin','2026-06-12 14:59:22','生产计划中心生成的计划入库单','0','2026-06-12 14:59:16','admin','2026-06-12 14:59:23','admin'),('2065328059789713410','IR2026061241093','PLAN_IN','PLAN_INBOUND','2065298217488662529','IR2026061241093',NULL,'CONFIRMED',1,1.0000,'admin','2026-06-12 13:00:41','admin','2026-06-12 14:59:41','生产计划中心生成的计划入库单','0','2026-06-12 14:59:16','admin','2026-06-12 14:59:42','admin'),('2065328060032983041','IR2026061242556','PLAN_IN','PLAN_INBOUND','2065298223620734977','IR2026061242556',NULL,'CONFIRMED',1,16.0000,'admin','2026-06-12 13:00:43','admin','2026-06-12 14:59:50','生产计划中心生成的计划入库单','0','2026-06-12 14:59:16','admin','2026-06-12 14:59:51','admin'),('2065328060163006466','IR2026061243971','PLAN_IN','PLAN_INBOUND','2065298229555675137','IR2026061243971',NULL,'CONFIRMED',1,13.0000,'admin','2026-06-12 13:00:44','admin','2026-06-12 14:59:56','生产计划中心生成的计划入库单','0','2026-06-12 14:59:16','admin','2026-06-12 14:59:56','admin'),('2065328060255281153','IR2026061245281','PLAN_IN','PLAN_INBOUND','2065298235037630465','IR2026061245281',NULL,'CONFIRMED',1,14.0000,'admin','2026-06-12 13:00:45','admin','2026-06-12 15:00:01','生产计划中心生成的计划入库单','0','2026-06-12 14:59:16','admin','2026-06-12 15:00:02','admin'),('2065341419360956417','MO20260612-25493300','MANUAL_OUT','MANUAL',NULL,NULL,'2063883246932418562','CONFIRMED',1,1.0000,'admin','2026-06-12 15:52:21','admin','2026-06-12 15:52:26','','0','2026-06-12 15:52:21','admin','2026-06-12 15:52:26','admin'),('2065349229603815425','KO20260612-29024600','KITTING_OUT','MRP','2065088372913311745','SO2026061110246',NULL,'CONFIRMED',1,112.0000,'admin','2026-06-12 16:23:23','admin','2026-06-12 16:23:48','物料需求计划生成配套出库单','0','2026-06-12 16:23:23','admin','2026-06-12 16:23:48','admin');
/*!40000 ALTER TABLE `sp_warehouse_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_warehouse_request_allocation`
--

DROP TABLE IF EXISTS `sp_warehouse_request_allocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_warehouse_request_allocation` (
  `id` varchar(64) NOT NULL,
  `request_id` varchar(64) NOT NULL,
  `request_item_id` varchar(64) NOT NULL,
  `inventory_id` varchar(64) NOT NULL,
  `warehouse_id` varchar(64) NOT NULL,
  `location_id` varchar(64) NOT NULL,
  `material_id` varchar(64) NOT NULL,
  `batch_no` varchar(128) DEFAULT NULL,
  `qty` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `before_qty` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `after_qty` decimal(18,4) NOT NULL DEFAULT '0.0000',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='warehouse request FIFO allocation';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_warehouse_request_allocation`
--

LOCK TABLES `sp_warehouse_request_allocation` WRITE;
/*!40000 ALTER TABLE `sp_warehouse_request_allocation` DISABLE KEYS */;
INSERT INTO `sp_warehouse_request_allocation` VALUES ('2065349335040229378','2065349229603815425','2065349229649952769','2065328088742993922','2063882874474029057','2063882874599858178','2063211621905866753','IR2026061239732',112.0000,112.0000,0.0000,'FIFO','CONFIRMED','0','2026-06-12 16:23:48','admin','2026-06-12 16:23:48','admin');
/*!40000 ALTER TABLE `sp_warehouse_request_allocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_warehouse_request_item`
--

DROP TABLE IF EXISTS `sp_warehouse_request_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_warehouse_request_item` (
  `id` varchar(64) NOT NULL,
  `request_id` varchar(64) NOT NULL,
  `material_id` varchar(64) NOT NULL,
  `material_code` varchar(128) DEFAULT NULL,
  `material_name` varchar(255) DEFAULT NULL,
  `warehouse_id` varchar(64) DEFAULT NULL,
  `location_id` varchar(64) DEFAULT NULL,
  `batch_no` varchar(128) DEFAULT NULL,
  `request_qty` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `confirmed_qty` decimal(18,4) NOT NULL DEFAULT '0.0000',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='warehouse inbound/outbound request item';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_warehouse_request_item`
--

LOCK TABLES `sp_warehouse_request_item` WRITE;
/*!40000 ALTER TABLE `sp_warehouse_request_item` DISABLE KEYS */;
INSERT INTO `sp_warehouse_request_item` VALUES ('2065324708448440323','2065324708448440322','2063211773064388609','M000002','CPU','2063882874474029057','2063882874599858177','',11111.0000,11111.0000,'','CONFIRMED',NULL,'','0','2026-06-12 14:45:57','admin','2026-06-12 14:46:13','admin'),('2065328025992011778','2065328025992011777','2063220154210721794','M000006','台式电脑主机','2063883558099443714','2063883558099443715','',11111.0000,11111.0000,'','CONFIRMED',NULL,'','0','2026-06-12 14:59:08','admin','2026-06-12 14:59:15','admin'),('2065328059684855812','2065328059684855810','2063211621905866753','M000001','主板电路版','2063882874474029057','2063882874599858178','IR2026061239732',112.0000,112.0000,'个','CONFIRMED','2065298211784409090',NULL,'0','2026-06-12 14:59:16','admin','2026-06-12 14:59:23','admin'),('2065328059978457089','2065328059789713410','2063211773064388609','M000002','CPU','2063883246932418562','2063883246995333121','IR2026061241093',1.0000,1.0000,'个','CONFIRMED','2065298217488662530',NULL,'0','2026-06-12 14:59:16','admin','2026-06-12 14:59:42','admin'),('2065328060100091905','2065328060032983041','2063211829855264770','M000003','内存条','2063883246932418562','2063883246995333122','IR2026061242556',16.0000,16.0000,'个','CONFIRMED','2065298223620734978',NULL,'0','2026-06-12 14:59:16','admin','2026-06-12 14:59:51','admin'),('2065328060163006468','2065328060163006466','2063212207153881089','M000004','电源','2063882874474029057','2063882874599858179','IR2026061243971',13.0000,13.0000,'个','CONFIRMED','2065298229555675138',NULL,'0','2026-06-12 14:59:16','admin','2026-06-12 14:59:56','admin'),('2065328060322390018','2065328060255281153','2063212256785080322','M000005','机箱','2063883246932418562','2063883246995333123','IR2026061245281',14.0000,14.0000,'个','CONFIRMED','2065298235037630466',NULL,'0','2026-06-12 14:59:16','admin','2026-06-12 15:00:02','admin'),('2065341419386122242','2065341419360956417','2063211773064388609','M000002','CPU','2063883246932418562','2063883246995333121','IR2026061241093',1.0000,1.0000,'','CONFIRMED',NULL,'','0','2026-06-12 15:52:21','admin','2026-06-12 15:52:26','admin'),('2065349229649952769','2065349229603815425','2063211621905866753','M000001','主板电路版','2063882874474029057','2063882874599858178','IR2026061239732',112.0000,112.0000,'个','CONFIRMED','2065270312754790402',NULL,'0','2026-06-12 16:23:23','admin','2026-06-12 16:23:48','admin');
/*!40000 ALTER TABLE `sp_warehouse_request_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_warehouse_transaction`
--

DROP TABLE IF EXISTS `sp_warehouse_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_warehouse_transaction` (
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
  `qty` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `before_qty` decimal(18,4) NOT NULL DEFAULT '0.0000',
  `after_qty` decimal(18,4) NOT NULL DEFAULT '0.0000',
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='warehouse stock transaction';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_warehouse_transaction`
--

LOCK TABLES `sp_warehouse_transaction` WRITE;
/*!40000 ALTER TABLE `sp_warehouse_transaction` DISABLE KEYS */;
INSERT INTO `sp_warehouse_transaction` VALUES ('2065324776744292354','WI20260612-73319','2065324708448440322','MI20260612-57028','2065324708448440323','IN','MANUAL_IN','2063882874474029057','2063882874599858177','2063211773064388609','',11111.0000,0.0000,11111.0000,'admin','2026-06-12 14:46:13','','2026-06-12 14:46:13','admin','2026-06-12 14:46:13','admin'),('2065328054941097986','WI20260612-54899','2065328025992011777','MI20260612-47850','2065328025992011778','IN','MANUAL_IN','2063883558099443714','2063883558099443715','2063220154210721794','',11111.0000,0.0000,11111.0000,'admin','2026-06-12 14:59:14','','2026-06-12 14:59:15','admin','2026-06-12 14:59:15','admin'),('2065328088742993923','WI20260612-62963','2065328059684855810','IR2026061239732','2065328059684855812','IN','PLAN_IN','2063882874474029057','2063882874599858178','2063211621905866753','IR2026061239732',112.0000,0.0000,112.0000,'admin','2026-06-12 14:59:22','生产计划中心生成的计划入库单','2026-06-12 14:59:23','admin','2026-06-12 14:59:23','admin'),('2065328168384438274','WI20260612-81945','2065328059789713410','IR2026061241093','2065328059978457089','IN','PLAN_IN','2063883246932418562','2063883246995333121','2063211773064388609','IR2026061241093',1.0000,0.0000,1.0000,'admin','2026-06-12 14:59:41','生产计划中心生成的计划入库单','2026-06-12 14:59:42','admin','2026-06-12 14:59:42','admin'),('2065328204434481154','WI20260612-90546','2065328060032983041','IR2026061242556','2065328060100091905','IN','PLAN_IN','2063883246932418562','2063883246995333122','2063211829855264770','IR2026061242556',16.0000,0.0000,16.0000,'admin','2026-06-12 14:59:50','生产计划中心生成的计划入库单','2026-06-12 14:59:51','admin','2026-06-12 14:59:51','admin'),('2065328229302509570','WI20260612-96469','2065328060163006466','IR2026061243971','2065328060163006468','IN','PLAN_IN','2063882874474029057','2063882874599858179','2063212207153881089','IR2026061243971',13.0000,0.0000,13.0000,'admin','2026-06-12 14:59:56','生产计划中心生成的计划入库单','2026-06-12 14:59:56','admin','2026-06-12 14:59:56','admin'),('2065328250651516931','WI20260612-01557','2065328060255281153','IR2026061245281','2065328060322390018','IN','PLAN_IN','2063883246932418562','2063883246995333123','2063212256785080322','IR2026061245281',14.0000,0.0000,14.0000,'admin','2026-06-12 15:00:01','生产计划中心生成的计划入库单','2026-06-12 15:00:02','admin','2026-06-12 15:00:02','admin'),('2065341440126955522','WO20260612-01239600','2065341419360956417','MO20260612-25493300','2065341419386122242','OUT','MANUAL_OUT','2063883246932418562','2063883246995333121','2063211773064388609','IR2026061241093',1.0000,1.0000,0.0000,'admin','2026-06-12 15:52:26','','2026-06-12 15:52:26','admin','2026-06-12 15:52:26','admin'),('2065349335061200897','WO20260612-01601500','2065349229603815425','KO20260612-29024600','2065349229649952769','OUT','KITTING_OUT','2063882874474029057','2063882874599858178','2063211621905866753','IR2026061239732',112.0000,112.0000,0.0000,'admin','2026-06-12 16:23:48','物料需求计划生成配套出库单','2026-06-12 16:23:48','admin','2026-06-12 16:23:48','admin');
/*!40000 ALTER TABLE `sp_warehouse_transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_work_order_change`
--

DROP TABLE IF EXISTS `sp_work_order_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_work_order_change` (
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
  KEY `idx_work_order_change_work_order` (`work_order_id`,`status`),
  KEY `idx_work_order_change_workflow` (`workflow_instance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='已下达工单变更申请';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_work_order_change`
--

LOCK TABLES `sp_work_order_change` WRITE;
/*!40000 ALTER TABLE `sp_work_order_change` DISABLE KEYS */;
/*!40000 ALTER TABLE `sp_work_order_change` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_work_shop`
--

DROP TABLE IF EXISTS `sp_work_shop`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_work_shop` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键id',
  `work_shop` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `work_shop_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='工作车间表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_work_shop`
--

LOCK TABLES `sp_work_shop` WRITE;
/*!40000 ALTER TABLE `sp_work_shop` DISABLE KEYS */;
INSERT INTO `sp_work_shop` VALUES ('1336875254022176','DC-车间1','电池组装车间','2020-03-14 11:29:57','admin','2020-03-18 10:52:39','admin'),('1336875591663648','DC-JS01','加酸车间','2020-03-14 11:32:38','admin','2020-03-14 11:32:38','admin');
/*!40000 ALTER TABLE `sp_work_shop` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_workflow_category`
--

DROP TABLE IF EXISTS `sp_workflow_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_workflow_category` (
  `id` varchar(64) NOT NULL,
  `parent_id` varchar(64) DEFAULT '0',
  `category_name` varchar(128) NOT NULL,
  `category_code` varchar(64) NOT NULL,
  `sort_num` int NOT NULL DEFAULT '30',
  `status` varchar(16) NOT NULL DEFAULT '0',
  `remark` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_workflow_category_code` (`category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程分类';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_workflow_category`
--

LOCK TABLES `sp_workflow_category` WRITE;
/*!40000 ALTER TABLE `sp_workflow_category` DISABLE KEYS */;
INSERT INTO `sp_workflow_category` VALUES ('wf_cat_prod','0','生产流程','prod',30,'0','生产订单审批与生产流程管控默认分类','2026-06-11 15:20:13','admin','2026-06-11 15:35:57','admin');
/*!40000 ALTER TABLE `sp_workflow_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_workflow_definition`
--

DROP TABLE IF EXISTS `sp_workflow_definition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_workflow_definition` (
  `id` varchar(64) NOT NULL,
  `model_id` varchar(64) NOT NULL,
  `category_id` varchar(64) NOT NULL,
  `definition_code` varchar(64) NOT NULL,
  `definition_name` varchar(128) NOT NULL,
  `business_type` varchar(64) NOT NULL,
  `version_no` int NOT NULL DEFAULT '1',
  `node_json` text NOT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'active',
  `publish_time` varchar(32) DEFAULT NULL,
  `remark` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_workflow_def_business` (`business_type`,`status`),
  KEY `idx_workflow_def_code` (`definition_code`,`version_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程定义';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_workflow_definition`
--

LOCK TABLES `sp_workflow_definition` WRITE;
/*!40000 ALTER TABLE `sp_workflow_definition` DISABLE KEYS */;
INSERT INTO `sp_workflow_definition` VALUES ('2064982409283751938','2064976334933241858','wf_cat_prod','order-proval','生产订单审批流程','ORDER_APPROVAL',1,'[{\"nodeKey\":\"start\",\"nodeName\":\"订单提交\",\"nodeType\":\"start\"},{\"nodeKey\":\"order_approve\",\"nodeName\":\"生产订单审批\",\"nodeType\":\"approval\",\"assigneeType\":\"user\",\"assigneeId\":\"2063899732770078722\",\"assigneeName\":\"张三10086\",\"events\":[{\"eventType\":\"complete\",\"actionCode\":\"ORDER_APPROVE\",\"actionName\":\"订单审批通过\"}]},{\"nodeKey\":\"end\",\"nodeName\":\"审批完成\",\"nodeType\":\"end\"}]','active','2026-06-11 16:05:46','','2026-06-11 16:05:47','admin','2026-06-11 16:05:47','admin'),('wf_def_order_approval_v1','wf_model_order_approval','wf_cat_prod','order_approval','生产订单审批流程','ORDER_APPROVAL',1,'[{\"nodeKey\":\"start\",\"nodeName\":\"订单提交\",\"nodeType\":\"start\"},{\"nodeKey\":\"order_approve\",\"nodeName\":\"生产订单审批\",\"nodeType\":\"approval\",\"assigneeType\":\"role\",\"assigneeId\":\"productionManagerRole\",\"assigneeName\":\"生产主管\",\"events\":[{\"eventType\":\"complete\",\"actionCode\":\"ORDER_APPROVE\",\"actionName\":\"订单审批通过\"}]},{\"nodeKey\":\"end\",\"nodeName\":\"审批完成\",\"nodeType\":\"end\"}]','inactive','2026-06-11 15:20:13','默认生产订单审批流程','2026-06-11 15:20:13','admin','2026-06-11 22:51:01','admin');
/*!40000 ALTER TABLE `sp_workflow_definition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_workflow_event`
--

DROP TABLE IF EXISTS `sp_workflow_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_workflow_event` (
  `id` varchar(64) NOT NULL,
  `definition_id` varchar(64) NOT NULL,
  `node_key` varchar(64) NOT NULL,
  `event_type` varchar(32) NOT NULL,
  `action_code` varchar(64) NOT NULL,
  `action_name` varchar(128) DEFAULT NULL,
  `status` varchar(16) NOT NULL DEFAULT '0',
  `sort_num` int NOT NULL DEFAULT '1',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_workflow_event_node` (`definition_id`,`node_key`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程事件模板';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_workflow_event`
--

LOCK TABLES `sp_workflow_event` WRITE;
/*!40000 ALTER TABLE `sp_workflow_event` DISABLE KEYS */;
INSERT INTO `sp_workflow_event` VALUES ('2064982409329889282','2064982409283751938','order_approve','complete','ORDER_APPROVE','订单审批通过','0',1,'2026-06-11 16:05:47','admin','2026-06-11 16:05:47','admin'),('wf_event_order_approve','wf_def_order_approval_v1','order_approve','complete','ORDER_APPROVE','订单审批通过','0',1,'2026-06-11 15:20:13','admin','2026-06-11 15:20:13','admin');
/*!40000 ALTER TABLE `sp_workflow_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_workflow_event_log`
--

DROP TABLE IF EXISTS `sp_workflow_event_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_workflow_event_log` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程事件日志';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_workflow_event_log`
--

LOCK TABLES `sp_workflow_event_log` WRITE;
/*!40000 ALTER TABLE `sp_workflow_event_log` DISABLE KEYS */;
INSERT INTO `sp_workflow_event_log` VALUES ('2065086232207659009','2064982409283751938','2065085549593071618','2065085549635014658','complete','ORDER_APPROVE','success','订单状态已同步为已审批','2026-06-11 22:58:20','admin','2026-06-11 22:58:20','admin'),('2065086239824515074','2064982409283751938','2065079596065878017','2065079596103626754','complete','ORDER_APPROVE','success','订单状态已同步为已审批','2026-06-11 22:58:22','admin','2026-06-11 22:58:22','admin'),('2065086246774476802','2064982409283751938','2065054397673062402','2065054397727588353','complete','ORDER_APPROVE','success','订单状态已同步为已审批','2026-06-11 22:58:23','admin','2026-06-11 22:58:23','admin'),('2065090751247257601','2064982409283751938','2065088388163801089','2065088388184772609','complete','ORDER_APPROVE','success','订单状态已同步为已审批','2026-06-11 23:16:17','admin','2026-06-11 23:16:17','admin'),('2065258986246590465','2064982409283751938','2065258985915240449','2065258986007515138','complete','ORDER_APPROVE','success','订单状态已同步为已审批','2026-06-12 10:24:48','admin','2026-06-12 10:24:48','admin'),('2065296961860845570','2064982409283751938','2065296773423349762','2065296773490458626','complete','ORDER_APPROVE','success','订单状态已同步为已审批','2026-06-12 12:55:42','admin','2026-06-12 12:55:42','admin');
/*!40000 ALTER TABLE `sp_workflow_event_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_workflow_form`
--

DROP TABLE IF EXISTS `sp_workflow_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_workflow_form` (
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
  `skip_first_node` tinyint NOT NULL DEFAULT '1',
  `skip_same_handler` tinyint NOT NULL DEFAULT '0',
  `allow_return` tinyint NOT NULL DEFAULT '1',
  `allow_transfer` tinyint NOT NULL DEFAULT '1',
  `allow_entrust` tinyint NOT NULL DEFAULT '1',
  `allow_revoke` tinyint NOT NULL DEFAULT '1',
  `status` varchar(16) NOT NULL DEFAULT '0',
  `sort_num` int NOT NULL DEFAULT '30',
  `remark` varchar(500) DEFAULT NULL,
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) NOT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_workflow_form_key` (`form_key`),
  KEY `idx_workflow_form_business` (`business_type`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程表单配置';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_workflow_form`
--

LOCK TABLES `sp_workflow_form` WRITE;
/*!40000 ALTER TABLE `sp_workflow_form` DISABLE KEYS */;
INSERT INTO `sp_workflow_form` VALUES ('wf_form_order_record','生产订单审批流程','orderRecord','ORDER_APPROVAL','order_approval','url','/order/release/add-or-update-ui?id=${task.procIns.bizKey}','/order/release/add-or-update-ui?id=${task.procIns.bizKey}','生产订单审批-${task.businessCode}','ORDER_APPROVE',1,0,1,1,1,1,'0',30,'默认生产订单审批表单，审批通过后同步工单状态。','2026-06-11 16:05:03','admin','2026-06-11 16:05:03','admin');
/*!40000 ALTER TABLE `sp_workflow_form` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_workflow_instance`
--

DROP TABLE IF EXISTS `sp_workflow_instance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_workflow_instance` (
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
  KEY `idx_workflow_inst_business` (`business_type`,`business_id`),
  KEY `idx_workflow_inst_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程实例';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_workflow_instance`
--

LOCK TABLES `sp_workflow_instance` WRITE;
/*!40000 ALTER TABLE `sp_workflow_instance` DISABLE KEYS */;
INSERT INTO `sp_workflow_instance` VALUES ('2065054397673062402','2064982409283751938','ORDER_APPROVAL','2065054397568204802','WO20260611205149890','SO202606117192 / 台式电脑主机','completed','end','审批完成','1184019107907227649','超级管理员','2026-06-11 20:51:49','2026-06-11 22:58:23',NULL,'2026-06-11 20:51:50','admin','2026-06-11 22:58:23','admin'),('2065055980838273026','2064982409283751938','ORDER_APPROVAL','2065055980813107202','WO20260611205807366','FC2026061167198 / 杯子','revoked','order_approve','生产订单审批','1184019107907227649','超级管理员','2026-06-11 20:58:07','2026-06-11 20:59:04','撤回流程','2026-06-11 20:58:07','admin','2026-06-11 20:59:05','admin'),('2065079596065878017','2064982409283751938','ORDER_APPROVAL','2065079596011352066','WO20260611223157668','SO202606115594 / 台式电脑主机','completed','end','审批完成','1184019107907227649','超级管理员','2026-06-11 22:31:57','2026-06-11 22:58:21',NULL,'2026-06-11 22:31:58','admin','2026-06-11 22:58:22','admin'),('2065085549593071618','2064982409283751938','ORDER_APPROVAL','2065085549542739970','WO20260611225537101','SO2026061134640 / 台式电脑主机','completed','end','审批完成','1184019107907227649','超级管理员','2026-06-11 22:55:37','2026-06-11 22:58:19',NULL,'2026-06-11 22:55:37','admin','2026-06-11 22:58:20','admin'),('2065088388163801089','2064982409283751938','ORDER_APPROVAL','2065088388130246658','WO20260611230653874','SO2026061110246 / 台式电脑主机','completed','end','审批完成','1184019107907227649','超级管理员','2026-06-11 23:06:53','2026-06-11 23:16:17',NULL,'2026-06-11 23:06:54','admin','2026-06-11 23:16:17','admin'),('2065258985915240449','2064982409283751938','ORDER_APPROVAL','2065055980813107202','WO20260611205807366','FC2026061167198 / 杯子','completed','end','审批完成','1184019107907227649','超级管理员','2026-06-12 10:24:47','2026-06-12 10:24:47',NULL,'2026-06-12 10:24:48','admin','2026-06-12 10:24:48','admin'),('2065296773423349762','2064982409283751938','ORDER_APPROVAL','2065296773423349761','WO20260612125456802','SO2026061253964 / 台式电脑主机','completed','end','审批完成','1184019107907227649','超级管理员','2026-06-12 12:54:56','2026-06-12 12:55:41',NULL,'2026-06-12 12:54:57','admin','2026-06-12 12:55:42','admin');
/*!40000 ALTER TABLE `sp_workflow_instance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_workflow_model`
--

DROP TABLE IF EXISTS `sp_workflow_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_workflow_model` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程模型';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_workflow_model`
--

LOCK TABLES `sp_workflow_model` WRITE;
/*!40000 ALTER TABLE `sp_workflow_model` DISABLE KEYS */;
INSERT INTO `sp_workflow_model` VALUES ('2064976334933241858','wf_cat_prod','order-proval','生产订单审批流程','ORDER_APPROVAL','[{\"nodeKey\":\"start\",\"nodeName\":\"订单提交\",\"nodeType\":\"start\"},{\"nodeKey\":\"order_approve\",\"nodeName\":\"生产订单审批\",\"nodeType\":\"approval\",\"assigneeType\":\"user\",\"assigneeId\":\"2063899732770078722\",\"assigneeName\":\"张三10086\",\"events\":[{\"eventType\":\"complete\",\"actionCode\":\"ORDER_APPROVE\",\"actionName\":\"订单审批通过\"}]},{\"nodeKey\":\"end\",\"nodeName\":\"审批完成\",\"nodeType\":\"end\"}]','published','','2026-06-11 15:41:38','admin','2026-06-11 16:05:47','admin'),('wf_model_order_approval','wf_cat_prod','order_approval','生产订单审批流程','ORDER_APPROVAL','[{\"nodeKey\":\"start\",\"nodeName\":\"订单提交\",\"nodeType\":\"start\"},{\"nodeKey\":\"order_approve\",\"nodeName\":\"生产订单审批\",\"nodeType\":\"approval\",\"assigneeType\":\"role\",\"assigneeId\":\"productionManagerRole\",\"assigneeName\":\"生产主管\",\"events\":[{\"eventType\":\"complete\",\"actionCode\":\"ORDER_APPROVE\",\"actionName\":\"订单审批通过\"}]},{\"nodeKey\":\"end\",\"nodeName\":\"审批完成\",\"nodeType\":\"end\"}]','published','订单创建后由生产/仓储管理角色审批，审批通过后工单进入已审批状态','2026-06-11 15:20:13','admin','2026-06-11 22:51:01','admin');
/*!40000 ALTER TABLE `sp_workflow_model` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_workflow_task`
--

DROP TABLE IF EXISTS `sp_workflow_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_workflow_task` (
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
  KEY `idx_workflow_task_assignee` (`assignee_type`,`assignee_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='流程任务';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_workflow_task`
--

LOCK TABLES `sp_workflow_task` WRITE;
/*!40000 ALTER TABLE `sp_workflow_task` DISABLE KEYS */;
INSERT INTO `sp_workflow_task` VALUES ('2065054397727588353','2065054397673062402','2064982409283751938','ORDER_APPROVAL','2065054397568204802','WO20260611205149890','生产订单审批','order_approve','生产订单审批','user','1184019107907227649','超级管理员','done','approve','同意','2026-06-11 20:51:49','2026-06-11 22:58:23','2026-06-11 20:51:50','admin','2026-06-11 22:58:23','admin'),('2065055980855050241','2065055980838273026','2064982409283751938','ORDER_APPROVAL','2065055980813107202','WO20260611205807366','生产订单审批','order_approve','生产订单审批','user','2063899732770078722','张三10086','revoked','revoke','撤回流程','2026-06-11 20:58:07','2026-06-11 20:59:04','2026-06-11 20:58:07','admin','2026-06-11 20:59:05','admin'),('2065079596103626754','2065079596065878017','2064982409283751938','ORDER_APPROVAL','2065079596011352066','WO20260611223157668','生产订单审批','order_approve','生产订单审批','user','1184019107907227649','超级管理员','done','approve','同意','2026-06-11 22:31:57','2026-06-11 22:58:21','2026-06-11 22:31:58','admin','2026-06-11 22:58:22','admin'),('2065085549635014658','2065085549593071618','2064982409283751938','ORDER_APPROVAL','2065085549542739970','WO20260611225537101','生产订单审批','order_approve','生产订单审批','user','1184019107907227649','超级管理员','done','approve','同意','2026-06-11 22:55:37','2026-06-11 22:58:19','2026-06-11 22:55:37','admin','2026-06-11 22:58:20','admin'),('2065088388184772609','2065088388163801089','2064982409283751938','ORDER_APPROVAL','2065088388130246658','WO20260611230653874','生产订单审批','order_approve','生产订单审批','user','1184019107907227649','超级管理员','done','approve','同意','2026-06-11 23:06:53','2026-06-11 23:16:17','2026-06-11 23:06:54','admin','2026-06-11 23:16:17','admin'),('2065258986007515138','2065258985915240449','2064982409283751938','ORDER_APPROVAL','2065055980813107202','WO20260611205807366','生产订单审批','order_approve','生产订单审批','user','1184019107907227649','超级管理员','done','approve','订单审批通过','2026-06-12 10:24:47','2026-06-12 10:24:47','2026-06-12 10:24:48','admin','2026-06-12 10:24:48','admin'),('2065296773490458626','2065296773423349762','2064982409283751938','ORDER_APPROVAL','2065296773423349761','WO20260612125456802','生产订单审批','order_approve','生产订单审批','user','1184019107907227649','超级管理员','done','approve','同意','2026-06-12 12:54:56','2026-06-12 12:55:41','2026-06-12 12:54:57','admin','2026-06-12 12:55:42','admin');
/*!40000 ALTER TABLE `sp_workflow_task` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-12 17:12:19
