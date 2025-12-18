FROM atropim-base:latest

COPY config/cron/daemon-shim.sh /usr/local/bin/php-daemon-shim
RUN chmod +x /usr/local/bin/php-daemon-shim

ENV PHP_PATH=/usr/local/bin/php-daemon-shim

COPY config/cron/crontab /etc/cron.d/atro-cron
RUN chmod 0644 /etc/cron.d/atro-cron && crontab /etc/cron.d/atro-cron

CMD ["/bin/bash", "-c", "printenv | grep -v 'no_proxy' >> /etc/environment && cron -f"]
