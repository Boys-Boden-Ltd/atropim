FROM atropim-base:latest

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["php-fpm"]
