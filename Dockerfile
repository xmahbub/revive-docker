FROM php:8.2-apache

# Update package list and install libzip-dev
RUN apt-get update && apt-get install -y libzip-dev

# Install PHP extensions
RUN docker-php-ext-install zip mysqli pdo pdo_mysql
RUN docker-php-ext-enable mysqli

# Add your source files to the /var/www/html directory
ADD ./src /var/www/html

# Print the current working directory during the build
RUN pwd

# Change permissions on the /var/www/html/www/admin/plugins directory
RUN chmod -R a+w /var/www/html/www/admin/plugins
RUN chown -R www-data:www-data /var/www/html

# Set ServerName in Apache configuration
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Restart Apache service
RUN service apache2 restart

# Expose port 80 for HTTP
EXPOSE 80

# Start Apache in the foreground
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
