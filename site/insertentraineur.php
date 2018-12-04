<?php
//session_start() ;
error_reporting(E_ALL);
include ('config.php');
$request = DB::get()->prepare("INSERT INTO ENTRAINEUR (id_entraineur, nom, prenom, date_naissance, adhesion , mail, num_tel) VALUES ('".$_POST['id_entraineur']."','".$_POST['nom']."', '".$_POST['prenom']."', '".$_POST['date_naissance']."', '".$_POST['adhesion']."', '".$_POST['mail']."', '".$_POST['num_tel']."');");
$data = $request->execute();
header('location: ./entraineur.php');
?>