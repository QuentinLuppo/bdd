<?php
//session_start() ;
error_reporting(E_ALL);
include ('config.php');
// On appelle la méthode statique get() de la classe DB qui renvoit une instance du PDO.
$request = DB::get()->query('select * from BUDGET');
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" >
   <head>
       <title>Athletes</title>
       <meta http-equiv="Content-Type" content="text/html; charset=utf8" />
       <link rel="stylesheet" media="screen" type="text/css" title="style_tab" href="css/default.css" />
   </head>

<body>

<table>
		<caption>Liste des budgets</caption>
		<thead>
			<tr>
				<th>cout</th>
				<th>budget</th>
				<th>annee</th>
			</tr>
		</thead>
	<tbody>
<?php
// On récupère les données. Chaque ligne est sockée dans le tableau data.
while($data = $request->fetch()) {
	//var_dump($data);
	?>
	<tr>
		<td><?php echo	$data['cout']; ?></td> <!-- 'code' est une colonne de la BDD. -->
		<td><?php echo	$data['budget']; ?></td>
		<td><?php echo	$data['annee']; ?></td>
	</tr>
	<?php
}
$request->closeCursor(); // ne pas oublier de fermer le curseur.
?>
</tbody>
</table>
<form method="post" action="ath.php">
		<tr><td></td><td><input type="submit" value="return" /></tr></br>
</form>
</html>