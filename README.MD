# Phplist Docker Image

## Introduction

This repository wraps [phplist](https://github.com/phpList/phplist3) in a Docker image for enabling modern deployment models.

## Docker Hub

Built images are available at [Docker Hub](https://hub.docker.com/r/xjonathanlei/phplist).

## Mandatory Environment Variables

### DATABASE_HOST

Database host including port in format: `localhost:3306`.

### DATABASE_NAME

Database database name.

### DATABASE_USER

Database username.

### DATABASE_PASSWORD

Database password. You must supply a database password either through environment variable `DATABASE_PASSWORD` or Docker Secret introduced below. If both are supplied, the environment variable value is ignored.

## Optional Environment Variables

### TEST_MODE

Whether to run phplist in test mode. Can be one of the following:

- true
- false

Defaults to `false`

### MESSAGE_ENVELOPE

Message envelope email address.

### BOUNCE_PROTOCOL

Protocol for handling bounces. Can be one of the following:

- pop
- mbox

Defaults to `pop`

### BOUNCE_MAILBOX_HOST

Bonuce mailbox POP3 host. Used when `BOUNCE_PROTOCOL` is `pop`.

> Example: `outlook.office365.com`

### BOUNCE_MAILBOX_USER

Bonuce mailbox POP3 username. Used when `BOUNCE_PROTOCOL` is `pop`.

### BOUNCE_MAILBOX_PASSWORD

Bonuce mailbox POP3 password. Used when `BOUNCE_PROTOCOL` is `pop`. If a Docker Secret with target `BOUNCE_MAILBOX_PASSWORD` is present, this environment variable is ignored.

### BOUNCE_MAILBOX_PORT

Bonuce mailbox POP3 port. Used when `BOUNCE_PROTOCOL` is `pop`.

> Example: `995/pop3/ssl`

### BOUNCE_MBOX_FILE

Path to mbox file used for bonuces. Used when `BOUNCE_PROTOCOL` is `mbox`.

## Docker Secret Support

If you're deploying this image in Docker Swarm, you can set the following config options with [Docker Secret](https://docs.docker.com/engine/swarm/secrets/):

- `DATABASE_PASSWORD`
- `BOUNCE_MAILBOX_PASSWORD`

Simply set the secret `target` to the option name (e.g. `DATABASE_PASSWORD`).