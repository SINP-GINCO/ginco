.. default-values

Attribution de valeurs par défaut
=================================

Certains champs seront remplis par des valeurs par défaut, ou par des valeurs calculées par l'application si ils sont vides :

* **heureDateDebut** : rempli par "00:00:00" si il n'est pas fourni ;

* **heureDateFin** : rempli par "23:59:59" si il n'est pas fourni ;

* **la version du référentiel Taxref** : celle-ci sera remplie par la version du référentiel en cours dans la plateforme, si l'un
  des champs cdNom ou cdRef est fourni, mais pas versionTaxref.

* **le nom et la version du référentiel des mailles** : ceux-ci seront remplis par le nom et la version du référentiel des mailles en cours
  dans la plateforme, si un ou plusieurs codes de mailles sont fournis.