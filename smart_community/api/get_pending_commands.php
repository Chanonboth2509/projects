<?php
header("Content-Type: application/json");
require 'db_config.php';

// 1. ค้นหาคำสั่งที่ยังไม่ได้ส่ง (status = 'pending') มา 1 รายการ (เอาที่เก่าสุดก่อน)
$sql = "SELECT * FROM commands WHERE status = 'pending' ORDER BY created_at ASC LIMIT 1";
$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $row = $result->fetch_assoc();
    
    // 2. ถ้าเจอ ให้ส่ง JSON กลับไปบอก Gateway
    echo json_encode([
        "status" => "has_command",       // บอกว่ามีคำสั่งนะ
        "node_id" => $row['node_id'],    // ส่งไปหาเครื่องไหน
        "command" => $row['command']     // คำสั่งอะไร (เช่น ACK_SOS)
    ]);

    // 3. ⚠️ สำคัญ: เปลี่ยนสถานะเป็น 'fetched' ทันที 
    // เพื่อป้องกัน Gateway หยิบคำสั่งเดิมไปทำซ้ำๆ ไม่หยุด
    $cmd_id = $row['id'];
    $conn->query("UPDATE commands SET status = 'fetched' WHERE id = $cmd_id");

} else {
    // 4. ถ้าไม่มีคำสั่งอะไรเลย
    echo json_encode(["status" => "empty"]);
}

$conn->close();
?>