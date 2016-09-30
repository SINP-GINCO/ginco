# OGAM - Compilation des services JAVA

## Installation du JDK

La compilation des sources Java des services requiert le Java Development Toolkit, installation via APT : 

 `sudo apt-get install openjdk-7-jdk`


Note : La sortie de la compilation sous Java 1.7 affiche des warnings car les listes doivent être typées sous cette version.
(Contrairement aux versions précédentes). 

## Services 

L'application OGAM utilise 3 services, qui des applications Java/Tomcat, à savoir  : 

* **Un service d'intégration de données**;
* **Un service d'harmonisation**;
* **Un service de génération de rapport.**

**Fonctionnement :**

Le déploiement des services s'effectue via les tâches automatisées ANT.

Les services sont dans un premier temps compilé dans un répertoire de travail temporaire **`/tmp`**.

Puis ils sont copié dans le répertoire :  **`/var/lib/tomcat7/webapps`**

Chaque répertoire de service possède un fichier `WEB-INF/web.xml` qui définit l'association entre l'URL et le servlet à déclencher.

## Préalable : compilation de la librairie fr.ifn.commons.jar

La compilation des services nécessite en amont de compiler les librairies java **`ifn`**.

Depuis le répertoire : **`libs_java`**

Exécuter la commande ANT de build (`ant build`).

Ceci génère un fichier JAR copié de manière temporaire dans le répertoire : `/tmp/dist/libs_java/fr.ifn.commons.jar`.


## Compilation et déploiement du service de génération de rapport

Se placer dans le répertoire du projet et exécuter : 

**`sudo ant deployReportGenerationService`**

Ceci provoque la génération des services d'intégration et de génération de rapport.

Note: le dossier `service_generation_rapport` est la sur-couche du moteur de génération de rapport basé sur [BIRT](http://eclipse.org/birt/, "Business Intelligence and Reporting Tools"). 

Ce répertoire inclut les images et templates des rapports.

Le noyau de BIRT se trouve quant à lui dans le dossier `ServiceGenerationRapport`.
