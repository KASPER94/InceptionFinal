#!/bin/sh

set -e
# Le script s'arrête dès qu'une commande échoue
export QUERY_FILE=/query.sql

# Validation des variables d'environnement
if [ -z "$DB_NAME" ] || [ -z "$WP_USER_LOGIN" ] || [ -z "$WP_USER_PASSWORD" ]; then
  echo "Error: Missing required environment variables." >&2
  exit 1
fi

# Génération des commandes SQL dans query.sql
echo "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;" >> $QUERY_FILE
echo "CREATE USER IF NOT EXISTS \`$WP_ADMIN_LOGIN\`@'%' IDENTIFIED BY '$WP_ADMIN_PASSWORD';" >> $QUERY_FILE
echo "GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO \`$WP_ADMIN_LOGIN\`@'%' WITH GRANT OPTION;" >> $QUERY_FILE
echo "FLUSH PRIVILEGES;" >> $QUERY_FILE

# Affichage pour débogage
echo "Generated SQL commands:"
cat $QUERY_FILE

# Rendre le fichier accessible
chmod +rw $QUERY_FILE

# Exécuter MariaDB avec le fichier d'initialisation SQL
exec mysqld --init-file=$QUERY_FILE
