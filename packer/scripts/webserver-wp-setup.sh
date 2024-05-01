#!/bin/bash -e

# basic WP installation steps from:
# https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-on-centos-7

cd ~/ || exit
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz

rsync -avP ~/wordpress/ /var/www/html/
mkdir /var/www/html/wp-content/uploads

# update config
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

# replace keys and salts with random values from WP remote
curl -s https://api.wordpress.org/secret-key/1.1/salt/ | sed -i -e '/Authentication unique keys and salts./,+17 {/define/{r /dev/stdin' -e 'd}};s/\r//' /var/www/html/wp-config.php
# replace DB config, note that password is replaced with inline Packer script
sed -i -e 's/database_name_here/wordpress/' -e 's/username_here/wordpressuser/' -e "/define( 'DB_HOST'/s/localhost/10.10.15.60/" /var/www/html/wp-config.php

# change AllowOverride for /var/www/html only
# https://serverfault.com/a/95992
awk '/<Directory "\/var\/www\/html">/,/AllowOverride None/{sub("None", "All",$0)}{print}' /etc/httpd/conf/httpd.conf | sudo tee /etc/httpd/conf/httpd.conf

sudo chown -R apache:apache /var/www/html/*
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
sudo systemctl restart httpd
