#!/bin/bash

sleep 5

chown -R www-data:www-data /var/www/html;
chown -R 755 /var/www/html;

if [ ! -e /var/www/html/wp-config.php ]; then
	echo "Wordpress: setting up..."
	
	wp config create \
		--allow-root \
		--dbname=$SQL_DATABASE \
		--dbuser=$SQL_USER \
		--dbpass=$SQL_PASSWORD \
		--dbhost=mariadb:3306 \
		--path='/var/www/html'
	
	wp core install \
		--allow-root \
		--url="$WP_DOMAIN" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_LOGIN" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--path='/var/www/html'
	echo "welcome pages passsed and admin created!"


	wp user create $WP_USER_LOGIN $WP_USER_EMAIL \
		--role=author \
		--user_pass=$WP_USER_PASSWORD \
		--allow-root \
		--path='/var/www/html'
	echo "normal user created!"
fi

echo "Done Worpress setup 👍"
exec /usr/sbin/php-fpm7.4 -F