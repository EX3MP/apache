FROM php:5.6-apache

ENV AP_SERVERNAME localhost
ENV AP_SERVERALIAS docker.local
ENV AP_SERVERADMIN c@docker.local


# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install php5-mysql php5-gd php5-twig php5-xdebug

# Install selected extensions and other stuff
RUN apt-get -y --no-install-recommends install git

# php config
COPY php.ini /usr/local/etc/php/
COPY php.ini /etc/php5/apache2/conf.d/

# PDO & mysqli
RUN docker-php-ext-install pdo pdo_mysql mysqli

#Install Composer globally
RUN curl -s -o /usr/local/bin/composer https://getcomposer.org/composer.phar && \
    chmod 0755 /usr/local/bin/composer

#xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Install mcrypt extension
RUN apt-get install -y \
    libmcrypt-dev \
    libssl-dev && \
    docker-php-ext-install mcrypt;

# Install gd
RUN apt-get install -y \
    libfreetype6-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libpng12-dev && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd

# Install zip extension & mb string exention
RUN docker-php-ext-install zip
RUN docker-php-ext-install mbstring

ADD 001-docker.conf /etc/apache2/sites-available/
RUN ln -s /etc/apache2/sites-available/001-docker.conf /etc/apache2/sites-enabled/

RUN a2enmod rewrite

# Clean image
RUN apt-get -yqq clean && \
    apt-get -yqq purge && \
    rm -rf /tmp/* /var/tmp/* /usr/share/doc/* && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 80

WORKDIR /var/www