# What is in this image?

This image is a php web development environment cooked based on the offical docker image [php](https://hub.docker.com/_/php/), and with the following enhancements. 

Enabled:

* gd
* pdo
* pdo_mysql
* pdo_pgsql
* pgsql
* mcrypt
* mysqli
* pdo_sqlite
* redis
* memcached

Defined:

* display_errors = "on"
* cgi.fix_pathinfo = 0
* date.timezone = "Etc/UTC"

# How to use this image

## Single instance mode

Get the docker image by running the following commands:

	docker pull liuxinnian/php

Start an instance:

	docker run -d -p 80:80 --name php -v /path/to/web:/var/www/html liuxinnian/php

This will start an instance, and you are ready to go.

## login to the container

	docker exec -t -i <container id> /bin/bash

## Linking with other containers

To use this image linking with redis, you have to have a running redis instance. Suppose you have a redis instance named some_redis, we can link it in our php instance with the name redis like this:

	docker run -d -p 80:80 --name php -v /path/to/web:/var/www/html --link some_redis:redis -d liuxinnian/php

Then in the instance, you can use the hostname redis to connect to the database.