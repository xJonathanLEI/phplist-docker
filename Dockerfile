FROM ubuntu:18.04 AS build

ENV PHPLIST_VERSION 3.5.6

WORKDIR /build

RUN apt-get update && apt-get install -y wget unzip
RUN wget "https://sourceforge.net/projects/phplist/files/phplist/${PHPLIST_VERSION}/phplist-${PHPLIST_VERSION}.tgz"
RUN tar -zxf phplist-${PHPLIST_VERSION}.tgz
RUN mkdir phplist && mv phplist-${PHPLIST_VERSION}/public_html/lists/** phplist

# Install phplist-plugin-amazonses

RUN wget "https://github.com/bramley/phplist-plugin-amazonses/archive/master.zip" && mv master.zip phplist-plugin-amazonses.zip
RUN unzip phplist-plugin-amazonses.zip
RUN mv phplist-plugin-amazonses-master/plugins/** phplist/admin/plugins/

COPY ./config_extended.php .

RUN cat config_extended.php >> phplist/config/config.php

FROM php:7.4-apache

# https://stackoverflow.com/questions/52314179/errors-when-installing-imap-extension-on-official-php-docker-image
RUN apt-get update && apt-get install -y git libc-client-dev libkrb5-dev && rm -r /var/lib/apt/lists/*

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install pdo pdo_mysql mysqli imap
RUN a2enmod rewrite

COPY --from=build /build/phplist/ /var/www/html/

COPY ./start-phplist.sh /usr/local/bin/
CMD ["start-phplist.sh"]