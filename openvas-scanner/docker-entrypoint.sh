#!/bin/bash

set -e

export OV_MAX_HOST=${OV_MAX_HOST:-5}
export OV_MAX_CHECKS=${OV_MAX_CHECKS:-4}

cat >/etc/openvas/openvas.conf<<-EOF
max_hosts = ${OV_MAX_HOST}
max_checks = ${OV_MAX_CHECKS}
EOF

if [ "${1:0:1}" = '-' ]; then
    set -- ospd-openvas "$@"
fi

if [ "$1" = 'ospd-openvas' ]; then
    chmod -R 777 /run/redis/

    rm -f /run/ospd.pid
    mkdir -p /run/ospd

    if [ -z "${SKIP_WAIT_REDIS}" ]; then
	echo "waiting for the redis..."
	while [ ! -e /run/redis/redis.sock ]; do
	    sleep 1;
	done
    fi
fi

exec "$@"
