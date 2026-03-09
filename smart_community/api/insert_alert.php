<?php
// insert_alert.php
header("Access-Control-Allow-Origin: *");
header("Content-Type: text/plain; charset=utf-8"); 
require 'db_config.php'; 

// 🌟 1. รับค่าแยกตาม Parameter ที่ Gateway ส่งมา
$node_id = isset($_GET['node_id']) ? $conn->real_escape_string($_GET['node_id']) : '';
$battery = isset($_GET['battery']) ? floatval($_GET['battery']) : 0.0; // ใช้ floatval เพื่อรองรับทศนิยม
$message = isset($_GET['msg']) ? $conn->real_escape_string($_GET['msg']) : '';
$rssi    = isset($_GET['rssi']) ? intval($_GET['rssi']) : 0;

// 🌟 2. กรณีฉุกเฉิน: ถ้า Gateway ส่งมาเป็นก้อนเดียว (msg อย่างเดียว) ให้ช่วยแยกให้
if ($node_id == '' && strpos($message, '|') !== false) {
    $parts = explode("|", $message);
    if (count($parts) >= 3) {
        $node_id = $conn->real_escape_string($parts[0]);
        $battery = floatval($parts[1]);
        $message = $conn->real_escape_string($parts[2]);
    }
}

if ($node_id == '' || $message == '') {
    echo "Error: Missing Data (Node: $node_id, Msg: $message)";
    $conn->close();
    exit();
}

// 🌟 3. อัปเดตสถานะอุปกรณ์ (Table: devices)
$sql_device = "INSERT INTO devices (id, status, battery, last_seen) 
               VALUES ('$node_id', 'Online', '$battery', NOW())
               ON DUPLICATE KEY UPDATE 
               status='Online', battery='$battery', last_seen=NOW()";
$conn->query($sql_device);

// 🌟 4. ถ้าเป็นแค่การส่ง STATUS (Heartbeat) ไม่ต้องบันทึกลง Alert
if (strpos($message, "STATUS") !== false || strpos($message, "HELLO") !== false) {
    echo "Device Updated ($node_id | Bat: $battery%)";
    $conn->close();
    exit(); 
}

// 🌟 5. คัดกรองประเภทเหตุการณ์
$type = "General"; 
$sos_keywords = ["ไฟไหม้", "ช่วยเหลือ", "SOS", "เจ็บป่วย", "ฉุกเฉิน", "อุบัติเหตุ", "รถชน", "น้ำท่วม", "สัตว์มีพิษ"];
$security_keywords = ["โจร", "บุกรุก", "ขโมย"];

foreach ($sos_keywords as $key) {
    if (strpos($message, $key) !== false) { $type = "SOS"; break; }
}
foreach ($security_keywords as $key) {
    if (strpos($message, $key) !== false) { $type = "Security"; break; }
}

$detail = "From: $node_id (Bat: $battery%, RSSI: $rssi dBm)";
$search_detail = "From: $node_id%"; 

// 🌟 6. ระบบป้องกัน Spam (ห้ามส่งซ้ำภายใน 1 นาที)
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

// 🌟 7. บันทึกแจ้งเหตุ (Table: alerts)
$sql_alert = "INSERT INTO alerts (message, type, detail, time, status) 
              VALUES ('$message', '$type', '$detail', NOW(), 'pending')";

if ($conn->query($sql_alert) === TRUE) {
    echo "Success: Alert Saved (Bat: $battery%)";
} else {
    echo "Error: " . $conn->error;
}

$conn->close();
?>