#!/bin/bash

if [[ -z "${TEST_MODE}" ]] || [[ "${TEST_MODE}" == "false" ]]; then
  # Test mode set (or defaults) to false
  sed -i -e "s/define('TEST', 1);/define('TEST', 0);/g" /var/www/html/config/config.php
elif [[ "${TEST_MODE}" == "true" ]]; then
  # Test mode set to true
  # This is the default in config.php. Do nothing here
  :
else
  echo "Invalid TEST_MODE: ${TEST_MODE}. Valid values are: \"true\", \"false\"";
  exit 1;
fi

if [[ -n "${MYSQL_HOST}" ]]; then
  sed -i -e "s/\$database_host = 'dbhost';/\$database_host = '${MYSQL_HOST}';/g" /var/www/html/config/config.php
else
  echo "Environment variable MYSQL_HOST is mandatory";
  exit 1;
fi

if [[ -n "${MYSQL_DATABASE}" ]]; then
  sed -i -e "s/\$database_name = 'phplistdb';/\$database_name = '${MYSQL_DATABASE}';/g" /var/www/html/config/config.php
else
  echo "Environment variable MYSQL_DATABASE is mandatory";
  exit 1;
fi

if [[ -n "${MYSQL_USERNAME}" ]]; then
  sed -i -e "s/\$database_user = 'phplist';/\$database_user = '${MYSQL_USERNAME}';/g" /var/www/html/config/config.php
else
  echo "Environment variable MYSQL_USERNAME is mandatory";
  exit 1;
fi

if [[ -f /run/secrets/MYSQL_PASSWORD ]]; then
  PASSWORD_FROM_DOCKER_SECRET=$(cat /run/secrets/MYSQL_PASSWORD)
  sed -i -e "s/\$database_password = 'phplist';/\$database_password = '${PASSWORD_FROM_DOCKER_SECRET}';/g" /var/www/html/config/config.php
elif [[ -n "${MYSQL_PASSWORD}" ]]; then
  sed -i -e "s/\$database_password = 'phplist';/\$database_password = '${MYSQL_PASSWORD}';/g" /var/www/html/config/config.php
else
  echo "Environment variable MYSQL_PASSWORD is mandatory";
  exit 1;
fi

if [[ -n "${MESSAGE_ENVELOPE}" ]]; then
  sed -i -e "s/\/\/ \$message_envelope = '.*';/\$message_envelope = '${MESSAGE_ENVELOPE}';/g" /var/www/html/config/config.php
fi

if [[ -n "${BOUNCE_PROTOCOL}" ]]; then
  sed -i -e "s/\$bounce_protocol = '.*';/\$bounce_protocol = '${BOUNCE_PROTOCOL}';/g" /var/www/html/config/config.php
fi

if [[ -n "${BOUNCE_MAILBOX_HOST}" ]]; then
  sed -i -e "s/\$bounce_mailbox_host = '.*';/\$bounce_mailbox_host = '${BOUNCE_MAILBOX_HOST}';/g" /var/www/html/config/config.php
fi

if [[ -n "${BOUNCE_MAILBOX_USER}" ]]; then
  sed -i -e "s/\$bounce_mailbox_user = '.*';/\$bounce_mailbox_user = '${BOUNCE_MAILBOX_USER}';/g" /var/www/html/config/config.php
fi

if [[ -f /run/secrets/BOUNCE_MAILBOX_PASSWORD ]]; then
  PASSWORD_FROM_DOCKER_SECRET=$(cat /run/secrets/BOUNCE_MAILBOX_PASSWORD)
  sed -i -e "s/\$bounce_mailbox_password = '.*';/\$bounce_mailbox_password = '${PASSWORD_FROM_DOCKER_SECRET}';/g" /var/www/html/config/config.php
elif [[ -n "${BOUNCE_MAILBOX_PASSWORD}" ]]; then
  sed -i -e "s/\$bounce_mailbox_password = '.*';/\$bounce_mailbox_password = '${BOUNCE_MAILBOX_PASSWORD}';/g" /var/www/html/config/config.php
fi

if [[ -n "${BOUNCE_MAILBOX_PORT}" ]]; then
  sed -i -e "s/\$bounce_mailbox_port = '.*';/\$bounce_mailbox_port = '${BOUNCE_MAILBOX_PORT//\//\\\/}';/g" /var/www/html/config/config.php
fi

if [[ -n "${BOUNCE_MBOX_FILE}" ]]; then
  sed -i -e "s/\$bounce_mailbox = '.*';/\$bounce_mailbox = '${BOUNCE_MBOX_FILE}';/g" /var/www/html/config/config.php
fi

exec apache2-foreground;