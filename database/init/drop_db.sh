#!/bin/bash
set -x
set -e

# FIXME lire les paramètres sur la ligne de commande.
db_name=docker
host=192.168.0.2
port=5432 #conserver cette Initialisation par défaut
db_adminuser=admin
db_adminuser_pw=S1NPM@st3r

dropdb $db_name -h $host -p $port -U $db_adminuser --if-exists
