<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: text/plain; charset=utf-8"); 
require 'db_config.php'; 

$node_id = isset($_GET['node_id']) ? $_GET['node_id'] : '';
$battery = isset($_GET['battery']) ? intval($_GET['battery']) : 0;
$message = isset($_GET['msg']) ? $_GET['msg'] : '';
$rssi    = isset($_GET['rssi']) ? intval($_GET['rssi']) : 0;

if ($node_id == '' && strpos($message, '|') !== false) {
    $parts = explode("|", $message);
    if (count($parts) >= 3) {
        $node_id = $parts[0];
        $battery = intval($parts[1]);
        $message = $parts[2];
    }
}

if ($node_id == '' && $message == '') {
    echo "Error: No Data";
    $conn->close();
    exit();
}

$sql_device = "INSERT INTO devices (id, status, battery, last_seen) 
               VALUES ('$node_id', 'Online', '$battery', NOW())
               ON DUPLICATE KEY UPDATE 
               status='Online', battery='$battery', last_seen=NOW()";

if (!$conn->query($sql_device)) {
}

if (strpos($message, "STATUS") !== false) {
    echo "Heartbeat Updated ($node_id | Bat: $battery%)";
    $conn->close();
    exit(); 
}

$type = "General"; 

if (strpos($message, "ไฟไหม้") !== false) $type = "SOS";
if (strpos($message, "ช่วยเหลือ") !== false) $type = "SOS";
if (strpos($message, "SOS") !== false) $type = "SOS";
if (strpos($message, "เจ็บป่วย") !== false) $type = "SOS";
if (strpos($message, "ฉุกเฉิน") !== false) $type = "SOS";
if (strpos($message, "อุบัติเหตุ") !== false) $type = "SOS"; 
if (strpos($message, "รถชน") !== false) $type = "SOS"; 
if (strpos($message, "น้ำท่วม") !== false) $type = "SOS"; 
if (strpos($message, "สัตว์มีพิษ") !== false) $type = "SOS"; 
if (strpos($message, "โจร") !== false) $type = "Security";
if (strpos($message, "บุกรุก") !== false) $type = "Security";

$detail = "From: $node_id (Bat: $battery%, RSSI: $rssi dBm)";

$search_detail = "From: $node_id%"; 

$check_dup = "SELECT id FROM alerts 
              WHERE message = '$message' 
              AND detail LIKE '$search_detail' 
              AND time >= NOW() - INTERVAL 2 MINUTE 
              AND status != 'resolved'"; 

$result_dup = $conn->query($check_dup);

if ($result_dup->num_rows > 0) {
    echo "Duplicate ignored (Spam protection)";
    $conn->close();
    exit(); 
}

$sql_alert = "INSERT INTO alerts (message, type, detail, time, status) 
              VALUES ('$message', '$type', '$detail', NOW(), 'pending')";

if ($conn->query($sql_alert) === TRUE) {
    echo "Success: Alert Saved (Bat: $battery%)";
} else {
    echo "Error: " . $conn->error;
}

$conn->close();
?>