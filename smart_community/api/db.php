<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$servername = "localhost";
$username = "root";        // ⚠️ แก้ให้ตรงกับเครื่องคุณ
$password = "";            // ⚠️ แก้ให้ตรงกับเครื่องคุณ
$dbname = "smart_community"; // ⚠️ ชื่อ Database ต้องเป๊ะ

$conn = new mysqli($servername, $username, $password, $dbname);
$conn->set_charset("utf8");

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "DB Connect Failed: " . $conn->connect_error]));
}
?>