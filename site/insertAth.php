<?php
//session_start() ;
error_reporting(E_ALL);

include ('config.php');
$req = DB::get()->prepare("insert into ATH (id_licence, nom, prenom) values (:id_licence, :nom, :prenom)");
// Utilisation d'un try... catch pour captuer et gérer proprement les erreurs potentielles.
try {
	$req->execute(array(
		'id_licence' => $_POST['id_licence'],
		'nom' => $_POST['nom'],
		'prenom' => $_POST['prenom']
		));
		// redirection
} catch(PDOException $erreur) {
echo "Erreur ".$erreur->getMessage();
}
header('location: ./ath.php');
?>

