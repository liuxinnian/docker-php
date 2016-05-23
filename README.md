# What is in this image?

This image is a php web development environment cooked based on the offical docker image [php:5-apache](https://hub.docker.com/_/php/), and with the following enhancements. 

Enabled:

* enchant
* ctype
* dom
* exif
* fileinfo
* gettext
* pdo
* posix
* pspell
* shmop
* soap
* sockets
* wddx
* interbase
* xmlwriter
* opcache
* mbstring
* pdo_mysql
* pdo_pgsql
* intl
* pgsql
* bz2
* xsl
* mcrypt
* iconv
* json
* mysqli
* pdo_sqlite
* phar
* curl
* ftp
* hash
* session
* simplexml
* tokenizer
* xml
* xmlrpc
* zip
* bcmath
* calendar
* dba
* tidy
* sysvmsg
* sysvsem
* sysvshm
* mongo 
* redis
* memcached
* xdebug

Defined:

* display_errors = "on"
* cgi.fix_pathinfo = 0
* date.timezone = "Etc/UTC"
* SERVER_ENVIRONMENT="development" in /usr/local/etc/php/conf.d/environment.ini

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

To use this image linking with MySQL, you have to have a running MySQL instance, more information about MySQL docker image, please refer to tommylau/mysql. Suppose you have a MySQL instance named mysql5.6_server, we can link it in our php instance with the name mysql like this:

	docker run -d -p 80:80 --name php -v /path/to/web:/var/www/html --link mysql5.6_server:mysql -d liuxinnian/php

Then in the instance, you can use the hostname mysql to connect to the database.

# reference
Mainly reference from Dockerfile: https://hub.docker.com/r/tommylau/php/~/dockerfile/