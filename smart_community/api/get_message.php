<?php
if (file_exists("broadcast.txt")) {
    echo file_get_contents("broadcast.txt");
} else {
    echo "No Message";
}
?>