FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean

COPY ./conf/my.cnf /etc/mysql/my.cnf
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
COPY ./install.sh .

CMD ["/bin/sh", "./install.sh"]