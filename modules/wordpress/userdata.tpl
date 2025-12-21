#!/bin/bash -e

# set database details with perl find and replace
sudo perl -pi -e "s/database_name_here/${db_name}/g" /var/www/html/wp-config.php
sudo perl -pi -e "s/username_here/${db_user}/g" /var/www/html/wp-config.php
sudo perl -pi -e "s/password_here/${db_pass}/g" /var/www/html/wp-config.php
sudo perl -pi -e "s/localhost/${db_host}/g" /var/www/html/wp-config.php

sudo mount -t --bind efs -o tls ${efs_id}:/ /var/www/html/wp-content

sudo service nginx restart
