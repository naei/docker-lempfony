FROM ubuntu:16.04
MAINTAINER Lucas Pantanella

# A default MySQL root password can be set at build
# Otherwise, the "development" password will be used
ARG mysql_root_pwd=development

ENV DEBIAN_FRONTEND noninteractive

RUN \
# Base install
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y wget curl vim nano && \
# Install Nginx
  apt-get install -y nginx && \
  usermod -u 1000 www-data && \
# Install PHP 7.0
  apt-get install -y php7.0-fpm php7.0-cli php7.0-intl php7.0-xml php7.0-mysql && \
  sed -i \
    -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" \
    -e "s/;date.timezone.*$/date.timezone = \"UTC\"/" \
    /etc/php/7.0/fpm/php.ini && \
  sed -i "s/;date.timezone.*$/date.timezone = \"UTC\"/" /etc/php/7.0/cli/php.ini && \
  echo "<?php phpinfo(); ?>" > /var/www/index.php && \
# Install Symfony
  curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && \
  chmod a+x /usr/local/bin/symfony && \
# Install Composer
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
# Install MySQL
  apt-get install -y mysql-server && \
  service mysql start && mysqladmin -u root password $mysql_root_pwd && \
# Install PHPMyAdmin
  apt-get install -y phpmyadmin && \
# Clean system
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Default vhost config for Nginx and PHP
ADD default-vhost.conf /etc/nginx/sites-available/default

# Container default directory
WORKDIR /var/www

# Ports to listen to
EXPOSE 80

# Start services at startup
CMD \
  service mysql start && \
  service php7.0-fpm start && \
  nginx && \
  bash