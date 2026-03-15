<?php
session_start();
header("Content-Type: application/json");
header("Cache-Control: no-cache, no-store, must-revalidate");
require 'db_config.php';

$members_count = 0;
$res = $conn->query("SELECT COUNT(*) as c FROM members");
if($res) $members_count = $res->fetch_assoc()['c'];

$nodes_total = 0;
$res_total = $conn->query("SELECT COUNT(*) as c FROM devices WHERE id != 'GATEWAY-MAIN'");
if($res_total) $nodes_total = $res_total->fetch_assoc()['c'];

$nodes_online = 0;
$res_online = $conn->query("SELECT COUNT(*) as c FROM devices WHERE id != 'GATEWAY-MAIN' AND status = 'Online'");
if($res_online) $nodes_online = $res_online->fetch_assoc()['c'];

$battery_stats = [0, 0, 0, 0]; 
$res_bat = $conn->query("SELECT battery FROM devices WHERE id != 'GATEWAY-MAIN' AND status = 'Online'");
if($res_bat) {
    while($row = $res_bat->fetch_assoc()) {
        $bat = intval($row['battery']);
        if($bat < 20) {
            $battery_stats[0]++; 
        } elseif($bat <= 60) {
            $battery_stats[1]++; 
        } elseif($bat <= 90) {
            $battery_stats[2]++; 
        } else {
            $battery_stats[3]++; 
        }
    }
}

$sos_count = 0;
$sql_sos = "SELECT COUNT(*) as c FROM alerts WHERE type='SOS' AND status != 'resolved'";
$res = $conn->query($sql_sos);
if($res) $sos_count = $res->fetch_assoc()['c'];

$latest_broadcast = "ไม่มีประกาศ";
$sql_last = "SELECT title FROM notifications ORDER BY created_at DESC LIMIT 1";
$res = $conn->query($sql_last);
if($res && $res->num_rows > 0) {
    $latest_broadcast = $res->fetch_assoc()['title'];
}

$gateway_status = 'offline';
$res_gw = $conn->query("SELECT status FROM devices WHERE id = 'GATEWAY-MAIN'");
if ($res_gw && $res_gw->num_rows > 0) {
    $row_gw = $res_gw->fetch_assoc();
    if (strtolower($row_gw['status']) === 'online') {
        $gateway_status = 'online';
    }
}

$admin_name = isset($_SESSION['admin_name']) ? $_SESSION['admin_name'] : 'Admin';
$admin_email = isset($_SESSION['admin_email']) ? $_SESSION['admin_email'] : 'lanjalernchanon@gmail.com';

echo json_encode([
    "members_count" => $members_count,
    "nodes_online" => $nodes_online,
    "nodes_total" => $nodes_total,
    "sos_count" => $sos_count,
    "latest_broadcast" => $latest_broadcast,
    "battery_stats" => $battery_stats,
    "gateway_status" => $gateway_status,
    "admin_name" => $admin_name,
    "admin_email" => $admin_email
]);

$conn->close();
?>