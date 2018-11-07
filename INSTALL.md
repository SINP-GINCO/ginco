# Installation de GINCO

Ce processus d'installation est destiné à être effectué en local pour un poste de développeur, dans un environnement Linux (testé sous Debian et Ubuntu). 
 
Il est à adapter pour un déploiement dans un autre environnement.

## Prérequis

Les applications et paquets suivants doivent être installées au préalable : 

```bash
# Postgresql et Postgis (version: 9.4 minimum, l'application fonctionne dans les versions supérieures)
apt-get install -y postgresql postgresql-client postgresql-contrib postgresql-9.4-postgis

# Apache & php (php 5.5 minimum, l'application fonctionne avec php7)
apt-get install -y apache2 php5 php5-pgsql php5-cli php5-curl php5-bcmath php5-mbstring
a2enmod rewrite
a2enmod expires
a2enmod cgi
a2enmod cgid
a2enmod remoteip

# Mapserver
apt-get install -y cgi-mapserver mapserver-bin mapserver-doc php5-mapscript libapache2-mod-fcgid
# mapserv is a fcgi compatible, use default config sethandler with .fcgi
ln /usr/lib/cgi-bin/mapserv /usr/lib/cgi-bin/mapserv.fcgi
a2enmod fcgid

# Tomcat et drivers postgres
apt-get install -y  tomcat8 libpostgresql-jdbc-java
ln -fs  /usr/share/java/postgresql-jdbc4.jar /usr/share/tomcat8/lib/postgresql-jdbc4.jar

# RabbitMQ
apt-get install -y rabbitmq-server
# Facultatif : Management plugin
rabbitmq-plugins enable rabbitmq_management

# Supervisor
apt-get install -y supervisor

# GDAL
apt-get install -y gdal-bin

# Divers
apt-get install -y zip
apt-get install -y libxml2-utils
# node sert à compiler les fichiers less. Le résultat de la compilation est commité, donc node n'est pas utile ailleurs que sur les machines de dev.
apt-get install nodejs 
```

L'application Sencha Command doit aussi être installée pour exécuter le build du client ExtJS.
Elle n'est pas nécessaire pour l'exécution de l'application. Les instructions d'installation et 
les paquets peuvent être trouvés ici : https://www.sencha.com/products/extjs/cmd-download/. 
Attention, ne pas installer la commande en tant que super utilisateur (sudo), sinon il sera difficile 
de l'utiliser en tant qu'utilisateur normal.
Rajouter la commande sencha dans son PATH. 

## Récupération des codes
```bash
# Créer de préférence un répertoire pour l'ensemble des codes du projet:
mkdir -p /path/to/ginco-project
cd /path/to/ginco-project

# récupérer le code du projet ginco
git clone https://github.com/SINP-GINCO/ginco.git

# récupérer le code du configurateur
git clone https://github.com/SINP-GINCO/ogam-configurator.git configurator

```

## Configuration de votre instance

Copier le fichier `configs/example.properties`, ou `configs/localhost.properties.dist`, 
à la racine du projet, le renommer en localhost.properties, et adapter le contenu 
à votre configuration.

## Initialisation de la base

Créer d'abord deux utilisateurs Postgres: un administrateur, et un utilisateur standard nommé "ogam": 
```bash
sudo -u postgres psql -c "CREATE ROLE admin WITH LOGIN PASSWORD 'passwd' SUPERUSER;"
sudo -u postgres psql -c "CREATE ROLE ogam  WITH LOGIN PASSWORD 'passwd' NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE;"
```

Créer un répertoire /var/data/ginco et donner tous les droits aux utilisateurs apache et tomcat.  

Créer et initialiser la base de données avec le script create_db.php : 
```bash
php database/init/create_db.php -f localhost.properties
```

## Lancement du build

Le script `build_ginco.php` s'occupe de builder les différentes parties de 
l'application (Symfony, Java, ExtJS, fichiers de configuration...). Vous pouvez le lancer 
sans arguments pour voir les options disponibles. Pour lancer le build complet 
de l'application en environnement de développement :

```bash
php build_ginco.php -f localhost.properties --mode=dev
```

Si vous êtes derrière un proxy, il sera nécessaire de rajouter les informations du proxy
pour gradle (responsable de builder la partie Java) : 

```bash
# Proxy for Gradle (à mettre dans ~/.bashrc ou ~/.profile par exemple)
export GRADLE_OPTS="-Dhttps.proxyHost=proxy.domain.fr -Dhttps.proxyPort=XXXX"
```

A la fin du build, le script affiche des instructions de post-installation.
Les suivre scrupuleusement ! 

## Configuration Apache 

Vous venez de rajouter un fichier nommé ginco_mon.domain.xx.conf dans /etc/apache2/sites-available ; 
la première fois, il est nécessaire d'activer ce site :

```bash
sudo a2ensite ginco_mon.domain.xx
```

Rajoutez l'url mon.domain.xx dans le fichier /etc/hosts. 

Créez un lien symbolique dans /var/www/ vers le répertoire /pat/to/ginco-project/ginco. Attention 
ce lien doit être le même que celui indique dans localhost.properties, pour la variable apache.path.to.app

## Fin

Redémarrez tous les services : 

```bash
sudo service apache restart 
sudo service tomcat8 restart 
sudo service supervisor force-stop; sudo service supervisor restart
```
Si tout s'est bien passé, votre instance Ginco est up sur l'url que vous avez indiqué dans la configuration 
(variables url.protocol, url.domain et url.basepath). 