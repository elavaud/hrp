#!/bin/bash
# Docker entrypoint file
# Build the configuration file

# Clean up potential config files and start fresh from template
rm /var/www/config.inc.php
cp /var/www/config.TEMPLATE.inc.php /var/www/config.inc.php

# Replace environment files
sed -i -e "s/host = localhost/host = ${DB_HOST}/g" /var/www/config.inc.php
sed -i -e "s/username = ojs/username = ${DB_USER}/g" /var/www/config.inc.php
sed -i -e "s/password = ojs/password = ${DB_PWD}/g" /var/www/config.inc.php
sed -i -e "s/name = ojs/name = ${DB_NAME}/g" /var/www/config.inc.php
#sed -i -e "s/http:\/\/pkp.sfu.ca\/ojs/${BASE_URL}/g" /var/www/config.inc.php

# Not using OJS installation process
sed -i -e "s/installed = Off/installed = On/g" /var/www/config.inc.php

# If dev environment, use debug settings
if [ ${ENV_TYPE} = "dev" ]; then
    sed -i -e "s/show_stats =  Off/show_stats =  On/g" /var/www/config.inc.php
    sed -i -e "s/show_stacktrace = Off/show_stacktrace = On/g" /var/www/config.inc.php
    sed -i -e "s/display_errors = Off/display_errors = On/g" /var/www/config.inc.php
    sed -i -e "s/deprecation_warnings = Off/deprecation_warnings = On/g" /var/www/config.inc.php
    #sed -i -e "s/debug = Off/debug = On/g" /var/www/config.inc.php ## uncomment this line for DB outputs. Very verbose
fi

# Set upload folder at root
sed -i -e "s/files_dir = files/files_dir = \/uploads/g" /var/www/config.inc.php

# Use URL parameters instead of CGI PATH_INFO. This is useful for broken server setups that don't support the PATH_INFO environment variable.
sed -i -e "s/disable_path_info = Off/disable_path_info = On/g" /var/www/config.inc.php

# Set writable permissions to cache directory
chown -R www-data:www-data /var/www/cache

# Check if CSS file exists, if not create it using template
if [ ! -e /var/www/plugins/themes/hrp/hrp.css ] then
    cp /var/www/plugins/themes/hrp/hrp.TEMPLATE.css /var/www/plugins/themes/hrp/hrp.css
fi

php-fpm --nodaemonize