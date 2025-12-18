#!/bin/bash
set -e

if [ ! -f "vendor/autoload.php" ]; then
    echo "----------------------------------------------------------------"
    echo ">> FRESH INSTALL: Starting Setup..."
    echo "----------------------------------------------------------------"

    # 1. Clone Skeleton Structure
    if [ ! -d ".git" ]; then
        echo ">> Cloning Skeleton Structure..."
        git clone https://gitlab.atrocore.com/atrocore/skeleton-pim-no-demo.git .
    fi

    echo "----------------------------------------------------------------"
    echo ">> Configuring Git & Composer..."
    echo "----------------------------------------------------------------"

    # 4. Remove Stale Lock & Vendor
    rm -rf composer.lock vendor/

    #composer config repositories.atrocore composer https://packagist.atrocore.com/packages.json?id=common

    echo "----------------------------------------------------------------"
    echo ">> Running Installation..."
    echo "----------------------------------------------------------------"

    # 5. Run Update
    # We use --prefer-dist to try and get Zips first, but if it falls back to git,
    # our config above will handle it.
    php composer.phar self-update && php composer.phar update
    #composer self-update && composer update

    # 6. Permissions
    chown -R www-data:www-data .
    chmod -R 775 data custom client

    echo ">> INSTALLATION COMPLETE"
else
    echo ">> AtroPIM is already installed. Starting services..."
fi

exec "$@"
