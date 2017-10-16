.. Modèle d'import

Configurer les modèles d'import
===============================

Principe
--------

Un modèle d'import est une description d'un ensemble de fichiers, de leurs attributs et des relations entre ces attributs et les attributs des tables du modèle de données associé. C'est l'étape qui suit la configuration d'un modèle de données.

Une fois un modèle d'import décrit  et configuré, il est possible de le publier. Ce modèle d'import publié est la brique de base indispensable à l'import de données d'occurences de taxons.

Chaque plateforme GINCO, régionale ou thématique, comprend nativement le modèle d'import DEE.
Les administrateurs régionaux peuvent créer un ou plusieurs modèles d'import supplémentaires, qui seront accessibles aux utilisateurs de la plateforme.

Créer un modèle d'import
------------------------

.. image:: ../images/configurateur/configurateur-modele-import-accueil.png

1. Cliquer sur "Modèles d'import" dans le menu du haut pour accéder à la page de gestion des modèles de d'import.
2. Initialement, un modèle est présent et configuré : le modèle standard DEE.

.. note:: Le modèle standard DEE n'est ni modifiable, ni supprimable.

3. Pour créer un nouveau modèle, cliquer sur "Créer un nouveau modèle d'import".
   Un modèle vierge, sans fichiers ni champs, sera créé.

Lors de la création, vous devez indiquer le nom de votre nouveau modèle, une description (facultative), ainsi que le modèle de données **cible** :

.. image:: ../images/configurateur/configurateur-modele-import-creation.png

Le rattachement à un modèle de donnés cible est obligatoire et permet de faire les liaisons entre les champs des tables du modèle cible et les champs des fichiers du modèle d'import.

Dans cet exemple, on voit que le modèle de données cible sélectionné est "*Modèle standard régional*". 

Votre nouveau modèle est visible sur la page de gestion des modèles de d'import (**1**) :

.. image:: ../images/configurateur/configurateur-modele-import-liste.png

2. Le nouveau modèle n'est pas publié sur la plateforme,
    comme l'indique le bouton "Publier" présent (flèche droite, ou bouton de lecture),
    contrairement au modèle DEE, comme l'indique le bouton "Dépublier" (carré, ou bouton d'arrêt de lecture).
3. et 4. Vous pouvez donc le modifier et le supprimer (les boutons sont actifs),
    contrairement au modèle DEE (ses
    boutons sont inactifs) : en effet, il n'est possible de modifier/supprimer un modèle que s'il n'est pas publié
    sur la plateforme (voir `Publier / Dépublier un modèle d'import`_).


Configurer les fichiers et les champs d’un modèle d'import
-------------------------------------------------------------

Cliquez sur l'icône "Modifier" (**3**), sur la page de gestion des modèles d'import, pour accéder à la page de configuration de votre modèle :

.. image:: ../images/configurateur/configurateur-modele-import-fonctions.png

On peut y:

* `Créer et modifier des fichiers`_ (**1** et **2**)
* `Supprimer des fichiers`_ (**4**)
* `Ordonner les fichiers`_ (**5**)
* `Gérer les champs des fichiers`_ (**3**)

Créer et modifier des fichiers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: ../images/configurateur/configurateur-modele-import-modification.png

Les champs demandés sont :

* **Nom :** Nom du fichier, utilisé en base de données : tous les caractères sont autorisés, mais le nombre de caractères est limité à 36.
* **Description :** *(facultatif)* Texte libre décrivant le fichier.

La page d'édition d'un modèle de fichier est divisée en 2 onglets :

* Modifier
* Gérer les champs

Supprimer des fichiers
^^^^^^^^^^^^^^^^^^^^^^

Pour supprimer un fichier, il suffit de cliquer sur le bouton "Corbeille" (**4**) du fichier que vous souhaitez supprimer. Le fichier sera directement supprimé.

Ordonner les fichiers
^^^^^^^^^^^^^^^^^^^^^

Pour ordonner les fichiers, il suffit de glisser-déposer vos fichiers les uns au-dessus ou au-dessous des autres, puis de cliquer sur le bouton "Enregistrer l'ordre d'import des fichiers" (**5**).

Gérer les champs des fichiers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

L'écran de gestion des champs du fichier permet de rajouter et supprimer des champs depuis le dictionnaire de données vers le fichier.

.. image:: ../images/configurateur/configurateur-fichier-parties.png

Il est divisé en 3 parties principales :

* **1** : le tableau des champs du modèle de données cible : il liste tous les champs disponibles dans le modèle de données.
* **2** : le tableau des champs du fichier : il liste uniquement les champs qui sont attendus dans les fichiers téléversés sur la plateforme.
* **3** : une partie sur l'ajout de champs automatique à partir d'une table du modèle de données cible. Pratique pour faire correspondre quasi-immédiatement les champs du fichier avec ceux d'une table.

Les différentes fonctionnalités de cet écran sont décrites ci-dessous.

.. image:: ../images/configurateur/configurateur-fichier-fonctions.png

1. **Rechercher un champ** : il suffit de taper une chaîne de caractères courte pour filtrer les champs du modèle de données de données et ainsi faciliter la sélection de champs.

2. **Sélectionner tous les champs** en cochant la case dans la ligne de titre du tableau.

3. **Sélectionner un champ** en cochant la case qui lui correspond.

4. **Ajouter un ou plusieurs champ(s)** en cliquant sur la flèche : les champs sélectionnés seront alors ajoutés au tableau de droite.

.. note:: Une fois que vous avez ajouté un ou plusieurs champ(s), il n'est pas nécessaire d'appuyer sur l'un des deux boutons d'enregistrement (**12**).

.. note:: Un champ ne peut être présent en doublon dans un fichier.

.. note:: Il n'est pas possible d'ajouter un champ dans le fichier sans qu'il existe dans le modèle de données.

5. **Définir le nom du champ dans l'en-tête du fichier** d'import. Le module d'import se base sur la ligne d'en-tête du fichier d'import pour savoir quelle colonne correspond à quel champ en base. Par défaut, le configurateur considère que le nom d'un champs dans le fichier est le même que ceux du modèle d'import. Cependant, si vous souhaitez en définir un autre, vous pouvez l'indiquer dans la colonne "Nom du champ dans le fichier".

6. **Rendre un champ obligatoire** ou non en cochant la case correspondant à un champ dans le fichier.

.. note:: Il est préférable de rendre un champ obligatoire sur le modèle d'import plutôt que sur le modèle de données.

.. note:: Le caractère obligatoire d'un champ obligatoire du modèle de données cible ne peut être modifié.

.. note:: Certains champs sont obligatoires dans le modèle de données et pas dans le modèle d'import. lorsqu'ils sont calculés automatiquement par l'application à l'import (par exemple: l'identifiant pernanent SINP ou les champs de sensibilité).

7. **Remplir le format de date** pour tous les champs dont l'unité est "*DATE*". Par défaut, le format de date pré-rempli est *yyyy-MM-dd*, mais vous pouvez le modifier. Vous trouverez plus de détails dans :ref:`format-des-dates`.

.. warning:: Pour enregistrer le caractère obligatoire, le format de date et le nom d'un champ dans le fichier, il est nécessaire de cliquer sur l'un des deux boutons d'enregistrement (**12**).

8. **Supprimer tous les champs du fichier** en cliquant sur la corbeille dans la ligne de titre.

.. warning:: Attention, tous les champs du fichier seront directement supprimés. Il n'y a pas de possibilité d'annulation.

9. **Supprimer un champ du fichier** en cliquant sur la corbeille correspondant à un champ dans le fichier.

10. **Ajouter des champs automatiquement** depuis une table du modèle de données cible. Pour ce faire, il suffit de sélectionner une table, puis de cliquer sur "Ajout automatique". Tous les champs de la table seront alors rajoutés à la liste des champs du fichier, excepté les champs dont la valeur est calculée par l'application lors de l'import. Une fois effectué, un rapport sera affiché.

.. image:: ../images/configurateur/configurateur-fichier-confirmation-ajout-auto.png

11. **Ajouter seulement les champs obligatoires** permet, lors de l'ajout automatique, de n'ajouter dans le format de fichier que les champs qui sont obligatoires dans le modèle de données.

12. **Ajouter également les champs calculés automatiquement** permet d'ajouter dans le format de fichier les champs dont les valeurs sont calculées automatiquement par GINCO lors de l'import de données. Si tous les champs du modèle DSR sont présents cette option est inutile, mais si votre modèle de données ne contient pas tous les champs du standard, il est possible que certains champs ne puissent pas être calculés automatiquement.

13. **Ajout automatique** est le bouton permettant de lancer l'ajout de champs automatique dans le format de fichier.

14. **Enregistrer** vos modifications : seules les modifications liées au caractère obligatoire d'un champ, leur nom dans l'en-tête du fichier d'import, ainsi que le format de date sont enregistrées à ce moment-là. Le reste (ajout de champs, suppression) est enregistré lors de chaque action effectuée.

Publier / dépublier un modèle d'import
--------------------------------------

Lorsque vous avez terminé de configurer votre modèle d'import, et que vous souhaitez le rendre disponible pour publication, il suffit de cliquer sur le bouton de lecture dans le tableau des modèles d'import :

.. image:: ../images/configurateur/configurateur-modele-import-publication.png

Le modèle d'import sera alors disponible en production.

**Attention** : pour qu'un modèle d'import soit publiable :

* son modèle de données cible doit être publié
* il doit comporter au moins un fichier d'import
* chacun de ses fichiers doit comporter au moins un champ
* tous les champs obligatoires du modèle de données cible doivent être présents dans le modèle d'import

Si toutes ces conditions ne sont pas atteintes, le bouton de publication est grisé.

.. note:: Une fois publié, le modèle de d'import ne peut plus être ni supprimé ni modifié. Vous pouvez toutefois continuer à consulter sa configuration en visualisant son contenu (bouton Visualiser).

Après avoir publié votre modèle de données, la publication de votre modèle d'import de fichiers vous permettra de téléverser vos données depuis la page d'import de données de l'application.

Si vous souhaitez dépublier un modèle d'import, il suffit de cliquer sur le bouton d'arrêt de lecture dans le tableau des modèles d'import :

.. image:: ../images/configurateur/configurateur-modele-import-depublication.png

A la dépublication d'un modèle d'import, et à la différence de la dépublication d'un modèle de données, seul celui-ci est dépublié. Le modèle de données cible n'est pas impacté, vous pourrez donc toujours requêter et visualiser les données importées. Il ne vous sera par contre plus possible de téléverser des données d'observation.

.. warning:: Il n'est pas possible de dépublier un modèle d'import lorsqu'un import est en cours.
