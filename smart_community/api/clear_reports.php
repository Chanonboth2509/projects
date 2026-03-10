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
$sql = "TRUNCATE TABLE alerts"; 

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => "ลบข้อมูลไม่ได้: " . $conn->error]);
}

$conn->close();
?>