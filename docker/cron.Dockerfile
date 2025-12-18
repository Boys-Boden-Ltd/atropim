FROM atropim-base:latest

COPY config/crontab /etc/cron.d/atrocron
RUN chmod 0644 /etc/cron.d/atrocron && crontab /etc/cron.d/atrocron

CMD ["cron", "-f"]
