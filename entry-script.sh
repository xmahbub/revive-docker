#!/bin/bash

# Set permissions on /var/www/html/www/admin/plugins
chmod -R a+w var/www/html/www/admin/plugins
chown -R www-data:www-data /var/www/html

# Start Apache in the foreground
exec /usr/sbin/apache2ctl -DFOREGROUND
