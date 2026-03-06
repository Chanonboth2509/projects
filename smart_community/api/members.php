<?php
header("Content-Type: application/json; charset=UTF-8");
include 'db_config.php';

$method = $_SERVER['REQUEST_METHOD'];

if ($method == 'GET') {
    $sql = "SELECT * FROM members ORDER BY id DESC";
    $result = $conn->query($sql);
    $members = array();
    while($row = $result->fetch_assoc()) {
        $members[] = array(
            "id" => $row['id'],
            "name" => $row['name'],
            "address" => $row['address'],
            "phone" => $row['phone'],
            "emergency" => array(
                "name" => $row['emergency_name'],
                "phone" => $row['emergency_phone']
            )
        );
    }
    echo json_encode($members);
}

if ($method == 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);
    
    $name = $data['name'];
    $address = $data['address'];
    $phone = $data['phone'];
    $em_name = $data['emergency']['name'];
    $em_phone = $data['emergency']['phone'];

    if (isset($data['id']) && $data['id'] != "") {
        $id = $data['id'];
        $sql = "UPDATE members SET name='$name', address='$address', phone='$phone', emergency_name='$em_name', emergency_phone='$em_phone' WHERE id=$id";
    } else {
        $sql = "INSERT INTO members (name, address, phone, emergency_name, emergency_phone) VALUES ('$name', '$address', '$phone', '$em_name', '$em_phone')";
    }

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => $conn->error]);
    }
}

if ($method == 'DELETE') {
    $id = $_GET['id'];
    $sql = "DELETE FROM members WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error"]);
    }
}

$conn->close();
?>