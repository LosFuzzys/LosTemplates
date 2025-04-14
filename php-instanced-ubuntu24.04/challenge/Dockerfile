# Debian 12
# PHP 8.4.5
# Apache 2.4.62
FROM docker.io/library/php@sha256:abce8fe7e3390e96d3ac52dff8e6f5ff9507f4a7bee2b18f11404b74d7efec66

# Copy challenge required files
COPY ./config/php.ini $PHP_INI_DIR/php.ini
COPY ./web /var/www/html
COPY ./flag.txt /flag.txt
