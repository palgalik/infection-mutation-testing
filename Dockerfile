FROM php:7.3-fpm

WORKDIR /var/www

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'a5c698ffe4b8e849a443b120cd5ba38043260d5c4023dbf93e1558871f1f07f58274fc6f4c93bcfd858c6bd0775cd8d1') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir=/var/www \
    && php -r "unlink('composer-setup.php');" \
    && mv /var/www/composer.phar /usr/local/bin/composer

RUN apt-get update \
  && apt-get install -y wget gnupg git unzip

RUN pecl install xdebug-2.7.2 \
    && docker-php-ext-enable xdebug \
    && echo 'xdebug.remote_port=9000' >> /usr/local/etc/php/php.ini \
    && echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/php.ini \
    && echo 'xdebug.remote_connect_back=1' >> /usr/local/etc/php/php.ini