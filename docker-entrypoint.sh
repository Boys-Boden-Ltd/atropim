#!/bin/bash
set -e

if [ ! -f "vendor/autoload.php" ]; then
    echo ">> Fresh Install: Starting Setup..."

    if [ ! -d ".git" ]; then
        echo ">> Cloning Skeleton Structure..."
        git clone https://gitlab.atrocore.com/atrocore/skeleton-pim-no-demo.git .
    fi

    echo ">> Running Composer Installation..."

    php composer.phar self-update
    export COMPOSER_PROCESS_TIMEOUT=2000
    php composer.phar update -n

    echo ">> Composer Installation Complete"

    echo ">> Running Application Installation..."

    php composer.phar config repositories.boysandbodencli vcs https://github.com/Boys-Boden-Ltd/atrocore-cli-install
    php composer.phar require atrocore/cli-install dev-main

    echo ">> Application Installation Complete"

else
    echo ">> AtroPIM is already installed. Starting services..."
fi

exec "$@"
