#!/bin/bash
set -e

APP=$1
VERSION=$2

ROOT="/var/www/$APP"
SERVER_BLOCK="/etc/nginx/sites-available/$APP"

if [[  -z "$APP" || "$APP" =~ [^a-zA-Z0-9-] ]]; then
  echo "Invalid project name. Only alphanumerics and hyphens characters are allowed."
  exit 1
else 
  if [ -d "$ROOT" ]; then
    echo "The project $APP already exist."
    exit 1
  fi
fi

# Create Symfony app
cd /var/www
symfony new $APP $VERSION

# Update dependencies 
cd $APP
composer update

# Fix access issues
apt-get update && apt-get install -y acl
HTTPDUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
mkdir -p $ROOT/app/cache $ROOT/app/logs
(
setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX $ROOT/app/cache $ROOT/app/logs
setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX $ROOT/app/cache $ROOT/app/logs
) || true

sed -i '/if (isset($_SERVER/,+6 s/^/\/\//' $ROOT/web/app_dev.php
sed -i '/if (!in_array(@$_SERVER/,+6 s/^/\/\//' $ROOT/web/config.php

# Create Nginx server block file
cat > $SERVER_BLOCK <<- _EOF
server {
  listen 80;
  listen [::]:80;

  server_name $APP.dev;

  root $ROOT/web;

  location / {
      try_files \$uri /app_dev.php\$is_args\$args;
  }

  location ~ ^/(app_dev|config)\.php(/|$) {
      fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
      fastcgi_split_path_info ^(.+\.php)(/.*)$;
      include fastcgi_params;
      fastcgi_param  SCRIPT_FILENAME  \$realpath_root\$fastcgi_script_name;
      fastcgi_param DOCUMENT_ROOT \$realpath_root;
  }

  error_log /var/log/nginx/$APP.log;
  access_log /var/log/nginx/$APP.log;
}
_EOF

# Enable the new server block configuration
ln -s $SERVER_BLOCK /etc/nginx/sites-enabled/
nginx -t && service nginx reload


echo ">>>>> Your Symfony app is now available at http://$APP.dev !"
