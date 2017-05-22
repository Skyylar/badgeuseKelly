<?php
$sql = ("DROP TABLE " . $promo);
$req = $conn->prepare($sql);
$req->execute();
