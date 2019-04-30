#!/bin/bash

set -e

if [ "${1:0:1}" = '-' ]; then
    set -- openvassd "$@"
fi

if [ "$1" = 'openvassd' ]; then
    chmod -R 777 /var/run/redis/

    if [ -z "${SKIP_WAIT_REDIS}" ]; then
	echo "waiting for the reids..."
	while [ ! -e /var/run/redis/redis.sock ]; do
	    sleep 1;
	done
    fi
fi

exec "$@"
