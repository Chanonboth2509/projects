<?php
session_start();
header("Content-Type: application/json");

if (isset($_SESSION['admin_id'])) {
    // ดึงอีเมลจาก Session (ถ้าไม่มีให้ใช้ค่าเริ่มต้น)
    $email = isset($_SESSION['admin_email']) ? $_SESSION['admin_email'] : 'lanjalernchanon@gmail.com';
    
    echo json_encode([
        "auth" => true, 
        "user" => $_SESSION['admin_name'],
        "email" => $email
    ]);
} else {
    echo json_encode(["auth" => false]);
}
?>