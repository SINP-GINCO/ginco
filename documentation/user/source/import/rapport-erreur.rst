.. Rapport de conformité et cohérence, signification des erreurs

.. _corriger_les_erreurs_dimport:

Résoudre les erreurs d'import
=============================

En cas d'erreur lors de l'import, la nature et la localisation des erreurs sont indiquées dans le "Rapport de
conformité et cohérence", disponible pour chaque jeu de données sur la page listant les jeux de données.

Localisation des erreurs
------------------------

Dans la partie "Détails des erreurs de conformité", le nom du champ ainsi que la ligne dans le fichier
où est localisée l'erreur, si ils ont identifiables, sont indiqués.

Signification des erreurs
-------------------------

Les différentes erreurs possèdent un code d'erreur, dont voici la signification :


* **1000 - Fichier vide**; Les fichiers ne doivent pas être vides.

* **1001 - Nombre de champs incorrect**; Le fichier doit contenir le bon nombre de champs,
  séparés par des points-virgules et aucun ne doit contenir de point-virgule. Peut arriver notamment :
  - si le séparateur de champ dans le fichier csv n'est pas un point-virgule ;
  - s'il existe des champs vides en fin de ligne, qui n'ont pas été comptés par le tableur ; il est facile de résoudre problème en insérant une ligne d'en-têtes en haut de fichier (commençant par //).

* **1002 - Contrainte d'intégrité non respectée** ; Cette erreur concerne les modèles à plusieurs tables,
  elle survient quand la valeur d'une clé étrangère dans une table n'existe pas dans la table parente.

* **1003 - Erreur SQL non répertoriée**; Cette erreur capte toutes les erreurs non standard ; l'erreur SQL précise
  est indiquée dans le paragraphe "Erreurs de conformité". Cela provient en général d'une mauvaise configuration
  des modèles. Contactez votre administrateur régional en lui transférant le rapport de conformité.

* **1004 - Ligne dupliquée** ; Cette erreur survient lorsque l'on tente de livrer des données avec un identifiant
  producteur qui existe déjà dans des jeux de données déjà intégrés par le même producteur (le champ
  mappé sur "OGAM_ID_table_xxx"). Il faut soit supprimer la donnée précedemment importée, voire le jeu de données entier,
  soit modifier les identifiants dans le jeu de données que l'on cherche à livrer.

* **1101 - Champ obligatoire manquant** ; Un champ obligatoire est manquant.

* **1102 - Format non respecté** ; Un champ n'est pas au format attendu. Voir :ref:`format_des_champs`.

* **1103 - Type de champ erroné** ; Le type du champ ne correspond pas au type attendu.

* **1104 - Date erronée** ; Le format de la date n'est pas le format attendu. Pour connaître le format attendu
  pour ce champ date, téléchargez le fichier de modèle sur la page d'upload du
  fichier d'import ; le format est indiqué entre parenthèses pour chaque champ date.

* **1105  - Code erroné** ; La valeur du champ n'est pas dans la liste des codes attendus pour ce champ. Pour
  connaître la liste des codes autorisés pour les champs du standard DEE, reportez-vous au `Standard d'échanges d'occurrences de taxon v1.2.1  <https://inpn.mnhn.fr/docs/standard/Occurrences_de_taxon_v1_2_1_FINALE.pdf>`_.

* **1106 - Valeur du champ hors limites** ; La valeur du champ n'entre pas dans la plage attendue (min et max).

* **1107 - Chaîne de caractères trop longue** ; La valeur du champ comporte trop de caractères. La limite pour les
  chaînes de caractère est de 255 caractères.

* **1108 - Colonne indéfinie** ; Colonne indéfinie.

* **1109 - Pas de mapping pour ce champ** ; Le champ dans le fichier n'a pas de colonne de destination
  dans une table en base. Il s'agit d'une erreur de configuration du modèle, contactez votre administrateur régional.

* **1110 - Valeur incorrecte** ; La valeur donnée n'est pas reconnue et empêche l'exécution du code
  (remplissage automatique de champs).
