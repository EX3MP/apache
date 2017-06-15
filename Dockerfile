FROM php:7.1-apache

ENV APACHE_SERVERNAME localhost
ENV APACHE_SERVERALIAS docker.local
ENV APACHE_SERVERADMIN c@docker.local
ENV APACHE_LOG_DIR /var/log/apache2


# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install git php7-mysql php7-gd php7-imagick php7-twig php7-xdebug \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# php config
COPY php.ini /usr/local/etc/php/
COPY php.ini /etc/php5/apache2/conf.d/
COPY 000-default.conf /etc/apache2/sites-available/

# PDO & mysqli
RUN docker-php-ext-install pdo pdo_mysql mysqli

#Install Composer globally
RUN curl -s -o /usr/local/bin/composer https://getcomposer.org/composer.phar && \
    chmod 0755 /usr/local/bin/composer

#xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug opcache

# Install mcrypt extension
RUN apt-get update && apt-get install -y \
    libmcrypt-dev \
    libssl-dev && \
    docker-php-ext-install mcrypt \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install gd
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libpng12-dev && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install zip extension & mb string exention
RUN docker-php-ext-install zip
RUN docker-php-ext-install mbstring

RUN a2enmod rewrite

# Clean image
RUN apt-get -yqq clean && \
    apt-get -yqq purge && \
    rm -rf /tmp/* /var/tmp/* && \
    rm -rf /var/lib/apt/lists/*


EXPOSE 80

WORKDIR /var/www
