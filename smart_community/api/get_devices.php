<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
require 'db_config.php'; // ⚠️ เช็ค path config ให้ถูก

// =========================================================
// 🟢 ส่วนสำคัญ: สั่ง Database ให้เปลี่ยนสถานะทันที
// =========================================================

// 1. ถ้าใครเงียบไปเกิน 5 นาที (เทียบกับเวลาปัจจุบันของ Server) ให้แก้เป็น Offline
$sql_kick = "UPDATE devices 
             SET status = 'Offline', 
                 last_seen = last_seen 
             WHERE last_seen < (NOW() - INTERVAL 1 MINUTE)";

$conn->query($sql_kick);

// =========================================================
// 2. ดึงข้อมูลล่าสุด (ที่อัปเดตแล้ว) ส่งกลับไปให้หน้าเว็บ
// =========================================================
$sql = "SELECT * FROM devices ORDER BY id ASC";
$result = $conn->query($sql);

$devices = [];
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $devices[] = $row;
    }
}

echo json_encode($devices);
$conn->close();
?>