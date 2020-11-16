<?php
		/* Activation des mesages d'erreurs*/
		ini_set('display_errors', '1');
		ini_set('display_startup_errors', '1');
		error_reporting(E_ALL);
	
		require 'db_connection.php';

		/* Etablir la connexion avec la base de donnée*/
		$conn = connect();

		/* Requête pour récupérer la liste des films et leurs réalisateurs */
		$myQuery = "SELECT f.titre, f.annee, tmp.prenom, tmp.nom, 'Producteur' as metier
					FROM films f
					INNER JOIN (
					SELECT rel.idf, c.prenom, c.nom
					FROM contacts c
					INNER JOIN rel_cantacts_films_metiers rel
					ON rel.idc = c.idContact AND rel.idm in (SELECT idMetier FROM metiers WHERE fr_value = 'Producteur') 
					) AS tmp ON tmp.idf = f.idFilm ORDER BY f.idFilm";

		$films = [];
		/* creation d'un tableau des films */
		if ($result = $conn->query($myQuery)) 
		{		
				$row = $result->fetch_row();
				$title = $row[0];
				$films[0]=
						[
						'titre' => $row[0],
						'annee' => $row[1],
						'realisateurs' => $row[2].'.'.$row[3],
						];
				$i =0;
			while ($row = $result->fetch_row()) 
			{
				if ($title == $row[0])
				{
					$films[$i]['realisateurs']= $films[$i]['realisateurs'].' ; '.$row[2].'.'.$row[3];
				}
				else
				{
					++$i;
					$films[$i]=
						[
						'titre' => $row[0],
						'annee' => $row[1],
						'realisateurs' => $row[2].'.'.$row[3],
						];
				}
			}
		
		}

		/* Libèrer le résultat */
		$result->close();

		/* Creation d'un rendring HTML du résultat*/
		$htmlTable ='';
		$htmlTable .= 	"<table class='table' >
				<thead class='thead-dark'>
				<tr>
				<th>Titre</th>
				<th>Année de sortie</th>
				<th>Realisateur(s)</th>
				</tr>
				</thead>";
		foreach ($films as $film) {
		  $htmlTable .=  "<tr>";
		  $htmlTable .=  "<td>" . $film['titre'] . "</td>";
		  $htmlTable .=  "<td>" . $film['annee'] . "</td>";
		  $htmlTable .=  "<td>" . $film['realisateurs']. "</td>";
		  $htmlTable .=  "</tr>";
		}
		$htmlTable .= "</table>";

		echo $htmlTable;
?>