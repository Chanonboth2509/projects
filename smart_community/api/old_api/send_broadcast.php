<?php
header("Content-Type: application/json");
require 'db_config.php';

$data = json_decode(file_get_contents("php://input"), true);

if(isset($data['title']) && isset($data['message'])) {
    $title = $conn->real_escape_string($data['title']);
    $msg = $conn->real_escape_string($data['message']);
    
    // บันทึกลงตาราง messages (Gateway จะมา poll ตารางนี้)
    // หมายเหตุ: คุณต้องสร้างตาราง 'messages' หรือใช้ตาราง alerts โดยระบุ type='Broadcast'
    $sql = "INSERT INTO alerts (message, type, detail, time) VALUES ('$title: $msg', 'Broadcast', 'Sent from Web', NOW())";
    
    if($conn->query($sql)) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }
}
$conn->close();
?>