FROM php:8.3-fpm

# 1. Install System Libraries (Now including ImageMagick dev libs)
RUN apt-get update && apt-get install -y \
    git \
    cron \
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
    $PHPIZE_DEPS

# 2. Configure & Install Core PHP Extensions
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

# 3. Install ImageMagick via PECL (Critical for PIM)
RUN pecl install xattr imagick \
    && docker-php-ext-enable xattr imagick

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
