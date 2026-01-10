<?php
header("Content-Type: application/json");
require 'db_config.php';

// 1. นับจำนวนลูกบ้าน (สมมติมีตาราง members)
$members_count = 0;
$res = $conn->query("SELECT COUNT(*) as c FROM members");
if($res) $members_count = $res->fetch_assoc()['c'];

// 2. นับ Node ออนไลน์ (สมมติมีตาราง devices)
$nodes_online = 0;
$nodes_total = 0;
$battery_stats = [0, 0, 0, 0]; // <20%, 20-60%, 61-90%, >90%

$res = $conn->query("SELECT status, battery FROM devices");
if($res) {
    $nodes_total = $res->num_rows;
    while($row = $res->fetch_assoc()) {
        if($row['status'] == 'Online') $nodes_online++;
        
        // จัดกลุ่มแบตเตอรี่
        $bat = intval($row['battery']);
        if($bat < 20) $battery_stats[0]++;
        elseif($bat <= 60) $battery_stats[1]++;
        elseif($bat <= 90) $battery_stats[2]++;
        else $battery_stats[3]++;
    }
}

// 3. นับ SOS วันนี้ (จากตาราง alerts ที่ Gateway ส่งมา)
$sos_count = 0;
// นับเฉพาะ type='SOS' และเป็นของ "วันนี้"
$sql_sos = "SELECT COUNT(*) as c FROM alerts WHERE type='SOS' AND DATE(time) = CURDATE()";
$res = $conn->query($sql_sos);
if($res) $sos_count = $res->fetch_assoc()['c'];

// 4. ข้อความล่าสุด
$latest_broadcast = "ไม่มีรายงาน";
$sql_last = "SELECT message FROM alerts ORDER BY time DESC LIMIT 1";
$res = $conn->query($sql_last);
if($res && $res->num_rows > 0) $latest_broadcast = $res->fetch_assoc()['message'];

echo json_encode([
    "members_count" => $members_count,
    "nodes_online" => $nodes_online,
    "nodes_total" => $nodes_total,
    "sos_count" => $sos_count,
    "latest_broadcast" => $latest_broadcast,
    "battery_stats" => $battery_stats
]);

$conn->close();
?>