<?php
header('Content-Type: application/json; charset=utf-8');
require 'db_config.php';

$sql = "SELECT id, username, email, created_at FROM admins ORDER BY id ASC";
$result = $conn->query($sql);
$admins = [];

if ($result) {
    while ($row = $result->fetch_assoc()) {
        $admins[] = $row;
    }
}
echo json_encode($admins);
$conn->close();
?>