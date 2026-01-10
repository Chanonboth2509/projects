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

        // 1. บันทึกลงฐานข้อมูล (เพื่อให้มีประวัติ)
        $sql = "INSERT INTO notifications (title, content, type, recipients) VALUES ('$title', '$content', '$type', 'All')";
        
        if ($conn->query($sql) === TRUE) {
            
            // 🔥 [จุดที่ต้องแก้] เขียนไฟล์ Text ให้ Gateway (สำคัญมาก!)
            // Gateway จะส่ง LoRa ตามข้อความในไฟล์นี้
            // รูปแบบ: TYPE|TITLE|CONTENT
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
// --- ส่วนที่ 2: ดึงประวัติ (GET) ---
else {
    $sql = "SELECT * FROM notifications ORDER BY id DESC LIMIT 5";
    $result = $conn->query($sql);
    $notes = [];
    if ($result) {
        while($row = $result->fetch_assoc()) {
            // จัดรูปแบบวันที่ให้สวยงาม
            $row['date'] = date("d/m H:i", strtotime($row['created_at'] ?? $row['date'])); 
            $notes[] = $row;
        }
    }
    echo json_encode($notes);
}
$conn->close();
?>