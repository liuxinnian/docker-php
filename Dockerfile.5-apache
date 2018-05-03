FROM php:5-apache

MAINTAINER Xinnian Liu <liuxinnian@palmax.com>

# Fix docker-php-ext-install script error
RUN sed -i 's/docker-php-\(ext-$ext.ini\)/\1/' /usr/local/bin/docker-php-ext-install

#Tools
RUN apt-get update && apt-get install -y \
		libtool \
		automake \
		apt-utils \
        g++ \
		curl \
		wget \
        git \
        unzip
		
#Devel
RUN apt-get update && apt-get install -y \		
		libpq-dev \
        libsqlite3-dev \
        libmemcached-dev \
        libzip-dev

RUN docker-php-ext-install pdo_mysql pdo_pgsql pgsql pdo_sqlite zip

#GD and mcrypt
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

#PECL
RUN pecl install -o -f redis-2.2.8 && docker-php-ext-enable redis
RUN pecl install -o -f memcached-2.2.0 && docker-php-ext-enable memcached

#Maxmind GEOIP
RUN git clone --recursive https://github.com/maxmind/libmaxminddb \
    && ( \
        cd libmaxminddb \
        && ./bootstrap \
        && ./configure  \
        && make install \
        && ldconfig \
    ) \
    && rm -rf libmaxminddb

#Maxmind GEOIP Database
RUN rm -rf /usr/local/share/GeoIP/
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz \
    && gunzip -f GeoLite2-Country.mmdb.gz \
    && ( \
        mkdir -p /usr/local/share/GeoIP/ \
        && cp -f GeoLite2-Country.mmdb /usr/local/share/GeoIP/ \
    ) \
    && rm -rf GeoLite2-Country.mmdb

#Maxmind GEOIP Database
RUN wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz \
    && gunzip -f GeoLite2-City.mmdb.gz \
    && ( \
        mkdir -p /usr/local/share/GeoIP/ \
        && cp -f GeoLite2-City.mmdb /usr/local/share/GeoIP/ \
    ) \
    && rm -rf GeoLite2-City.mmdb

#MaxMind-DB-Reader-php
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

#Composer
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin/ --filename=composer 

# php.ini
RUN sed 's/^;\(date.timezone.*\)/\1 \"Etc\/UTC\"/' > /usr/local/etc/php/php.ini
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