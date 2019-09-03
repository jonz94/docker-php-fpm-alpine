FROM php:7.3.8-fpm-alpine3.10

LABEL maintainer="jonz94 <jody16888@gmail.com>"

RUN set -ex \
    && apk add --update --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        imagemagick-dev \
        libmemcached-dev \
        libtool \
        zlib-dev \
    \
    && docker-php-ext-install \
        bcmath \
        mysqli \
        opcache \
        pcntl \
        pdo_mysql \
    \
    # Install zip
    && apk add --update --no-cache --virtual .zip-runtime-deps libzip-dev \
    && docker-php-ext-configure zip --with-libzip=/usr/include \
    && docker-php-ext-install zip \
    \
    # Install imagick
    && apk add --update --no-cache --virtual .imagick-runtime-deps imagemagick \
    && pecl install imagick-3.4.4 \
    && docker-php-ext-enable imagick \
    \
    # Install memcached
    && apk add --update --no-cache --virtual .memcached-runtime-deps libmemcached-libs zlib \
    && pecl install memcached-3.1.3 \
    && docker-php-ext-enable memcached \
    # Install redis
    && pecl install redis-5.0.2 \
    && docker-php-ext-enable redis \
    # Clean up
    && apk del .build-deps
