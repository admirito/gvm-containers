#!/bin/bash

set -e

if [ "${1:0:1}" = '-' ]; then
    set -- ospd-openvas "$@"
fi

if [ "$1" = 'ospd-openvas' ]; then
    chmod -R 777 /var/run/redis/

    rm -f /var/run/ospd.pid

    if [ -z "${SKIP_WAIT_REDIS}" ]; then
	echo "waiting for the reids..."
	while [ ! -e /var/run/redis/redis.sock ]; do
	    sleep 1;
	done
    fi
fi

exec "$@"
