<?php
header('Content-Type: application/json');

$host = 'localhost';
$user = 'root';
$pass = '';
$db   = 'smart_community';

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "เชื่อมต่อฐานข้อมูลล้มเหลว: " . $conn->connect_error]));
}

$sql_alerts = "TRUNCATE TABLE alerts"; 
$clear_alerts = $conn->query($sql_alerts);

$sql_notifications = "TRUNCATE TABLE notifications"; 
$clear_notifications = $conn->query($sql_notifications);

if ($clear_alerts === TRUE && $clear_notifications === TRUE) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => "ลบข้อมูลไม่ได้: " . $conn->error]);
}

$conn->close();
?>