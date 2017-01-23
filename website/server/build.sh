#!/bin/bash
set -e
set -x
#------------------------------------------------------------------------------
# Build the project for prod environment
# parameters are all forward to composer.
#------------------------------------------------------------------------------

# get composer
curl -sS https://getcomposer.org/installer | php
# get dependencies and build
./composer.phar install $@

# install assets
php app/console assets:install

# Dump Assetic assets for prod environnement
php app/console assetic:dump --env=prod
#  Clear and warmup cache: no because ii is initialised with wrong values
# php app/console cache:clear --env=prod
# php app/console cache:warmup --env=prod

