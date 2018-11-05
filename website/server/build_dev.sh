#!/bin/bash
#------------------------------------------------------------------------------
# Build the project for dev environment
# parameters are all forward to composer.
#------------------------------------------------------------------------------

# Set permissions on cache and logs
HTTPDUSER=`ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`

sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX app/cache app/logs app/sessions
sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX app/cache app/logs app/sessions

# Set permissions on logs to tomcat user
TOMCATUSER=tomcat8

sudo setfacl -R -m u:"$TOMCATUSER":rwX app/logs
sudo setfacl -dR -m u:"$TOMCATUSER":rwX app/logs

# get composer
curl -sS https://getcomposer.org/installer | php
# get dependencies and build
./composer.phar install $@

# install assets
php app/console assets:install --symlink

# Dump Assetic assets for env environnement
php app/console assetic:dump --env=dev
php app/console cache:clear --env=dev
php app/console cache:warmup --env=dev
