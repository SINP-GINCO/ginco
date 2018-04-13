.. rattachement

Calcul des rattachements administratifs
=======================================

Lors de l'import, un rattachement administratif de chaque observation est effectué.

Chaque observation sera rattachée aux entités administratives de réference (communes, mailles et départements).

.. warning:: Les données de référence actuellement utilisées dans le calcul sont les données ADMIN EXPRESS-COG carto 2017. Il se peut donc qu'il y ait des incohérences aux limites si vous utilisez un autre référentiel.

Algorithme
----------

Pour chaque observation :

* **Si une géométrie est présente** : un calcul est effectué pour rattacher aux communes, aux mailles et aux départements.
* **Si soit typeinfogeocommune = 1 ou typeinfogeomaille = 1 ou typeinfogeodepartement = 1** : on calcule les rattachements aux autres couches en prenant la couche qui a son typeInfoGeo à 1 comme base de calcul.
* **S'il n'y a ni géométrie, ni typeInfoGeo à 1** : ce cas n'est pas possible dans Ginco, un fichier avec une telle observation sera refusé à limport.

.. note:: Le cas où plusieurs références d'une même couche sont livrées sont gérés (plusieurs codes communes, plusieurs codes mailles, et/ou plusieurs codes départements). Par exemple, dans le cas où une observation est livrée avec plusieurs communes mais sans géométrie, une union des géométries des communes est calculée, et nous calculons l'intersection de l'aire de cette union de géométries avec chaque commune de référence pour déterminer la ou les mailles et le ou les départements qui leurs sont rattachés.

Vous trouverez les divers cas d'usage et les divers principes liés au rattachements administratifs dans :download:`ce document de référence </downloads/note_representation_carto_dee_v0.4.pdf>`.
