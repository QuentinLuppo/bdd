<?php
//session_start() ;
error_reporting(E_ALL);
include ('config.php');
$request = DB::get()->prepare("INSERT INTO ATH (id_licence, nom, prenom, date_naissance, adhesion , mail, num_tel, fin_validite, id_cat) VALUES ('".$_POST['id_licence']."','".$_POST['nom']."', '".$_POST['prenom']."', '".$_POST['date_naissance']."', '".$_POST['adhesion']."', '".$_POST['mail']."', '".$_POST['num_tel']."','".$_POST['fin_validite']."','".$_POST['id_cat']."');");
$data = $request->execute();
header('location: ./ath.php');
?>

