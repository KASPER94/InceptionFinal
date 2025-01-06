#!/bin/bash

	sed -i "s/listen = \/run\/php\/php8.1-fpm.sock/listen = 9000/" "/etc/php/8.1/fpm/pool.d/www.conf";
	chown -R www-data:www-data /var/www/*;
	chown -R 755 /var/www/*;
	mkdir -p /run/php/;
	touch /run/php/php8.1-fpm.pid;

if [ ! -f /var/www/html/wp-config.php ]; then
# 	echo "Wordpress: setting up..."
# 	mkdir -p /var/www/html
# 	wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar;
# 	chmod +x wp-cli.phar; 
# 	mv wp-cli.phar /usr/local/bin/wp;
# 	cd /var/www/html;
# 	wp core download --allow-root;
# 	mv /var/www/wp-config.php /var/www/html/
# 	echo "Wordpress: creating users..."
# 	wp core install --allow-root --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMIN_LOGIN} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL}
# 	wp user create --allow-root ${WP_USER_LOGIN} ${WP_USER_EMAIL} --role=author --user_pass=${WP_USER_PASSWORD};
# 	echo "Wordpress: set up!"
# fi

# php-fpm8.1 -F

# exec "$@"

# #!/bin/bash
# if [ ! -f "${VOL_PATH_WP}/wp-config.php" ]; then

  # Download Wordpress
  wp core download --path=/var/www/html --allow-root

  # Config wordpress database
  wp config create --dbname=$DB_NAME \
              --dbuser=$WP_ADMIN_LOGIN \
              --dbpass=$WP_ADMIN_PASSWORD \
              --dbhost=mariadb:3306 \
              --allow-root \
              --path=/var/www/html

  # Config wordpress core
  wp core install --url="${WP_URL}" \
              --title="${WP_TITLE}" \
              --admin_user="${WP_ADMIN_LOGIN}" \
              --admin_password="${WP_ADMIN_PASSWORD}" \
              --admin_email="${WP_ADMIN_EMAIL}" \
              --allow-root \
              --path=/var/www/html

  wp user create $WP_USER_LOGIN $WP_USER_EMAIL \
              --allow-root \
              --path=/var/www/html

fi

# exec "$@"
mkdir -p /run/php
php-fpm8.1 -F