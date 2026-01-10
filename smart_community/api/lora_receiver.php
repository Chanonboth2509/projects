<?php
// ไฟล์: api/lora_receiver.php
// หน้าที่: รับค่าจาก LoRa Gateway แล้วอัปเดตลงฐานข้อมูล
header("Content-Type: application/json; charset=UTF-8");
include 'db.php';

// รับค่าแบบ JSON หรือ POST Form
$data = json_decode(file_get_contents("php://input"), true);

// ถ้าไม่มี JSON ให้ลองรับแบบ POST ปกติ (x-www-form-urlencoded)
if (is_null($data)) {
    $id = $_POST['id'];
    $battery = $_POST['battery'];
} else {
    $id = $data['id'];
    $battery = $data['battery'];
}

// ตรวจสอบข้อมูล
if (!isset($id) || !isset($battery)) {
    http_response_code(400);
    echo json_encode(["status" => "error", "message" => "Incomplete Data"]);
    exit();
}

// อัปเดตข้อมูลลง MySQL
// หมายเหตุ: เราตั้ง Status เป็น 'Online' อัตโนมัติ เพราะมีการส่งข้อมูลเข้ามา
$sql = "UPDATE devices SET battery = $battery, status = 'Online', last_updated = NOW() WHERE id = '$id'";

if ($conn->query($sql) === TRUE) {
    // เช็คว่าอัปเดตเจอไหม (ถ้า Device ID ผิดจะไม่เจอ)
    if ($conn->affected_rows > 0) {
        echo json_encode(["status" => "success"]);
    } else {
        // ถ้าไม่เจอ ID นี้ในระบบ อาจจะสั่งให้ Insert เพิ่มอัตโนมัติก็ได้ (Optional)
        echo json_encode(["status" => "warning", "message" => "Device ID not found"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}

$conn->close();
?>