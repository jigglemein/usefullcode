FROM php:7.0-apache
RUN apt-get update && apt-get install -y \
        && docker-php-ext-install mysqli
COPY website /var/www/html/
