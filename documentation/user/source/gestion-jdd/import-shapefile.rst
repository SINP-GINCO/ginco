.. Format du fichier d'import et des champs

Fichier d'import shapefile
==========================

Sur la page de chargement des données, un second onglet permet d'importer des fichiers shapefile.

.. image:: ../images/gestion-jdd/import-shapefile.png

Les valeurs des champs doivent respecter les mêmes règles que pour l'import au format CSV.

Le format shapefile imposant des noms de colonnes inférieurs à 10 caractères, il faut définir un modèle d'import spécifique pour les shapefile.

Le modèle "occ_taxon_dsr_exemple_import_shapefile", présent de base dans le module de configuration, contient les champs du standard national d'occurence de taxon, en version courte (moins de 10 caractères).