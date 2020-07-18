FROM ubuntu:18.04 AS build

ENV PHPLIST_VERSION 3.5.5

WORKDIR /build

RUN apt-get update && apt-get install -y wget unzip
RUN wget "https://sourceforge.net/projects/phplist/files/phplist/${PHPLIST_VERSION}/phplist-${PHPLIST_VERSION}.tgz"
RUN tar -zxf phplist-${PHPLIST_VERSION}.tgz
RUN mkdir phplist && mv phplist-${PHPLIST_VERSION}/public_html/lists/** phplist

# Install phplist-plugin-amazonses

RUN wget "https://github.com/bramley/phplist-plugin-amazonses/archive/master.zip" && mv master.zip phplist-plugin-amazonses.zip
RUN unzip phplist-plugin-amazonses.zip
RUN mv phplist-plugin-amazonses-master/plugins/** phplist/admin/plugins/

COPY . .

RUN cat config_extended.php >> phplist/config/config.php

FROM php:7.4-apache

RUN apt-get update && apt-get install -y git
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN a2enmod rewrite

COPY --from=build /build/phplist/ /var/www/html/

COPY ./start-phplist.sh /usr/local/bin/
CMD ["start-phplist.sh"]