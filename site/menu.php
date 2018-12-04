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
<form method="post" action="ath.php">
	<table><caption>table ath</caption>
	<tr><td>Go on ath</td><td><input type="submit" value="See ath" /></tr></br>
	</table>
</form>
<form method="post" action="cat.php">
	<table><caption>Permert de voir la table categorie </caption>
		<tr><td>Go on all categorie</td><td><input type="submit" value="See cathegorie" /></tr></br>
	</table>
</form>
<form method="post" action="entraineur.php">
	<table><caption>Permert de voir la table entraineur </caption>
		<tr><td>entraineur all</td><td><input type="submit" value="See entraineur"/></tr></br>
	</table>
</form>
<form method="post" action="getbudget.php">
	<table><caption>table Budget </caption>
	<tr><td>Go on budget</td><td><input type="submit" value="See budget" /></tr></br>
	</table>
</form>
</html>