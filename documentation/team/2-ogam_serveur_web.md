# OGAM - Installation des serveurs web sur Linux

## Adressage du serveur de développement

Editer le fichier `/etc/hosts` et ajouter :

```
127.0.0.5 sinp
127.0.0.5 sinp.ign.fr
127.0.0.5 sinp-1.ign.fr
127.0.0.5 sinp-2.ign.fr
127.0.0.5 sinp-3.ign.fr
127.0.0.5 sinp-4.ign.fr
127.0.0.5 sinp-5.ign.fr
127.0.0.5 sinp-6.ign.fr
127.0.0.5 sinp-7.ign.fr
127.0.0.5 sinp-8.ign.fr
127.0.0.5 sinp-9.ign.fr
```

## Installation d'Apache et de PHP via APT

`sudo apt-get install apache2 php5-common libapache2-mod-php5 php5-cli`

L'application OGAM fait usage de la ré-écriture d'URL, il est nécessaire d'activer le module **_Rewrite_** : 

`sudo a2enmod rewrite`

Le module _expires_ doit également être activé : 

`sudo a2enmod expires`

Le nom de domaine du serveur et l'utilisation du mod Rewrite doit être spécifié dans le fichier de conf. d'Apache :

***/etc/apache2/apache2.conf***

```
ServerName localhost
RewriteEngine On
```

Le **_module CGI_** doit être activé pour que Mapserver fonctionne : 

`sudo a2enmod cgi`

Note : Il semble que le module `cgid` (permettant l'exécution de script utilisant un daemon CGI) doit également être activé.

`sudo a2enmod cgid`

Apache doit être redémarré pour tenir compte des modifications : 

`sudo /etc/init.d/apache2 restart`

## Configuration du serveur HTTP (Apache)

Le modèle de configuration d'Apache (hôtes virtuelles etc.) se trouve dans le répertoire: `website/config/httpd_ogam.conf`.
[TODO: Ajouter explications sur le contenu du fichier de configuration]

Ce fichier doit être copié et adapté (selon l'environnement de développement) dans : 

`/etc/apache2/sites-available/`

Un lien symbolique doit être créé dans le répertoire **sites-enabled** : 

`sudo ln -s ../sites-available/sinp.conf`


## Installation du serveur cartographique : MapServer

`sudo apt-get install cgi-mapserver mapserver-bin mapserver-doc php5-mapscript`


## Configuration de PHP 

Changer les limitations de PHP pour le projet OGAM

`/etc/php5/apache2/php.ini`

```
post_max_size = 100M
upload_max_filesize = 100M
memory_limit = 512M
```

