#!/bin/sh

echo "\n\033[2;31m==============================\033[0m"
echo "\n\033[2;31m=== Database configuration ===\033[0m"
echo "\n\033[2;31m==============================\033[0m\n"

#VERIFIE SI LE DOSSIER DE LA DB EXISTE DEJA
if [ -d "/var/lib/mysql/${SQL_DATABASE}" ]
then 
    echo "==> database ${SQL_DATABASE} already exists\n"
else
    echo "starting mariadb..."
    service mariadb start #demare le service
    sleep 1
    echo "creating database: ${SQL_DATABASE}"
    mysql -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};" #CREER LA BASE DE DONNEE SI ELLE N'EXISTE PAS
    mysql -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';" #CREER UN USER AVEC UN PASS SI IL N'EXISE PAS DEJA
    mysql -e "GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';"  #DONNE TOUTES LES PERMS SUR LA DB A SQL_USER
    mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';" #DONNE TOUTES LES PERMS A ROOT POUR LES CONNEXIONS DEPUIS LOCALHOST AVEC LE ROOT PASS
    sleep 1
    # shutting down mariadb so it can be restarted using exec
    # needed because like this mysqlq becomes processus #1 in container
    mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown
    echo "database ready"
fi
sleep 1
# using exec, the specified command becomes PID 1
# runs the command without a shell. It can have advantages in term of signal handling and clean process termination
echo "Database up and ready !\n" 
# exec is good because ca assure que docker peut restart mysqld si ya un soucis
exec mysqld