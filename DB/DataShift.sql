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
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `DepartmentsID` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`DepartmentsID`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'ICU'),(2,'CCU'),(3,'اورژانس'),(4,'جراحی');
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
) ENGINE=InnoDB AUTO_INCREMENT=773 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personnel`
--

LOCK TABLES `personnel` WRITE;
/*!40000 ALTER TABLE `personnel` DISABLE KEYS */;
INSERT INTO `personnel` VALUES (1,'محمد کریمی','official',0,4,1,'mk1403','mk123456789'),(2,'زهرا قاسمی','official',54,2,0,'zq1403','zq123456789'),(3,'امیرعلی ستوده','official',54,2,0,'aa1403','aa123456789'),(4,'فاطممه عابدی','hourly',24,2,0,'faa1403','fa123456789'),(5,'محمد موجی','hourly',28,3,0,'mmm1403','mm123456789'),(44,'سارا مرادی','hourly',12,3,0,'sam1403','sm123456789'),(47,'هادی سلیمی','hourly',5,2,0,'hs1403','hs123456789'),(49,'احمد کریمی','official',35,3,0,'ak1403','ak123456789'),(513,'زهرا کریمی','hourly',45,4,0,'zk1403','zk123456789'),(514,'محمد حسینی','hourly',44,5,0,'mh1403','mh123456789'),(515,'علی احمدی','hourly',41,5,0,'aaa1403','aa123456789'),(516,'مریم رضا','hourly',21,3,0,'mr1403','mr123456789'),(517,'حسن جعفری','hourly',23,4,0,'hj1403','hj123456789'),(518,'فاطمه موسوی','hourly',24,5,0,'fm1403','fm123456789'),(519,'رضا پورمحمدی','hourly',35,5,0,'rp1403','rp123456789'),(520,'سارا ربیعی','hourly',30,4,0,'sr1403','sr123456789'),(521,'علی نیکو','hourly',40,3,0,'an1403','an123456789'),(522,'مینا باقری','hourly',41,4,0,'mb1403','mb123456789'),(523,'کامران رحیمی','hourly',48,2,0,'kr1403','kr123456789'),(524,'شهرام افشاری','hourly',42,5,0,'sha1403','sha123456789'),(525,'علی غفاری','hourly',50,2,0,'ag1403','ag123456789'),(526,'ناهید بهرامی','hourly',36,3,0,'nb1403','nb123456789'),(527,'سید مصطفی حسینی','hourly',46,2,0,'sm1403','sm123456789'),(528,'محسن طاهری','hourly',29,2,0,'mt1403','mt123456789'),(529,'سمیه حسنی','hourly',23,3,0,'shh1403','sh123456789'),(530,'آیدا سلیمانی','hourly',48,4,0,'as1403','as123456789'),(531,'محمد علیزاده','hourly',22,3,0,'ma1403','ma123456789'),(532,'زهرا موسوی','hourly',28,5,0,'zmm1403','zm123456789'),(713,'زهرا مرادی','official',54,2,0,'zm1403','zm123456789'),(714,'فاطمه احمدی','official',35,3,0,'fa1403','fa123456789'),(715,'نسرین علیزاده','official',50,4,0,'na1403','na123456789'),(716,'پریسا یوسفی','official',30,5,0,'py1403','py123456789'),(717,'مریم محمدی','official',35,3,0,'mmmm1403','mm123456789'),(718,'شهرزاد نوروزی','official',54,2,0,'sn1403','sn123456789'),(719,'ریحانه قربانی','official',50,4,0,'rc1403','rc123456789'),(720,'الهام حسن‌زاده','official',30,5,0,'eh1403','eh123456789'),(721,'سارا قاسمی','official',35,3,0,'sq1403','sq123456789'),(722,'مونا موسوی','official',54,2,0,'mm1403','mm123456789'),(723,'شبنم حسینی','official',50,4,0,'sh1403','sh123456789'),(724,'آرزو نیکو','official',30,5,0,'ann1403','an123456789'),(725,'لیلا رحیمی','official',35,3,0,'lr1403','lr123456789'),(726,'مهسا کاظمی','official',50,4,0,'mkk1403','mk123456789'),(727,'زینب باقری','official',54,2,0,'zb1403','zb123456789'),(728,'فریبا جلالی','official',30,5,0,'fj1403','fj123456789'),(729,'نازنین سلیمانی','official',35,3,0,'ns1403','ns123456789'),(730,'ریحانه تهرانی','official',50,4,0,'rt1403','rt123456789'),(731,'عسل مهدوی','official',54,2,0,'am1403','am123456789'),(732,'سحر قاسمی','official',30,5,0,'sqq1403','sq123456789'),(763,'علی مرادی','official',54,2,0,'amm1403','am123456789'),(764,'رضا احمدی','official',35,3,0,'ra1403','ra123456789'),(765,'حسین علیزاده','official',50,4,0,'ha1403','ha123456789'),(766,'محمد یوسفی','official',30,5,0,'my1403','my123456789'),(767,'کامران محمدی','official',35,3,0,'km1403','km123456789'),(768,'مهدی نوروزی','official',54,2,0,'mn1403','mn123456789'),(769,'حامد قربانی','official',50,4,0,'hc1403','hc123456789'),(770,'امیر حسن‌زاده','official',30,5,0,'ah1403','ah123456789'),(771,'بابک قاسمی','official',35,3,0,'bc1403','bc123456789'),(772,'سینا موسوی','official',54,2,0,'smm1403','sm123456789');
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
INSERT INTO `positions` VALUES (1,'مدیر سیستم',0),(2,'پرستار',54),(3,'سرپرستار',35),(4,'هوشبر',50),(5,'پزشک',30);
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
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requestlog`
--

LOCK TABLES `requestlog` WRITE;
/*!40000 ALTER TABLE `requestlog` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=352 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shiftassignments`
--

LOCK TABLES `shiftassignments` WRITE;
/*!40000 ALTER TABLE `shiftassignments` DISABLE KEYS */;
INSERT INTO `shiftassignments` VALUES (257,4,1,1,'2024-12-25',4),(258,4,2,1,'2024-12-25',4),(259,4,3,1,'2024-12-25',4),(261,44,3,2,'2024-12-21',0),(262,5,2,1,'2024-12-26',5),(263,47,1,1,'2024-12-25',4),(264,44,2,1,'2024-12-27',6),(265,44,3,1,'2024-12-27',6),(272,5,2,1,'2024-12-24',3),(273,5,3,1,'2024-12-24',3),(274,49,1,1,'2024-12-27',6),(278,44,2,2,'2024-12-25',4),(279,44,3,2,'2024-12-25',4),(281,44,1,2,'2024-12-27',6),(282,49,2,2,'2024-12-26',5),(288,5,1,2,'2024-12-31',3),(289,5,2,2,'2024-12-31',3),(290,5,3,2,'2024-12-31',3),(291,4,3,2,'2024-12-30',2),(293,44,2,2,'2024-12-28',0),(295,49,2,2,'2024-12-28',0),(296,5,3,2,'2025-01-01',4),(300,5,2,2,'2024-12-25',4),(301,5,3,2,'2024-12-25',4),(303,47,2,2,'2024-12-27',6),(304,4,2,2,'2024-12-25',4),(305,47,2,2,'2024-12-24',3),(308,44,1,1,'2024-11-25',2),(309,44,2,1,'2024-11-25',2),(310,44,3,1,'2024-11-25',2),(311,44,1,1,'2024-12-30',2),(312,44,2,1,'2024-12-30',2),(313,44,3,1,'2024-12-30',2),(317,5,3,1,'2024-12-28',0),(318,49,2,2,'2024-12-31',3),(319,49,3,2,'2024-12-31',3),(320,47,2,2,'2024-12-29',1),(321,47,3,2,'2024-12-29',1),(326,4,2,1,'2024-12-31',3),(327,4,3,1,'2024-12-31',3),(328,47,2,1,'2024-12-31',3),(329,47,3,1,'2024-12-31',3),(330,49,2,1,'2024-12-29',1),(336,47,2,2,'2025-01-01',4),(337,5,3,2,'2025-01-03',6),(338,47,1,2,'2025-01-02',5),(339,47,2,2,'2025-01-02',5),(340,47,3,2,'2025-01-02',5),(342,47,2,1,'2025-01-02',5),(343,47,3,1,'2025-01-02',5),(345,44,3,2,'2025-01-02',5),(347,44,1,2,'2024-12-31',3),(348,47,1,2,'2024-12-31',3),(350,44,0,1,'2024-12-24',3),(351,3,3,1,'2024-12-26',5);
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
INSERT INTO `shifts` VALUES (0,'0','0','OFF',0),(1,'06:00','13:00','M',7),(2,'13:00','21:00','E',8),(3,'21:00','06:00','N',9);
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

-- Dump completed on 2024-12-25  6:27:42
