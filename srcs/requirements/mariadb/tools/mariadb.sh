#!/bin/bash

set -e

chown -R mysql:mysql /var/run/mysqld
chmod 775 /var/run/mysqld

if [ ! -d "/var/lib/mysql/$SQL_DATABASE" ]; then
    echo "Setting up mariadb"
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "Configs using bootstrap"

    echo "
    FLUSH PRIVILEGES;
    CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES; " > /tmp/init.sql

    mysqld --user=mysql --bootstrap < /tmp/init.sql
    rm /tmp/init.sql
fi

echo "Done MariaDB setup 👍"
exec mysqld_safe --user=mysql
