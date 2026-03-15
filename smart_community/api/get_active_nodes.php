<?php
error_reporting(0); 
require 'db_config.php'; 
$result = $conn->query("SELECT id FROM devices WHERE id != 'GATEWAY-MAIN' AND status = 'Online'");

$nodes = array();
if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $nodes[] = trim($row['id']);
    }
}
echo implode(",", $nodes);
?>