#!/bin/bash
#------------------------------------------------------------------------------
# Build the project for prod environment - used by SINP installer
# parameters are all forward to composer.
#------------------------------------------------------------------------------

# get composer
curl -sS https://getcomposer.org/installer | php
# get dependencies and build
./composer.phar install $@
