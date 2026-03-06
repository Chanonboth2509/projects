<?php
// ไฟล์: api/ack_alert.php
header("Content-Type: application/json; charset=UTF-8");

// 1. เชื่อมต่อฐานข้อมูล (หาไฟล์ config ให้เจอ)
if (file_exists('../db_config.php')) {
    require_once '../db_config.php';
} elseif (file_exists('db_config.php')) {
    require_once 'db_config.php';
} else {
    http_response_code(500);
    echo json_encode(["status" => "error", "message" => "Database config not found"]);
    exit();
}

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['id'])) {
    $id = $conn->real_escape_string($data['id']);
    
    // --- 🟢 ส่วนที่เพิ่มใหม่: ดึงชื่อ Node ออกมาจากแจ้งเตือนก่อน ---
    $sql_get_node = "SELECT detail FROM alerts WHERE id = '$id'";
    $result = $conn->query($sql_get_node);
    
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $detail = $row['detail']; // ตัวอย่าง: "From: NODE-001 (Bat: ...)"
        
        // แกะเอาเฉพาะคำว่า NODE-001 ออกมา (อยู่หลังคำว่า From:)
        // ใช้การระเบิดข้อความด้วยช่องว่าง
        $parts = explode(" ", $detail);
        if (count($parts) >= 2) {
            $node_id = $parts[1]; // ตัวที่ 2 คือ ID (NODE-001)
            
            // 🔥 สร้างคำสั่งลงตาราง commands ให้ Gateway มาหยิบไปทำ
            // Gateway จะเห็นว่ามี command 'ACK_SOS' รออยู่ แล้วจะส่ง LoRa กลับไปหา Node
            $sql_cmd = "INSERT INTO commands (node_id, command, status) VALUES ('$node_id', 'ACK_SOS', 'pending')";
            $conn->query($sql_cmd);
        }
    }
    // -----------------------------------------------------------

    // 2. อัปเดตสถานะในเว็บให้เป็น resolved (เหมือนเดิม)
    $sql = "UPDATE alerts SET status = 'resolved' WHERE id = '$id'";
    
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "รับเรื่องและส่งสัญญาณกลับเรียบร้อย"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "No ID provided"]);
}

$conn->close();
?>