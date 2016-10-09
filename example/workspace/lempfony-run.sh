#!/bin/bash

PORT=80
CURR_DIR=$( cd $( dirname $0 ) && pwd )

if (( $# > 0 )); then
    if ( (( $# == 2 )) && ([ $1 == "-p" ] || [ $1 == "--port" ])); then
        if ([[ $2 =~ ^-?[0-9]+$ ]] && (( $2 >= 0 && $2 <= 65535 ))); then
            PORT=$2
        else
            echo "Error: Invalid port."
            exit 1
        fi
    else
        echo "Error: Invalid argument - Only -p (--port) <PORT> is allowed."
        exit 1
    fi
fi

docker run -it --rm --name lempfony -p ${PORT}:80 \
-v ${CURR_DIR}/conf/lempfony:/opt/lempfony/volume \
-v ${CURR_DIR}/conf/nginx-sites:/etc/nginx/sites-available \
-v ${CURR_DIR}/log:/var/log \
-v ${CURR_DIR}/mysql:/var/lib/mysql \
-v ${CURR_DIR}/www:/var/www \
naei/lempfony:latest
