# OGAM - Installation PostgreSQL / PostGIS

## Installation via le gestionnaire de paquets APT

`sudo apt-get install postgresql pgadmin3`

`sudo apt-get install postgresql-9.3-postgis-2.1`

## Configuration de PostgreSQL

Configuration de l'accès depuis les postes de l'équipe de développement.

Editer le fichier de Postgre
`/etc/postgresql/9.3/main/postgresql.conf`

```
listen_addresses = '*' 
port = 5432
```

Editer le fichier d'authentification du client  `/etc/postgresql/9.3/main/pg_hba.conf`

```
host	all	all	172.17.0.188/16	md5
```

Si _ogam_ n'est pas un utilisateur Unix, ajouter l'utilisateur ogam dans le fichier `pg_hba.conf` :

```bash
# "local" is for Unix domain socket connections only
local   all             ogam                                    md5
local   all             all                                     peer
```

## Création de la base de données

Les scripts SQL de création de la base de données se situent dans le répertoire `database`

Lancer les scripts suivants :

Executer le script **0-Create_bdd.sql** :  

 `sudo -i -u postgres psql < 0-Create_bdd.sql` 
        

### Création de l'utilisateur

L'application OGAM et la base de données du projet nécessite la création du rôle Postgre : **ogam**

Lancer le script : **0-Create_user.sql** de création du rôle **ogam**.

Un rôle **'admin'** doit également exister pour l'administration de PostgreSQL.

-- Créer un compte admin qui sera accessible par le réseau 
CREATE ROLE admin LOGIN ENCRYPTED PASSWORD 'secret' SUPERUSER CREATEDB CREATEROLE;


### Création des schémas 

`psql -h localhost -p 5432 -U admin -d sinp -f nom_du_fichier.sql`

| Script  | Description |
| ------------- | ------------- |
| **1-1-Create_metadata_schema.sql**  | Schéma du méta-modèle |
| **1-2-Create_mapping_schema.sql**  |  Configuration de la composante carto.  |
| **1-3-Create_website_schema.sql** |  Configuration de l'application et utilisateurs, droits, rôles, groupes ...  |
| **1-4-Create_raw_data_schema.sql** | Entrepôt des données importées  |
| **1-7-Create_harmonized_data_schema.sql**  | Entrepôt des données élémentaires d'échanges   |
| **3-0-Create_referentiels_schema.sql** | Référentiels (TaxRef, Réf. carto) |
| **2-Set_search_path.sql**  | Permet de désigner les tables sans préfixer par le schéma  |

---------------------------------------------------------------------------------------------------------

### Création et peuplement des tables

| Script  | Description |
| ------------- | ------------- |
| **1-5-Create_FLORE_IGN_DATA_TABLE.sql** | Table des observations IGN  |
| **1-6-Create_OBSERVATION_table.sql**  | Table des observations MNHN |
| **3-Init_role.sql**  | Définit les droits des utilisateurs de l'application |

## Création du schéma métadata (= méta-modèle ODS)

Le _métamodèle_ permet la configuration des protocoles et des modèles de données utilisées dans l'application (permet par exemple de définir la correspondant entre les champs de différentes tables etc.).

Le _métamodèle_ est un fichier **`ods`**. Dans un premier temps, il est exporté sous forme de fichiers tabulaires
(CSV). Il se situe dans **`database/metadata.ods`**.

Le script SQL **`database/Metadata/import_metadata_from_csv.sql`**. permet d'importer dans la base **sinp** les données provenant des csv.

Ce script est appelé via une tâche ANT qui permet définir dynamiquement les chemins vers les fichiers CSV et de faciliter la re-peuplement de la base sous Eclipse.

---------------------------------------------------------------------------------------------------------

## Peuplement des tables via l'outil ANT

Installation de l'outil ANT : 

`sudo apt-get install ant`

### Edition du fichiers de propriétés 

Les tâches automatisées avec ANT sont configurés via des fichiers séparées **`build.ppts`** , il est nécessaire d'adapter ces fichiers. Ici il est nécessaire d'apdater le fichier **`database/build.ppts`** :

```bash
services.url = http://localhost:8080

db.hostname = localhost
bd.port = 5432
bd.user = admin
bd.base = sinp
tomail = email@ign.fr
deploy.dir = /var/www/sinp

services.map.url = http://sinp.ign.fr

gp.wxs.url = http://wxs-i.ign.fr
gp.api.key = 7gr31kqe5xttprd2g7zbkqgo
```

---------------------------------------------------------------------------------------------------------


### Lancement des tâches


```bash
#Peuple le schéma metadata
sudo ant UpdateMetadata
#Peuple les requêtes prédéfinies de l'application
sudo ant  UpdatePredefinedRequests 
# Peuple les paramètres de l'application
sudo ant  UpdateApplicationParameters 
# Met à jour le schéma de configuration cartographique
sudo ant  UpdateMapping 
#Import du référentiel Taxnomique 'TaxRef'
sudo ant ImportTaxRef8 
```

## Peuplement des référentiels


Les référentiels sont dans le dossier `database\Referentiels`.
Chacun de ces script doit être lancé après l'initilisation de la base de données et des schémas via psql : 

`psql -h localhost -U admin -f grille.sql -d sinp -f nom_du_fichier.sql`

* communes.sql
* departements.sql
* regions.sql
* EN_INPN_v20141203.sql (Espaces naturels INPN)
* grille.sql  (Grille national INPN 10kmx10km)
