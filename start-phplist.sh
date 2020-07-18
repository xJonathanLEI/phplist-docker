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

if [[ -z "${DATABASE_CONNECTION_SSL}" ]] || [[ "${DATABASE_CONNECTION_SSL}" == "true" ]]; then
  # Database SSL set (or defaults) to true
  # This is the default in config.php. Do nothing here
  :
elif [[ "${DATABASE_CONNECTION_SSL}" == "false" ]]; then
  # Database SSL set to false
  sed -i -e "s/\$database_connection_ssl = true;/\$database_connection_ssl = ${DATABASE_CONNECTION_SSL};/g" /var/www/html/config/config.php
else
  echo "Invalid DATABASE_CONNECTION_SSL: ${DATABASE_CONNECTION_SSL}. Valid values are: \"true\", \"false\"";
  exit 1;
fi

if [[ -n "${DATABASE_HOST}" ]]; then
  sed -i -e "s/\$database_host = 'dbhost';/\$database_host = '${DATABASE_HOST}';/g" /var/www/html/config/config.php
else
  echo "Environment variable DATABASE_HOST is mandatory";
  exit 1;
fi

if [[ -n "${DATABASE_NAME}" ]]; then
  sed -i -e "s/\$database_name = 'phplistdb';/\$database_name = '${DATABASE_NAME}';/g" /var/www/html/config/config.php
else
  echo "Environment variable DATABASE_NAME is mandatory";
  exit 1;
fi

if [[ -n "${DATABASE_USER}" ]]; then
  sed -i -e "s/\$database_user = 'phplist';/\$database_user = '${DATABASE_USER}';/g" /var/www/html/config/config.php
else
  echo "Environment variable DATABASE_USER is mandatory";
  exit 1;
fi

if [[ -f /run/secrets/DATABASE_PASSWORD ]]; then
  PASSWORD_FROM_DOCKER_SECRET=$(cat /run/secrets/DATABASE_PASSWORD)
  sed -i -e "s/\$database_password = 'phplist';/\$database_password = '${PASSWORD_FROM_DOCKER_SECRET}';/g" /var/www/html/config/config.php
elif [[ -n "${DATABASE_PASSWORD}" ]]; then
  sed -i -e "s/\$database_password = 'phplist';/\$database_password = '${DATABASE_PASSWORD}';/g" /var/www/html/config/config.php
else
  echo "Environment variable DATABASE_PASSWORD is mandatory";
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