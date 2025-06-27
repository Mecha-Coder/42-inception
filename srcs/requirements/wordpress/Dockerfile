FROM debian:bullseye

RUN apt-get update && apt upgrade -y
RUN apt-get -y install \
	php7.4 \
	php-mysql \
	php-fpm \
  php-curl \
  php-xml \
  php-mbstring \
  php-json \
	wget \
  sendmail

EXPOSE 9000

RUN mkdir -p /run/php/
RUN mkdir -p /var/www/html

RUN wget https://wordpress.org/wordpress-6.0.tar.gz -P /var/www/html && \
    cd /var/www/html && \
    tar -xzf wordpress-6.0.tar.gz && \
    mv wordpress/* . && \
    rm -rf wordpress-6.0.tar.gz wordpress

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/wordpress.sh ./wordpress.sh

RUN chmod +x wordpress.sh

CMD [ "./wordpress.sh" ]