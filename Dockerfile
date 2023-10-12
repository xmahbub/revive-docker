FROM php:8.2-apache
RUN apt-get update
RUN apt-get install -y libzip-dev
RUN docker-php-ext-install zip
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable mysqli
ADD ./src /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

ENV APACHE_CONFDIR /etc/apache2
ENV APACHE_ENVVARS $APACHE_CONFDIR/envvars

RUN set -ex \
	\
# generically convert lines like
#   export APACHE_RUN_USER=www-data
# into
#   : ${APACHE_RUN_USER:=www-data}
#   export APACHE_RUN_USER
# so that they can be overridden at runtime ("-e APACHE_RUN_USER=...")
	&& sed -ri 's/^export ([^=]+)=(.*)$/: ${\1:=\2}\nexport \1/' "$APACHE_ENVVARS" \
	\
# setup directories and permissions
	&& . "$APACHE_ENVVARS" \
	&& for dir in \
		"$APACHE_LOCK_DIR" \
		"$APACHE_RUN_DIR" \
		"$APACHE_LOG_DIR" \
		/var/www/html \
	; do \
		rm -rvf "$dir" \
		&& mkdir -p "$dir" \
		&& chown -R "$APACHE_RUN_USER:$APACHE_RUN_GROUP" "$dir"; \
	done

RUN set -ex \
	&& . "$APACHE_ENVVARS" \
	&& ln -sfT /dev/stderr "$APACHE_LOG_DIR/error.log" \
	&& ln -sfT /dev/stdout "$APACHE_LOG_DIR/access.log" \
	&& ln -sfT /dev/stdout "$APACHE_LOG_DIR/other_vhosts_access.log"

RUN service apache2 restart
EXPOSE 80
EXPOSE 443
