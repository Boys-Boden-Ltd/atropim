FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    cron \
    git \
    procps \
    postgresql-client \
    zip \
    unzip \
    build-essential \
    locales \
    libcurl4 \
    libcurl4-openssl-dev \
    libsodium-dev \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev \
    libavif-dev \
    libattr1-dev \
    libonig-dev \
    libzip-dev \
    zlib1g-dev \
    libmagickwand-dev \
    libldap2-dev \
    libldap-common \
    $PHPIZE_DEPS \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        mbstring \
        curl \
        xml \
        ftp \
        ldap \
        pdo \
        pdo_pgsql \
        gd \
        zip \
        intl \
        opcache \
        exif

RUN pecl install xattr imagick \
    && docker-php-ext-enable xattr imagick

WORKDIR /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
