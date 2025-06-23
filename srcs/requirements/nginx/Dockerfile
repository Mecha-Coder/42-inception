
FROM alpine:3.19

RUN apk update && apk add --no-cache \
    nginx \
    openssl

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout ${SSL_PRIVATE_KEY} \
    -out ${SSL_PUBLIC_CERT} \
    -subj "/CN=${DOMAIN_NAME:-localhost}"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]