<?php
header("Content-Type: application/json");
header("Cache-Control: no-cache, no-store, must-revalidate");
require '../db_config.php';

// ---------------------------------------------------
// 1. ปรับเวลาให้ยืดหยุ่นขึ้น (จาก 3 นาที เป็น 30 นาที) 
// เพื่อให้สถานะ Online อยู่ได้นานขึ้นขณะทดสอบ
// ---------------------------------------------------
$conn->query("UPDATE devices SET status = 'Offline' WHERE last_seen < (NOW() - INTERVAL 1 MINUTE)");

// ---------------------------------------------------
// 2. นับจำนวน Online 
// ---------------------------------------------------
$online_count = 0;
$res_online = $conn->query("SELECT COUNT(*) as count FROM devices WHERE status = 'Online'");
if ($res_online) $online_count = $res_online->fetch_assoc()['count'];

// ---------------------------------------------------
// 3. นับจำนวน SOS (ตรวจสอบความถูกต้องของเงื่อนไข)
// ---------------------------------------------------
$sos_count = 0;
$res_sos = $conn->query("SELECT COUNT(*) as count FROM alerts WHERE type = 'SOS' AND status != 'resolved'");
if ($res_sos) $sos_count = $res_sos->fetch_assoc()['count'];

// ---------------------------------------------------
// 4. ดึงประกาศล่าสุด
// ---------------------------------------------------
$latest_msg = "ไม่มีประกาศ";
$latest_type = "normal";
$res_last = $conn->query("SELECT * FROM alerts ORDER BY time DESC LIMIT 1");
if ($res_last && $res_last->num_rows > 0) {
    $row = $res_last->fetch_assoc();
    $latest_msg = $row['message'];
    $latest_type = $row['type'];
}

// ---------------------------------------------------
// 5. เช็คสถานะ Gateway (ปรับให้รองรับ Case-Sensitive)
// ---------------------------------------------------
$gateway_status = 'offline';
$res_gw = $conn->query("SELECT status FROM devices WHERE id = 'GATEWAY-MAIN'");
if ($res_gw && $res_gw->num_rows > 0) {
    $status_val = $res_gw->fetch_assoc()['status'];
    // เช็คทั้ง Online และ online เพื่อความชัวร์
    if (strtolower($status_val) === 'online') {
        $gateway_status = 'online';
    }
}

echo json_encode([
    "online" => $online_count,
    "sos" => $sos_count,
    "latest_msg" => $latest_msg,
    "latest_type" => $latest_type,
    "gateway_status" => $gateway_status
]);

$conn->close();
?>