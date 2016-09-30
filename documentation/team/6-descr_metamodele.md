# OGAM - Description des champs du métamodèle


Le métamodèle se configure via le fichier metadata.ods. Chaque feuille du fichier correspond à une table de la base de données.

- **Data** : décrit les attributs utilisés dans les différentes DS et DEE
- **Unit** : décrit le type d'unité de Data
- **Mode** : décrit les différentes valeurs des listes déroulantes (subtype MODE dans Data).
- **TableFormat** : liste les types de DEE et DS, chacun correspondant à une table dans la BDD
- **FileFormat** : décrit les fichiers d'import des données (csv)
- **TableField** : décrit les champs des tables de TableFormat
- **FormField** : décrit les champs des formulaires d'édition
- **FileField** : décrit les champs des fichiers d'import de données (nommés suivant FileFormat)
- **FieldMapping** : associe les champs des tables à ceux des formulaires, ou des fichiers d'import, ou à leurs champ harmonisés
- **Dataset** : liste les différents jeux de données
- **DatasetFiles** : liste les jeux de données pour leur intégration (import)
- **DatasetFields** : les champs qui apparaissent dans le requeteur
- **TableSchema** : les différents schémas de la base de données



