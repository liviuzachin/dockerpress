ARG APP_NAME=app
ARG ALPINE_VERSION=latest

FROM alpine:${ALPINE_VERSION}

# Setup document root
WORKDIR /var/www

# Install packages and remove default server definition
RUN apk add --no-cache \
  php8 \
  php8-fpm \
  php8-mysqli \
  php8-json \
  php8-openssl \
  php8-curl \
  php8-zlib \
  php8-xml \
  php8-phar \
  php8-session \
  php8-intl \
  php8-dom \
  php8-xmlreader \
  php8-xmlwriter \
  php8-exif \
  php8-fileinfo \
  php8-sodium \
  php8-gd \
  php8-simplexml \
  php8-ctype \
  php8-mbstring \
  php8-zip \
  php8-opcache \
  php8-iconv \
  php8-pecl-imagick \
  php8-tokenizer \
  nginx \
  supervisor \
  curl \
  bash \
  less

# Create symlink so programs depending on `php` still function
RUN ln -s /usr/bin/php8 /usr/bin/php

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY config/php.ini /etc/php8/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www /run /var/lib/nginx /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Add application 
# COPY --chown=nobody ./app /var/www/root

# Install composer from the official image
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Run composer install to install the dependencies
# RUN composer install --optimize-autoloader --no-interaction --no-progress
RUN composer create-project roots/bedrock root

WORKDIR /var/www/root/web/app/themes/${APP_NAME}

# Run composer install to install the dependencies
# RUN composer install --optimize-autoloader --no-interaction --no-progress
RUN composer create-project roots/sage ${APP_NAME} dev-main

WORKDIR /var/www/root

# Expose the port nginx is reachable on
EXPOSE 80

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/fpm-ping
