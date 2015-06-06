#!/usr/bin/env bash
# Install mysql-server with root pass: 'root'
DBNAME=wordpress
DBPASSWD=12345

WPUSER=wordpress
WPPASS=12345

#sudo apt-get -qq update
sudo apt-get -y install apache2 php5 php5-mysql
sudo apt-get -y install php5-xdebug php5-cgi

# Install MySQL
debconf-set-selections <<< "mysql-server mysql-server/root_password password ${DBPASSWD}"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${DBPASSWD}"
sudo apt-get -y install mysql-server

# Create database and user for Wordpress
mysql -uroot -p${DBPASSWD} -e "CREATE DATABASE ${DBNAME}"
mysql -uroot -p${DBPASSWD} -e "CREATE USER '${WPUSER}'@'%' IDENTIFIED BY '${WPPASS}'"
mysql -uroot -p${DBPASSWD} -e "GRANT ALL ON ${DBNAME}.* TO '${WPUSER}'@'%'"
mysql -uroot -p${DBPASSWD} -e "FLUSH PRIVILEGES"

# Install PHPMyadmin
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
sudo apt-get -y install phpmyadmin

# Remove default html page that bundles with Java
rm /var/www/html/index.htm*

# link
[ -f /vagrant/xdebug.ini ] && sudo cp /vagrant/xdebug.ini /etc/php5/mods-available/xdebug.ini

echo "You've been provisioned!"
