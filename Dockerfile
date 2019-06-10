FROM php:7.3.6-fpm-alpine3.9

LABEL maintainer="jonz94 <jody16888@gmail.com>"

RUN set -x \
    && apk add --update --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        imagemagick-dev \
        libtool \
    \
    && docker-php-ext-install \
        bcmath \
        mysqli \
        opcache \
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
    # Clean up
    && apk del .build-deps
