<?php
header("Content-Type: application/json; charset=UTF-8");
include 'db.php';

// เชื่อมตาราง sos_logs กับ members เพื่อเอาชื่อคนแจ้ง
$sql = "SELECT s.*, m.name as sender_name 
        FROM sos_logs s 
        LEFT JOIN members m ON s.member_id = m.id 
        ORDER BY s.created_at DESC LIMIT 20";

$result = $conn->query($sql);

$data = array();
if ($result) {
    while($row = $result->fetch_assoc()) {
        $data[] = array(
            "id" => $row['id'],
            // ถ้าหาชื่อเจอให้ใส่ชื่อ ถ้าไม่เจอให้บอกว่า Unknown
            "user_name" => $row['sender_name'] ?? 'Unknown Member (ID: '.$row['member_id'].')', 
            "status" => $row['status'],
            "location" => $row['location'],
            "handler" => "Admin",
            "date" => date("d/m/Y H:i", strtotime($row['created_at']))
        );
    }
}

echo json_encode($data);
$conn->close();
?>