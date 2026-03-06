<?php
header("Content-Type: application/json");
require 'db_config.php';

// =================================================================
// 🟢 ส่วนที่เพิ่มใหม่: บันทึก Heartbeat ของ Gateway
// ทุกครั้งที่บอร์ดทักมาถามคำสั่ง ให้ถือว่ามัน Online และรีเซ็ตเวลาใหม่
// =================================================================
$sql_heartbeat = "INSERT INTO devices (id, status, battery, last_seen) 
                  VALUES ('GATEWAY-MAIN', 'Online', 100, NOW()) 
                  ON DUPLICATE KEY UPDATE status='Online', battery=100, last_seen=NOW()";
$conn->query($sql_heartbeat);

// 1. ค้นหาคำสั่งที่ยังไม่ได้ส่ง (status = 'pending')
$sql = "SELECT * FROM commands WHERE status = 'pending' ORDER BY created_at ASC LIMIT 1";
$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $row = $result->fetch_assoc();
    
    // 2. ถ้าเจอ ให้ส่ง JSON กลับไปบอก Gateway
    echo json_encode([
        "status" => "has_command",       
        "node_id" => $row['node_id'],    
        "command" => $row['command']     
    ]);

    // 3. เปลี่ยนสถานะเป็น 'fetched' ทันที 
    $cmd_id = $row['id'];
    $conn->query("UPDATE commands SET status = 'fetched' WHERE id = $cmd_id");

} else {
    // 4. ถ้าไม่มีคำสั่งอะไรเลย
    echo json_encode(["status" => "empty"]);
}

$conn->close();
?>