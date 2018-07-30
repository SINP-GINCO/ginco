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

## Consignes de migration 

**Consignes inscrites dans le ticket #1434**

Rappel des traitements effectués sur les champs taxonomiques lors de l'import

* Lors de l'import, l'utilisateur doit remplir obligatoirement cdNom OU cdRef.
* Ginco refuse l'import si la valeur fournie pour cdNom ne correspond pas à un code présent dans la table mode_taxref.
* Ginco refuse l'import si la valeur fournie pour cdRef ne correspond pas à un code présent dans la table mode_taxref.
=> pas de contrôle de cohérence entre cdNom et cdRef lorsque les deux champs sont remplis.
* Si versionTaxref est renseigné par l'utilisateur, Ginco ne fait rien. Sinon Ginco remplit le champ avec la valeur du champ version de la table referentiels.liste_referentiels pour taxref.
* Ginco calcule le nomValide à partir de cdRef si l'utilisateur a fourni une valeur, sinon à partir de cdNom.

### A faire

* Remplacer le référentiel Taxref v10 par Taxref v11 dans referentiels.taxref et metadata.mode_taxref (voir ticket #1351, ça a déjà été fait pour DLB). En profiter pour supprimer les tables taxref_rang et taxref_statut qui ne nous servent pas.

* Mettre à jour la table referentiels.liste_referentiels pour taxref.

* Ajouter les champs cdNomCalcule, cdRefCalcule (mêmes paramètres dans le métamodèle et le configurateur que codeMailleCalcule, avec comme unité TaxrefValue), et TaxoStatut, TaxoModif et TaxoAlerte (mêmes paramètres dans le métamodèle et le configurateur que sensiAlerte). Changer l'unité des champs cdNom et cdRef en characterString.

* Lors des checks de l'import, remplir cdNomCalcule à partir de cdNom si fourni, et cdRefCalcule (dans tous les cas). Voir avec Judith pour le calcul de cdRefCalcule si on se base plutôt sur le cdNom ou le cdRef lorsque les 2 sont fournis. Le contrôle que cdNom ou cdRef du producteur appartiennent à Taxref est donc fait à ce moment là. En cas d'erreur on enregistre l'erreur comme d'habitude.

* Coder la montée de version des données (observations) contenues dans la plateforme.

  * Il faut utiliser les fichiers TAXREF_CHANGES.txt et CDNOM_DISPARUS.xls.
  * Dans TAXREF_CHANGES.txt, les lignes qui nous intéressent sont celles pour lesquelles (CHAMP=CD_REF ou CD_NOM ou LB_NOM) et pour lesquelles (TYPE_CHANGE=MODIFICATION ou RETRAIT). On peut donc supprimer toutes les autres.
  * CDNOM_DISPARUS apporte des précisions sur les traitement de certains taxons. Tous les taxons de CDNOM_DISPARUS correspondent à des TYPE_CHANGE=RETRAIT et CHAMP=CD_NOM de TAXREF_CHANGES. Ce fichier est donc en contradiction avec TAXREF_CHANGES, car il apporte des CD_NOM_REMPLACEMENT à des CD_NOM qui sont en RETRAIT dans TAXREF_CHANGES

### Règles de calcul à appliquer :

#### A) Lorsque TYPE_CHANGE=MODIFICATION et CHAMP=CD_REF, il faut : trouver les données telles que cdRefCalcule vaut VALEUR_INIT. Pour ces données, mettre :

* cdRefCalcule=VALEUR_FINAL
* TaxoStatut=Diffusé
* TaxoModif=Modification TAXREF
* TaxoAlerte=NON

#### B) Lorsque TYPE_CHANGE=RETRAIT (on a alors que des CHAMP=CD_NOM), il faut : trouver les données telles que cdNomCalcule vaut VALEUR_INIT. Pour ces données, mettre :

* cdNomCalcule à NULL
* cdRef_Calcule à NULL
* nomValide à NULL
* TaxoStatut =‘Gel’
* TaxoModif = ‘Gel TAXREF’
* taxoAlerte = OUI.

**SAUF LORSQUE :**

* CD_NOM correspond à un CD_NOM de CDNOM_DISPARUS et que CD_RAISON_SUPPRESSION = 1, auquel cas il faut mettre :
  * cdNomCalcule=CD_NOM_REMPLACEMENT
  * mettre à jour cdRefCalcule et nomValide à partir du nouveau cdNomCalcule.
  * TaxoStatut=Diffusé
  * TaxoModif=Modification TAXREF
  * TaxoAlerte=NON

* CD_NOM correspond à un CD_NOM de CDNOM_DISPARUS et que CD_RAISON_SUPPRESSION = 3, auquel cas il faut mettre :
  * cdNomCalcule à NULL
  * cdRef_Calcule à NULL
  * nomValide à NULL
  * TaxoStatut =‘Gel’ ???
  * TaxoModif = ‘Gel TAXREF’
  * taxoAlerte = OUI.

* CD_NOM correspond à un CD_NOM de CDNOM_DISPARUS et que CD_RAISON_SUPPRESSION = 2, auquel cas il faut mettre :
  * cdNomCalcule à NULL
  * cdRef_Calcule à NULL
  * nomValide à NULL
  * TaxoStatut =‘Gel’
  * TaxoModif = ‘Suppression TAXREF’
  * taxoAlerte = OUI.

Le plus simple serait sûrement de supprimer les lignes de TAXREF_CHANGES telles que CD_NOM existe dans CDNOM_DISPARUS et CD_RAISON_SUPPRESSION = 1 ou 3, de supprimer les lignes de CDNOM_DISPARUS telles que CD_RAISON_SUPPRESSION = 2 ou Null, et de parcourir les fichiers l'un après l'autre.

#### C) Lorsque TYPE_CHANGE=MODIFICATION et CHAMP=LB_NOM, il faut : trouver les données telles que cdNomCalcule vaut CD_NOM. Pour ces données, mettre :

* nomValide=VALEUR_FINAL.

A priori faire tout cela dans un script d'update de la base (sql/php).

Remarque : contrairement à ce que dit la documentation Taxref, le champ PLUS_RECENTE_DIFFUSION dans CDNOM_DISPARUS correspond à la première version de Taxref dans laquelle le cdNom est apparu. Le fichier contient donc un certain nombre de taxons qui n'existent déjà plus en v10, et qui ne nous sont donc pas du tout utiles !