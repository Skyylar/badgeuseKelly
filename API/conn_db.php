<?php

$servername = "localhost";

$username = "root";

$password = "123";

$dbname = "api_badgeuse";
try {
    $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password, array(
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
}
catch (Exception $e) {
    echo $e->getMessage();
}
