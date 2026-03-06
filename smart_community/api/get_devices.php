<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
require 'db_config.php';

$sql_kick = "UPDATE devices 
             SET status = 'Offline', 
                 last_seen = last_seen 
             WHERE last_seen < (NOW() - INTERVAL 1 MINUTE)";

$conn->query($sql_kick);
$sql = "SELECT * FROM devices ORDER BY id ASC";
$result = $conn->query($sql);

$devices = [];
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $devices[] = $row;
    }
}

echo json_encode($devices);
$conn->close();
?>