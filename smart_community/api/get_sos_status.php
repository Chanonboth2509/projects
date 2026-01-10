<?php
header("Content-Type: application/json");
require 'db_config.php';

// 1. ดึงข้อมูลล่าสุด 10 รายการที่ไม่ใช่ Broadcast
$sql = "SELECT * FROM alerts WHERE type != 'Broadcast' ORDER BY id DESC LIMIT 10";
$result = $conn->query($sql);

$alerts = [];
if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $phpTime = strtotime($row['time']);
        $timeStr = date("H:i", $phpTime) . " น.";
        
        // 🟢 ตรวจสอบสถานะ: ถ้า status ไม่ใช่ 'resolved' (คือยังไม่ได้รับเคส) ให้แสดงสีแดง
        // วิธีนี้จะครอบคลุมทั้งค่าที่เป็น 'pending', ค่าว่างเปล่า (NULL), หรือค่าเริ่มต้นอื่นๆ
        $dbStatus = isset($row['status']) ? $row['status'] : '';
        
        if ($dbStatus !== 'resolved') {
            $alerts[] = [
                "id" => $row['id'],
                "status" => "alert", // สั่งให้หน้าเว็บแสดงช่องสีแดง
                "message" => $row['message'],
                "detail" => $row['detail'],
                "type" => $row['type'],
                "time" => $timeStr
            ];
        }
    }
}

// 2. ส่งข้อมูลกลับ
// ถ้าทุกรายการถูกเปลี่ยนเป็น 'resolved' หมดแล้ว หน้าจอจะกลับเป็นสีเขียวเอง
echo json_encode($alerts);
$conn->close();
?>