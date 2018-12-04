<?php
// initialisation de la session
// INDISPENSABLE À CETTE POSITION SI UTILISATION DES VARIABLES DE SESSION.
session_start() ;
error_reporting(E_ALL);
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" >
   <head>
       <title>Athletes</title>
       <meta http-equiv="Content-Type" content="text/html; charset=utf8" />
       <link rel="stylesheet" media="screen" type="text/css" title="style_tab" href="css/default.css" />
   </head>

<body>

<?php
include ('config.php');
// On appelle la méthode statique get() de la classe DB qui renvoit une instance du PDO.
$request = DB::get()->query('select * from ENTRAINEUR');
?>
	<table>
		<caption>Liste des entraineurs</caption>
		<thead>
			<tr>
				<th>Id_entraineur</th>
				<th>Nom</th>
				<th>Prenom</th>
				<th>Date de naissance</th>
				<th>1er adhesion</th>
				<th>adresse mail</th>
				<th>num tel</th>
			</tr>
		</thead>
	<tbody>
<?php
// On récupère les données. Chaque ligne est sockée dans le tableau data.
while($data = $request->fetch()) {
	//var_dump($data);
	?>
	<tr>
		<td><?php echo	$data['id_entraineur']; ?></td> <!-- 'code' est une colonne de la BDD. -->
		<td><?php echo	$data['nom']; ?></td>
		<td><?php echo	$data['prenom']; ?></td>
		<td><?php echo	$data['date_naissance']; ?></td>
		<td><?php echo	$data['adhesion']; ?></td>
		<td><?php echo	$data['mail']; ?></td>
		<td><?php echo	$data['num_tel']; ?></td>
	</tr>
	<?php
}
$request->closeCursor(); // ne pas oublier de fermer le curseur.
?>
</tbody>
</table>

<!-- Toutes les données du formulaire seront envoyées à la page 'insertCourse.php' avec la méthode POST. -->
<form method="post" action="insertentraineur.php">
	<table><caption>Ajout d'un entraineur</caption>
		<tr><td>Id_entraineur: </td><td><input type="text" name="id_entraineur" /></td></tr> </br>
		<tr><td>Nom : </td><td><input type="text" name="nom" /></td></tr></br>
		<tr><td>Prenom : </td><td><textarea name="prenom" rows="5" cols="40"></textarea></tr></br> 
		<tr><td>Date de naissance : </td><td><input type="text" name="date_naissance" /></td></tr></br>
		<tr><td>adhesion : </td><td><input type="text" name="adhesion" /></td></tr></br>
		<tr><td>mail : </td><td><input type="text" name="mail" /></td></tr></br>
		<tr><td>num tel : </td><td><input type="text" name="num_tel" /></td></tr></br>
		<tr><td>tout doit etre remplie</td><td><input type="submit" value="Valider" /></tr></br>
	</table>
</form>
</body>
</body>
<form method="post" action="menu.php">
		<tr><td></td><td><input type="submit" value="return" /></tr></br>
</form>
</html>