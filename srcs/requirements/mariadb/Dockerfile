FROM debian:bullseye

RUN apt update && apt upgrade -y
RUN apt-get install -y \ 
	mariadb-server \
	procps

EXPOSE 3306

RUN mkdir -p /var/run/mysqld 

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./tools/mariadb.sh ./mariadb.sh

RUN chmod +x mariadb.sh

CMD [ "./mariadb.sh" ]