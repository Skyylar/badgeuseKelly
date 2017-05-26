<?php

require_once('class.phpmailer.php');
require_once('conn_db.php');
require_once('get.php');
class StudentManager
{
    private $_db;

    public function __construct($db)
    {
        $this->setDb($db);
    }
    
    public function setDb(PDO $db)
    {
        $this->_db = $db;
    }
    
    public function add_student($fname, $lname, $login, $close, $promo)
    {
        include 'create_table.php';
        $sql = ("INSERT INTO " . $promo . " (Login, Nom, Prenom, close, Date) VALUES( '" . $login . "', '" . $lname . "', '" . $fname . "', '" . $close . "', CURRENT_TIMESTAMP);");
        
        try {
            $req = $this->_db->prepare($sql);
            if ($this->already_here($login, $promo) < 1)
                {
                    $req->execute();
                }
        }
        catch (Exception $e) {
            echo $e->getMessage();
        }
        
    }
    
    public function valid_student($login, $promo)
    {
        $sql = ("UPDATE `" . $promo . "` SET `badgeuse` = 'true', `Heure_badgeuse` = CURRENT_TIMESTAMP, `close` = 'false' WHERE `Login`='" . $login . "';");
        $req = $this->_db->prepare($sql);
        $req->execute();
    }
    
    public function get_valid($promo)
    {
        $sql = ("SELECT * FROM `" . $promo . "` WHERE `badgeuse` != 'true'");
        $req = $this->_db->prepare($sql);
        $req->execute();
        while ($donnees = $req->fetch()) {
            echo $donnees['Login'] . " ";
        }
    }

    public function already_here($login, $promo)
    {
        $count = 0;
        $sql = ("SELECT * FROM `" . $promo ."` WHERE `Login` = '".$login ."';");
        $req = $this->_db->prepare($sql);
        $req->execute();
        if ($req->fetch())
            {
                return 1;
            }
        else
            return 0;
    }
    
    public function get_close($promo)
    {
        $sql = ("SELECT * FROM `" . $promo . "` WHERE `close` = 'true'");
        $req = $this->_db->prepare($sql);
        $req->execute();
        while ($donnees = $req->fetch()) {
            echo $donnees['Login'] . " ";
        }
    }
    
  public function getList($promo)
  {
      $sql = ("SELECT * FROM " . $promo);
      $req = $this->_db->prepare($sql);
      $req->execute();
      while ($donnees = $req->fetch()) {
          echo $donnees['Login'] . " ";
          echo $donnees['Prenom'] . " ";
          echo $donnees['Nom'] . " ";
          echo $donnees['Heure_badgeuse'] . " " ;
          echo $donnees['Date'] . "\n";
      }
  }
  
  public function notlate($promo, $login)
  {
      $this->valid_student($login, $promo);
      $sql = ("UPDATE `" . $promo . "` SET `Retard` = `Retard` - 1 WHERE `Login`='" . $login . "' AND `Retard` > 0;");
      $req = $this->_db->prepare($sql);
      $req->execute();
  }

  public function inlate($promo, $login)
  {
      $sql = ("UPDATE `" . $promo . "` SET `Retard` = `Retard` + 1 WHERE `Login` = '" . $login . "' AND `Retard` < 1;"	);
      echo $sql;
      $req = $this->_db->prepare($sql);
      $req->execute();
  }			
  
  public function who_is_late($promo, $login)
  {
      $sql = ("SELECT * FROM " . $promo . " WHERE `badgeuse` = 0");
      $req = $this->_db->prepare($sql);
      $req->execute();
      while ($donnees = $req->fetch()) {
          $sql = ("UPDATE `" . $promo . "` SET `Retard` = `Retard` + 1 WHERE `Login` = '" . $donnees['Login'] . "';");
          $req2 = $this->_db->prepare($sql);
          $req2->execute();
      }
  }
  
  public function setmissed($promo, $login)
  {
      $this->notlate($promo, $login);
      $this->valid_student($login, $promo);
      $sql = ("UPDATE `" . $promo . "` SET `Absence` = `Absence` + 1 WHERE `Login` = '" . $login . "' AND `badgeuse` = 'true';");
      $req = $this->_db->prepare($sql);
      $req->execute();
  }
  
  public function send_csv($promo)
  {
      $this->who_is_late($promo);
      $sql = ("SELECT * FROM " . $promo . " ORDER BY `Badgeuse`;");
      $list = [];
      $req = $this->_db->prepare($sql);
      $req->execute();
      while ($donnees = $req->fetch()) {
          $list[] = array($donnees['Login'], $donnees['Prenom'], $donnees['Nom'], $donnees['Heure_badgeuse'], $donnees['Date'], "    present = ", $donnees['badgeuse']);
      }
      $file= $promo .".csv";
      $fp=fopen($file,"w");
      
      foreach ($list as $fields) {
          fputcsv($fp, $fields);
      }
      fclose($fp);
      
      // shell_exec("echo 'Ci-joint le compte rendu de la badgeuse' | mutt -s 'Badgeuse' -a *.csv -- delass_v@etna-alternance.net");
      
      $mail = new PHPMailer();
      $mail->AddAttachment('./'. $promo .'.csv');
      $mail->CharSet = "utf-8";
      $mail->SetFrom('badgeusek@gmail.com', 'Badgeuse');
      $mail->Subject = 'Compte-rendu du Badge';
      $mail->Body = 'Ci-Joint le Compte-rendu du Badge';
      $mail->AddAddress('tang_g@etna-alternance.net');
      $mail->Send();
      shell_exec("rm ". $promo .".csv");
  }
  
  public function details($promo, $login)
  {
      $sql = ("SELECT * FROM " . $promo . " WHERE `Login` = '" . $login . "';");
      $req = $this->_db->prepare($sql);
      $req->execute();
      $donnees = $req->fetch();
      echo $donnees['Retard'] . " ";
      echo $donnees['Absence'];
  }
}

$manager = new StudentManager($db);


if (isset($fname) && isset($lname) && isset($login) && isset($close) && isset($promo)) {
    $manager->add_student($fname, $lname, $login, $close, $promo);
}

if (isset($getter) && isset($promo)) {
    $manager->getList($promo);
}

if (isset($update) && isset($login) && isset($promo)) {
    $manager->valid_student($login, $promo);
}

if (isset($badgeuse) & isset($promo)) {
    $manager->get_valid($promo);
}

if (isset($closecompte) && isset($promo)) {
    $manager->get_close($promo);
}

if (isset($send) && isset($promo)) {
    $manager->send_csv($promo);
}

if (isset($noproblem) && isset($promo) && isset($login)) {
    $manager->notlate($promo, $login);
}

if (isset($late) && isset($promo) && isset($login)) {
    $manager->inlate($promo, $login);
}

if (isset($missed) && isset($promo) && isset($login)) {
    $manager->setmissed($promo, $login);
}

if (isset($ls) && isset($promo) && isset($login)) {
    $manager->details($promo, $login);
}
