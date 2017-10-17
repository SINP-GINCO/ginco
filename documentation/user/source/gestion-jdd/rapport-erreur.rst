.. Rapport de conformité et cohérence, signification des erreurs

.. _corriger_les_erreurs_dimport:

Résoudre les erreurs d'import
=============================

En cas d'erreur lors de l'import, la nature et la localisation des erreurs sont indiquées dans le "Rapport d'erreur" (Rapport de
conformité et cohérence), disponible pour chaque soumission sur la page listant les jeux de données.

Le service d'import détecte les erreurs en 3 étapes :

étape 1
-------
Dans un premier temps, le service d'import s'assure que la ligne d'en-tête du fichier importé est correcte :

* pas de nom de colonne en doublon ;
* pas de nom de colonne inconnu dans le modèle d'import ;
* pas de colonne obligatoire manquante.

Toute la ligne est évaluée pour ces 3 contrôles. Si une erreur est relevée, l'import n'est pas poursuivi.

étape 2
-------
Contrôles de conformité et cohérence.
Les erreurs sont enregistrées au fur et à mesure.
Elles ne sont pas bloquantes pour le reste de la ligne ou du fichier, dans la limite de 1000 erreurs, auquel cas les contrôles s'arrêtent.

* **Conformité**: ce sont les erreurs de format, et de valeurs non conformes aux nomenclatures et aux référentiels
  (pour les valeurs de type code).

* **Cohérence** : ce sont des erreurs spécifiques au standard SINP, qui concernent souvent la cohérence entre plusieurs champs;
  par exemple, certains champs doivent être remplis (ou non) en fonction de la valeur prise par d'autres champs.

Le service d’import lance les contrôles de conformité et de cohérence vis à vis du standard "Occurrence de taxons" du SINP. Vous pouvez vous référer au
`détail du standard "Occurence de taxon" <http://standards-sinp.mnhn.fr/wp-content/uploads/sites/16/versionhtml/OccTax_v1_2_1/>`_
pour connaître l'ensemble des règles de cohérence.

étape 3
-------
Cette étape concerne les contrôles sur le champ géométrique
ainsi que les erreurs identifiées lors de l'insertion des données en base (bloquantes pour le reste de la ligne).

Localisation des erreurs
------------------------

Dans la partie "Détails des erreurs de conformité", le nom du champ ainsi que la ligne dans le fichier
où est localisée l'erreur, si ils ont identifiables, sont indiqués.

Dans la partie "Détails des erreurs de cohérence", la ligne où est localisée l'erreur est indiquée, ainsi qu'un message
permettant d'identifier les champs en erreur.

Signification des erreurs
-------------------------

Les différentes erreurs possèdent un code d'erreur, dont voici la signification :

Erreurs de conformité
^^^^^^^^^^^^^^^^^^^^^

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

* **1111 - Géométrie invalide** ; La valeur de la géométrie ne correpond pas au format WKT.

* **1112 - Mauvais type de géométrie** ; Le type de la géométrie ne correspond pas au type attendu.

* **1113 - Mauvais SRID pour la géométrie** ; L'identifiant du système de coordonnées (srid) indiqué ne correspond pas à celui des données.
  C'est-à-dire que l'identifiant du système de référence indiqué sur la page d'import du fichier ne peut pas correspondre aux coordonnées indiquées dans le champ géométrique du fichier importé.

* **1114 - Nom du champ incorrect** ; Le nom de la colonne indiqué dans la ligne d'en-tête du fichier csv n'existe pas dans le modèle d'import.
  Vous devez soit modifier votre fichier, soit modifier la configuration du modèle de fichier (pour cela, il vous faut contacter votre administrateur régional).
  
* **1115 - Des noms de colonnes sont en double** ; Des noms de colonnes sont en double dans la ligne d'en-tête du fichier importé.

* **1116 - Colonne obligatoire manquante** ; Colonne obligatoire manquante dans la ligne d'en-tête du fichier d'import.
  Vous devez soit l'ajouter à votre fichier, soit modifier la configuration du modèle de fichier (pour cela, il vous faut contacter votre administrateur régional).

Erreurs de cohérence
^^^^^^^^^^^^^^^^^^^^

* **1200 - Champs obligatoires conditionnels manquants** ; il existe des groupes de champs "obligatoires conditionnels",
  c'est à dire que certains champs doivent être fournis obligatoirement si d'autres champs le sont. Par exemple, si l'un
  des champs  décrivant l'objet "Commune" est fourni, tous doivent être fournis.

* **1201 - Tableaux n'ayant pas le même nombre d'éléments** ; certains champs de type tableaux doivent avoir le même nombre
  d'éléments, par exemple codeCommune et nomCommune (et les éléments doivent se correspondre).

* **1202 - Version Taxref manquante** ; si un code de taxon est fourni (dans cdNom ou cdRef), alors la version du
  référentiel taxonomique utilisé doit être indiquée.

* **1203 - Référence bibliographique manquante** ; si le champ "statutSource" a la valeur "Li" (Littérature), alors une
  référence bibliographique doit être indiquée.

* **1204 - Incohérence entre les champs de preuve** ; si le champ "preuveExistante" vaut oui, alors l'un des deux champs
  "preuveNumérique" ou "preuveNonNumérique" doit être rempli. A l'inverse, si l'un de ces deux champs est rempli, alors
  "preuveExistante" ne doit pas prendre une autre valeur que "oui" (code 1).

* **1205 - PreuveNumerique n'est pas une url** ; le champ "preuveNumérique" indique l'adresse web à laquelle on pourra
  trouver la preuve numérique ou l'archive contenant toutes les preuves numériques. Il doit commencer par "http://",
  "https://", ou "ftp://".

* **1206 - Incohérence entre les champs d'habitat** ; Si le référentiel Habitat utilisé n'est pas HABREF, c'est le champ
  codeHabitat qui doit être fourni. Si le référentiel est HABREF, codeHabitat ou codeHabref peuvent être utilisés.

* **1207 - Géoréférencement manquant** ; un géoréférencement doit être fourni, c'est à dire qu'il faut livrer :
  soit une géométrie, soit une ou plusieurs commune(s), ou département(s), ou maille(s), dont le champ "typeInfoGeo"
  est indiqué à 1.

* **1208 - Plusieurs géoréférencements** ; un seul géoréférencement doit être livré ; un seul champ "typeInfoGeo" peut valoir 1.

* **1209 -  Période d’observation** ; la valeur de jourdatedebut est ultérieure à celle de jourdatefin ou la valeur de jourdatefin est ultérieure à la date du jour.
