FROM debian:bullseye

RUN apt-get update
RUN apt-get install gnupg ca-certificates apt-transport-https software-properties-common wget curl lsb-release -y
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
RUN apt-get update
RUN apt-get install -y \
    php8.1-cli \
    php8.1-fpm \
    php8.1-mysqli \
    php8.1-common \
    php8.1-xml \
    php8.1-curl \
    php8.1-mbstring \
    php8.1-zip
RUN apt install -y mariadb-client musl

EXPOSE 9000

COPY ./conf/www.conf /etc/php/8.1/fpm/pool.d
COPY ./tools /var/www/

RUN chmod +x /var/www/wordpress_start.sh

ENTRYPOINT [ "/var/www/wordpress_start.sh" ]

CMD ["/usr/sbin/php-fpm8.1", "-F"]
