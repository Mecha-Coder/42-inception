FROM debian:bullseye

RUN apt-get update && apt upgrade -y
RUN apt-get install -y \
    nginx \
    openssl

EXPOSE 443

RUN mkdir -p /etc/nginx/ssl
RUN mkdir -p /run/nginx

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./tools/nginx.sh ./nginx.sh

RUN chmod +x nginx.sh

CMD [ "./nginx.sh" ]
