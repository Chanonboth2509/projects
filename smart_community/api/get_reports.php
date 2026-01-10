<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
require 'db_config.php';

// ดึงข้อมูลทั้งหมด เรียงจากล่าสุดไปเก่าสุด
$sql = "SELECT * FROM alerts ORDER BY time DESC";
$result = $conn->query($sql);

$reports = [];
if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        // แปลงวันที่เป็นรูปแบบ d/m/Y H:i
        $phpTime = strtotime($row['time']);
        $dateStr = date("d/m/Y H:i", $phpTime);
        
        $reports[] = [
            "id" => $row['id'],
            "datetime" => $dateStr,           // วันที่ที่จัดฟอร์แมตแล้ว
            "raw_msg" => $row['message'],     // ข้อความหลัก
            "type" => $row['type'],           // SOS, Security, Test, General
            "detail" => $row['detail'],       // ข้อมูล RSSI หรือ Node ID
            
            // ถ้าใน DB มีคอลัมน์ status ให้ใช้ค่าจริง ถ้าไม่มีให้ใช้ 'Saved'
            "status" => isset($row['status']) ? $row['status'] : 'Saved'
        ];
    }
}

echo json_encode($reports);
$conn->close();
?>