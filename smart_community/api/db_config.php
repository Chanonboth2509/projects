<?php
$servername = "localhost";
$username = "root"; // ปกติ XAMPP ใช้ root
$password = "";     // ปกติ XAMPP ไม่มีรหัส
$dbname = "smart_community"; // ⚠️ ชื่อฐานข้อมูลต้องตรงกับที่คุณสร้าง

$conn = new mysqli($servername, $username, $password, $dbname);
$conn->set_charset("utf8");

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}
?>