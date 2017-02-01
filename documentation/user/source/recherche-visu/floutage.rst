.. floutage

.. _fonctionnement-floutage:

Le floutage des données
***********************

Le floutage des données est une fonctionnalité mise en place sur le projet GINCO en accord avec les règles de diffusion et de floutage du SINP.

Elle met en place des filtres qui agissent sur :

* les critères de requête
* les résultats affichés dans le tableau de résultats
* les résultats affichés sur la carte
* les fiches de détails
* les exports de résultats

Selon divers critères basés sur les champs *diffusionNiveauPrecision*, *dsPublique*, et *sensiNiveau* de la donnée, ainsi que sur les permissions de l'utilisateur *visualiser les données sensibles* et *visualiser les données privées*, un niveau de floutage est calculé dynamiquement et comparé à la valeur associée à chaque bac de visualisation.

Ainsi, supposons que le niveau de floutage calculé pour une certaine donnée est 2. Dans ce cas, seules les informations à la maille et aux échelles inférieures seront affichées (donc, le département en sus).
Cela se matérialisera par l'impossibilité de voir la donnée sur la couche géométrie précise et sur la couche commune, ainsi que par le remplacement dans le tableau de résultats des valeurs non-visualisables par une valeur constante ne donnant aucune information.

.. note:: Le floutage des données n'engendre pas comme on pourrait l'entendre un floutage réel où des données floues remplacent les données précises. Elles ne sont en effet non pas floutées, mais cachées. Les données ne remontent pas chez le client et il est donc impossible de les récupérer de quelque manière que ce soit.

Vous trouverez les divers cas d’usage et les divers principes liés au calcul du floutage dans :download:`ce document de référence </downloads/Note_Diffusion_DSR-DEE_GINCO.pdf>`.



