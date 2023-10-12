#!/bin/bash

# Set permissions on /var/www/html/www/admin/plugins
echo "Current working directory: $(pwd)"
chmod -R a+w www/admin/plugins
chown -R www-data:www-data /var/www/html

# Start Apache in the foreground
exec /usr/sbin/apache2ctl -DFOREGROUND
