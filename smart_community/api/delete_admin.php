<?php
header('Content-Type: application/json; charset=utf-8');
require 'db_config.php';

$data = json_decode(file_get_contents("php://input"), true);
$id = isset($data['id']) ? $conn->real_escape_string($data['id']) : '';

if (!empty($id)) {
    $sql = "DELETE FROM admins WHERE id = '$id'";
    
    if ($conn->query($sql) === TRUE) {
        echo json_encode(['status' => 'success']);
    } else {
        echo json_encode(['status' => 'error', 'message' => "ลบไม่ได้: " . $conn->error]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'ไม่พบ ID ที่ต้องการลบ']);
}
$conn->close();
?>