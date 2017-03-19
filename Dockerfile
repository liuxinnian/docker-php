FROM php:5-apache

# Mainly reference from below Dockerfile
# https://hub.docker.com/r/tommylau/php/~/dockerfile/

MAINTAINER Xinnian Liu <liuxinnian@palmax.com>

# Fix docker-php-ext-install script error
RUN sed -i 's/docker-php-\(ext-$ext.ini\)/\1/' /usr/local/bin/docker-php-ext-install

# Install Tools
RUN apt-get update && apt-get install -y \
		libtool \
		automake \
		unzip \
		vim \
		apt-utils \
		git \
		curl \
		g++ \
		wget

# Install Libs
RUN apt-get update && apt-get install -y \		
		libpq-dev \
		libmemcached-dev \
		libmcrypt-dev \
		libfreetype6 \
		libjpeg62-turbo \
		libjpeg62-turbo-dev \
		libpng12-dev \
		libpng12-0 \
		libsqlite3-dev \
		libjpeg-dev \
		libmcrypt4 \
		libpng3 \
		libpng++-dev \
		libgd-dev \
&& docker-php-ext-install pdo \
&& docker-php-ext-install pdo_mysql \
&& docker-php-ext-install pdo_pgsql \
&& docker-php-ext-install pgsql \
&& docker-php-ext-install mcrypt \
&& docker-php-ext-install mysql \
&& docker-php-ext-install mysqli \
&& docker-php-ext-install pdo_sqlite \
&& docker-php-ext-configure gd \
	--enable-gd-native-ttf \
	--with-jpeg-dir=/usr/lib/x86_64-linux-gnu \
	--with-png-dir=/usr/lib/x86_64-linux-gnu \
	--with-freetype-dir=/usr/lib/x86_64-linux-gnu \
&& docker-php-ext-install gd

# Install PECL
RUN pecl install -o -f mongodb-1.2.6 redis-2.2.8 memcached-2.2.0 inotify-0.1.6
RUN docker-php-ext-enable mongodb redis memcached inotify

# Install Maxmind GEOIP lib
RUN git clone --recursive https://github.com/maxmind/libmaxminddb \
    && ( \
        cd libmaxminddb \
        && ./bootstrap \
        && ./configure  \
        && make install \
        && ldconfig \
    ) \
    && rm -r libmaxminddb

# Install Maxmind GEOIP Database
RUN rm -rf /usr/local/share/GeoIP/
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz \
    && gunzip -f GeoLite2-Country.mmdb.gz \
    && ( \
        mkdir -p /usr/local/share/GeoIP/ \
        && cp -f GeoLite2-Country.mmdb /usr/local/share/GeoIP/ \
    ) \
    && rm -r GeoLite2-Country.mmdb

# Install Maxmind GEOIP Database
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz \
    && gunzip -f GeoLite2-City.mmdb.gz \
    && ( \
        mkdir -p /usr/local/share/GeoIP/ \
        && cp -f GeoLite2-City.mmdb /usr/local/share/GeoIP/ \
    ) \
    && rm -r GeoLite2-City.mmdb

# Install MaxMind-DB-Reader-php
RUN git clone https://github.com/maxmind/MaxMind-DB-Reader-php.git \
    && ( \ 
        cd MaxMind-DB-Reader-php/ext \
        && phpize \
        && ./configure \
        && make \
        && make install \
    ) \
    && rm -r MaxMind-DB-Reader-php \
    && docker-php-ext-enable maxminddb


# Install Composer for Laravel
# RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

# Setup timezone to Etc/UTC
RUN sed 's/^;\(date.timezone.*\)/\1 \"Etc\/UTC\"/' > /usr/local/etc/php/php.ini

RUN sed -i "s/display_errors = Off/display_errors = On/" /usr/local/etc/php/php.ini

# Disable cgi.fix_pathinfo in php.ini
RUN sed -i 's/;\(cgi\.fix_pathinfo=\)1/\10/' /usr/local/etc/php/php.ini

# Cleanup all downloaded packages
RUN apt-get -y autoclean && apt-get -y autoremove && apt-get -y clean && rm -rf /var/lib/apt/lists/* && apt-get update


# Enable necessary modules in Apache 2
RUN a2enmod rewrite

EXPOSE 80

# Create and switch to web directory
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html  

WORKDIR /var/www/html

# Restart Apache after enable
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]  