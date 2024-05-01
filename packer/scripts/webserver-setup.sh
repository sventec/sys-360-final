#!/bin/bash -e

sudo yum update -y
sudo amazon-linux-extras install -y php7.2
sudo yum install -y httpd php-gd wget rsync

sudo systemctl enable --now httpd

sudo usermod -aG apache ec2-user
# update group membership w/o relogging
# sudo su - ec2-user

sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
