
FROM alpine:3.19

RUN apk update && apk add --no-cache \
    nginx \
    openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/CN=${DOMAIN_NAME:-localhost}"

COPY conf/nginx.conf ./temp/nginx.conf

RUN envsubst '$DOMAIN' </temp/nginx.conf > /etc/nginx/sites-available.default

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]