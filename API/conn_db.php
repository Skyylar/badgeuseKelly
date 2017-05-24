<?php

$servername = "localhost";
$username = your_user;
$password = your_password;
$dbname = "api_badgeuse";
try {
    $db = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password, array(
        PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
}
catch (Exception $e) {
    echo $e->getMessage();
}

