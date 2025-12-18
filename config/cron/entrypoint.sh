#!/bin/bash
set -e

printenv | grep -v "no_proxy" >> /etc/environment

if [ -d "/var/www/html/data" ]; then
    echo ">> Fixing directory permissions..."
    chown -R www-data:www-data /var/www/html/data /var/www/html/public /var/www/html/upload 2>/dev/null || true
fi

exec cron -f
