<?php
// Gateway ESP32 จะยิงมาที่นี่
if (file_exists("broadcast.txt")) {
    echo file_get_contents("broadcast.txt");
} else {
    echo "No Message";
}
?>