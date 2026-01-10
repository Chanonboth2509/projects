<?php
// เคลียร์ค่าขยะทุกอย่างก่อนเริ่มทำงาน
ob_clean(); 

// ปิด Error HTML หน้าเว็บ (ให้ส่งแต่ JSON)
error_reporting(E_ALL);
ini_set('display_errors', 0); 

header("Content-Type: application/json");

$response = [];

try {
    // 1. เชื่อมต่อฐานข้อมูล
    if (file_exists('db_config.php')) {
        require_once 'db_config.php';
    } elseif (file_exists('../db_config.php')) {
        require_once '../db_config.php';
    } else {
        throw new Exception("หาไฟล์ db_config.php ไม่เจอ");
    }

    // 2. รับข้อมูลจากหน้าเว็บ
    $input = file_get_contents("php://input");
    $data = json_decode($input, true);

    if (!isset($data['node_id'])) {
        throw new Exception("ไม่พบรหัสอุปกรณ์ (Node ID)");
    }

    $node_id = $conn->real_escape_string($data['node_id']);
    
    // 3. บันทึกคำสั่งลงตาราง commands (เพื่อให้ Gateway ส่ง LoRa กลับ)
    // หมายเหตุ: ตาราง commands ต้องมีคอลัมน์ node_id, command, status
    $sql_cmd = "INSERT INTO commands (node_id, command, status) VALUES ('$node_id', 'ACK_SOS', 'pending')";
    $conn->query($sql_cmd); 
    // (ถ้าตาราง commands ไม่มีคอลัมน์ node_id ให้แก้บรรทัดบนเป็นชื่อคอลัมน์ที่ถูก หรือคอมเมนต์ทิ้งไปก่อนถ้ายังไม่ใช้ Gateway)

    // -------------------------------------------------------------------------
    // 🟢 4. ส่วนสำคัญ: อัปเดตสถานะในตาราง alerts ให้จบเคส (ช่องแดงหาย)
    // ใช้ LIKE '%$node_id%' เพื่อหาแถวที่มีชื่อ Node นี้อยู่ในข้อความ detail
    // -------------------------------------------------------------------------
    $sql_update = "UPDATE alerts SET status = 'resolved' WHERE detail LIKE '%$node_id%' AND (status != 'resolved' OR status IS NULL)";
    
    if ($conn->query($sql_update)) {
        $response = [
            "status" => "success", 
            "message" => "✅ รับเคสแล้ว! ระบบได้เคลียร์การแจ้งเตือนของ $node_id ออกจากหน้าจอแล้ว"
        ];
    } else {
        throw new Exception("Update Failed: " . $conn->error);
    }

} catch (Exception $e) {
    // ส่ง Error กลับเป็น JSON เสมอ
    http_response_code(500);
    $response = [
        "status" => "error", 
        "message" => "เกิดข้อผิดพลาด: " . $e->getMessage()
    ];
}

// ส่งผลลัพธ์กลับ
echo json_encode($response);

if (isset($conn)) $conn->close();
?>