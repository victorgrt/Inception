#!/bin/bash

sleep 10
cd /var/www/html
if [ ! -f wp-config.php ];
then
    sleep 10
    ./wp-cli.phar core download --allow-root

    ./wp-cli.phar config create --allow-root \
                --dbname=$SQL_DATABASE \
                --dbuser=$SQL_USER \
                --dbpass=$SQL_PASSWORD \
                --dbhost=mariadb:3306\

    ./wp-cli.phar core install --allow-root \
                --url=$DOMAIN_NAME \
                --title="$SITE_TITLE" \
                --admin_user=$WP_ADMIN_LOGIN \
                --admin_password=$WP_ADMIN_PASS \
                --admin_email=$WP_ADMIN_MAIL \

    ./wp-cli.phar user create $USER1_LOGIN $USER1_MAIL --allow-root \
                --role=author \
                --user_pass=$USER1_PASS \

    chown -R www-data:www-data /var/www/html/wp-content
    chown -R www-data:www-data /var/www/html

    echo "Wordpress is now setup"

else
    usermod -u 33 www-data && groupmod -g 33 www-data
    chown -R www-data:www-data /var/www/html/
    echo "Wordpress is already setup"
    echo "$ADMIN_USER\n$ADMIN_PASSWORD\n"

fi

exec /usr/sbin/php-fpm7.4 -F;