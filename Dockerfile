FROM php:8.2-apache

# Update package list and install libzip-dev
RUN apt-get update && apt-get install -y libzip-dev

# Install PHP extensions
RUN docker-php-ext-install zip mysqli pdo pdo_mysql
RUN docker-php-ext-enable mysqli

# COPY source files to the /var/www/html directory
COPY ./src /var/www/html

RUN chmod -R a+w /var/www/html/www/admin/plugins
RUN chown -R www-data:www-data /var/www/html

# Set ServerName in Apache configuration
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Expose port 80 for HTTP
EXPOSE 80

# Start the application
CMD ["apache2-foreground"]