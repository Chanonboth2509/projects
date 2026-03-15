<?php
session_start();
header("Content-Type: application/json; charset=utf-8");
header("Cache-Control: no-cache, no-store, must-revalidate");
header("Pragma: no-cache");
header("Expires: 0");

require 'db_config.php';

if (isset($_SESSION['admin_id'])) {
    $admin_id = $conn->real_escape_string($_SESSION['admin_id']);
    $check_sql = "SELECT id FROM admins WHERE id = '$admin_id'";
    $result = $conn->query($check_sql);
    
    if ($result && $result->num_rows > 0) {
        $email = isset($_SESSION['admin_email']) ? $_SESSION['admin_email'] : 'lanjalernchanon@gmail.com';
        echo json_encode([
            "auth" => true, 
            "user" => $_SESSION['admin_name'],
            "email" => $email
        ]);
    } else {
        session_destroy();
        echo json_encode(["auth" => false]);
    }
} else {
    echo json_encode(["auth" => false]);
}

if (isset($conn)) { $conn->close(); }
?>