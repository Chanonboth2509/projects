<?php
header("Content-Type: application/json; charset=UTF-8");
include 'db_config.php';

$data = json_decode(file_get_contents("php://input"), true);
$user = $data['username']; 
$email = $data['email'];   // รับอีเมลมาแล้ว
$pass = $data['password'];

// เพิ่มการเช็คว่าต้องมี email ด้วย
if (!empty($user) && !empty($pass) && !empty($email)) {
    $user = $conn->real_escape_string($user);
    $email = $conn->real_escape_string($email); // 🟢 ป้องกัน SQL Injection ให้ email
    $pass = $conn->real_escape_string($pass);

    // เช็คว่าชื่อผู้ใช้นี้ซ้ำไหม
    $check = "SELECT id FROM admins WHERE username = '$user'";
    if ($conn->query($check)->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "ชื่อผู้ใช้นี้ถูกใช้ไปแล้ว กรุณาใช้ชื่ออื่น"]);
    } else {
        // 🟢 เพิ่มคอลัมน์ email และตัวแปร '$email' ลงในคำสั่ง SQL
        $sql = "INSERT INTO admins (username, email, password, name, created_at) 
                VALUES ('$user', '$email', '$pass', '$user', NOW())";
        
        if ($conn->query($sql)) {
            echo json_encode(["status" => "success"]);
        } else {
            echo json_encode(["status" => "error", "message" => "SQL Error: " . $conn->error]);
        }
    }
} else {
    echo json_encode(["status" => "error", "message" => "กรุณากรอกข้อมูลให้ครบถ้วน (ชื่อ, อีเมล, รหัสผ่าน)"]);
}
$conn->close();
?>