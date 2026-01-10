<?php
session_start();
header("Content-Type: application/json; charset=UTF-8");
include 'db.php'; // ตรวจสอบว่าไฟล์ db.php อยู่ข้างๆ กัน

$data = json_decode(file_get_contents("php://input"), true);
$user = $data['username'];
$pass = $data['password'];

// เช็คข้อมูลในฐานข้อมูล
$sql = "SELECT * FROM admins WHERE username = '" . $conn->real_escape_string($user) . "' AND password = '" . $conn->real_escape_string($pass) . "'";
$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $_SESSION['admin_id'] = $row['id'];
    $_SESSION['admin_name'] = $row['name'];
    echo json_encode(["status" => "success"]);
} else {
    // ถ้า Login ไม่ผ่าน
    echo json_encode(["status" => "error", "message" => "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง"]);
}
$conn->close();
?>