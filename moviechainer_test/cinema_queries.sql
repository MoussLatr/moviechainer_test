/*
*Le nombre de table que j'estime nécessaire au bon fonctionnement de l'app est de 4. Trois tables pour représenter les éléments de la problématique qui sont les films, les contacts et les métiers et une quatrième qui traduit justement l'association ternaire entre elles.
*Pourquoi INNODB ?
    +conformité intégrale à la norme ACID.
    +Prend en charge les suppressions et mises à jour en cascade.
*/
CREATE TABLE  films (
	idFilm MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
    titre VARCHAR( 100 ) NOT NULL ,
    annee year,
    PRIMARY KEY (idFilm)
) ENGINE = INNODB ;
CREATE TABLE  contacts (
	idContact MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
    civilite ENUM( 'Monsieur',  'Madame',  'Mademoiselle' ) NOT NULL,
    prenom VARCHAR( 100 ) NOT NULL ,
    nom VARCHAR( 100 ) NOT NULL ,
    PRIMARY KEY (idContact)
) ENGINE = INNODB ;
CREATE TABLE  metiers  (
	idMetier SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    fr_value VARCHAR( 100 ) NOT NULL ,
    en_value VARCHAR( 100 ) NOT NULL ,
    PRIMARY KEY (idMetier)
) ENGINE = INNODB ;
CREATE TABLE  rel_cantacts_films_metiers (
    idc MEDIUMINT UNSIGNED NOT NULL,
    idf MEDIUMINT UNSIGNED NOT NULL,
	idm SMALLINT  UNSIGNED NOT NULL,
    PRIMARY KEY (idc, idf, idm),
    CONSTRAINT Constr_contacts
        FOREIGN KEY contacts_fk (idc) REFERENCES contacts (idContact)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Constr_films
        FOREIGN KEY films_fk (idf) REFERENCES films (idFilm)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT Constr_metiers
        FOREIGN KEY metiers_fk (idm) REFERENCES metiers(idMetier)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = INNODB ;

/*Population de la base de donnees*/

INSERT INTO films  (titre,annee) VALUES
("Vertigo", 1958),
("The Innocents", 1961),
("Lawrence of Arabia", 1962);

INSERT INTO contacts (civilite, prenom, nom) VALUES
("Monsieur", "Alfred", "Hitchcock"),
("Monsieur", "Jack", "Clayton"),
("Monsieur", "David", "Lean");

INSERT INTO metiers (fr_value, en_value) VALUES
("Realisateur", "Director"),
("Scenariste", "Writer");

#Association  contact a zone metiers
INSERT INTO rel_cantacts_films_metiers (idc, idf, idm) VALUES
(1, 1, 1),
(1, 1, 2),
(2, 2, 1);
#Or
INSERT INTO rel_cantacts_films_metiers (idc, idf, idm)
SELECT c.idContact, f.idFilm, m.idMetier
FROM contacts c, films f, metiers m
WHERE c.prenom = "Alfred" AND f.titre = "Vertigo" AND m.fr_value = "Scenariste";

#La requête pour la liste des filmes et leurs réalisateurs
SELECT f.titre, f.annee, tmp.prenom, tmp.nom, 'Producteur' as metier
FROM films f
INNER JOIN (
SELECT rel.idf, c.prenom, c.nom
FROM contacts c
INNER JOIN rel_cantacts_films_metiers rel
ON rel.idc = c.idContact AND rel.idm in (SELECT idMetier FROM metiers WHERE fr_value = 'Producteur') 
) AS tmp ON tmp.idf = f.idFilm ORDER BY f.idFilm;