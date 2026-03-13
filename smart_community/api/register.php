<?php
header("Content-Type: application/json; charset=UTF-8");
include 'db_config.php';

$data = json_decode(file_get_contents("php://input"), true);
$user = $data['username']; 
$email = $data['email'];   
$pass = $data['password'];

if (!empty($user) && !empty($pass) && !empty($email)) {

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode(["status" => "error", "message" => "รูปแบบอีเมลไม่ถูกต้อง (ต้องมี @)"]);
        exit();
    }
    
    if (strlen($pass) < 6) {
        echo json_encode(["status" => "error", "message" => "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร"]);
        exit();
    }

    $user = $conn->real_escape_string($user);
    $email = $conn->real_escape_string($email); 
    $pass = $conn->real_escape_string($pass);

    $check = "SELECT id FROM admins WHERE username = '$user'";
    if ($conn->query($check)->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "ชื่อผู้ใช้นี้ถูกใช้ไปแล้ว กรุณาใช้ชื่ออื่น"]);
    } else {
        $sql = "INSERT INTO admins (username, email, password, name, created_at) 
                VALUES ('$user', '$email', '$pass', '$user', NOW())";
        
        if ($conn->query($sql)) {
            echo json_encode(["status" => "success"]);
        } else {
            echo json_encode(["status" => "error", "message" => "SQL Error: " . $conn->error]);
        }
    }
} else {
    echo json_encode(["status" => "error", "message" => "กรุณากรอกข้อมูลให้ครบถ้วน"]);
}
?>