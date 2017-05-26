<?php

$sql = ("CREATE TABLE IF NOT EXISTS " . $promo . " (
  `ID`                 INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Login`              VARCHAR(40)  NOT NULL,
  `Nom`                VARCHAR(100) NOT NULL,
  `Prenom`             VARCHAR(100) NOT NULL,
  `close`              VARCHAR(10)  NOT NULL,
  `Retard`	       INT DEFAULT 0,
  `Absence`	       INT DEFAULT 0,
  `badgeuse`	       VARCHAR(6)   DEFAULT 'false',
  `Heure_badgeuse`     TIME,
  `Date`               DATE
);");

echo $sql;
$req = $this->_db->prepare($sql);
$req->execute();


