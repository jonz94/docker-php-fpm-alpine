FROM php:7.4.7-fpm-alpine3.12

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
        sockets \
    \
    # Install zip
    && apk add --update --no-cache --virtual .zip-runtime-deps libzip-dev \
    && docker-php-ext-install zip \
    \
    # Install imagick
    && apk add --update --no-cache --virtual .imagick-runtime-deps imagemagick \
    && pecl install imagick-3.4.4 \
    && docker-php-ext-enable imagick \
    \
    # Install redis
    && pecl install redis-5.2.2 \
    && docker-php-ext-enable redis \
    \
    # Install ffmpeg
    && apk add --update --no-cache ffmpeg \
    \
    # Clean up
    && apk del .build-deps \
    && rm -fr /tmp/pear
