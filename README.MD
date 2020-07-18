# Phplist Docker Image

## Introduction

This repository wraps [phplist](https://github.com/phpList/phplist3) in a Docker image for enabling modern deployment models.

## Docker Hub

Built images are available at [Docker Hub](https://hub.docker.com/r/xjonathanlei/phplist).

## Mandatory Environment Variables

### MYSQL_HOST

MySQL host including port in format: `localhost:3306`.

### MYSQL_DATABASE

MySQL database name.

### MYSQL_USERNAME

MySQL username.

### MYSQL_PASSWORD

MySQL password. You must supply a MySQL password either through environment variable `MYSQL_PASSWORD` or Docker Secret introduced below. If both are supplied, the environment variable value is ignored.

## Optional Environment Variables

### TEST_MODE

Whether to run phplist in test mode. Can be one of the following:

- true
- false

Defaults to `false`

## Docker Secret Support

If you're deploying this image in Docker Swarm, you can set database password with [Docker Secret](https://docs.docker.com/engine/swarm/secrets/) by setting `target` to `MYSQL_PASSWORD`.