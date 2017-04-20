<?php
require_once('class.phpmailer.php');
include 'conn_db.php';

// Récupération des données de la database

$sql = ("SHOW TABLES");
$req = $conn->prepare($sql);
$req->execute();
while ($donnees = $req->fetch()) {
	$sql = ("SELECT * FROM " . $donnees['Tables_in_api_badgeuse']);
        $list = [];
        $req2 = $conn->prepare($sql);
        $req2->execute();
        while ($donnee = $req2->fetch()) {
                $list[] = array($donnee['Login'], $donnee['Prenom'], $donnee['Nom'], $donnee['Heure_badgeuse'], $donnee['Date']);
        }

// Ecriture du Fichier CSV

$file= $donnees['Tables_in_api_badgeuse'] . ".csv";
$fp=fopen($file,"w");

foreach ($list as $fields) {
    fputcsv($fp, $fields);
}
fclose($fp);

// Envoie de Mail

$mail = new PHPMailer();
$mail->AddAttachment('./'.$file);
$mail->CharSet = "utf-8";
$mail->SetFrom('badgeusek@gmail.com', 'Badgeuse');
$mail->Subject = 'Compte-rendu du Badge pour promo ' . $file;
$mail->Body = 'Ci-Joint le Compte-rendu des Badges';
$mail->AddAddress('adam_j@etna-alternance.net');
$mail->Send();
include 'reset.php';
}
shell_exec("rm -rf *.csv");
/*  	Feature envoie Mail au Absent
$sql = ("SHOW TABLES");
$req = $conn->prepare($sql);
$req->execute();
while ($donnees = $req->fetch()) {
  //      echo $donnees['Tables_in_api_badgeuse'] . " ";
        $sql = ("SELECT * FROM " . $donnees['Tables_in_api_badgeuse'] WHERE `badgeuse` = 0);
        $list = [];
        $req2 = $conn->prepare($sql);
        $req2->execute();
        while ($donnee = $req2->fetch())
        {
                $list[] = array($donnee['Login'], $donnee['Prenom'], $donnee['Nom'], $donnee['Heure_badgeuse'], $donnee['Date']);
        }

$mail = new PHPMailer();
$mail->CharSet = "utf-8";
$mail->SetFrom('badgeusek@gmail.com', 'Badgeuse');
$mail->Subject = 'Absence de Badgage';
$mail->Body = 'Vous n'avez pas badgé aujourd\'hui pensez à contacter l'école.';
$mail->AddAddress($donnee['Login'].'@etna-alternance.net');
$mail->Send();
*/ 
