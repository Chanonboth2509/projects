<?php
// ไฟล์: api/logout.php
session_start();

// ล้างค่า Session ทั้งหมด
session_unset();

// ทำลาย Session ทิ้ง
session_destroy();

// ส่งสถานะกลับไปบอก Javascript
header("Content-Type: application/json");
echo json_encode(["status" => "success", "message" => "Logged out successfully"]);
?>