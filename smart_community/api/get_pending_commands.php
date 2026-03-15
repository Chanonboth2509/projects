<?php
header("Content-Type: application/json");
require 'db_config.php';
$sql_heartbeat = "INSERT INTO devices (id, status, battery, last_seen) 
                  VALUES ('GATEWAY-MAIN', 'Online', 100, NOW()) 
                  ON DUPLICATE KEY UPDATE status='Online', battery=100, last_seen=NOW()";
$conn->query($sql_heartbeat);

$sql = "SELECT * FROM commands WHERE status = 'pending' ORDER BY created_at ASC LIMIT 1";
$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
    $row = $result->fetch_assoc();
    
    echo json_encode([
        "status" => "has_command",       
        "node_id" => $row['node_id'],    
        "command" => $row['command']     
    ]);

    $cmd_id = $row['id'];
    $conn->query("UPDATE commands SET status = 'fetched' WHERE id = $cmd_id");

} else {
    echo json_encode(["status" => "empty"]);
}

$conn->close();
?>