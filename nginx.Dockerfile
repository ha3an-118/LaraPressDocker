FROM ubuntu:latest


RUN apt-get update && apt-get install -y locales  \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ENV DEBIAN_FRONTEND noninteractive


RUN echo "nameserver 185.51.200.2" > /etc/resolve.conf
RUN echo "nameserver 178.22.122.100" >> /etc/resolve.conf


RUN apt-get -y update && apt-get -y install  ca-certificates apt-transport-https software-properties-common \
&& add-apt-repository -y ppa:ondrej/php
RUN  apt-get -y update && apt-get -y install  nginx  php8.0  php-cli php-fpm \
        php-json php8.0-common php-mysql php-zip php-gd php-mbstring php-curl \
        php-xml php-pear php-bcmath curl perl pwgen openssl  unzip curl perl \
        pwgen openssl xz-utils  mysql-client

#install composer

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer

#install npm 

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

# git php debug tools unzip vim nodejs

RUN apt-get -y update && apt-get install -y  nodejs  vim php-xdebug unzip git

# Clean installation app
RUN apt-get clean


EXPOSE 80
EXPOSE 443
EXPOSE 900

COPY ./Docker/Shell/develop.nginx.sh /bin/app
RUN chmod +x /bin/app
