#!/bin/bash

if [ ! -f /var/www/html/wp-config.php ]; then
  wp core download --path=/var/www/html --allow-root

  wp config create --dbname="${DB_NAME}" \
              --dbuser="${WP_ADMIN_LOGIN}" \
              --dbpass="${WP_ADMIN_PASSWORD}" \
              --dbhost=mariadb:3306 \
              --allow-root \
              --path=/var/www/html

  wp core install --url="${WP_URL}" \
              --title="${WP_TITLE}" \
              --admin_user="${WP_ADMIN_LOGIN}" \
              --admin_password="${WP_ADMIN_PASSWORD}" \
              --admin_email="${WP_ADMIN_EMAIL}" \
              --skip-email \
              --allow-root \
              --path=/var/www/html

  wp user create "${WP_USER_LOGIN}" "${WP_USER_EMAIL}" \
              --user_pass="${WP_USER_PASSWORD}" \
              --allow-root \
              --path=/var/www/html
  
fi

mkdir -p /run/php
php-fpm8.1 -F