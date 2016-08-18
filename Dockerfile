FROM ubuntu:16.04
MAINTAINER Lucas Pantanella

# A default MySQL root password can be set at build
# Otherwise, the "development" password will be used
ARG mysql_root_pwd=development

ENV DEBIAN_FRONTEND noninteractive

# Add Symfony project creation script
COPY symfony-create.sh /usr/bin/symfony-create

RUN \
# Base install
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y wget curl vim nano acl && \
# Install Nginx
  apt-get install -y nginx && \
# Install PHP 7.0
  apt-get install -y php7.0-fpm php7.0-cli php7.0-intl php7.0-xml php7.0-mysql php7.0-zip && \
  sed -i \
    -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" \
    -e "s/;date.timezone.*$/date.timezone = \"UTC\"/" \
    /etc/php/7.0/fpm/php.ini && \
  sed -i "s/;date.timezone.*$/date.timezone = \"UTC\"/" /etc/php/7.0/cli/php.ini && \
  echo "<?php phpinfo(); ?>" > /var/www/index.php && \
# Install Symfony
  curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && \
  chmod a+x /usr/local/bin/symfony /usr/bin/symfony-create && \
# Install Composer
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
# Install MySQL
  apt-get install -y mysql-server && \
  usermod -d /var/lib/mysql/ mysql && \
  service mysql start && mysqladmin -u root password $mysql_root_pwd && \
# Install phpMyAdmin
  apt-get install -y phpmyadmin && \
# Move default MySQL & phpMyAdmin databases to a non-shared folder
  service mysql stop && \
  mkdir /var/lib/mysql-db && \
  mv /var/lib/mysql/* /var/lib/mysql-db/ && \
# Clean system
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add default Nginx server block for PHP and phpMyAdmin
COPY site-default /etc/nginx/site-default

# Set default directory
WORKDIR /var/www

# Set ports to listen to
EXPOSE 80

# Actions on container startup
ENTRYPOINT \
  # Restore default MySQL & phpMyAdmin databases into the MySQL host volume
  cp -rn /var/lib/mysql-db/* /var/lib/mysql && \
  # Restore and enable Nginx server blocks
  cp -f /etc/nginx/site-default /etc/nginx/sites-available/default && \
  ln -sf /etc/nginx/sites-available/* /etc/nginx/sites-enabled/ && \
  # Add permissions on host volumes
  chown -R mysql /var/lib/mysql && \
  mkdir -p /var/log/mysql && chown -R mysql /var/log/mysql && \
  chown -R www-data /var/www && \
  mkdir -p /var/log/nginx && chown -R www-data /var/log/nginx && \
  # Start services
  service mysql start && \
  service php7.0-fpm start && \
  service nginx start && \
  # Start bash
  /bin/bash