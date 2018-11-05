# OGAM - Serveur Tomcat sur Linux

## Installation via APT
`sudo apt-get install tomcat8`

L'installation crée un nouvel utilisateur **tomcat8**

Le redémarrage du serveur peut se faire comme un deamon classique :  
`/etc/init.d/tomcat8 restart`

## Installation de la console d'admininistration

Installation de la console d'administration : 

`sudo apt-get install tomcat8-admin tomcat8-docs tomcat8-examples`

Les consoles d'administration _manager_ et _host-manager_ nécessitent l'installation du paquet _tomcat8-admin_.

Les URL des consoles sont:


* <http://localhost:8080/manager/html>

* <http://localhost:8080/host-manager/html>

Pour pouvoir utiliser les consoles d'admnistration il faut éditer le fichier de configuration suivant : 

`/etc/tomcat8/tomcat-users.xml`

et définir les rôles d'administration de Tomcat : 

```xml
<role rolename="manager-gui"/>
<role rolename="admin-gui"/>
<role rolename="manager-jmx"/>
<role rolename="manager-status"/>
<user username="tomcat" password="s3cret" roles="manager-jmx,manager-status,admin-gui,manager-gui"/>
</tomcat-users>
```

Avec Tomcat8, les rôles d'administration ont été découpé plus finement:  
Il faut créer les rôles:

*    **manager-gui** - allows access to the HTML GUI and the status pages
*    **manager-script** - allows access to the text interface and the status pages
*    **manager-jmx** - allows access to the JMX proxy and the status pages
*    **manager-status** - allows access to the status pages only

Il faut un rôle **admin** pour gérer les hôtes virtuels.  

Le mot de passe est en clair dans le fichier de conf. alors je n'ai pas utilisé un mot de passe habituel.

## Configuration de la connexion à Postgre et l'envoi d' email

Les services JAVA d'OGAM se connectent à la base de données Postgres, notamment le service d'intégration de données.

Installation du pilote **Postgresql-JDBC**:

`sudo apt-get install libpostgresql-jdbc-java`

Installation de la librairie d'envoie d'email : 

`sudo apt-get install libgnumail-java`

Création des liens symboliques :

```
cd    /usr/share/tomcat8/lib
sudo ln -s ../../java/gnumail.jar javax.mail.jar
sudo ln -s ../../java/postgresql.jar postgresql.jar
```

Note : La librairie **tomcat-jdbc.jar**  est également requise et doit être installée si elle n'est pas présente. 
