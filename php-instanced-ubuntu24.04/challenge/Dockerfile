# Debian 12
# PHP 8.7.3
# Apache 2.4.59
FROM docker.io/library/php@sha256:88cccc4e34d127a42f11d670ca94910d958f0a0bf3bfc8dc58fd6c0f22ac3b2d

# Copy challenge required files
COPY ./config/php.ini $PHP_INI_DIR/php.ini
COPY ./web /var/www/html
COPY ./flag.txt /flag.txt
