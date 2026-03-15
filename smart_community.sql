-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 15, 2026 at 05:41 AM
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
(15, 'b', 'b@gmail.com', 'both2509', 'b', '2026-03-13 12:23:05');

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
(8, 'NODE-001', 'สัตว์มีพิษ', 'SOS', 'From: NODE-001 (Bat: 100%, RSSI: -37 dBm)', '2026-03-14 15:23:12', 'resolved'),
(9, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 100%, RSSI: -39 dBm)', '2026-03-14 15:23:17', 'resolved'),
(10, 'NODE-001', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-001 (Bat: 100%, RSSI: -34 dBm)', '2026-03-14 15:24:40', 'resolved'),
(11, 'NODE-001', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-001 (Bat: 100%, RSSI: -28 dBm)', '2026-03-14 15:25:42', 'resolved'),
(12, 'NODE-001', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-001 (Bat: 100%, RSSI: -28 dBm)', '2026-03-14 15:26:00', 'resolved'),
(13, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -44 dBm)', '2026-03-14 15:26:01', 'resolved'),
(14, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -25 dBm)', '2026-03-14 15:30:16', 'resolved'),
(15, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -34 dBm)', '2026-03-14 15:30:17', 'resolved'),
(16, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 100%, RSSI: -16 dBm)', '2026-03-14 15:30:45', 'resolved'),
(17, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 99%, RSSI: -34 dBm)', '2026-03-14 15:30:54', 'resolved'),
(18, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 99%, RSSI: -35 dBm)', '2026-03-14 15:32:25', 'resolved'),
(19, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 100%, RSSI: -35 dBm)', '2026-03-14 15:38:35', 'resolved'),
(20, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 100%, RSSI: -36 dBm)', '2026-03-14 15:41:06', 'resolved'),
(21, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -36 dBm)', '2026-03-14 15:41:14', 'resolved'),
(22, 'NODE-012', 'น้ำท่วม', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -39 dBm)', '2026-03-14 15:42:42', 'resolved'),
(23, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -43 dBm)', '2026-03-14 15:43:46', 'resolved'),
(24, 'NODE-012', 'ขอความช่วยเหลือ', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -44 dBm)', '2026-03-14 15:44:06', 'resolved'),
(25, 'NODE-001', 'ไฟไหม้ !', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -31 dBm)', '2026-03-14 15:44:29', 'resolved'),
(26, 'NODE-012', 'ไฟไหม้ !', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -36 dBm)', '2026-03-14 15:47:10', 'resolved'),
(27, 'NODE-012', 'สัตว์มีพิษ', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -41 dBm)', '2026-03-14 15:47:42', 'resolved'),
(28, 'NODE-012', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-012 (Bat: 100%, RSSI: -41 dBm)', '2026-03-14 15:49:23', 'resolved'),
(29, 'NODE-001', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -34 dBm)', '2026-03-14 15:49:40', 'resolved'),
(30, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -30 dBm)', '2026-03-14 15:56:34', 'resolved'),
(31, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -35 dBm)', '2026-03-14 15:56:34', 'resolved'),
(32, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -42 dBm)', '2026-03-14 15:56:48', 'resolved'),
(33, 'NODE-001', 'อุบัติเหตุ/รถชน', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -30 dBm)', '2026-03-14 15:57:08', 'resolved'),
(34, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -27 dBm)', '2026-03-14 15:57:15', 'resolved'),
(35, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -35 dBm)', '2026-03-14 15:58:34', 'resolved'),
(36, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -46 dBm)', '2026-03-14 16:54:23', 'resolved'),
(37, 'NODE-001', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-001 (Bat: 100%, RSSI: -43 dBm)', '2026-03-14 16:54:39', 'resolved'),
(38, 'NODE-001', 'เจ็บป่วยฉุกเฉิน', 'SOS', 'From: NODE-001 (Bat: 100%, RSSI: -42 dBm)', '2026-03-14 16:54:41', 'resolved'),
(39, 'NODE-001', 'มีผู้บุกรุก/โจร', 'Security', 'From: NODE-001 (Bat: 100%, RSSI: -44 dBm)', '2026-03-14 17:01:54', 'resolved'),
(40, 'NODE-012', 'POWERON โหนดพร้อมทำงาน', 'General', 'From: NODE-012 (Bat: 100%, RSSI: -46 dBm)', '2026-03-14 17:18:00', 'resolved'),
(41, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -45 dBm)', '2026-03-14 17:18:06', 'resolved'),
(42, 'NODE-012', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-012 (Bat: 100%, RSSI: -44 dBm)', '2026-03-14 17:18:19', 'resolved'),
(43, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 100%, RSSI: -43 dBm)', '2026-03-14 17:19:14', 'resolved'),
(44, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 100%, RSSI: -34 dBm)', '2026-03-14 17:19:15', 'resolved'),
(45, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -42 dBm)', '2026-03-14 17:19:43', 'resolved'),
(46, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน|Direct', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -34 dBm)', '2026-03-14 17:19:44', 'resolved'),
(47, 'NODE-001', 'SOS ขอความช่วยเหลือด่วน', 'SOS', 'From: NODE-001 (Bat: 98%, RSSI: -49 dBm)', '2026-03-14 17:20:07', 'resolved');

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
(15, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:25:26'),
(16, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:25:28'),
(17, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:25:29'),
(18, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:25:51'),
(19, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:33:02'),
(20, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:33:05'),
(21, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:33:06'),
(22, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:33:08'),
(23, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:33:09'),
(24, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:33:11'),
(25, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:33:12'),
(26, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:39:09'),
(27, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:41:21'),
(28, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:41:23'),
(29, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:43:08'),
(30, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:44:02'),
(31, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:44:22'),
(32, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:45:34'),
(33, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:47:37'),
(34, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:49:20'),
(35, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:49:36'),
(36, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:50:05'),
(37, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:57:02'),
(38, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:57:04'),
(39, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:57:05'),
(40, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:57:53'),
(41, 'NODE-001', 'ACK_SOS', '', '2026-03-14 15:57:54'),
(42, 'NODE-012', 'ACK_SOS', '', '2026-03-14 15:58:57'),
(43, 'NODE-001', 'ACK_SOS', '', '2026-03-14 16:55:11'),
(44, 'NODE-001', 'ACK_SOS', '', '2026-03-14 16:55:13'),
(45, 'NODE-012', 'ACK_SOS', '', '2026-03-14 16:55:14'),
(46, 'NODE-001', 'ACK_SOS', '', '2026-03-14 17:19:24'),
(47, 'NODE-001', 'ACK_SOS', '', '2026-03-14 17:19:25'),
(48, 'NODE-012', 'ACK_SOS', '', '2026-03-14 17:19:27'),
(49, 'NODE-012', 'ACK_SOS', '', '2026-03-14 17:19:28'),
(50, 'NODE-012', 'ACK_SOS', '', '2026-03-14 17:19:32'),
(51, 'NODE-001', 'ACK_SOS', '', '2026-03-14 17:19:33'),
(52, 'NODE-001', 'ACK_SOS', '', '2026-03-14 17:19:48'),
(53, 'NODE-001', 'ACK_SOS', '', '2026-03-14 17:19:50'),
(54, 'NODE-001', 'ACK_SOS', '', '2026-03-14 17:20:34');

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
('GATEWAY-MAIN', 'Online', 100, NULL, '2026-03-14 18:04:30', '2026-03-14 18:04:30'),
('node-001', 'Online', 98, 3, '2026-03-14 18:03:58', '2026-03-14 18:03:58'),
('node-012', 'Online', 98, 4, '2026-03-14 17:36:38', '2026-03-14 17:36:38');

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
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `alerts`
--
ALTER TABLE `alerts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `commands`
--
ALTER TABLE `commands`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `members`
--
ALTER TABLE `members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
