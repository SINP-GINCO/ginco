# Documentation utilisateur de GINCO

Ce répertoire contient un projet Sphinx autonome : la documentation utilisateur du projet GINCO. Elle se rapporte aux 
 projets suivants : 
 
* ogam / ogam
* SINP-GINCO / ginco
* SINP / configurateur

## SPHINX

### En bref

Sphinx est un générateur de documentation. Il compile des fichiers sources au format texte ou rst
(ReStructured Text), pour générer de la documentation dans différents formats de sortie : HTML, LaTeX 
 puis PDF à partir du LaTeX, et beaucoup d'autres formats... 
 
Le rst permet d'indiquer le formatage du texte : titres, listes, liens, etc... 
Et Sphinx ajoute des fonctionnalités, telles que la construction d'une table des matières (toctree), 
le marquage par version, les notes et warnings... 

### Documentation

* [Documentation Sphinx](http://www.sphinx-doc.org/en/stable/)
* [Syntaxe RST générale](http://www.sphinx-doc.org/en/stable/rest.html)
* [Syntaxe RST spécifique Sphinx](http://www.sphinx-doc.org/en/stable/markup/index.html)

## Installation de Sphinx

```bash
apt-get install python-sphinx
```
## Organisation du projet

`ginco/documentation/user/` contient le projet de documentation utilisateur.

Le sous-répertoire `source` contient : 

* les fichiers sources `*.rst`, organisés en sous-dossiers par grande partie de la documentation : 
  introduction, configurateur, metadonnées, etc...
    
* un fichier `index.rst` qui contient la table des matières globale ; en fait cette table des matières 
  appelle les fichiers `index.rst` de chaque partie, qui contiennent chacun une table des matières 
  détaillée de la partie. 
  
* un répertoire `images`où sont rangées les images illustrant la doc (essentiellement des captures d'écran). 

* un répertoire `_themes` contenant le thème utilisé (thème "Read the docs" pour Sphinx). 

* les répertoires `_static` et  `_templates`, qui sont vides mais indiqués dans la conf. 

* le fichier de configuration `conf.py`. C'est là où est indiqué le thème utilisé, et diverses options 
  (à voir en particulier pour les versions). 
 
Lorsque l'on compile le projet, un répertoire `build` est créé et contient la documentation aux formats de sortie 
choisis.
  
Le fichier Makefile à la racine contient les options courantes pour la compilation du projet.

## Compiler le projet

Se placer dans `ginco/documentation/user/` et exécuter : 

```bash
make clean
make html
```
Les fichiers html sont générés dans `build/html`. Pour voir le résultat, ouvrir `build/html/index.html`
dans un navigateur. 

Pour générer un PDF : 

```bash
make latexpdf
```
Le fichier généré est `build/latex/Ginco.pdf`. 

## Captures d'écran

Pour créer des captures d'écran annotées, utiliser le plugin Chrome 
[Awesome Screenshot](https://chrome.google.com/webstore/detail/awesome-screenshot-screen/nlipoenfbbikpbjkfpfillcgkoblgpmj?hl=fr&gl=FR). 
