# Debian 12
# PHP 8.7.3
# Apache 2.4.59
FROM docker.io/library/php@sha256:b3ff205fcc739fc504750dab29d4c30afb2702730d37a1068a16c14f30a7d48f

# Copy challenge required files
COPY ./config/php.ini $PHP_INI_DIR/php.ini
COPY ./web /var/www/html
COPY ./flag.txt /flag.txt
