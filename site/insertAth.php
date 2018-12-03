<?php
//session_start() ;
error_reporting(E_ALL);

include ('config.php');
/*$req = DB::get()->prepare("insert into ATH (id_licence, nom, prenom, date_naissance, adhesion , mail, num_tel, fin_validite, id_cat) values (:id_licence, :nom, :prenom, :date_naissance, :adhesion , :mail, :num_tel, :fin_validite, :id_cat)");
// Utilisation d'un try... catch pour captuer et gérer proprement les erreurs potentielles.

try {
	$req->execute(array(
		'id_licence' => $_POST['id_licence'],
		'nom' => $_POST['nom'],
		'prenom' => $_POST['prenom'],
		'date_naissance' => $_POST['date_naissance'],
		'adhesion' => $_POST['adhesion'],
		'mail' => $_POST['mail'],
		'num_tel' => $_POST['num_tel'],
		'fin_validite' => $_POST['fin_validite']
		'id_cat' => $_POST['id_cat']
	));
*/
$request = DB::get()->prepare("INSERT INTO ATH (id_licence, nom, prenom, date_naissance, adhesion , mail, num_tel, fin_validite, id_cat) VALUES ('".$_POST['id_licence']."','".$_POST['nom']."', '".$_POST['prenom']."', '".$_POST['date_naissance']."', '".$_POST['adhesion']."', '".$_POST['mail']."', '".$_POST['num_tel']."','".$_POST['fin_validite']."','".$_POST['id_cat']."');");
$data = $request->execute();
header('location: ./ath.php');
?>

