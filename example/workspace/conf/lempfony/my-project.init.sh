#!/bin/bash

## setup my-project
cd /var/www/my-project && \
# clear cache
app/console cache:clear && \
composer clear-cache && \
# fix permissions on cache and logs folders
HTTPDUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1` && \
mkdir -p app/cache app/logs && \
setfacl -R -m u:$HTTPDUSER:rwX -m u:`whoami`:rwX app/cache app/logs && \
setfacl -dR -m u:$HTTPDUSER:rwX -m u:`whoami`:rwX app/cache app/logs