-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: datashift
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `7i87`
--

DROP TABLE IF EXISTS `7i87`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `7i87` (
  `RequestID` int DEFAULT NULL,
  `PersonnelID` int DEFAULT NULL,
  `DepartmentsID` int DEFAULT NULL,
  `type` text,
  `day` int DEFAULT NULL,
  `commit` text,
  `status` json DEFAULT NULL,
  `date` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `7i87`
--

LOCK TABLES `7i87` WRITE;
/*!40000 ALTER TABLE `7i87` DISABLE KEYS */;
INSERT INTO `7i87` VALUES (80,1,1,'get',1,'','[3]','1403-07-01'),(62,1,1,'get',2,'','[3]','1403-07-02'),(82,1,2,'remove',2,'','[3]','1403-07-02'),(83,1,2,'change',2,'','[1, 2]','1403-07-02'),(85,47,1,'get',3,'hyjhj','[2]','1403-07-03'),(86,47,1,'get',3,'hyjhj','[3]','1403-07-03');
/*!40000 ALTER TABLE `7i87` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `DepartmentsID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`DepartmentsID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'ICU'),(2,'اورژانس');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personnel`
--

DROP TABLE IF EXISTS `personnel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personnel` (
  `PersonnelID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `contractType` varchar(45) NOT NULL,
  `workinghours` int NOT NULL,
  `positionID` int NOT NULL,
  `isAdmin` tinyint DEFAULT NULL,
  `username` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`PersonnelID`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `PersonnelID_UNIQUE` (`PersonnelID`)
) ENGINE=InnoDB AUTO_INCREMENT=473 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personnel`
--

LOCK TABLES `personnel` WRITE;
/*!40000 ALTER TABLE `personnel` DISABLE KEYS */;
INSERT INTO `personnel` VALUES (1,'امیرعلی ستوده','official',54,1,0,'aa1403','aa123456789'),(2,'زهرا قاسمی','official',54,1,0,'zq1403','zq123456789'),(3,'محمد کریمی','official',0,4,1,'mk1403','mk123456789'),(4,'فاطممه عابدی','hourly',24,2,0,'fa1403','fa123456789'),(5,'محمد موجی','hourly',28,3,0,'mm1403','mm123456789'),(44,'سارا مرادی','hourly',12,3,0,'sm1403','sm123456789'),(47,'هادی سلیمی','hourly',5,2,0,'hs1403','hs123456789'),(49,'احمد کریمی','official',35,3,0,'ak1403','aa123456789');
/*!40000 ALTER TABLE `personnel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `positions`
--

DROP TABLE IF EXISTS `positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `positions` (
  `PositionsID` int NOT NULL,
  `name` varchar(45) NOT NULL,
  `standardWorkingHours` int NOT NULL,
  PRIMARY KEY (`PositionsID`),
  UNIQUE KEY `PositionsID_UNIQUE` (`PositionsID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `positions`
--

LOCK TABLES `positions` WRITE;
/*!40000 ALTER TABLE `positions` DISABLE KEYS */;
INSERT INTO `positions` VALUES (1,'پرستار',54),(2,'سرپرستار',40),(3,'پزشک',35),(4,'مدیرسیستم',0);
/*!40000 ALTER TABLE `positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requestlog`
--

DROP TABLE IF EXISTS `requestlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requestlog` (
  `RequestlogID` int NOT NULL AUTO_INCREMENT,
  `RequestID` varchar(45) NOT NULL,
  `status` varchar(45) NOT NULL,
  `adminAction` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`RequestlogID`),
  UNIQUE KEY `RequestlogID_UNIQUE` (`RequestlogID`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requestlog`
--

LOCK TABLES `requestlog` WRITE;
/*!40000 ALTER TABLE `requestlog` DISABLE KEYS */;
INSERT INTO `requestlog` VALUES (130,'146','accept','محمد کریمی'),(131,'147','reject','محمد کریمی'),(132,'148','current',NULL),(133,'149','reject','محمد کریمی'),(134,'150','accept','محمد کریمی'),(135,'151','accept','محمد کریمی');
/*!40000 ALTER TABLE `requestlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `requests` (
  `RequestID` int NOT NULL AUTO_INCREMENT,
  `PersonnelID` int NOT NULL,
  `DepartmentsID` int NOT NULL,
  `type` varchar(45) NOT NULL,
  `day` varchar(45) NOT NULL,
  `commit` text,
  `status` varchar(45) DEFAULT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`RequestID`),
  UNIQUE KEY `RequestID_UNIQUE` (`RequestID`)
) ENGINE=InnoDB AUTO_INCREMENT=152 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` VALUES (146,1,1,'get','5','لطفا لطفا لطفا','[3]','2024-12-26'),(147,1,2,'get','0','جون من','[1]','2024-12-21'),(148,1,2,'get','0','جون من','[2]','2024-12-21'),(149,1,2,'get','0','جون من','[3]','2024-12-21'),(150,44,2,'get','0','','[3]','2024-12-21'),(151,44,1,'off','3','بدبختی دارم','[]','2024-12-24');
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`shiftdata`@`%`*/ /*!50003 TRIGGER `CangeRequestLog` AFTER INSERT ON `requests` FOR EACH ROW begin insert into datashift.requestlog (requestlog.RequestID,requestlog.status) values (new.RequestID,"current"); end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `shiftassignments`
--

DROP TABLE IF EXISTS `shiftassignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shiftassignments` (
  `SiftAssignmentsID` int NOT NULL AUTO_INCREMENT,
  `PersonnelID` int NOT NULL,
  `ShiftsID` int NOT NULL,
  `DepartmentsID` int NOT NULL,
  `date` date NOT NULL,
  `day` int NOT NULL,
  PRIMARY KEY (`SiftAssignmentsID`),
  UNIQUE KEY `SiftAssignmentsID_UNIQUE` (`SiftAssignmentsID`)
) ENGINE=InnoDB AUTO_INCREMENT=351 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shiftassignments`
--

LOCK TABLES `shiftassignments` WRITE;
/*!40000 ALTER TABLE `shiftassignments` DISABLE KEYS */;
INSERT INTO `shiftassignments` VALUES (257,4,1,1,'2024-12-25',4),(258,4,2,1,'2024-12-25',4),(259,4,3,1,'2024-12-25',4),(260,1,3,1,'2024-12-26',5),(261,44,3,2,'2024-12-21',0),(262,5,2,1,'2024-12-26',5),(263,47,1,1,'2024-12-25',4),(264,44,2,1,'2024-12-27',6),(265,44,3,1,'2024-12-27',6),(266,3,3,1,'2024-12-24',3),(267,2,1,1,'2024-12-26',5),(268,2,2,1,'2024-12-26',5),(271,1,3,1,'2024-12-24',3),(272,5,2,1,'2024-12-24',3),(273,5,3,1,'2024-12-24',3),(274,49,1,1,'2024-12-27',6),(275,2,1,1,'2024-12-25',4),(278,44,2,2,'2024-12-25',4),(279,44,3,2,'2024-12-25',4),(280,1,0,2,'2024-12-25',4),(281,44,1,2,'2024-12-27',6),(282,49,2,2,'2024-12-26',5),(285,1,3,1,'2025-01-03',6),(286,1,2,1,'2024-12-28',0),(287,1,2,1,'2024-12-31',3),(288,5,1,2,'2024-12-31',3),(289,5,2,2,'2024-12-31',3),(290,5,3,2,'2024-12-31',3),(291,4,3,2,'2024-12-30',2),(292,2,1,2,'2025-01-02',5),(293,44,2,2,'2024-12-28',0),(295,49,2,2,'2024-12-28',0),(296,5,3,2,'2025-01-01',4),(299,3,0,2,'2024-12-25',4),(300,5,2,2,'2024-12-25',4),(301,5,3,2,'2024-12-25',4),(302,2,3,2,'2024-12-26',5),(303,47,2,2,'2024-12-27',6),(304,4,2,2,'2024-12-25',4),(305,47,2,2,'2024-12-24',3),(308,44,1,1,'2024-11-25',2),(309,44,2,1,'2024-11-25',2),(310,44,3,1,'2024-11-25',2),(311,44,1,1,'2024-12-30',2),(312,44,2,1,'2024-12-30',2),(313,44,3,1,'2024-12-30',2),(314,2,1,1,'2025-01-01',4),(315,2,2,1,'2025-01-01',4),(316,2,3,1,'2025-01-01',4),(317,5,3,1,'2024-12-28',0),(318,49,2,2,'2024-12-31',3),(319,49,3,2,'2024-12-31',3),(320,47,2,2,'2024-12-29',1),(321,47,3,2,'2024-12-29',1),(324,1,2,2,'2025-01-01',4),(325,1,3,2,'2025-01-01',4),(326,4,2,1,'2024-12-31',3),(327,4,3,1,'2024-12-31',3),(328,47,2,1,'2024-12-31',3),(329,47,3,1,'2024-12-31',3),(330,49,2,1,'2024-12-29',1),(331,3,0,1,'2024-12-31',3),(332,3,0,2,'2024-12-27',6),(333,3,0,2,'2024-12-22',1),(334,3,0,2,'2024-12-29',1),(335,3,0,2,'2024-12-28',0),(336,47,2,2,'2025-01-01',4),(337,5,3,2,'2025-01-03',6),(338,47,1,2,'2025-01-02',5),(339,47,2,2,'2025-01-02',5),(340,47,3,2,'2025-01-02',5),(341,2,2,2,'2024-12-30',2),(342,47,2,1,'2025-01-02',5),(343,47,3,1,'2025-01-02',5),(344,3,2,2,'2025-01-02',5),(345,44,3,2,'2025-01-02',5),(346,2,3,2,'2024-12-31',3),(347,44,1,2,'2024-12-31',3),(348,47,1,2,'2024-12-31',3),(349,3,3,2,'2024-12-31',3),(350,44,0,1,'2024-12-24',3);
/*!40000 ALTER TABLE `shiftassignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shifts`
--

DROP TABLE IF EXISTS `shifts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shifts` (
  `ShiftsID` int NOT NULL AUTO_INCREMENT,
  `startTime` varchar(8) NOT NULL,
  `endTime` varchar(8) NOT NULL,
  `type` varchar(10) NOT NULL,
  `time` int NOT NULL,
  PRIMARY KEY (`ShiftsID`),
  UNIQUE KEY `ShiftsID_UNIQUE` (`ShiftsID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shifts`
--

LOCK TABLES `shifts` WRITE;
/*!40000 ALTER TABLE `shifts` DISABLE KEYS */;
INSERT INTO `shifts` VALUES (0,'0','0','OFF',0),(1,'06:00','12:00','M',6),(2,'12:00','20:00','E',5),(3,'20:00','06:00','N',6);
/*!40000 ALTER TABLE `shifts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'datashift'
--

--
-- Dumping routines for database 'datashift'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-23 22:44:26
