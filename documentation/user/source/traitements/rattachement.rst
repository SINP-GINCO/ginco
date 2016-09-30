.. rattachement

Calcul des rattachements administratifs
=======================================

Lors de l'import, un rattachement administratif de chaque observation est effectué.

Selon les données livrées, chaque observation sera rattachée à une ou plusieurs entités administratives de réference (communes, mailles et départements).

.. warning:: Les données de référence actuellement utilisées dans le calcul sont les données issues du GeoFLA version 2015.1. Il se peut donc qu'il y ait des incohérences aux limites si vous utilisez un autre référentiel (BDTopo par exemple).

Algorithme
----------

Pour chaque observation :

* **Si une géométrie est présente** : selon le type de géométrie *(parmi point, multipoint, ligne, multiligne, polygone et multipolygone)*, un calcul est effectué pour rattacher aux communes, aux mailles et aux départements.
* **Si soit typeinfogeocommune = 1 ou typeinfogeomaille = 1 ou typeinfogeodepartement = 1** : on calcule les rattachements à toutes les couches *inférieures et supérieures, incluant la géométrie précise*, à la couche qui à son typeinfogeo à 1, en prenant comme base de calcul cette couche.
* **S'il n'y a ni géométrie, ni typeinfogeo à 1** :
    * si le champ "codeCommune" est renseigné, un calcul est effectué pour rattacher aux communes, aux mailles et aux départements.
    * si le champ "codeMaille" est renseigné, un calcul est effectué pour rattacher aux mailles et aux départements.
    * si le champ "codeDepartement" est renseigné, un calcul est effectué pour rattacher aux mailles et aux départements.

.. note:: Le cas où plusieurs références d'une même couche sont livrées sont gérés (plusieurs codes communes, plusieurs codes mailles, et/ou plusieurs codes départements). Par exemple, dans le cas où une observation est livrée avec plusieurs communes mais sans géométrie, une union des géométries des communes est calculée, et nous calculons l'intersection de l'aire de cette union de géométries avec chaque commune de référence pour déterminer la ou les mailles et le ou les départements qui leurs sont rattachés.

Vous trouverez les divers cas d'usage et les divers principes liés au rattachements administratifs dans :download:`ce document de référence </downloads/note_representation_carto_dee_v0.4.pdf>`.
