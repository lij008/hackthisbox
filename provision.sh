#!/bin/bash

# Database password (we could randomly generate this).
DB_PASS=Password_1

# Install Git.
sudo apt install -y git

# Clone website into web root.
sudo rm -rf /var/www/html/*
sudo git clone https://github.com/lij008/hackthisbox.git /var/www/html/

# Install Apache.
sudo apt install -y apache2
sudo service apache2 start

# Install MariaDB.
sudo apt install -y mariadb-server
sudo service mariadb start

# Install PHP.
sudo apt install -y php
sudo apt install -y php-mysqli
sudo service apache2 restart

# Set up database.
sudo mysql -uroot < /var/www/html/sql/db.sql

# Secure MariaDB installation.
sudo apt install -y expect
sudo expect /var/www/html/resources/db_secure.exp $DB_PASS

# Set database password for website.
sudo sed -i -e "s/define('DB_PASS', '');/define('DB_PASS', '$DB_PASS');/g" /var/www/html/web/db_configuration.php

# Go to web root.
cd /var/www/html

# Create symlink into project web root.
# sudo ln -s web html

# Install NPM.
# yum install -y epel-release
# curl --silent --location https://rpm.nodesource.com/setup_6.x | sudo bash -
curl --silent --location https://deb.nodesource.com/setup_6.x | sudo bash -
sudo apt install -y nodejs
sudo apt install -y npm 


# Run project build.
sudo npm install
sudo ./node_modules/.bin/bower install install --allow-root
sudo ./node_modules/.bin/gulp

# Make web root owned by the Apache user.
# sudo chown apache:apache /var/www/* -R
sudo chmod 777 /var/www/* -R