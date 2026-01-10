<?php
require 'db_config.php';

// รับค่าจาก Gateway
$raw_msg = isset($_GET['msg']) ? $_GET['msg'] : '';
$rssi = isset($_GET['rssi']) ? $_GET['rssi'] : 0;

if ($raw_msg != "") {
    // 1. แยกข้อมูล ID|BAT|MSG
    $parts = explode("|", $raw_msg);
    
    $node_id = "Unknown";
    $battery = 0;
    $message = $raw_msg; 
    
    if (count($parts) >= 3) {
        $node_id = $parts[0];  
        $battery = intval($parts[1]); 
        $message = $parts[2];  
        
        // อัปเดตสถานะอุปกรณ์ (Device Status)
        $sql_device = "INSERT INTO devices (id, status, battery, last_seen) 
                       VALUES ('$node_id', 'Online', '$battery', NOW())
                       ON DUPLICATE KEY UPDATE 
                       status='Online', battery='$battery', last_seen=NOW()";
        $conn->query($sql_device);
    }

    // 2. ตรวจสอบประเภทเหตุ
    $type = "General";
    if (strpos($message, "ไฟไหม้") !== false) $type = "SOS";
    if (strpos($message, "ช่วยเหลือ") !== false) $type = "SOS";
    if (strpos($message, "โจร") !== false) $type = "Security";
    if (strpos($message, "ทดสอบ") !== false) $type = "Test";
    
    $detail = "From: $node_id (Bat: $battery%, RSSI: $rssi dBm)";

    // --- 🟢 แก้ไข: ป้องกันข้อมูลซ้ำโดยเช็ค detail ด้วย (กันพลาดกรณีเครื่องอื่นส่งมาพร้อมกัน) ---
    $check_dup = "SELECT id FROM alerts 
                  WHERE message = '$message' 
                  AND detail = '$detail' 
                  AND time >= NOW() - INTERVAL 5 SECOND";

    $result_dup = $conn->query($check_dup);

    if ($result_dup->num_rows > 0) {
        echo "Duplicate ignored";
        $conn->close();
        exit(); 
    }
    // -----------------------------------------------------

    // --- 🟢 แก้ไข: เพิ่ม 'status' ลงไปใน INSERT เพื่อให้หน้าเว็บเด้งสีแดงชัวร์ๆ ---
    $sql_alert = "INSERT INTO alerts (message, type, detail, time, status) 
                  VALUES ('$message', '$type', '$detail', NOW(), 'pending')";
    
    if ($conn->query($sql_alert) === TRUE) {
        echo "Success: Alert Saved & Device Synced";
    } else {
        echo "Error: " . $conn->error;
    }

} else {
    echo "Empty Message";
}

$conn->close();
?>