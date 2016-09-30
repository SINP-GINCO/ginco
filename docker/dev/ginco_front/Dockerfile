# Une image debian ign avec ce qu'il faut pour le front GINCO
FROM ign/debian:jessie
MAINTAINER Ginco Dev Team <sinp-dev@ign.fr>

# Mise à jour du système
RUN apt-get update && apt-get -y upgrade &&\
    apt-get install -y vim &&\
    apt-get install -y apache2 php5 php5-pgsql php5-cli php5-curl &&\
    apt-get install -y cgi-mapserver mapserver-bin mapserver-doc php5-mapscript libapache2-mod-fcgid &&\
    apt-get install -y tilecache python-flup python-paste python-imaging &&\
    apt-get install -y  tomcat7 libpostgresql-jdbc-java libgnumail-java


RUN a2enmod rewrite expires cgi cgid

# Mise à jour de la timezone dans les fichiers de conf PHP TODO: à valider
RUN sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/Paris/g' /etc/php5/cli/php.ini &&\
    sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/Paris/g' /etc/php5/apache2/php.ini 

# Install mapserver
#==================
# mapserv is a fcgi compatible, use default config sethandler with .fcgi
RUN ln /usr/lib/cgi-bin/mapserv /usr/lib/cgi-bin/mapserv.fcgi &&\
    a2enmod fcgid



# Install tomcat7 et libs associées
#==================================
RUN TOMCAT_LIB=/usr/share/tomcat7/lib &&\
    ln -fs  /usr/share/java/gnumail.jar  $TOMCAT_LIB/javax.mail.jar &&\
    ln -fs  /usr/share/java/postgresql-jdbc4.jar $TOMCAT_LIB/postgresql-jdbc4.jar

# module proxy pour passer les requêtes vers geosource à tomcat depuis apache.
RUN a2enmod proxy proxy_ftp proxy_http proxy_connect
# environnement spécifique pour geosource.
ENV JAVA_OPTS="$JAVA_OPTS -server -Xms128m -Xmx1024m"


# Nécessaire pour faire un pg_dump
#==================================
#echo "Install de pg client"
#apt-get install -y postgresql-client


EXPOSE 80
EXPOSE 8080

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

RUN echo service tomcat7 start > /var/tmp/start.sh &&\
    rm -rf /run/httpd/* /tmp/httpd* &&\
    echo /usr/sbin/apache2 -D FOREGROUND >> /var/tmp/start.sh &&\
    chmod +x /var/tmp/start.sh

CMD ["sh", "/var/tmp/start.sh"]


# TENTATIVES ANTERIEURES:
#------------------------
#CMD ["sh", "/var/tmp/start.sh"] # problème avec tomcat et s'arrete tout de suite
#CMD ["/etc/init.d/apache2", "start"] # s'arrête tout de suite parce qu'il ne reste pas au premier plan...
#CMD ["/usr/sbin/apache2", "-D", "FOREGROUND"]
#CMD service tomcat7 start && tail -F /var/lib/tomcat7/logs/catalina.out 
# le tail permet de conserver tomcat au premier plan.
#running tail -f will not follow the file after it rotates, however using 
# tail -F does. If tomcat rotates the file once every night your instance will 
# die at that time. However running tail -F will follow the file even if it’s 
# rotated or renamed.