# CHANGELOG

Ce changelog liste les modifications significatives du projet pour les différentes versions (corrections de bugs et évolutions).

Pour voir le diff entre deux versions, aller à (par exemple) : https://github.com/SINP-GINCO/ginco/compare/v1.0.0...v1.1.0

## V1.0.0 (28/03/2017)
Première version de production.

## V1.0.1 (05/04/2017)

* \#1109: Rendre le champ du standard jddMetadonneeDEEId non obligatoire puisqu'il est rempli automatiquement lors de l'import
* \#1102 et \#1107: Correction de plusieurs bugs sur la page de jeux de données

[Liste complète des commits](https://github.com/SINP-GINCO/ginco/compare/v1.0.0...v1.0.1)

## V1.0.2 (10/05/2017)

* \#1107: Corrections de bugs sur la page de jeux de données
* \#915: Ajout des légendes des espaces naturels pour la visualisation cartographique
* \#1099: Correction de bug sur la mise à jour automatique de la sensibilité lors de l'édition
* \#1101: Ajout d'un pop-up pour la saisie d'un commentaire lors de création, de la regénération et la suppression d'une DEE


[Liste complète des commits](https://github.com/SINP-GINCO/ginco/compare/v1.0.1...v1.0.2)


## V1.0.3 (02/06/2017)

* \#1136 et \#1139: Corrections de bugs sur la page de jeux de données
* \#1118: Corrections de bug: le bouton "créer un utilisateur" avait disparu à cause d'un pied de page mal calibré


[Liste complète des commits](https://github.com/SINP-GINCO/ginco/compare/v1.0.2...v1.0.3)


## V1.0.4 (26/06/2017)

* \#1137: Bug sur les formats de date 
* \#1159: Mise à jour du référentiel de sensibilité intégrant la liste régionale Centre-Val de Loire


[Liste complète des commits](https://github.com/SINP-GINCO/ginco/compare/v1.0.3...v1.0.4)

## V1.0.5 (25/07/2017)

* Corrections de noms de couches WFS pour les espaces naturels
* \#1197: Corrections de bug sur la dépublication des modèles de données


[Liste complète des commits](https://github.com/SINP-GINCO/ginco/compare/v1.0.4...v1.0.5)

## V2.0.0 (27/07/2017)

Cette version est la migration de l'application sous le framework Symfony. 
Les évolutions les plus significatives concernent le design et 
l'ergonomie (en particulier sur la page de gestion des jeux de données). 
A ceci près, cette version est autant que possible isofonctionnelle 
par rapport à la version précédente.

## V2.0.1 (07/09/2017)

* Evolutions du service d'import: 
    * Le service d'import prend maintenant en compte les en-têtes des colonnes du fichier csv, et 
    ne se fonde plus sur l'ordre des champs pour reconnaitre les champs du modèle de données (\#1201)
    * Le service d'import remonte toutes les erreurs rencontrées, et non plus seulement la
     première erreur par ligne. (\#1152)
* Résolution de bugs bloquant la dépublication d'un modèle de données.
* Rétablissement de l'accès à lavisualisation des données pour les visiteurs non loggués
* Correction de divers bugs...

[Liste complète des commits](https://github.com/SINP-GINCO/ginco/compare/v2.0.0...v2.0.1)

## V2.0.2 (02/10/2017)

* Création de plusieurs versions pour la documentation, afin de suivre les versions de prod et de test de l'application.
* La suppression de gros jeux de données est maintenant asynchrone
* Correction de divers bugs...

[Liste complète des commits](https://github.com/SINP-GINCO/ginco/compare/v2.0.1...v2.0.2)

## V2.0.3 (26/10/2017)

* Mise en place d'une pagination avec tri et filtre de recherche, sur toutes les pages de listes de l'application (sauf les jeux de données)
* Création d'une page d'accueil et d'une page de présentation dont le contenu est entièrement personnalisable par l'administrateur  
* Les instances de test ont été basculées sur des sous-domaines de naturefrance.fr: https://ginco.naturefrance.fr/test-region
* Correction de divers bugs...

[Liste complète des commits](https://github.com/SINP-GINCO/ginco/compare/v2.0.2...v2.0.3)

## V2.0.4 (08/12/2017)

* Ginco utilise maintenant les annuaires SINP : celui des organismes, et celui des personnes
* Par conséquent, la connexion à l'application se fait maintenant via le site de l'INPN.
* Import de fichiers Shapefile
* L'administrateur peut choisir la projection d'export des données
* Et toujours la correction de divers bugs...

[Liste complète des commits](https://github.com/SINP-GINCO/ginco/compare/v2.0.3...v2.0.4)