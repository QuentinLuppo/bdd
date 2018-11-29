<?php
include ('../config.php');

function getAth() {
	$req = DB::get()->query('select * from ath');
	$ath = $req->fetchAll();
	return $ath;
}	

?>
