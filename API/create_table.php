<?php

$sql = ("CREATE TABLE IF NOT EXISTS " . $promo . " (
  `Login`              VARCHAR(40)  NOT NULL,
  `Nom`                VARCHAR(100) NOT NULL,
  `Prenom`             VARCHAR(100) NOT NULL,
  `close`              VARCHAR(10)  NOT NULL,
  `badgeuse`	       VARCHAR(6)   DEFAULT false,
  `Heure_badgeuse`     TIME,
  `Date`               DATE
);");

echo "=====";
echo $sql;

$req = $conn->prepare($sql);
$req->execute();

