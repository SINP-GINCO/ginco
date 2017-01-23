#!/bin/bash
set -e
set -x
#------------------------------------------------------------------------------
# Build the project for prod environment - used by SINP installer
# parameters are all forward to composer.
#------------------------------------------------------------------------------

# get composer
curl -sS https://getcomposer.org/installer | php
# get dependencies and build
./composer.phar install $@

# Dump js-routing
php app/console fos:js-routing:dump --env=prod --target="./src/Ign/Bundle/OGAMConfigurateurBundle/Resources/public/js/fos_js_routes.js"

# install assets
php app/console assets:install

# Dump Assetic assets for prod environnement, clear and warmup cache
php app/console assetic:dump --env=prod
php app/console cache:clear --env=prod
php app/console cache:warmup --env=prod

