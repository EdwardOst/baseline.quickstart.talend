-- MySQL dump 10.13 Distrib 5.5.24, for Win32 (x86)
--
-- Host: 127.0.0.1 Database: amc
-- ------------------------------------------------------
-- Server version 5.5.24-log
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
--
-- Current Database: `amc`
--
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `amc` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `amc`;

--
-- Table structure for table `tflowmetercatcher`
--
DROP TABLE IF EXISTS `tflowmetercatcher`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tflowmetercatcher` (
`moment` datetime DEFAULT NULL,
`pid` varchar(20) DEFAULT NULL,
`father_pid` varchar(20) DEFAULT NULL,
`root_pid` varchar(20) DEFAULT NULL,
`system_pid` bigint(8) DEFAULT NULL,
`project` varchar(50) DEFAULT NULL,
`job` varchar(255) DEFAULT NULL,
`job_repository_id` varchar(255) DEFAULT NULL,
`job_version` varchar(255) DEFAULT NULL,
`context` varchar(50) DEFAULT NULL,
`origin` varchar(255) DEFAULT NULL,
`label` varchar(255) DEFAULT NULL,
`count` int(3) DEFAULT NULL,
`reference` int(3) DEFAULT NULL,
`thresholds` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
--
-- Dumping data for table `tflowmetercatcher`
--
LOCK TABLES `tflowmetercatcher` WRITE;
/*!40000 ALTER TABLE `tflowmetercatcher` DISABLE KEYS */;
/*!40000 ALTER TABLE `tflowmetercatcher` ENABLE KEYS */;
UNLOCK TABLES;
--
-- Table structure for table `tlogcatcher`
--
DROP TABLE IF EXISTS `tlogcatcher`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tlogcatcher` (
`moment` datetime DEFAULT NULL,
`pid` varchar(20) DEFAULT NULL,
`root_pid` varchar(20) DEFAULT NULL,
`father_pid` varchar(20) DEFAULT NULL,
`project` varchar(50) DEFAULT NULL,
`job` varchar(255) DEFAULT NULL,
`context` varchar(50) DEFAULT NULL,
`priority` int(3) DEFAULT NULL,
`type` varchar(255) DEFAULT NULL,
`origin` varchar(255) DEFAULT NULL,
`message` varchar(255) DEFAULT NULL,
`code` int(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
--
-- Dumping data for table `tlogcatcher`
--
LOCK TABLES `tlogcatcher` WRITE;
/*!40000 ALTER TABLE `tlogcatcher` DISABLE KEYS */;
/*!40000 ALTER TABLE `tlogcatcher` ENABLE KEYS */;
UNLOCK TABLES;
--

-- Table structure for table `tstatcatcher`
--
DROP TABLE IF EXISTS `tstatcatcher`;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tstatcatcher` (
`moment` datetime DEFAULT NULL,
`pid` varchar(20) DEFAULT NULL,
`father_pid` varchar(20) DEFAULT NULL,
`root_pid` varchar(20) DEFAULT NULL,
`system_pid` bigint(8) DEFAULT NULL,
`project` varchar(50) DEFAULT NULL,
`job` varchar(255) DEFAULT NULL,
`job_repository_id` varchar(255) DEFAULT NULL,
`job_version` varchar(255) DEFAULT NULL,
`context` varchar(50) DEFAULT NULL,
`origin` varchar(255) DEFAULT NULL,
`message_type` varchar(255) DEFAULT NULL,
`message` varchar(255) DEFAULT NULL,
`duration` bigint(8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
--
-- Dumping data for table `tstatcatcher`
--
LOCK TABLES `tstatcatcher` WRITE;
/*!40000 ALTER TABLE `tstatcatcher` DISABLE KEYS */;
/*!40000 ALTER TABLE `tstatcatcher` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

