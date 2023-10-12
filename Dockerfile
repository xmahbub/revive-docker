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

# Set ServerName in Apache configuration
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copy the entry script into the containers`
COPY entry-script.sh /usr/local/bin/entry-script.sh

# Make the entry script executable
RUN chmod +x /usr/local/bin/entry-script.sh

# Expose port 80 for HTTP
EXPOSE 80

# Define the entry point
CMD ["/usr/local/bin/entry-script.sh"]
