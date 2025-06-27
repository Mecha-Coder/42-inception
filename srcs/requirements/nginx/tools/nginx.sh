#!/bin/bash

sleep 5;

chown -R www-data:www-data /var/www/html;
chown -R 755 /var/www/html;

if [ ! -f /etc/nginx/ssl/nginx.crt ]; then

  echo "Nginx: setting up ssl ...";

  openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "${SSL_SUBJ}";

  echo "Nginx: ssl is set up!";
fi

echo "Done Nginx setup 👍"
nginx -g "daemon off;"