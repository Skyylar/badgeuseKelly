<?php

// Remise a 0 apres envoie du CSV

$sql2 = ("UPDATE `" . $donnees['Tables_in_api_badgeuse'] . "` SET `badgeuse` = 'false', `Heure_badgeuse` = 'false' WHERE 1");
$req3 = $conn->prepare($sql2);
$req3->execute();
