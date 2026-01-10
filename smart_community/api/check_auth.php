<?php
session_start();
header("Content-Type: application/json");
if (isset($_SESSION['admin_id'])) {
    echo json_encode(["auth" => true, "user" => $_SESSION['admin_name']]);
} else {
    echo json_encode(["auth" => false]);
}
?>