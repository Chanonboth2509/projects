<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
require 'db_config.php';

// ใช้ UNION ALL เพื่อรวมข้อมูลจากตาราง alerts และ notifications
$sql = "
    SELECT id, message, type, detail, time, status 
    FROM alerts
    
    UNION ALL
    
    SELECT id, title AS message, 'Broadcast' AS type, content AS detail, created_at AS time, 'Sent' AS status 
    FROM notifications
    
    ORDER BY time DESC
";

$result = $conn->query($sql);

$reports = [];
if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        // แปลงวันที่เป็นรูปแบบ d/m/Y H:i
        $phpTime = strtotime($row['time']);
        $dateStr = date("d/m/Y H:i", $phpTime);
        
        $reports[] = [
            "id" => $row['id'],
            "datetime" => $dateStr,           
            "raw_msg" => $row['message'],     
            "type" => $row['type'],           
            "detail" => $row['detail'],       
            "status" => isset($row['status']) ? $row['status'] : 'Saved'
        ];
    }
}

echo json_encode($reports);
$conn->close();
?>