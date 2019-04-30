#!/bin/bash

set -e

if [ "${1:0:1}" = '-' ]; then
    set -- gsad "$@"
fi

set -- ${@/\$GVMD_HOST/$GVMD_HOST}
set -- ${@/\$GVMD_PORT/$GVMD_PORT}

if [ "$1" = 'gsad' ]; then
    :
fi

exec "$@"
