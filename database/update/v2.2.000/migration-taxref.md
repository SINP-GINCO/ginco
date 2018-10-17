# Migration TAXREF V11

## Fichiers de TAXREF V11 :

La version 11 de TAXREF se trouve ici : https://inpn.mnhn.fr/telechargement/referentielEspece/taxref/11.0/menu

* **TAXREFv11.txt** : les données mêmes de TAXREF
* **TAXREF_CHANGES.txt** : description des changements survenus dans TAXREF (retrait, modification, ajout)
* **CDNOM_DISPARUS.xls** : précisions sur certains retraits (certains sont en fait des modifications, et non de vrais retraits)


## Description des scripts

* **update_taxref_to_v11.sql** : Supprime la table taxref et en crée une nouvelle selon le nouveau modèle
* **populateTaxref.sh** : Télécharge et remplit la table taxref avec les nouvelles données
* **update_taxref_v11_metadata.php** : met à jour le métamodèle avec des nouveaux champs : cdnomcalcule, cdrefcalcule, taxostatut, taxomodif, taxoalerte.
* **update_taxref_v11_data.php** : met à jour les données existantes en base de v10 vers v11.


## Création du fichier all_changes.csv

L'idée est de croiser les données de **TAXREF_CHANGES.txt** et de **CDNOM_DISPARUS.xls** (qu'on considère converti en CSV préalablement) afin de regrouper dans un seul fichier, nommé **all_changes.csv** toutes les modifications du changement de version.

**Créer une base de données avec deux tables :**

```sql
CREATE TABLE taxref_changes(
	cd_nom TEXT,
	num_version_init TEXT,
	num_version_final TEXT,
	champ TEXT,
	valeur_init TEXT,
	valeur_final TEXT,
	type_change TEXT
);
-- ALTER TABLE taxref_changes ADD CONSTRAINT pk_taxref_changes PRIMARY KEY(cd_nom) ;

CREATE TABLE cdnom_disparus(
	cd_nom TEXT,
	plus_recente_diffusion TEXT,
	cd_nom_remplacement TEXT,
	cd_raison_suppression TEXT,
	raison_suppression TEXT
)
-- ALTER TABLE cdnom_disparus ADD CONSTRAINT pk_cdnom_disparus PRIMARY KEY(cd_nom)
```

**Importer les données :**

```sh
cat TAXREF_CHANGES.txt | psql -d mabase -c "COPY taxref_changes FROM STDIN CSV HEADER DELIMITER E'\t'"
cat CDNOM_DISPARUS.csv | psql -d mabase -c "COPY cdnom_disparus FROM STIDN CSV HEADER DELIMITER E'\t'"

```

Note : le délimiteur de CSV dans ces fichiers est une tabulation.

**Retirer les cas inutiles :**

Notamment les ajouts de taxons qui ne nous intéressent pas pour la mise à jour des données.

```sql
DELETE FROM taxref_changes WHERE champ NOT IN ('CD_NOM', 'CD_REF', 'LB_NOM') ;
DELETE FROM taxref_changes WHERE type_change NOT IN ('MODIFICATION', 'RETRAIT') ;
```

**Croiser les données et exporter dans un fichier :**

```sql
CREATE TABLE all_changes AS
	SELECT t.*, c.cd_nom_remplacement, c.cd_raison_suppression
	FROM taxref_changes t
	LEFT JOIN cdnom_disparus c ON c.cd_nom = t.cd_nom
```

```sh
psql -d mabase -c "COPY all_changes TO STDOUT CSV HEADER"
```

Note : cette fois-ci, on garde les virgules comme séparateur, comme le veut le standard (plus simple pour traiter en php)