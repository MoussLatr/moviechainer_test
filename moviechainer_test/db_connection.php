<?php

function connect()
{
	$config = parse_ini_file('../info/db.ini');
	$serverName = "localhost";
	$conn = mysqli_connect($serverName, $config['username'], $config['password'], $config['db']);

	/* Check connection */
	if (!$conn) {
	  die("Connection failed: " . mysqli_connect_error());
	}
	return $conn;		
}

?>