<?php
header("Content-Type: application/json; charset=UTF-8");
require 'db_config.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    $input = file_get_contents("php://input");
    $data = json_decode($input, true);
    
    if (!empty($data['title']) && !empty($data['content'])) {
        $title = $conn->real_escape_string($data['title']);
        $content = $conn->real_escape_string($data['content']);
        $type = $conn->real_escape_string($data['type'] ?? 'General');

        $sql = "INSERT INTO notifications (title, content, type, recipients) VALUES ('$title', '$content', '$type', 'All')";
        
        if ($conn->query($sql) === TRUE) {
            
            // 🛡️ ดึงรายชื่ออุปกรณ์เฉพาะที่ขึ้นต้นด้วย "NODE-" เท่านั้น (ตัด GATEWAY ทิ้งไปเลย)
            $target_nodes = [];
            $node_query = $conn->query("SELECT id FROM devices WHERE id LIKE 'NODE-%'");
            if ($node_query->num_rows > 0) {
                while($r = $node_query->fetch_assoc()) {
                    $target_nodes[] = $r['id'];
                }
            }

            // ถ้ามีอุปกรณ์ลูกบ้าน ค่อยสร้างไฟล์ให้ Gateway
            if (count($target_nodes) > 0) {
                $target_string = implode(",", $target_nodes); 
                // ผลลัพธ์ที่จะได้คือ: NODE-012|General ประกาศ...
                $msgForGateway = "$target_string|$type $title $content";
                file_put_contents("broadcast.txt", $msgForGateway, LOCK_EX);
            } else {
                // ถ้าไม่มีลูกบ้านเลย ให้เขียนไฟล์หลอกไว้ Gateway จะได้ไม่ทำอะไร
                file_put_contents("broadcast.txt", "EMPTY|ไม่มีลูกบ้าน", LOCK_EX);
            }
            
            echo json_encode(["status" => "success", "message" => "Saved & Queued for Gateway"]);
        } else {
            echo json_encode(["status" => "error", "message" => $conn->error]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "ข้อมูลไม่ครบ"]);
    }
} 
else {
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
            $row['date'] = date("d/m H:i", strtotime($row['date_sort'])); 
            $notes[] = $row;
        }
    }
    echo json_encode($notes);
}
$conn->close();
?>