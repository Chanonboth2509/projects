<?php
header("Content-Type: application/json; charset=UTF-8");

if (file_exists('../db_config.php')) { require_once '../db_config.php'; } 
elseif (file_exists('db_config.php')) { require_once 'db_config.php'; } 
else { exit(json_encode(["status" => "error", "message" => "DB Error"])); }

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['id'])) {
    $id = $conn->real_escape_string($data['id']);
    
    $sql_get_node = "SELECT detail FROM alerts WHERE id = '$id'";
    $result = $conn->query($sql_get_node);
    
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $detail = $row['detail']; 
        $parts = explode(" ", $detail);
        
        if (count($parts) >= 2) {
            $node_id = trim($parts[1]); 
            
            $house_name = $node_id;
            if ($node_id == "NODE-001") $house_name = "234/1";
            if ($node_id == "NODE-012") $house_name = "233/2";
            $spaces = str_repeat(" ", rand(1, 3));
            $command_msg = "จนท.รับเรื่องบ้าน" . $spaces . "$house_name แล้ว";
            
            $target_nodes = [];
            $node_query = $conn->query("SELECT id FROM devices WHERE id LIKE 'NODE-%'");
            if ($node_query->num_rows > 0) {
                while($r = $node_query->fetch_assoc()) {
                    $target_nodes[] = $r['id'];
                }
            }

            if (count($target_nodes) > 0) {
                $target_string = implode(",", $target_nodes); 
                $msgForGateway = "$target_string|$command_msg";
                file_put_contents("broadcast.txt", $msgForGateway, LOCK_EX);
            } else {
                $msgForGateway = "$node_id|$command_msg";
                file_put_contents("broadcast.txt", $msgForGateway, LOCK_EX);
            }
        }
    }
    
    $sql = "UPDATE alerts SET status = 'resolved' WHERE id = '$id'";
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "รับเรื่องและสั่ง Gateway เรียบร้อย"]);
    } else {
        echo json_encode(["status" => "error", "message" => "อัปเดตสถานะไม่ได้"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "ไม่ได้ส่ง ID มา"]);
}

$conn->close();
?>