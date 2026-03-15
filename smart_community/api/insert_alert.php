<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: text/plain; charset=utf-8"); 
require 'db_config.php'; 

$node_id = isset($_GET['node_id']) ? $conn->real_escape_string($_GET['node_id']) : '';
$battery = isset($_GET['battery']) ? intval(round(floatval($_GET['battery']))) : 0; 
$message = isset($_GET['msg']) ? $conn->real_escape_string($_GET['msg']) : '';
$rssi    = isset($_GET['rssi']) ? intval($_GET['rssi']) : 0;

if ($node_id == '' || $message == '') {
    echo "Error: Missing Data (Node: $node_id, Msg: $message)";
    $conn->close();
    exit();
}

// -------------------------------------------------------------------------
// 🛠️ ส่วนที่แก้ไขใหม่: ป้องกันอุปกรณ์ผี (Ghost Node) ไม่ให้แอบสร้างตัวเองใหม่
// -------------------------------------------------------------------------
$check_node = $conn->query("SELECT id FROM devices WHERE id = '$node_id'");

if ($check_node->num_rows > 0) {
    // ถ้ามีอุปกรณ์นี้ในระบบ ให้อัปเดตสถานะและแบตเตอรี่ตามปกติ
    $sql_update = "UPDATE devices SET status='Online', battery='$battery', last_seen=NOW() WHERE id='$node_id'";
    $conn->query($sql_update);
} else {
    // 🚫 ถ้าไม่มีรายชื่ออุปกรณ์นี้ในระบบ (ถูกลบไปแล้ว) ให้บล็อกการทำงานและเด้งออกทันที!
    echo "Error: Unknown Device ($node_id)! Request Ignored.";
    $conn->close();
    exit(); 
}
// -------------------------------------------------------------------------

if (strpos($message, "STATUS") !== false || strpos($message, "HELLO") !== false) {
    echo "Device Updated ($node_id | Bat: $battery%)";
    $conn->close();
    exit(); 
}

$type = "General"; 
$sos_keywords = ["ไฟไหม้", "ช่วยเหลือ", "SOS", "เจ็บป่วย", "ฉุกเฉิน", "อุบัติเหตุ", "รถชน", "น้ำท่วม", "สัตว์มีพิษ"];
$security_keywords = ["โจร", "บุกรุก", "ขโมย"];

foreach ($sos_keywords as $key) {
    if (strpos($message, $key) !== false) { $type = "SOS"; break; }
}
foreach ($security_keywords as $key) {
    if (strpos($message, $key) !== false) { $type = "Security"; break; }
}

$bat_display = ($battery >= 101) ? "⚡ กำลังชาร์จ" : $battery . "%";

$detail = "From: $node_id (Bat: $bat_display, RSSI: $rssi dBm)";
$search_detail = "From: $node_id%"; 

$check_dup = "SELECT id FROM alerts 
              WHERE message = '$message' 
              AND detail LIKE '$search_detail' 
              AND time >= NOW() - INTERVAL 1 MINUTE 
              AND status != 'resolved'"; 

$result_dup = $conn->query($check_dup);

if ($result_dup->num_rows > 0) {
    echo "Duplicate ignored (Spam protection)";
    $conn->close();
    exit(); 
}

$sql_alert = "INSERT INTO alerts (node_id, message, type, detail, time, status) 
              VALUES ('$node_id', '$message', '$type', '$detail', NOW(), 'pending')";

if ($conn->query($sql_alert) === TRUE) {
    echo "Success: Alert Saved (Bat: $battery%)";
} else {
    echo "Error: " . $conn->error;
}

$conn->close();
?>