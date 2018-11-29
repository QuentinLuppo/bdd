<?php
include ('../config.php');

function getCourses() {
	$req = DB::get()->query('select * from ath');
	$courses = $req->fetchAll();
	return $courses;
}	

<?
