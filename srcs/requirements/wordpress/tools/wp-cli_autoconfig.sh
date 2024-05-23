#!bin/bash

# sleep 30
cd /var/www/html
if [ ! -f wp-config.php ];
then
    echo "setting up wordpress in here : $(pwd)"
    ./wp-cli.phar config create --allow-root --dbname=$SQL_DATABASE --dbuser=$SQL_USER --dbpass=$SQL_PASSWORD --dbhost=mariadb:3306
    sleep 10 #to let the time of the above thingy to finish
    chmod 777 wp-config.php
    chown -R root:root /var/www/html
    ./wp-cli.phar core install --allow-root --url=$DOMAIN_NAME --title=$SITE_TITLE --admin_user=$ADMIN_USER --admin_password=$ADMIN_PASSWORD --admin_email=$ADMIN_EMAIL
    ./wp-cli.phar user create $USER1_LOGIN $USER1_MAIL --allow-root --role=author --user_pass=$USER1_PASS
    echo "WORDPRESS SUCCESFULLY AUTO CONFIGURED !\n"
else
    echo "WP-CLI ALREADY CONFIGURED !!\n"
fi
exec /usr/sbin/php-fpm7.4 -F;