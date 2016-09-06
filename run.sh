#!/bin/sh
set -e
set -x

if [[ ! -f $DEVPI_SERVERDIR/.serverversion ]]; then
    devpi-server --restrict-modify root --start --host 127.0.0.1 --port 3141
    devpi use http://localhost:3141
    devpi login root --password=''
    devpi user -m root password="${DEVPI_PASSWORD}"
    devpi index -y -c public pypi_whitelist='*'
    if [[ -x /custom_init.sh ]]; then
        /custom_init.sh
    fi
    devpi-server --stop
fi

exec devpi-server --restrict-modify root --host 0.0.0.0 --port 3141
