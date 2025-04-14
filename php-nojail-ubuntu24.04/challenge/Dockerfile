# Debian 12
# PHP 8.4.5
# Apache 2.4.62
FROM docker.io/library/php@sha256:56a121dbe0a1f2dfd20b24d28408a0ec67c2e480b59a41d4c6c012870984bea6

# Copy challenge required files
COPY config/php.ini $PHP_INI_DIR/php.ini
COPY web /var/www/html
COPY flag.txt /flag.txt
