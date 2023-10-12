FROM php:8.2-apache
RUN apt-get update
RUN apt-get install -y libzip-dev
RUN docker-php-ext-install zip
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli
ADD ./src /var/www/html
RUN pwd
RUN chmod -R a+w /www/admin/plugins
RUN chown -R www-data:www-data /var/www/html

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN service apache2 restart

EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]

