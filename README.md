# GINCO

## A propos
GINCO est le projet d'implémentation de référence des plates-formes régionales et
thématique du SINP ([Système d'Information Nature et Paysage](http://www.naturefrance.fr/sinp/presentation-du-sinp))

Les objectifs de la plate-forme sont:
* importer des jeux de données fournis par les producteurs
* Contrôler les données livrées, leur affecter un identifiant SINP, calculer leur
sensibilité en fonction du référentiel de sensibilité régional.
* consulter ces données en respectant un floutage imposés par certains critères
de la données (ex: sensibilité) et les droits des utilisateurs.
* exporter les jeux de données au standard gml DEE à destination de la plate-forme
nationale.
* importer des jeux de données au standard gml DEE en provenance de la plate-forme
nationale.

GINCO est basé sur le logiciel OGAM. Ce logiciel développé par l'IGN à été choisi
parce qu'il largement configurable et qu'il doit permettre de s'adapter aux différentes
thématiques du SINP.

## Documentation utilisateur
La documentation utilisateur est consultable en ligne [ici](https://ginco.naturefrance.fr/doc).

## Installation
Le code actuellement en ligne n'est pas suffisant pour installer GINCO. Il manque
la brique de base OGAM. OGAM est un logiciel open souce sous licence GPL v3, mais
il est en cours de publication sur Github.
En attendant, le code d'OGAM actuellement utilisé par le projet peut être demandé
à l'équipe de développement GINCO: sinp-dev@ign.fr

Voir [ce document](/INSTALL.md/) pour la procédure complète d'installation.
