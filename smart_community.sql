-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 02, 2026 at 02:26 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `smart_community`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` tinyint(3) UNSIGNED NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `username`, `email`, `password`, `name`, `created_at`) VALUES
(16, 'bothcha', 'bothcha00@gmail.com', 'both2509', 'bothcha', '2026-03-15 18:18:58');

-- --------------------------------------------------------

--
-- Table structure for table `alerts`
--

CREATE TABLE `alerts` (
  `id` int(11) NOT NULL,
  `node_id` varchar(50) DEFAULT NULL,
  `message` varchar(255) NOT NULL,
  `type` enum('General','Security','SOS') DEFAULT 'General',
  `detail` varchar(255) DEFAULT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('pending','resolved','alert') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `alerts`
--

INSERT INTO `alerts` (`id`, `node_id`, `message`, `type`, `detail`, `time`, `status`) VALUES
(1, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -25 dBm)', '2026-04-01 19:50:56', 'resolved'),
(2, 'NODE-012', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -27 dBm)', '2026-04-01 19:51:38', 'resolved'),
(3, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -31 dBm)', '2026-04-01 19:55:21', 'resolved'),
(4, 'NODE-001', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-001 (Bat: 100%, RSSI: -21 dBm)', '2026-04-02 01:34:38', 'resolved'),
(5, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 100%, RSSI: -24 dBm)', '2026-04-02 03:44:26', 'resolved'),
(6, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 100%, RSSI: -19 dBm)', '2026-04-02 03:44:38', 'resolved'),
(7, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -25 dBm)', '2026-04-02 03:45:52', 'resolved'),
(8, 'NODE-001', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-001 (Bat: 100%, RSSI: -24 dBm)', '2026-04-02 03:50:27', 'resolved'),
(9, 'NODE-001', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-001 (Bat: 100%, RSSI: -27 dBm)', '2026-04-02 03:52:34', 'resolved'),
(10, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -32 dBm)', '2026-04-02 03:54:12', 'resolved'),
(11, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -60 dBm)', '2026-04-02 03:59:12', 'resolved'),
(12, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -43 dBm)', '2026-04-02 03:59:18', 'resolved'),
(13, 'NODE-012', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -31 dBm)', '2026-04-02 04:00:05', 'resolved'),
(14, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -19 dBm)', '2026-04-02 04:02:50', 'resolved'),
(15, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 100%, RSSI: -27 dBm)', '2026-04-02 04:05:15', 'resolved'),
(16, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 100%, RSSI: -31 dBm)', '2026-04-02 04:05:50', 'resolved'),
(17, 'NODE-001', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-001 (Bat: 100%, RSSI: -22 dBm)', '2026-04-02 04:06:11', 'resolved'),
(18, 'NODE-012', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -26 dBm)', '2026-04-02 04:06:19', 'resolved'),
(19, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 100%, RSSI: -26 dBm)', '2026-04-02 04:07:12', 'resolved'),
(20, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 100%, RSSI: -26 dBm)', '2026-04-02 04:07:13', 'resolved'),
(21, 'NODE-001', 'ไฟไหม้ !', 'SOS', 'From: NODE-001 (Bat: 100%, RSSI: -26 dBm)', '2026-04-02 04:08:29', 'resolved'),
(22, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -24 dBm)', '2026-04-02 04:08:42', 'resolved'),
(23, 'NODE-012', 'ไฟไหม้ !', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -24 dBm)', '2026-04-02 04:08:58', 'resolved'),
(24, 'NODE-001', 'สัตว์มีพิษ', 'SOS', 'From: NODE-001 (Bat: 99%, RSSI: -26 dBm)', '2026-04-02 04:09:22', 'resolved'),
(25, 'NODE-012', 'ไฟไหม้ !', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -22 dBm)', '2026-04-02 04:09:25', 'resolved'),
(26, 'NODE-001', 'สัตว์มีพิษ', 'SOS', 'From: NODE-001 (Bat: 99%, RSSI: -26 dBm)', '2026-04-02 04:10:13', 'resolved'),
(27, 'NODE-001', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-001 (Bat: 99%, RSSI: -33 dBm)', '2026-04-02 04:11:49', 'resolved'),
(28, 'NODE-001', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-001 (Bat: 99%, RSSI: -27 dBm)', '2026-04-02 04:13:37', 'resolved'),
(29, 'NODE-012', 'ไฟไหม้ !', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -20 dBm)', '2026-04-02 04:13:53', 'resolved'),
(30, 'NODE-012', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -21 dBm)', '2026-04-02 04:14:07', 'resolved'),
(31, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -21 dBm)', '2026-04-02 04:14:17', 'resolved'),
(32, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -27 dBm)', '2026-04-02 04:15:29', 'resolved'),
(33, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -34 dBm)', '2026-04-02 04:33:07', 'resolved'),
(34, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -31 dBm)', '2026-04-02 04:33:33', 'resolved'),
(35, 'NODE-001', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-001 (Bat: 99%, RSSI: -26 dBm)', '2026-04-02 04:33:37', 'resolved'),
(36, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -28 dBm)', '2026-04-02 04:34:27', 'resolved'),
(37, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -24 dBm)', '2026-04-02 04:34:27', 'resolved'),
(38, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -28 dBm)', '2026-04-02 04:34:46', 'resolved'),
(39, 'NODE-012', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -22 dBm)', '2026-04-02 04:35:51', 'resolved'),
(40, 'NODE-001', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-001 (Bat: 98%, RSSI: -21 dBm)', '2026-04-02 04:36:02', 'resolved'),
(41, 'NODE-001', 'ไฟไหม้ !', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -42 dBm)', '2026-04-02 04:41:09', 'resolved'),
(42, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -41 dBm)', '2026-04-02 04:41:49', 'resolved'),
(43, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -26 dBm)', '2026-04-02 04:41:49', 'resolved'),
(44, 'NODE-001', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-001 (Bat: 100%, RSSI: -46 dBm)', '2026-04-02 04:43:45', 'resolved'),
(45, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -24 dBm)', '2026-04-02 04:48:47', 'resolved'),
(46, 'NODE-012', 'ไฟไหม้ !', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -20 dBm)', '2026-04-02 04:57:11', 'resolved'),
(47, 'NODE-012', 'ไฟไหม้ !', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -19 dBm)', '2026-04-02 04:57:33', 'resolved'),
(48, 'NODE-001', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-001 (Bat: 99%, RSSI: -27 dBm)', '2026-04-02 04:57:45', 'resolved'),
(49, 'NODE-012', 'ไฟไหม้ !', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -19 dBm)', '2026-04-02 04:58:03', 'resolved'),
(50, 'NODE-012', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -23 dBm)', '2026-04-02 04:58:37', 'resolved'),
(51, 'NODE-001', 'ไฟไหม้ !', 'SOS', 'From: NODE-001 (Bat: 99%, RSSI: -26 dBm)', '2026-04-02 05:00:44', 'resolved'),
(52, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 100%, RSSI: -22 dBm)', '2026-04-02 05:17:56', 'resolved'),
(53, 'NODE-012', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -23 dBm)', '2026-04-02 05:18:41', 'resolved'),
(54, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -27 dBm)', '2026-04-02 05:19:00', 'resolved'),
(55, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -23 dBm)', '2026-04-02 05:19:08', 'resolved'),
(56, 'NODE-012', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -23 dBm)', '2026-04-02 05:19:19', 'resolved'),
(57, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 97%, RSSI: -21 dBm)', '2026-04-02 05:19:43', 'resolved'),
(58, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-012 (Bat: 96%, RSSI: -28 dBm)', '2026-04-02 05:19:57', 'resolved'),
(59, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 99%, RSSI: -26 dBm)', '2026-04-02 05:20:34', 'resolved'),
(60, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 95%, RSSI: -52 dBm)', '2026-04-02 05:20:51', 'resolved'),
(61, 'NODE-012', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-012 (Bat: 94%, RSSI: -27 dBm)', '2026-04-02 05:21:35', 'resolved'),
(62, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 94%, RSSI: -28 dBm)', '2026-04-02 05:21:48', 'resolved'),
(63, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 94%, RSSI: -29 dBm)', '2026-04-02 05:21:58', 'resolved'),
(64, 'NODE-012', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-012 (Bat: 94%, RSSI: -28 dBm)', '2026-04-02 05:22:12', 'resolved'),
(65, 'NODE-012', 'ไฟไหม้ !', 'SOS', 'From: NODE-012 (Bat: 94%, RSSI: -29 dBm)', '2026-04-02 05:22:15', 'resolved'),
(66, 'NODE-012', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-012 (Bat: 94%, RSSI: -28 dBm)', '2026-04-02 05:22:17', 'resolved'),
(67, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 94%, RSSI: -30 dBm)', '2026-04-02 05:22:25', 'resolved'),
(68, 'NODE-012', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-012 (Bat: 94%, RSSI: -31 dBm)', '2026-04-02 05:22:36', 'resolved'),
(69, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -24 dBm)', '2026-04-02 05:44:07', 'resolved'),
(70, 'NODE-001', 'ไฟไหม้ !', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -36 dBm)', '2026-04-02 05:44:41', 'resolved'),
(71, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -34 dBm)', '2026-04-02 05:44:47', 'resolved'),
(72, 'NODE-001', 'สัตว์มีพิษ', 'SOS', 'From: NODE-001 (Bat: 97%, RSSI: -37 dBm)', '2026-04-02 05:44:56', 'resolved'),
(73, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -24 dBm)', '2026-04-02 05:45:59', 'resolved'),
(74, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -34 dBm)', '2026-04-02 05:45:59', 'resolved'),
(75, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -27 dBm)', '2026-04-02 05:46:37', 'resolved'),
(76, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -31 dBm)', '2026-04-02 06:02:00', 'resolved'),
(77, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -34 dBm)', '2026-04-02 06:04:33', 'resolved'),
(78, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 97%, RSSI: -36 dBm)', '2026-04-02 06:04:41', 'resolved'),
(79, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 97%, RSSI: -34 dBm)', '2026-04-02 06:04:42', 'resolved'),
(80, 'NODE-001', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-001 (Bat: 96%, RSSI: -33 dBm)', '2026-04-02 06:07:03', 'resolved'),
(81, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -24 dBm)', '2026-04-02 06:08:09', 'resolved'),
(82, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -23 dBm)', '2026-04-02 06:08:11', 'resolved'),
(83, 'NODE-012', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -23 dBm)', '2026-04-02 06:08:13', 'resolved'),
(84, 'NODE-001', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-001 (Bat: 96%, RSSI: -32 dBm)', '2026-04-02 06:08:51', 'resolved'),
(85, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 96%, RSSI: -34 dBm)', '2026-04-02 06:09:17', 'resolved'),
(86, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 96%, RSSI: -23 dBm)', '2026-04-02 06:09:17', 'resolved'),
(87, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -23 dBm)', '2026-04-02 06:10:29', 'resolved'),
(88, 'NODE-012', 'ไฟไหม้ !', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -22 dBm)', '2026-04-02 06:11:42', 'resolved'),
(89, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 95%, RSSI: -22 dBm)', '2026-04-02 06:15:51', 'resolved'),
(90, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 98%, RSSI: -21 dBm)', '2026-04-02 06:16:47', 'resolved'),
(91, 'NODE-001', 'ไฟไหม้ !', 'SOS', 'From: NODE-001 (Bat: 94%, RSSI: -28 dBm)', '2026-04-02 06:17:08', 'resolved'),
(92, 'NODE-001', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-001 (Bat: 94%, RSSI: -26 dBm)', '2026-04-02 06:17:45', 'resolved'),
(93, 'NODE-001', 'น้ำท่วม', 'SOS', 'From: NODE-001 (Bat: 94%, RSSI: -27 dBm)', '2026-04-02 06:18:04', 'resolved'),
(94, 'NODE-001', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-001 (Bat: 94%, RSSI: -31 dBm)', '2026-04-02 06:18:53', 'resolved'),
(95, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -24 dBm)', '2026-04-02 06:36:40', 'pending'),
(96, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 98%, RSSI: -25 dBm)', '2026-04-02 06:36:44', 'resolved'),
(97, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -27 dBm)', '2026-04-02 06:36:49', 'resolved'),
(98, 'NODE-012', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -41 dBm)', '2026-04-02 06:36:56', 'resolved'),
(99, 'NODE-012', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -40 dBm)', '2026-04-02 06:36:57', 'resolved'),
(100, 'NODE-012', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -55 dBm)', '2026-04-02 06:37:01', 'resolved'),
(101, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -58 dBm)', '2026-04-02 06:37:42', 'resolved'),
(102, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 98%, RSSI: -55 dBm)', '2026-04-02 06:37:51', 'resolved'),
(103, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -37 dBm)', '2026-04-02 06:37:56', 'resolved'),
(104, 'NODE-012', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -37 dBm)', '2026-04-02 06:37:57', 'resolved'),
(105, 'NODE-012', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -34 dBm)', '2026-04-02 06:37:58', 'resolved'),
(106, 'NODE-012', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -25 dBm)', '2026-04-02 06:47:10', 'pending'),
(107, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 100%, RSSI: -25 dBm)', '2026-04-02 06:49:02', 'pending'),
(108, 'NODE-001', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-001 (Bat: 96%, RSSI: -22 dBm)', '2026-04-02 06:49:07', 'pending'),
(109, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -24 dBm)', '2026-04-02 06:49:22', 'pending'),
(110, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 96%, RSSI: -23 dBm)', '2026-04-02 06:49:27', 'pending'),
(111, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 96%, RSSI: -23 dBm)', '2026-04-02 06:49:28', 'pending'),
(112, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -23 dBm)', '2026-04-02 06:49:34', 'pending'),
(113, 'NODE-012', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -25 dBm)', '2026-04-02 06:49:42', 'pending'),
(114, 'NODE-012', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -23 dBm)', '2026-04-02 06:49:45', 'pending'),
(115, 'NODE-012', 'ไฟไหม้ !', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -23 dBm)', '2026-04-02 06:49:49', 'pending'),
(116, 'NODE-012', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -23 dBm)', '2026-04-02 06:49:57', 'pending'),
(117, 'NODE-001', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-001 (Bat: 96%, RSSI: -30 dBm)', '2026-04-02 06:50:26', 'pending'),
(118, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 96%, RSSI: -25 dBm)', '2026-04-02 06:50:42', 'pending'),
(119, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -21 dBm)', '2026-04-02 06:50:54', 'pending'),
(120, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -23 dBm)', '2026-04-02 06:50:56', 'pending'),
(121, 'NODE-001', 'น้ำท่วม', 'SOS', 'From: NODE-001 (Bat: 96%, RSSI: -26 dBm)', '2026-04-02 06:51:04', 'pending'),
(122, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 95%, RSSI: -23 dBm)', '2026-04-02 06:51:21', 'pending'),
(123, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -24 dBm)', '2026-04-02 06:51:26', 'pending'),
(124, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 95%, RSSI: -24 dBm)', '2026-04-02 06:51:43', 'pending'),
(125, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 100%, RSSI: -23 dBm)', '2026-04-02 06:51:48', 'pending'),
(126, 'NODE-012', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -24 dBm)', '2026-04-02 06:51:52', 'pending'),
(127, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -23 dBm)', '2026-04-02 06:51:59', 'pending'),
(128, 'NODE-012', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -23 dBm)', '2026-04-02 06:52:03', 'resolved'),
(129, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 94%, RSSI: -23 dBm)', '2026-04-02 06:52:43', 'resolved'),
(130, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -23 dBm)', '2026-04-02 06:52:58', 'resolved'),
(131, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -24 dBm)', '2026-04-02 06:52:58', 'resolved'),
(132, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -22 dBm)', '2026-04-02 06:53:04', 'resolved'),
(133, 'NODE-012', 'ไฟไหม้ !', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -22 dBm)', '2026-04-02 06:53:13', 'resolved'),
(134, 'NODE-001', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-001 (Bat: 94%, RSSI: -27 dBm)', '2026-04-02 06:53:20', 'resolved'),
(135, 'NODE-012', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -21 dBm)', '2026-04-02 06:53:27', 'resolved'),
(136, 'NODE-012', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -22 dBm)', '2026-04-02 06:53:37', 'resolved'),
(137, 'NODE-001', 'สัตว์มีพิษ', 'SOS', 'From: NODE-001 (Bat: 94%, RSSI: -25 dBm)', '2026-04-02 06:53:45', 'resolved'),
(138, 'NODE-001', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-001 (Bat: 94%, RSSI: -20 dBm)', '2026-04-02 06:54:42', 'resolved'),
(139, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 97%, RSSI: -42 dBm)', '2026-04-02 06:59:45', 'resolved'),
(140, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -52 dBm)', '2026-04-02 07:00:08', 'resolved'),
(141, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 94%, RSSI: -35 dBm)', '2026-04-02 07:03:40', 'resolved'),
(142, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 94%, RSSI: -24 dBm)', '2026-04-02 07:03:40', 'resolved'),
(143, 'NODE-012', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -23 dBm)', '2026-04-02 07:05:49', 'resolved'),
(144, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -25 dBm)', '2026-04-02 07:10:15', 'pending'),
(145, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -26 dBm)', '2026-04-02 07:10:27', 'pending'),
(146, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 99%, RSSI: -33 dBm)', '2026-04-02 07:12:32', 'pending'),
(147, 'NODE-012', 'ไฟไหม้ !', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -31 dBm)', '2026-04-02 07:12:34', 'pending'),
(148, 'NODE-012', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -32 dBm)', '2026-04-02 07:12:36', 'pending'),
(149, 'NODE-012', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -31 dBm)', '2026-04-02 07:12:42', 'pending'),
(150, 'NODE-001', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-001 (Bat: 95%, RSSI: -22 dBm)', '2026-04-02 07:12:43', 'pending'),
(151, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -29 dBm)', '2026-04-02 07:12:45', 'pending'),
(152, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -29 dBm)', '2026-04-02 07:12:46', 'pending'),
(153, 'NODE-012', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -27 dBm)', '2026-04-02 07:12:56', 'pending'),
(154, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -29 dBm)', '2026-04-02 07:13:41', 'pending'),
(155, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -25 dBm)', '2026-04-02 07:13:42', 'pending'),
(156, 'NODE-012', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -27 dBm)', '2026-04-02 07:13:50', 'pending'),
(157, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 98%, RSSI: -41 dBm)', '2026-04-02 07:14:46', 'pending'),
(158, 'NODE-001', 'ไฟไหม้ !', 'SOS', 'From: NODE-001 (Bat: 94%, RSSI: -22 dBm)', '2026-04-02 07:17:41', 'pending'),
(159, 'NODE-001', 'ไฟไหม้ !', 'SOS', 'From: NODE-001 (Bat: 94%, RSSI: -17 dBm)', '2026-04-02 07:24:05', 'pending');

-- --------------------------------------------------------

--
-- Table structure for table `commands`
--

CREATE TABLE `commands` (
  `id` int(11) NOT NULL,
  `node_id` varchar(50) NOT NULL,
  `command` varchar(255) NOT NULL,
  `status` enum('pending','sent') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `commands`
--

INSERT INTO `commands` (`id`, `node_id`, `command`, `status`, `created_at`) VALUES
(74, 'NODE-001', 'ACK_SOS', 'pending', '2026-03-15 19:56:56');

-- --------------------------------------------------------

--
-- Table structure for table `devices`
--

CREATE TABLE `devices` (
  `id` varchar(50) NOT NULL,
  `status` enum('Online','Offline') DEFAULT 'Offline',
  `battery` tinyint(3) UNSIGNED DEFAULT 100,
  `user_id` int(11) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_seen` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `devices`
--

INSERT INTO `devices` (`id`, `status`, `battery`, `user_id`, `last_updated`, `last_seen`) VALUES
('GATEWAY-MAIN', 'Online', 100, NULL, '2026-04-02 07:48:58', '2026-04-02 07:48:58'),
('NODE-001', 'Online', 94, 4, '2026-04-02 07:49:00', '2026-04-02 07:49:00'),
('NODE-012', 'Online', 98, 3, '2026-04-02 07:48:54', '2026-04-02 07:48:54');

-- --------------------------------------------------------

--
-- Table structure for table `members`
--

CREATE TABLE `members` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `emergency_name` varchar(255) DEFAULT NULL,
  `emergency_phone` varchar(15) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `members`
--

INSERT INTO `members` (`id`, `name`, `address`, `phone`, `emergency_name`, `emergency_phone`, `created_at`) VALUES
(3, 'ชานนท์ ลานเจริญ', '234/1 ม.5 ต.วังม่วง อ.วังม่วง จ.สระบุรี 18220', '064-8545012', 'โบ้ท', '085-3811242', '2025-12-22 05:48:34'),
(4, 'สมชาย ...', '233/2', '000-000-0000', 'ชาย', '000-000-0000', '2026-03-04 14:10:51');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `admin_id` tinyint(3) UNSIGNED DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `type` enum('General','Emergency') DEFAULT 'General',
  `content` text DEFAULT NULL,
  `recipients` varchar(255) DEFAULT 'All Members',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `admin_id`, `title`, `type`, `content`, `recipients`, `created_at`) VALUES
(1, NULL, 'Hi Hello Sawaddee', '', 'Hi Hello Swadee', 'All', '2026-04-01 19:52:04'),
(2, NULL, '123', '', '123', 'All', '2026-04-02 04:12:20'),
(3, NULL, 'พ่นยุง', '', 'พ่นยุง', 'All', '2026-04-02 04:43:06'),
(4, NULL, 'หยุดกดได้แล้ว', '', 'หยุดกดได้แล้ว', 'All', '2026-04-02 05:21:10'),
(5, NULL, '123', '', '123', 'All', '2026-04-02 06:07:57'),
(6, NULL, '123121212', '', '123', 'All', '2026-04-02 07:03:46'),
(7, NULL, 'คอนฟิว', '', 'โย่ว', 'All', '2026-04-02 07:13:39'),
(8, NULL, 'ไปกินเหล้ากัน', '', 'แบมบูๆ', 'All', '2026-04-02 07:14:05'),
(9, NULL, 'นายดิศรณ์', '', 'สวัสดีจ้าาาาาา', 'All', '2026-04-02 07:15:32'),
(10, NULL, 'ดิศรณ์', '', 'สวัสดีจ้าาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาาอิอิอิอิออิอิิออิอิอิอิอิอิอิอิอิอ', 'All', '2026-04-02 07:16:20'),
(11, NULL, 'สวัสดี', '', 'สวัสดีๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆๆ', 'All', '2026-04-02 07:17:29'),
(12, NULL, '11111111111111111111111111111111111111111111111111111111111', '', '111111111111111111111111', 'All', '2026-04-02 07:19:48');

-- --------------------------------------------------------

--
-- Table structure for table `sos_logs`
--

CREATE TABLE `sos_logs` (
  `id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `location` varchar(255) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `status` enum('Pending','Resolved') DEFAULT 'Pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `alerts`
--
ALTER TABLE `alerts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_alerts_device` (`node_id`);

--
-- Indexes for table `commands`
--
ALTER TABLE `commands`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cmd_device` (`node_id`);

--
-- Indexes for table `devices`
--
ALTER TABLE `devices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_notif_admin` (`admin_id`);

--
-- Indexes for table `sos_logs`
--
ALTER TABLE `sos_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `member_id` (`member_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `alerts`
--
ALTER TABLE `alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=160;

--
-- AUTO_INCREMENT for table `commands`
--
ALTER TABLE `commands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `sos_logs`
--
ALTER TABLE `sos_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `alerts`
--
ALTER TABLE `alerts`
  ADD CONSTRAINT `fk_alerts_device` FOREIGN KEY (`node_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `commands`
--
ALTER TABLE `commands`
  ADD CONSTRAINT `fk_cmd_device` FOREIGN KEY (`node_id`) REFERENCES `devices` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `devices`
--
ALTER TABLE `devices`
  ADD CONSTRAINT `fk_device_owner` FOREIGN KEY (`user_id`) REFERENCES `members` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notif_admin` FOREIGN KEY (`admin_id`) REFERENCES `admins` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `sos_logs`
--
ALTER TABLE `sos_logs`
  ADD CONSTRAINT `fk_sos_member` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
