# Une image debian ign avec ce qu'il faut pour la bdd GINCO.
FROM ign/debian:jessie
MAINTAINER Ginco Dev Team <sinp-dev@ign.fr>

# Mise à jour du système
RUN apt-get update && apt-get -y upgrade &&\
    apt-get install -y postgresql postgresql-client postgresql-contrib postgresql-9.4-postgis &&\
    /etc/init.d/postgresql start

# création d'un administrateur PostGreSQL et de l'utilisateur ogam
USER postgres
RUN /etc/init.d/postgresql start \
    && psql --command "CREATE ROLE admin WITH LOGIN PASSWORD 'S1NPM@st3r' SUPERUSER;" \
    && psql --command "CREATE ROLE ogam  WITH LOGIN PASSWORD 'ogam' NOSUPERUSER NOINHERIT NOCREATEDB NOCREATEROLE;"

USER root
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf && \
    echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

EXPOSE 5432

#RUN mkdir -p /var/run/postgresql && \
#    chown -R postgres /var/run/postgresql
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

USER postgres
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]