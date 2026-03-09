<?php
// 1. เริ่มเก็บ Buffer (เพื่อกันขยะหลุดออกไปก่อน)
ob_start();

// ปิด Error หน้าเว็บ (ให้ไปลง Log แทน)
error_reporting(E_ALL);
ini_set('display_errors', 0); 

header("Content-Type: application/json");

$response = [];

try {
    // 2. โหลดไฟล์ Database
    if (file_exists('db_config.php')) {
        require_once 'db_config.php';
    } elseif (file_exists('../db_config.php')) { // เผื่อไฟล์อยู่นอกโฟลเดอร์
        require_once '../db_config.php';
    } else {
        throw new Exception("หาไฟล์ db_config.php ไม่เจอ");
    }

    // 3. รับข้อมูล
    $input = file_get_contents("php://input");
    $data = json_decode($input, true);

    if (!isset($data['node_id'])) {
        throw new Exception("ไม่พบรหัสอุปกรณ์ (Node ID)");
    }

    $node_id = $conn->real_escape_string($data['node_id']);
    
    // 4. บันทึกคำสั่ง (ต้องแน่ใจว่าสร้างตาราง commands แล้ว)
    $sql_cmd = "INSERT INTO commands (node_id, command, status) VALUES ('$node_id', 'ACK_SOS', 'pending')";
    
    if (!$conn->query($sql_cmd)) {
        throw new Exception("SQL Error: " . $conn->error);
    }

    $response = [
        "status" => "success", 
        "message" => "ส่งสัญญาณรับทราบกลับไปที่ $node_id เรียบร้อยแล้ว"
    ];

} catch (Exception $e) {
    $response = [
        "status" => "error", 
        "message" => "เกิดข้อผิดพลาด: " . $e->getMessage()
    ];
}

// 5. ล้างขยะทั้งหมดที่อาจจะหลุดมาก่อนหน้านี้ (สำคัญมาก!)
ob_end_clean();

// 6. ส่ง JSON เพียวๆ
echo json_encode($response);

if (isset($conn)) $conn->close();
?>