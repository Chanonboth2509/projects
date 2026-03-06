<?php
// ไฟล์: api/notifications.php
header("Content-Type: application/json; charset=UTF-8");
require 'db_config.php';

$method = $_SERVER['REQUEST_METHOD'];

// --- ส่วนที่ 1: ส่งประกาศ (POST) ---
if ($method === 'POST') {
    $input = file_get_contents("php://input");
    $data = json_decode($input, true);
    
    if (!empty($data['title']) && !empty($data['content'])) {
        $title = $conn->real_escape_string($data['title']);
        $content = $conn->real_escape_string($data['content']);
        $type = $conn->real_escape_string($data['type'] ?? 'General');

        // 1. บันทึกลงตาราง notifications
        $sql = "INSERT INTO notifications (title, content, type, recipients) VALUES ('$title', '$content', '$type', 'All')";
        
        if ($conn->query($sql) === TRUE) {
            // 2. เขียนไฟล์ให้ Gateway นำไปส่ง LoRa
            $msgForGateway = "$type|$title|$content";
            file_put_contents("broadcast.txt", $msgForGateway);
            
            echo json_encode(["status" => "success", "message" => "Saved & Queued for Gateway"]);
        } else {
            echo json_encode(["status" => "error", "message" => $conn->error]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "ข้อมูลไม่ครบ"]);
    }
} 
// --- ส่วนที่ 2: ดึงประวัติรวม (GET) ---
else {
    // 🟢 ใช้ UNION ดึงจาก notifications และ alerts (ที่รับเรื่องแล้ว)
    $sql = "
        (SELECT id, title, content, type, created_at AS date_sort 
         FROM notifications)
        UNION ALL
        (SELECT id, message AS title, detail AS content, type, time AS date_sort 
         FROM alerts 
         WHERE status = 'resolved') 
        ORDER BY date_sort DESC LIMIT 5";

    $result = $conn->query($sql);
    $notes = [];
    
    if ($result) {
        while($row = $result->fetch_assoc()) {
            // จัดรูปแบบวันที่ให้สวยงามสำหรับหน้าเว็บ
            $row['date'] = date("d/m H:i", strtotime($row['date_sort'])); 
            $notes[] = $row;
        }
    }
    echo json_encode($notes);
}
$conn->close();
?>