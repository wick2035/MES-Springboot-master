-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: sparchetype
-- ------------------------------------------------------
-- Server version	8.0.43

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
  `bom_level` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'BOM灞傜骇: 0=鎴愬搧BOM 1=鍗婃垚鍝丅OM 2=缁勪欢BOM',
  `lock_status` varchar(10) NOT NULL DEFAULT 'draft' COMMENT '瀹氱増鏍囪瘑: draft=鑽夌? locked=宸插畾鐗',
  `validity` varchar(10) NOT NULL DEFAULT '鏈夋晥' COMMENT '鏈夋晥鎬? 鏈夋晥/鏃犳晥',
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
INSERT INTO `sp_bom` VALUES ('1268447170115383298','bbbbb','t002','t002','','1',NULL,NULL,0,'draft','鏈夋晥','0','2020-06-04 15:39:07','admin','2020-07-16 11:17:20','admin'),('1268811409925582850','0001','2019001','电子元件','','1',NULL,NULL,0,'draft','鏈夋晥','0','2020-06-05 15:46:28','admin','2026-05-26 10:53:43','admin'),('1270189758686146562','测试','123','123','','1',NULL,NULL,0,'draft','鏈夋晥','0','2020-06-09 11:03:32','admin','2020-07-04 15:32:47','admin'),('1272019534564536322','打算','123','123','','1',NULL,NULL,0,'draft','鏈夋晥','2','2020-06-14 12:14:25','admin','2020-07-09 15:10:38','admin'),('1272783744282112002','阿斯顿发送到','t002','t002','','1',NULL,NULL,0,'draft','鏈夋晥','0','2020-06-16 14:51:06','admin','2020-06-16 14:51:06','admin'),('1276415594372247554','77','123','123','','1',NULL,NULL,0,'draft','鏈夋晥','0','2020-06-26 15:22:47','admin','2020-07-08 15:30:46','admin'),('1276535719725346818','001','123','123','','1',NULL,NULL,0,'draft','鏈夋晥','0','2020-06-26 23:20:07','admin','2020-06-26 23:20:07','admin'),('1277125952237973506','A0001','t002','t002','','1',NULL,NULL,0,'draft','鏈夋晥','0','2020-06-28 14:25:30','admin','2020-06-28 14:25:30','admin'),('1277599659653836802','Y001','Y001','Y001','','1',NULL,NULL,0,'draft','鏈夋晥','0','2020-06-29 21:47:50','admin','2020-06-29 21:47:50','admin'),('1278528374608998401','dc001','Y001','Y001','','1',NULL,NULL,0,'draft','鏈夋晥','0','2020-07-02 11:18:13','admin','2020-07-02 11:18:13','admin'),('1280124062753075202','11111','002-2918','曲轴','11111','1',NULL,NULL,0,'draft','鏈夋晥','0','2020-07-06 20:58:55','admin','2020-07-06 20:58:55','admin'),('1281490436289179649','001','002-2918','曲轴','','1',NULL,NULL,0,'draft','鏈夋晥','0','2020-07-10 15:28:24','admin','2020-07-10 15:28:24','admin'),('1283634934423203842','333','2019001','电子元件','','1',NULL,NULL,0,'draft','鏈夋晥','0','2020-07-16 13:29:52','admin','2020-07-16 13:29:52','admin');
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
  `child_bom_id` varchar(64) DEFAULT NULL COMMENT '瀛怋OM ID (褰撳瓙椤规槸缁勪欢/鍗婃垚鍝佹椂鍏宠仈sp_bom.id)',
  `item_mat_type` varchar(10) DEFAULT NULL COMMENT '瀛愰」鐗╂枡绫诲瀷 FG/PG/COMP/PART',
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
/*!40000 ALTER TABLE `sp_bom_item` ENABLE KEYS */;
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
INSERT INTO `sp_equipment` VALUES ('eq_001','EQ000001','吊车','123','物料搬运','','1','0','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('eq_002','EQ000002','主板测试夹具','GJ-PCB-01','主板安装与测试的夹具','','1','0','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('eq_003','EQ000003','瓶体夹具','','瓶体加工夹具','','1','0','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('eq_004','EQ000004','手指套','','装配防护','防静电','1','0','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('eq_005','EQ000005','静电环','OWS20A','装配防静电','','1','0','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin');
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
INSERT INTO `sp_equipment_group` VALUES ('2062565359085801473','EG-1','1','','','0','2026-06-05 00:01:17','admin','2026-06-05 00:01:17','admin');
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
INSERT INTO `sp_equipment_group_device` VALUES ('2062565497464279041','2062565359085801473','eq_001',NULL,'0','2026-06-05 00:01:50','admin','2026-06-05 00:01:50','admin');
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
  `mat_source` varchar(16) DEFAULT NULL COMMENT '鐗╂枡鏉ユ簮 SELF鑷?埗 OUT澶栬喘',
  `texture` varchar(32) DEFAULT NULL COMMENT '鏉愯川',
  `lead_time` int NOT NULL DEFAULT '1' COMMENT '鐗╂枡闇?眰鎻愬墠鏈?澶?锛岃嚦灏?',
  `safety_stock` int NOT NULL DEFAULT '0' COMMENT '瀹夊叏搴撳瓨',
  `image_urls` varchar(2000) DEFAULT NULL COMMENT '鐗╂枡鍥剧墖锛屽?寮犻?鍙峰垎闅旂殑鐩稿?璺?緞',
  `remark` varchar(500) DEFAULT NULL COMMENT '澶囨敞淇℃伅',
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
INSERT INTO `sp_materile` VALUES ('1284051625900748801','000001','成品测试','件','产品1组','FG','大',NULL,NULL,1,0,NULL,NULL,'8*8','1279942838902304770','0005','2020-07-17 17:05:39','admin','2020-07-21 08:32:19','admin','0'),('2062753465916493825','M000001','主机','SET',NULL,'PRODUCT','','SELF','OTHER',1,0,'2026/06/05/7d02bdddcf3742358705d180e917819e.png','',NULL,NULL,NULL,'2026-06-05 12:28:45','admin','2026-06-05 12:29:22','admin','0');
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
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='工序表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_oper`
--

LOCK TABLES `sp_oper` WRITE;
/*!40000 ALTER TABLE `sp_oper` DISABLE KEYS */;
INSERT INTO `sp_oper` VALUES ('1336864489340960','ASY-01','装配工序',NULL,0.00,0.00,'Y',NULL,'2020-03-14 10:04:24','admin','2020-03-14 10:04:24','admin'),('1336864537575456','TST-02','测试工序',NULL,0.00,0.00,'Y',NULL,'2020-03-14 10:04:47','admin','2020-03-14 10:04:47','admin'),('1336864575324192','APK-01','包装工序',NULL,0.00,0.00,'Y',NULL,'2020-03-14 10:05:05','admin','2020-03-14 10:05:05','admin'),('1336864613072928','TST-01','集成测试工序',NULL,0.00,0.00,'Y',NULL,'2020-03-14 10:05:23','admin','2020-03-14 10:05:23','admin'),('1336868360683552','HJ-01','焊接',NULL,0.00,0.00,'Y',NULL,'2020-03-14 10:35:10','admin','2020-03-14 10:35:10','admin'),('1336868452958240','FJ-01','封胶工序',NULL,0.00,0.00,'Y',NULL,'2020-03-14 10:35:54','admin','2020-03-14 10:35:54','admin'),('1336868507484192','JS-01','加酸工序',NULL,0.00,0.00,'Y',NULL,'2020-03-14 10:36:20','admin','2020-03-14 10:36:20','admin'),('1336868562010144','QX-01','清洗工序',NULL,0.00,0.00,'Y',NULL,'2020-03-14 10:36:46','admin','2020-03-14 10:36:46','admin'),('1337248255574048','RK-01','入库工序',NULL,0.00,0.00,'Y',NULL,'2020-03-16 12:54:18','admin','2020-03-16 12:54:18','admin');
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
  `statue` tinyint DEFAULT NULL COMMENT '1,创建 2 进行中，3订单结束，4订单终结',
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
/*!40000 ALTER TABLE `sp_order` ENABLE KEYS */;
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
  `std_capacity` decimal(8,2) NOT NULL DEFAULT '8.00' COMMENT '鏃ユ爣鍑嗕骇鑳?灏忔椂)',
  `has_edge_warehouse` char(1) NOT NULL DEFAULT 'N' COMMENT '鏄?惁鏈夌嚎杈瑰簱 Y鏄?N鍚',
  `status` char(1) NOT NULL DEFAULT '1' COMMENT '状态 1启用 0停用',
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
INSERT INTO `sp_processing_unit` VALUES ('jg_unit_001','JG000001','电脑组装单元','person','PDF示例-电脑组装作业人员单元',8.00,'N','1','0','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('jg_unit_002','JG000002','加工单元1','device','PDF示例-轮毂上线工序所属单元',8.00,'N','1','0','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin');
/*!40000 ALTER TABLE `sp_processing_unit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_processing_unit_team`
--

DROP TABLE IF EXISTS `sp_processing_unit_team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_processing_unit_team` (
  `id` varchar(64) NOT NULL COMMENT '涓婚敭',
  `unit_id` varchar(64) NOT NULL COMMENT '鍔犲伐鍗曞厓ID',
  `team_id` varchar(64) NOT NULL COMMENT '鐝?粍ID',
  `remark` varchar(500) DEFAULT NULL COMMENT '澶囨敞淇℃伅',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0姝ｅ父 1鍒犻櫎',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_unit` (`unit_id`),
  KEY `idx_team` (`team_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='鍔犲伐鍗曞厓鐝?粍鍏崇郴琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_processing_unit_team`
--

LOCK TABLES `sp_processing_unit_team` WRITE;
/*!40000 ALTER TABLE `sp_processing_unit_team` DISABLE KEYS */;
INSERT INTO `sp_processing_unit_team` VALUES ('2062566080069881858','jg_unit_001','2062558805766782977',NULL,'0','2026-06-05 00:04:09','admin','2026-06-05 00:04:09','admin');
/*!40000 ALTER TABLE `sp_processing_unit_team` ENABLE KEYS */;
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
INSERT INTO `sp_sys_dict` VALUES ('1337618042191904','成品','FG','material_type','物料类型',2,'\"\"','0','2020-03-18 13:53:06','admin','2020-03-18 13:53:06','admin'),('1337618163826720','半成品','PG','material_type','物料类型',3,'\"\"','0','2020-03-18 13:54:04','admin','2020-03-18 13:54:04','admin'),('1337618837012512','个','PCS','ORDER_UNIT','生产单位',1,'\"\"','0','2020-03-18 13:59:25','admin','2020-03-18 13:59:41','admin'),('1337618939772960','箱','BOX','ORDER_UNIT','生产单位',2,'\"\"','0','2020-03-18 14:00:14','admin','2020-03-18 14:00:14','admin'),('3a375ac3609311f18e83005056c00001','产品','PRODUCT','material_type','物料类型-产品',6,'\"\"','0','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('3a375b1a609311f18e83005056c00001','标准件','STD','material_type','物料类型-标准件',7,'\"\"','0','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('3a375b2a609311f18e83005056c00001','其他','OTHER','material_type','物料类型-其他',8,'\"\"','0','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('3a383ae4609311f18e83005056c00001','自制','SELF','material_source','物料来源-自制',1,'\"\"','0','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('3a383b3e609311f18e83005056c00001','外购','OUT','material_source','物料来源-外购',2,'\"\"','0','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('3a3923de609311f18e83005056c00001','铝','AL','material_texture','材质-铝',1,'\"\"','0','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('3a392417609311f18e83005056c00001','铁','IRON','material_texture','材质-铁',2,'\"\"','0','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('3a392425609311f18e83005056c00001','纸质','PAPER','material_texture','材质-纸质',3,'\"\"','0','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('3a392432609311f18e83005056c00001','其他','OTHER','material_texture','材质-其他',4,'\"\"','0','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('3a3a0bef609311f18e83005056c00001','套','SET','ORDER_UNIT','生产单位',3,'\"\"','0','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('cf64531258ad11f1936e08bfb82fad24','组件','COMP','material_type','鐗╂枡绫诲瀷-缁勪欢',4,'\"\"','0','2026-05-26 10:51:35','admin','2026-05-26 10:51:35','admin'),('cf6457cc58ad11f1936e08bfb82fad24','零件','PART','material_type','鐗╂枡绫诲瀷-闆朵欢',5,'\"\"','0','2026-05-26 10:51:35','admin','2026-05-26 10:51:35','admin'),('roledict001','员工','employee','user_type','用户类型-员工',1,'\"\"','0','2026-05-26 09:48:16','admin','2026-05-26 09:48:16','admin'),('roledict002','管理员','manager','user_type','用户类型-管理员',2,'\"\"','0','2026-05-26 09:48:16','admin','2026-05-26 09:48:16','admin'),('roledict011','普通角色','normal','role_category','角色分类-普通角色',1,'\"\"','0','2026-05-26 09:48:16','admin','2026-05-26 09:48:16','admin'),('roledict012','系统角色','system','role_category','角色分类-系统角色',2,'\"\"','0','2026-05-26 09:48:16','admin','2026-05-26 09:48:16','admin'),('roledict021','全部数据','all','data_scope','数据范围-全部',1,'\"\"','0','2026-05-26 09:48:16','admin','2026-05-26 09:48:16','admin'),('roledict022','本部门','dept','data_scope','数据范围-本部门',2,'\"\"','0','2026-05-26 09:48:16','admin','2026-05-26 09:48:16','admin'),('roledict023','本部门及子部门','dept_child','data_scope','数据范围-本部门及子部门',3,'\"\"','0','2026-05-26 09:48:16','admin','2026-05-26 09:48:16','admin'),('roledict024','仅本人','self','data_scope','数据范围-仅本人',4,'\"\"','0','2026-05-26 09:48:16','admin','2026-05-26 09:48:16','admin'),('roledict031','全部业务','all','business_scope','业务范围-全部',1,'\"\"','0','2026-05-26 09:48:16','admin','2026-05-26 09:48:16','admin'),('roledict032','本部门业务','dept','business_scope','业务范围-本部门',2,'\"\"','0','2026-05-26 09:48:16','admin','2026-05-26 09:48:16','admin'),('roledict033','指定业务模块','specified','business_scope','业务范围-指定模块',3,'\"\"','0','2026-05-26 09:48:16','admin','2026-05-26 09:48:16','admin');
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
INSERT INTO `sp_sys_menu` VALUES ('1','currency','常规管理','#','0','1',1,'0','user:add','fa fa-address-book','','2019-10-18 11:18:29','SongPeng','2020-03-13 14:07:09','admin'),('10','system','系统管理','#','1','2',1,'0','user:add','fa fa-gears','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('101','menu','菜单管理','/admin/sys/menu/list-ui','10','3',1,'0','user:add','fa fa-bars','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('102','user','用户管理','/admin/sys/user/list-ui','10','3',2,'0','user:add','fa fa-user','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('103','role','角色管理','/admin/sys/role/list-ui','menu_perm_mgr','4',1,'0','user:add','fa fa-child','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('104','department','部门管理','/admin/sys/department/list-ui','10','3',4,'0','user:add','fa fa-sitemap','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('105','basedata','基础数据配置平台','/basedata/manager/list-ui','10','3',5,'0','user:add','fa fa-cog','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('106','basedatamanager','基础数据维护','/basedata/manager/item/list-ui','10','3',6,'0','user:add','fa fa-database','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('12','order','计划管理','','1','2',4,'0','user:add','fa fa-calendar','','2019-10-18 11:18:29','Wangziyang','2021-02-21 14:59:56','admin'),('121','orderRelease','工单下达','/order/release/list-ui','12','3',1,'0','user:add','fa fa-flag-o','','2019-10-18 11:18:29','Wangziyang','2019-10-18 11:18:29','Wangziyang'),('13','materiel','物料管理','#','1','2',2,'0','user:add','fa fa-cubes','','2019-10-18 11:18:29','Wangziyang','2019-10-18 11:18:29','Wangziyang'),('131','matdef','物料维护','/basedata/materile/list-ui','13','3',1,'0','user:add','fa fa-microchip','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('132','processing_unit','加工单元定义','/basedata/processing-unit/list-ui','base_data_center','3',3,'0','user:add','fa fa-cog','加工单元主数据','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('133','equipment','设备','/basedata/equipment/list-ui','13','3',3,'0','user:add','fa fa-wrench','设备主数据','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('14','Digitalplatform\n\n','数字化平台','#','1','2',6,'0','user:add','fa fa-pie-chart','','2019-10-18 11:18:29','Wangziyang','2019-10-18 11:18:29','Wangziyang'),('141','plandg','智慧大屏','/digitization/plan/plan-ui','14','3',1,'0','user:add','fa fa-desktop','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('15','ProcessManage','产品数据中心','','1','2',3,'0','user:add','fa fa-cubes','','2019-10-18 11:18:29','Wangziyang','2021-02-21 15:01:47','admin'),('151','flowProcess','工艺路线管理','/basedata/flow/process/list-ui','15','3',1,'0','user:add','fa fa-retweet','','2019-10-18 11:18:29','Wangziyang','2019-10-18 11:18:29','Wangziyang'),('152','bom','工艺BOM管理','/technology/bom/list-ui','15','3',2,'0','user:add','fa fa-file-text-o','','2019-10-18 11:18:29','Wangziyang','2019-10-18 11:18:29','Wangziyang'),('153','sp_oper_def','工序信息定义','/technology/oper/list-ui','15','3',3,'0','user:add','fa fa-thumb-tack','工序信息定义','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('154','process_route','工艺流程管理','/technology/process-route/tree-ui','15','3',4,'0','user:add','fa fa-sitemap','工艺流程管理','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('155','process_content','工艺内容编制','/technology/process-content/tree-ui','15','3',5,'0','user:add','fa fa-edit','工艺内容编制','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('156','process_query','产品工艺查询','/technology/process-query/tree-ui','15','3',6,'0','user:add','fa fa-search','产品工艺查询','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('16','wip','在制品管理','#','1','2',5,'0','user:add','fa fa-industry','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('161','generalSnProcess','SN通用过程采集','/rrr','16','3',1,'0','user:add','fa fa-product-hunt','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('17','DigitalSimulation','黑科数字孪生','#','1','2',7,'0','user:add','fa fa-ravelry','','2019-10-18 11:18:29','Wangziyang','2019-10-18 11:18:29','Wangziyang'),('171','DigitalSimulationFrom','数字仿真3D仓库','/digital/simulation/list-ui','17','3',1,'0','user:add','fa fa-codepen','','2019-10-18 11:18:29','Wangziyang','2019-10-18 11:18:29','Wangziyang'),('2','component','OPC操作','#','0','1',1,'0','user:add','fa fa-lemon-o','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('3','other','其他管理','#','0','1',1,'0','user:add','fa fa-slideshare','','2019-10-18 11:18:29','SongPeng','2019-10-18 11:18:29','SongPeng'),('banzu_def','banzuDef','班组员工定义','/basedata/team/list-ui','base_data_center','3',1,'0','user:add','fa fa-users','班组员工定义','2026-06-04 23:28:04','admin','2026-06-04 23:28:04','admin'),('base_data_center','baseDataCenter','基础数据中心','#','1','2',7,'0','user:add','fa fa-database','基础数据中心','2026-06-04 23:28:04','admin','2026-06-04 23:28:04','admin'),('bianzu_def','bianzuDef','编组设备定义','/basedata/equipment-group/list-ui','base_data_center','3',2,'0','user:add','fa fa-wrench','编组设备定义','2026-06-04 23:59:38','admin','2026-06-04 23:59:38','admin'),('cangku_def','cangkuDef','库房库位定义','/basedata/warehouse/list-ui','base_data_center','3',2,'0','user:add','fa fa-cube','库房库位定义','2026-06-05 12:02:22','admin','2026-06-05 12:02:22','admin'),('mat_info_def','matInfoDef','物料信息定义','/basedata/materile/list-ui','prod_data_center','3',1,'0','user:add','fa fa-info-circle','物料信息定义','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('menu_perm_mgr','permManage','权限管理','#','10','3',3,'0','','layui-icon-lock','权限管理目录','2026-05-26 09:50:17','admin','2026-05-26 09:50:17','admin'),('prod_data_center','prodDataCenter','生产数据中心','#','1','2',8,'0','user:add','fa fa-database','生产数据中心','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin');
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
  `is_deleted` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
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
INSERT INTO `sp_sys_role` VALUES ('1185025876737396738','超级管理员','admin','超级管理员',0,'0',NULL,NULL,NULL,NULL,'0','2019-10-18 10:52:40','SongPeng','2020-03-13 14:06:43','admin'),('1232532514523213826','体验者123','experience','体验者',0,'0',NULL,NULL,NULL,NULL,'0','2020-02-26 13:07:05','admin','2020-06-03 15:05:59','admin'),('1274963902774620161','检验员','10006','检验员',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:14:17','admin','2026-05-26 09:03:22','admin'),('1274963930100510721','1212','1212','1212',0,'0',NULL,NULL,NULL,NULL,'1','2020-06-22 15:14:23','admin','2026-05-28 21:41:54','admin'),('1274963986383876098','1311','121','111',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:14:37','admin','2020-06-22 15:14:37','admin'),('1274964058609790977','12121212','12121','1212',0,'0',NULL,NULL,NULL,NULL,'1','2020-06-22 15:14:54','admin','2026-05-28 21:41:58','admin'),('1274964096777957377','操作工','10005','操作工',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:15:03','admin','2026-05-26 09:03:06','admin'),('1274964138322538497','现场班组长','10004','现场班组长',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:15:13','admin','2026-05-26 09:02:52','admin'),('1274964176301961218','车间主管','10003','车间主管',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:15:22','admin','2026-05-26 09:02:32','admin'),('1274964233344495618','计划员','10002','计划员',0,'0',NULL,NULL,NULL,NULL,'0','2020-06-22 15:15:36','admin','2026-05-26 09:02:06','admin'),('1280124406522425346','工艺员','technologyRole','产品工艺管理角色，负责BOM和工艺路线维护',0,'0',NULL,NULL,NULL,NULL,'0','2020-07-06 21:00:17','admin','2026-05-26 09:01:51','admin'),('1281217564303929346','系统管理员','888888','系统管理员',0,'0',NULL,NULL,NULL,NULL,'0','2020-07-09 21:24:06','admin','2026-05-26 09:01:32','admin'),('1336542182244384','王子杨','123','王子杨',0,'0',NULL,NULL,NULL,NULL,'0','2020-03-12 15:22:56','admin','2020-03-12 15:22:56','admin'),('r_mes_001','数据员','baseDataRole','基础数据管理角色，负责物料、基础配置等数据维护',10,'0','employee','normal',NULL,NULL,'0','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('r_mes_003','生产计划员','productionPlannerRole','生产计划管理角色，负责工单下达和生产计划',30,'0','employee','normal',NULL,NULL,'0','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('r_mes_004','生产主管','productionManagerRole','生产及设备管理角色，负责生产计划和设备管理',40,'0','employee','normal',NULL,NULL,'0','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('r_mes_005','生产作业员','productionOperatorRole','生产执行角色，负责在制品过程采集和生产执行',50,'0','employee','normal',NULL,NULL,'0','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('r_mes_006','库房管理员','warehouseManagerRole','库房管理角色，负责库存和物料出入库管理',60,'0','employee','normal',NULL,NULL,'0','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('r_mes_007','质量管理员','qualityManagerRole','质量管理角色，负责质量检验和质量报表',70,'0','employee','normal',NULL,NULL,'0','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin');
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
INSERT INTO `sp_sys_role_menu` VALUES ('1','1185025876737396738','1','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('2','1185025876737396738','2','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('2062558427113406466','1281217564303929346?','1','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427113406467','1281217564303929346?','10','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427151155201','1281217564303929346?','101','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427151155202','1281217564303929346?','102','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427151155203','1281217564303929346?','menu_perm_mgr','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427151155204','1281217564303929346?','103','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427214069762','1281217564303929346?','104','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427214069763','1281217564303929346?','105','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427214069764','1281217564303929346?','106','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427214069765','1281217564303929346?','13','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427214069766','1281217564303929346?','131','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427276984321','1281217564303929346?','132','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427276984322','1281217564303929346?','133','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427276984323','1281217564303929346?','15','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427276984324','1281217564303929346?','151','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427276984325','1281217564303929346?','152','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427339898882','1281217564303929346?','153','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427339898883','1281217564303929346?','154','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427339898884','1281217564303929346?','155','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427339898885','1281217564303929346?','156','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427339898886','1281217564303929346?','12','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427339898887','1281217564303929346?','121','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427402813441','1281217564303929346?','16','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427402813442','1281217564303929346?','161','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427402813443','1281217564303929346?','14','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427402813444','1281217564303929346?','141','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427402813445','1281217564303929346?','17','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427402813446','1281217564303929346?','171','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427465728001','1281217564303929346?','base_data_center','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427465728002','1281217564303929346?','banzu_def','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427465728003','1281217564303929346?','2','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('2062558427465728004','1281217564303929346?','3','2026-06-04 23:33:44','admin','2026-06-04 23:33:44','admin'),('20f83ebd5aa211f18e83005056c00001','1281217564303929346','132','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('20f842805aa211f18e83005056c00001','1281217564303929346','133','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('20f8432f5aa211f18e83005056c00001','1281217564303929346','153','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('20f843bb5aa211f18e83005056c00001','1281217564303929346','154','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('20f844775aa211f18e83005056c00001','1281217564303929346','155','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('20f844fe5aa211f18e83005056c00001','1281217564303929346','156','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('20f96eb95aa211f18e83005056c00001','r_mes_002','153','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('20f96f805aa211f18e83005056c00001','r_mes_002','154','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('20f970065aa211f18e83005056c00001','r_mes_002','155','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('20f970825aa211f18e83005056c00001','r_mes_002','156','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('20fb091f5aa211f18e83005056c00001','r_mes_001','132','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('20fb0a705aa211f18e83005056c00001','r_mes_001','133','2026-05-28 22:33:00','admin','2026-05-28 22:33:00','admin'),('3','1185025876737396738','3','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('3a3be103609311f18e83005056c00001','1281217564303929346','mat_info_def','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('3a3be137609311f18e83005056c00001','1281217564303929346','prod_data_center','2026-06-05 12:01:27','admin','2026-06-05 12:01:27','admin'),('4','1185025876737396738','101','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('5','1185025876737396738','102','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('5f0947d458a411f1936e08bfb82fad24','r_mes_001','105','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f094b2158a411f1936e08bfb82fad24','r_mes_001','106','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f094b9358a411f1936e08bfb82fad24','r_mes_001','1','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f094bdb58a411f1936e08bfb82fad24','r_mes_001','131','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f094c2458a411f1936e08bfb82fad24','r_mes_001','13','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f094c6b58a411f1936e08bfb82fad24','r_mes_001','10','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0a401158a411f1936e08bfb82fad24','r_mes_002','152','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0a48db58a411f1936e08bfb82fad24','r_mes_002','1','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0a495758a411f1936e08bfb82fad24','r_mes_002','151','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0a49a058a411f1936e08bfb82fad24','r_mes_002','15','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0b0fa858a411f1936e08bfb82fad24','r_mes_003','1','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0b11e158a411f1936e08bfb82fad24','r_mes_003','12','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0b124758a411f1936e08bfb82fad24','r_mes_003','121','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0bf9b958a411f1936e08bfb82fad24','r_mes_004','1','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0bfbb058a411f1936e08bfb82fad24','r_mes_004','12','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0bfc1158a411f1936e08bfb82fad24','r_mes_004','121','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0bfc5058a411f1936e08bfb82fad24','r_mes_004','141','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0cb7c758a411f1936e08bfb82fad24','r_mes_005','1','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0cba7558a411f1936e08bfb82fad24','r_mes_005','161','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0cbad058a411f1936e08bfb82fad24','r_mes_005','16','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0d8c0e58a411f1936e08bfb82fad24','r_mes_006','1','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0d8e1358a411f1936e08bfb82fad24','r_mes_006','131','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0d8e7258a411f1936e08bfb82fad24','r_mes_006','13','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0e595c58a411f1936e08bfb82fad24','r_mes_007','1','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('5f0e5c7658a411f1936e08bfb82fad24','r_mes_007','141','2026-05-26 09:44:01','admin','2026-05-26 09:44:01','admin'),('6','1185025876737396738','103','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('6212f97958a511f1936e08bfb82fad24','1281217564303929346','menu_perm_mgr','2026-05-26 09:51:16','admin','2026-05-26 09:51:16','admin'),('63a8f3c5602e11f18e83005056c00001','1281217564303929346','bianzu_def','2026-06-04 23:59:38','admin','2026-06-04 23:59:38','admin'),('7','1185025876737396738','104','2019-10-28 14:51:44','admin','2019-10-28 14:51:56','admin'),('848e96d858a411f1936e08bfb82fad24','1280124406522425346','152','2026-05-26 09:45:04','admin','2026-05-26 09:45:04','admin'),('848ea7d858a411f1936e08bfb82fad24','1280124406522425346','1','2026-05-26 09:45:04','admin','2026-05-26 09:45:04','admin'),('848ea90458a411f1936e08bfb82fad24','1280124406522425346','151','2026-05-26 09:45:04','admin','2026-05-26 09:45:04','admin'),('848ea97d58a411f1936e08bfb82fad24','1280124406522425346','15','2026-05-26 09:45:04','admin','2026-05-26 09:45:04','admin'),('a8dc2cac58a311f1936e08bfb82fad24','1281217564303929346','2','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc371358a311f1936e08bfb82fad24','1281217564303929346','161','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc391f58a311f1936e08bfb82fad24','1281217564303929346','3','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc3a7d58a311f1936e08bfb82fad24','1281217564303929346','16','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc3bd058a311f1936e08bfb82fad24','1281217564303929346','106','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc3e0658a311f1936e08bfb82fad24','1281217564303929346','105','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc3f5a58a311f1936e08bfb82fad24','1281217564303929346','121','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc40a658a311f1936e08bfb82fad24','1281217564303929346','152','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc41e558a311f1936e08bfb82fad24','1281217564303929346','15','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc43a558a311f1936e08bfb82fad24','1281217564303929346','151','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc44ea58a311f1936e08bfb82fad24','1281217564303929346','1','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc463058a311f1936e08bfb82fad24','1281217564303929346','171','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc476c58a311f1936e08bfb82fad24','1281217564303929346','14','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc4ceb58a311f1936e08bfb82fad24','1281217564303929346','141','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc4f2d58a311f1936e08bfb82fad24','1281217564303929346','13','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc507d58a311f1936e08bfb82fad24','1281217564303929346','131','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc51c158a311f1936e08bfb82fad24','1281217564303929346','102','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc530458a311f1936e08bfb82fad24','1281217564303929346','10','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc544158a311f1936e08bfb82fad24','1281217564303929346','101','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc557e58a311f1936e08bfb82fad24','1281217564303929346','103','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc56b958a311f1936e08bfb82fad24','1281217564303929346','12','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc57f958a311f1936e08bfb82fad24','1281217564303929346','104','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('a8dc593758a311f1936e08bfb82fad24','1281217564303929346','17','2026-05-26 09:38:56','admin','2026-05-26 09:38:56','admin'),('fae38850602911f18e83005056c00001','1281217564303929346','banzu_def','2026-06-04 23:28:04','admin','2026-06-04 23:28:04','admin'),('fae3893a602911f18e83005056c00001','1281217564303929346','base_data_center','2026-06-04 23:28:04','admin','2026-06-04 23:28:04','admin'),('fedceb6f609211f18e83005056c00001','1281217564303929346','cangku_def','2026-06-05 11:59:48','admin','2026-06-05 11:59:48','admin');
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
INSERT INTO `sp_sys_user` VALUES ('1184009088826392578','宋鹏','iamsongpeng','9d7281eeaebded0b091340cfa658a7e8','','','13776337795','','1',NULL,'','','','','','','','','','0','2019-10-15 15:32:19','SongPeng','2020-02-28 16:44:59','admin'),('1184010472443396098','猴子','monkey','9d7281eeaebded0b091340cfa658a7e8','123','','137763377','','0',NULL,'','','','','','','','','','0','2019-10-15 15:37:52','SongPeng','2020-02-26 15:03:32','admin'),('1184019107907227649','超级管理员','admin','9d7281eeaebded0b091340cfa658a7e8','11','','13776337796','44','0','2004-06-01 00:00:00','2026/06/05/fa098de0b6a14ab1912a6ecf2c121d02.png','66','77','88','99','10','11','12','13','0','2019-10-15 16:12:08','SongPeng','2026-06-05 18:33:27','admin'),('1266201180838801409','cassman','cassman.yang','0302726d276d6b011d85404f2beb14a4','90573703','cassman.yang@qq.com','1111','86195','1','2019-05-21 00:00:00','#sd','45+645+65+6511','swim','sad','dsa','fasd','daf','dsaf','daf','0','2020-05-29 10:54:21','admin','2020-06-02 16:45:25','admin'),('1276512902757724162','小明','xm','a7c3fcdeca8ce6d49d2680eecd5e7431','1','1@qq.com','19298833438','323232','0','1998-09-12 00:00:00','1','1','12','1','1','1','1','1','1','0','2020-06-26 21:49:27','admin','2020-07-07 14:00:52','admin');
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
INSERT INTO `sp_sys_user_role` VALUES ('1242287110472966146','1184019107907227649','1185025876737396738','2020-03-24 11:08:22','admin','2020-03-24 11:08:22','admin'),('1267739082731270146','1266201180838801409','1336542182244384','2020-06-02 16:45:25','admin','2020-06-02 16:45:25','admin'),('1280381244774002690','1276512902757724162','1232532514523213826','2020-07-07 14:00:52','admin','2020-07-07 14:00:52','admin');
/*!40000 ALTER TABLE `sp_sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_table_manager`
--

DROP TABLE IF EXISTS `sp_table_manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_table_manager` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `table_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表名称',
  `table_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '表描述',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  `is_deleted` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '逻辑删除：1 表示删除，0 表示未删除，2 表示禁用',
  `permission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '""' COMMENT '授权(多个用逗号分隔，如：sys:menu:list,sys:menu:create)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `index1` (`table_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='主数据通用管理';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_table_manager`
--

LOCK TABLES `sp_table_manager` WRITE;
/*!40000 ALTER TABLE `sp_table_manager` DISABLE KEYS */;
INSERT INTO `sp_table_manager` VALUES ('1283020801696837633','sp_bom','','2020-07-14 20:49:31','admin','2020-07-14 20:49:31','admin','0','\"\"');
/*!40000 ALTER TABLE `sp_table_manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_table_manager_item`
--

DROP TABLE IF EXISTS `sp_table_manager_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_table_manager_item` (
  `id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '主键',
  `table_name_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '表名称id',
  `field` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '字段',
  `field_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '字段描述',
  `must_fill` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '是否必填',
  `sort_num` int NOT NULL COMMENT '排序',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `create_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '创建人',
  `update_time` datetime NOT NULL COMMENT '最后更新时间',
  `update_username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '最后更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='主数据基础数据明细表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_table_manager_item`
--

LOCK TABLES `sp_table_manager_item` WRITE;
/*!40000 ALTER TABLE `sp_table_manager_item` DISABLE KEYS */;
INSERT INTO `sp_table_manager_item` VALUES ('1283020801742974978','1283020801696837633','materiel_desc','888','Y',1,'2020-07-14 20:49:31','admin','2020-07-14 20:49:31','admin');
/*!40000 ALTER TABLE `sp_table_manager_item` ENABLE KEYS */;
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
INSERT INTO `sp_team` VALUES ('2062558805766782977','BZ001','生产作业','','','0','2026-06-04 23:35:14','admin','2026-06-04 23:35:14','admin');
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
INSERT INTO `sp_team_employee` VALUES ('2062558849525956610','2062558805766782977','1184009088826392578',NULL,'0','2026-06-04 23:35:25','admin','2026-06-04 23:35:25','admin');
/*!40000 ALTER TABLE `sp_team_employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_warehouse`
--

DROP TABLE IF EXISTS `sp_warehouse`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_warehouse` (
  `id` varchar(64) NOT NULL COMMENT '涓婚敭',
  `warehouse_code` varchar(64) NOT NULL COMMENT '搴撴埧缂栫爜',
  `warehouse_name` varchar(255) NOT NULL COMMENT '搴撴埧鍚嶇О',
  `warehouse_type` varchar(2) NOT NULL COMMENT '搴撴埧绫诲瀷 1闆朵欢搴?2浜у搧搴',
  `warehouse_desc` varchar(500) DEFAULT NULL COMMENT '搴撴埧鎻忚堪',
  `spec_group` int DEFAULT NULL COMMENT '瑙勬牸-缁',
  `spec_row` int DEFAULT NULL COMMENT '瑙勬牸-鎺',
  `spec_layer` int DEFAULT NULL COMMENT '瑙勬牸-灞',
  `spec_column` int DEFAULT NULL COMMENT '瑙勬牸-鍒',
  `remark` varchar(500) DEFAULT NULL COMMENT '澶囨敞淇℃伅',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0姝ｅ父 1鍒犻櫎 2绂佺敤',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_warehouse_code` (`warehouse_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='搴撴埧琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_warehouse`
--

LOCK TABLES `sp_warehouse` WRITE;
/*!40000 ALTER TABLE `sp_warehouse` DISABLE KEYS */;
INSERT INTO `sp_warehouse` VALUES ('2062753868678729730','KF001','配件电脑','1','',1,3,2,4,NULL,'0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin');
/*!40000 ALTER TABLE `sp_warehouse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sp_warehouse_location`
--

DROP TABLE IF EXISTS `sp_warehouse_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sp_warehouse_location` (
  `id` varchar(64) NOT NULL COMMENT '涓婚敭',
  `warehouse_id` varchar(64) NOT NULL COMMENT '鎵?睘搴撴埧ID',
  `location_code` varchar(128) NOT NULL COMMENT '搴撲綅缂栫爜 濡?KF001-1-2-3-4',
  `group_no` int DEFAULT NULL COMMENT '鍧愭爣-缁',
  `row_no` int DEFAULT NULL COMMENT '鍧愭爣-鎺',
  `layer_no` int DEFAULT NULL COMMENT '鍧愭爣-灞',
  `column_no` int DEFAULT NULL COMMENT '鍧愭爣-鍒',
  `status` varchar(2) NOT NULL DEFAULT '0' COMMENT '鐘舵? 0姝ｅ父 2绂佺敤',
  `is_deleted` varchar(2) NOT NULL DEFAULT '0' COMMENT '0姝ｅ父 1鍒犻櫎',
  `create_time` datetime NOT NULL,
  `create_username` varchar(64) DEFAULT NULL,
  `update_time` datetime NOT NULL,
  `update_username` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='搴撲綅琛';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sp_warehouse_location`
--

LOCK TABLES `sp_warehouse_location` WRITE;
/*!40000 ALTER TABLE `sp_warehouse_location` DISABLE KEYS */;
INSERT INTO `sp_warehouse_location` VALUES ('2062753868741644290','2062753868678729730','KF001-1-1-1-1',1,1,1,1,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644291','2062753868678729730','KF001-1-1-1-2',1,1,1,2,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644292','2062753868678729730','KF001-1-1-1-3',1,1,1,3,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644293','2062753868678729730','KF001-1-1-1-4',1,1,1,4,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644294','2062753868678729730','KF001-1-1-2-1',1,1,2,1,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644295','2062753868678729730','KF001-1-1-2-2',1,1,2,2,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644296','2062753868678729730','KF001-1-1-2-3',1,1,2,3,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644297','2062753868678729730','KF001-1-1-2-4',1,1,2,4,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644298','2062753868678729730','KF001-1-2-1-1',1,2,1,1,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644299','2062753868678729730','KF001-1-2-1-2',1,2,1,2,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644300','2062753868678729730','KF001-1-2-1-3',1,2,1,3,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644301','2062753868678729730','KF001-1-2-1-4',1,2,1,4,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644302','2062753868678729730','KF001-1-2-2-1',1,2,2,1,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644303','2062753868678729730','KF001-1-2-2-2',1,2,2,2,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644304','2062753868678729730','KF001-1-2-2-3',1,2,2,3,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868741644305','2062753868678729730','KF001-1-2-2-4',1,2,2,4,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868804558850','2062753868678729730','KF001-1-3-1-1',1,3,1,1,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868804558851','2062753868678729730','KF001-1-3-1-2',1,3,1,2,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868804558852','2062753868678729730','KF001-1-3-1-3',1,3,1,3,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868804558853','2062753868678729730','KF001-1-3-1-4',1,3,1,4,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868804558854','2062753868678729730','KF001-1-3-2-1',1,3,2,1,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868804558855','2062753868678729730','KF001-1-3-2-2',1,3,2,2,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868804558856','2062753868678729730','KF001-1-3-2-3',1,3,2,3,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin'),('2062753868804558857','2062753868678729730','KF001-1-3-2-4',1,3,2,4,'0','0','2026-06-05 12:30:21','admin','2026-06-05 12:30:21','admin');
/*!40000 ALTER TABLE `sp_warehouse_location` ENABLE KEYS */;
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-08 21:25:02
