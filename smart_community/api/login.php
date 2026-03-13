<?php
session_start(); 
header("Content-Type: application/json; charset=UTF-8");
include 'db_config.php'; 
$data = json_decode(file_get_contents("php://input"), true);
if (!$data) {
    $data = $_POST;
}

$user = isset($data['username']) ? $data['username'] : '';
$pass = isset($data['password']) ? $data['password'] : '';

$sql = "SELECT * FROM admins WHERE username = '" . $conn->real_escape_string($user) . "' AND password = '" . $conn->real_escape_string($pass) . "'";
$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $_SESSION['admin_id'] = $row['id'];
    $_SESSION['admin_name'] = $row['name'];
    $_SESSION['admin_email'] = $row['email']; 
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง"]);
}

$conn->close();
?>