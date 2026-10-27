#!/bin/bash
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
export section_break="##########################################"

printf "\b\n" "${section_break}" >&2
printf "\b\n"  "Installing Nginx" >&2
printf "\b\n" "${section_break}" >&2

sudo apt-get update
sudo apt-get install nginx -y
sudo service nginx start
sudo nginx -v

printf "\b\n" "${section_break}" >&2
printf "\b\n"  "Installing Wordpress Prerequisites" >&2
printf "\b\n" "${section_break}" >&2

sudo apt-get install software-properties-common
sudo add-apt-repository --yes ppa:ondrej/php
sudo apt update
sudo apt install -y \
  php-fpm>=8.4 \
  php-common>=8.4 \
  php-mysql>=8.4 \
  php-gmp>=8.4 \
  php-curl>=8.4 \
  php-intl>=8.4 \
  php-mbstring>=8.4 \
  php-xmlrpc>=8.4 \
  php-gd>=8.4 \
  php-xml>=8.4 \
  php-cli>=8.4 \
  php-zip>=8.4

# Deug: List installed PHP package versions
dpkg -l | grep php

printf "\b\n" "${section_break}" >&2
printf "\b\n"  "Installing EFS Utilities" >&2
printf "\b\n" "${section_break}" >&2

sudo apt-get -y install git
sudo git clone https://github.com/aws/efs-utils ~/efs-utils
sudo apt-get -y install binutils
sudo chmod -R ~/efs-utils
cd ~/efs-utils
sudo bash -c ~/efs-utils/build-deb.sh
sudo apt-get -y install ~/efs-utils/build/amazon-efs-utils*deb

sudo mkdir /var/www/html/wp-content
sudo mkdir /var/www/html/wp-content/uploads
sudo chmod 775 /var/www/html/wp-content/uploads
sudo chown -R www-data:www-data /var/www/html

printf "\b\n" "${section_break}" >&2
printf "\b\n"  "Installing Wordpress" >&2
printf "\b\n" "${section_break}" >&2

cd /var/www/html
sudo curl -O https://wordpress.org/latest.tar.gz
sudo tar -zxvf latest.tar.gz
cd wordpress
sudo cp -nr . ..
cd ..

sudo rm index.nginx-debian.html
sudo rm -R wordpress
sudo cp wp-config-sample.php wp-config.php

sudo perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php

sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
sudo touch /etc/nginx/sites-available/default
sudo bash -c 'cat > /etc/nginx/sites-available/default' << EOF
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /var/www/html;
        index index.php index.html index.htm index.nginx-debian.html;
        server_name _;
        location / {
                try_files \$uri \$uri/ /index.php?\$args;
        }
        location ~ \.php$ {
         include snippets/fastcgi-php.conf;
         fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
         include fastcgi_params;
        }
}
EOF

sudo service nginx restart

printf "\b\n" "${section_break}" >&2
printf "\b\n"  "Wordpress Installed - Restarting Nginx" >&2
printf "\b\n" "${section_break}" >&2
