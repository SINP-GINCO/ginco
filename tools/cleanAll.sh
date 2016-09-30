#!/bin/bash

sudo service apache2 restart
sudo service tomcat7 restart
sudo service postgresql restart
rm -rf /var/www/sinp/tmp/database/*
rm -rf /var/www/sinp/tmp/language/*

