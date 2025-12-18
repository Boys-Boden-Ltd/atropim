#!/bin/bash
set -e

if [ ! -f "vendor/autoload.php" ]; then
    echo ">> FRESH INSTALL: Starting Setup..."

    if [ ! -d ".git" ]; then
        echo ">> Cloning Skeleton Structure..."
        git clone https://gitlab.atrocore.com/atrocore/skeleton-pim-no-demo.git .
    fi

    echo ">> Running Installation..."

    php composer.phar self-update && php composer.phar update

    echo ">> INSTALLATION COMPLETE"
else
    echo ">> AtroPIM is already installed. Starting services..."
fi

exec "$@"
