<?php
require_once('class.phpmailer.php');
include 'conn_db.php';

$badgeuse = $_GET['badgeuse'];
$fname = $_GET['fname'];
$lname = $_GET['lname'];
$login = $_GET['login'];
$close = $_GET['close'];
$promo = $_GET['promo'];
$update = $_GET['update'];
$getter = $_GET['get'];
$send = $_GET['send'];
$promo = str_replace(" ", "", $promo);
$closecompte = $_GET['closecompte'];

if (isset($fname) && isset($lname) && isset($login) && isset($close) && isset($promo)) { 
	include 'create_table.php';
	$sql = ("INSERT INTO " . $promo . " (Login, Nom, Prenom, close, Date) VALUES( '" . $login . "', '" . $lname . "', '" . $fname . "', '" . $close . "', CURRENT_TIMESTAMP);");
	$req = $conn->prepare($sql);
	$req->execute();
	echo $sql;
}

if (isset($getter) && isset($promo)) {
	$sql = ("SELECT * FROM " . $promo);
	$req = $conn->prepare($sql);
	$req->execute();
	while ($donnees = $req->fetch()) {
		echo $donnees['Login'] . " ";
		echo $donnees['Prenom'] . " ";
		echo $donnees['Nom'] . " ";
		echo $donnees['Heure_badgeuse'] . " " ;
		echo $donnees['Date'] . "\n";
	}
}

if (isset($update) && isset($login) && isset($promo)) {
	$sql = ("UPDATE `" . $promo . "` SET `badgeuse` = 'true', `Heure_badgeuse` = CURRENT_TIMESTAMP, `close` = 'false' WHERE `Login`='" . $login . "';");
	$req = $conn->prepare($sql);
	$req->execute();
}

if (isset($badgeuse) & isset($promo)) {
        $sql = ("SELECT * FROM `" . $promo . "` WHERE `badgeuse` != 'true'");
        $req = $conn->prepare($sql);
        $req->execute();
        while ($donnees = $req->fetch()) {
                echo $donnees['Login'] . " ";
        }
}

if (isset($closecompte) && isset($promo)) {
	$sql = ("SELECT * FROM `" . $promo . "` WHERE `close` = 'true'");
        $req = $conn->prepare($sql);
        $req->execute();
	while ($donnees = $req->fetch()) {
	        echo $donnees['Login'] . " ";
        }
}

if (isset($send) && isset($promo)) {
$sql = ("SELECT * FROM " . $promo);
$list = []; 
        $req = $conn->prepare($sql);
        $req->execute();
        while ($donnees = $req->fetch()) {  
		$list[] = array($donnees['Login'], $donnees['Prenom'], $donnees['Nom'], $donnees['Heure_badgeuse'], $donnees['Date']);
	}

$file="file.csv";
$fp=fopen($file,"w");

foreach ($list as $fields) {
    fputcsv($fp, $fields);
}
fclose($fp);

$mail = new PHPMailer();
$mail->AddAttachment('./file.csv');
$mail->CharSet = "utf-8";
$mail->SetFrom('badgeusek@gmail.com', 'Badgeuse');
$mail->Subject = 'Compte-rendu du Badge';
$mail->Body = 'Ci-Joint le Compte-rendu du Badge';
$mail->AddAddress('adam_j@etna-alternance.net');
$mail->Send();
}


