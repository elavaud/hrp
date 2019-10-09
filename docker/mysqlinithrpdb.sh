#!/bin/bash

# Create HRP database
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${DB_NAME};"
# Grant access to HRP user to the HRP database
mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "GRANT ALL ON ${DB_NAME}.* TO '${MYSQL_USER}'@'%';"
# Import template inside HRP database
mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${DB_NAME} < /template.sql