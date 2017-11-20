.. Format du fichier d'import et des champs

Fichier d'import shapefile
==========================

Sur la page de chargement des données, un second onglet permet d'importer des fichiers shapefile.

.. image:: ../images/gestion-jdd/import-shapefile.png

Un shapefile étant constitué de plusieurs fichiers, ils doivent être regroupés dans une archive .zip portant le même nom que les fichiers. L'archive doit contenir au moins 4 fichiers avec les extensions .shp, .dbf, .shx et .prj

Par exemple, une archive "jeu_test.zip" doit contenir les fichiers "jeu_test.shp", "jeu_test.dbf", "jeu_test.shx" et "jeu_test.prj" pour pouvoir être importée.


Les valeurs des champs doivent respecter les mêmes règles que pour l'import au format CSV.

Le format shapefile imposant des noms de colonnes inférieurs à 10 caractères, il faut définir un modèle d'import spécifique pour les fichiers de type shapefile.
Le modèle d'import doit, en outre comporter les spécificité suivantes :

* formats de date : dd/MM/yyyy
* formats d'heure : HH:mm
* Nom de colonne dans le fichier du champ  de type géométrique (GEOM) : WKT

Le modèle "occ_taxon_dsr_import_shapefile", présent de base dans le module de configuration, contient les champs du standard national d'occurence de taxon, en version courte (moins de 10 caractères), et respecte les spécificités listées ci-dessus.


