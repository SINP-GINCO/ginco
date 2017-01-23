#!/bin/bash
#------------------------------------------------------------------------------
# Build the project for dev environment
# parameters are all forward to composer.
#------------------------------------------------------------------------------

# get composer
curl -sS https://getcomposer.org/installer | php
# get dependencies and build
./composer.phar install $@

# Dump js-routing
php app/console fos:js-routing:dump --env=dev --target="./src/Ign/Bundle/OGAMConfigurateurBundle/Resources/public/js/fos_js_routes_dev.js"

# install assets
php app/console assets:install --symlink
