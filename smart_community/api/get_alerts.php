<?php
header("Content-Type: application/json");
require 'db_config.php';

// ดึง 10 รายการล่าสุด
$sql = "SELECT * FROM alerts ORDER BY time DESC LIMIT 10";
$result = $conn->query($sql);

$alerts = [];
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        // จัดรูปแบบเวลาให้สวยงาม
        $phpTime = strtotime($row['time']);
        $timeStr = date("H:i", $phpTime) . " น.";
        
        $alerts[] = [
            "id" => $row['id'],
            "message" => $row['message'],
            "type" => $row['type'],       
            "detail" => $row['detail'],   
            "time" => $timeStr,
            
            // 🔥 เพิ่มบรรทัดนี้ครับ (สำคัญมาก!)
            "status" => $row['status']    
        ];
    }
}

echo json_encode($alerts);
$conn->close();
?>