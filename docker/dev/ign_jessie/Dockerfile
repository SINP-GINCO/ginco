# Une image debian de base avec les dépôts IGN et la locale en fr_FR.UTF-8.

FROM debian:jessie
MAINTAINER Ginco Dev Team <sinp-dev@ign.fr>


# Config spécifique à l'intranet IGN
#===================================
# DNS
# Le DNS devra être passé en paramètre du docker run

# gestion des proxy
#------------------
#RUN export http_proxy=http://proxy.ign.fr && \
#    export https_proxy=proxy.ign.fr && \
#    echo 'Acquire::http::Proxy "http://proxy.ign.fr:3128";' > /etc/apt/apt.conf.d/proxy && \
#    echo 'Acquire::https::Proxy "https://proxy.ign.fr:3128";' >> /etc/apt/apt.conf.d/proxy

# mirroirs interne ign
#---------------------
RUN echo "deb http://172.26.0.74/debian/ jessie main non-free contrib" > /etc/apt/sources.list && \
    echo "deb http://172.26.0.74/debian/ jessie-updates main non-free contrib" >> /etc/apt/sources.list && \
    echo "deb http://172.26.0.74/debian-security/ jessie/updates main non-free contrib" >> /etc/apt/sources.list


# Gestion de la locale
#---------------------
# méthode coopiée de fike/debian:jessie.en_UTF-8

#ENV DEBIAN_FRONTEND noninteractive 

#RUN echo "locales locales/locales_to_be_generated multiselect fr_FR.UTF-8 UTF-8" | debconf-set-selections &&\
#    echo "locales locales/default_environment_locale select fr_FR.UTF-8" | debconf-set-selections

# FIXME: il ne trouve pas le paquet "locales"...
#RUN apt-get install --no-install-recommends locales -y

#ENV LC_ALL fr_FR.UTF-8
#RUN apt-get clean && \
#    apt-get autoremove --purge -y && \
#    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*