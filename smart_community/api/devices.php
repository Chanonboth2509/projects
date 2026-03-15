<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'db_config.php'; 

$method = $_SERVER['REQUEST_METHOD'];

// --- GET: ดึงข้อมูลอุปกรณ์พร้อมชื่อเจ้าของ และที่อยู่ (JOIN Table) ---
if ($method == 'GET') {
    // 🟢 แก้ไข 1: เพิ่ม m.address as owner_address ในคำสั่ง SELECT
    $sql = "SELECT d.*, m.name as owner_name, m.address as owner_address 
            FROM devices d 
            LEFT JOIN members m ON d.user_id = m.id 
            ORDER BY d.id ASC";
            
    $result = $conn->query($sql);
    
    $devices = array();
    if ($result) {
        while($row = $result->fetch_assoc()) {
            $devices[] = array(
                "id" => $row['id'],
                "status" => $row['status'],
                "battery" => (int)$row['battery'],
                "userId" => $row['user_id'],
                "owner_name" => $row['owner_name'],
                
                // 🟢 แก้ไข 2: เพิ่มฟิลด์ owner_address ลงใน JSON ที่ส่งกลับ
                "owner_address" => isset($row['owner_address']) ? $row['owner_address'] : null,
                
                "last_seen" => isset($row['last_seen']) ? $row['last_seen'] : null 
            );
        }
    }
    echo json_encode($devices);
}

// --- ส่วน POST, PUT, DELETE ให้ใช้โค้ดเดิมของคุณได้เลยครับ (ไม่มีเปลี่ยนแปลง) ---
if ($method == 'POST' || $method == 'PUT') {
    $input = file_get_contents("php://input");
    $data = json_decode($input, true);

    if (!isset($data['id'])) {
        echo json_encode(["status" => "error", "message" => "Device ID is required"]);
        exit;
    }

    $id = $conn->real_escape_string($data['id']);
    $userId = !empty($data['userId']) ? "'" . $conn->real_escape_string($data['userId']) . "'" : "NULL";
    
    $check = $conn->query("SELECT id FROM devices WHERE id = '$id'");
    
    if ($check->num_rows > 0) {
        $sql = "UPDATE devices SET user_id = $userId WHERE id = '$id'";
    } else {
        $sql = "INSERT INTO devices (id, status, battery, user_id) VALUES ('$id', 'Offline', 100, $userId)";
    }

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success"]);
    } else {
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }
}

if ($method == 'DELETE') {
    $input = file_get_contents("php://input");
    $data = json_decode($input, true);

    if (isset($data['id'])) {
        $id = $conn->real_escape_string($data['id']);
        $sql = "DELETE FROM devices WHERE id = '$id'";
        if ($conn->query($sql) === TRUE) {
             echo json_encode(["status" => "success"]);
        } else {
             http_response_code(500);
             echo json_encode(["status" => "error", "message" => $conn->error]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "ID is required"]);
    }
}

$conn->close();
?>