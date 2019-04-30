#!/bin/bash

set -e

if [ "${1:0:1}" = '-' ]; then
	set -- gvmd "$@"
fi

if [ "$1" = 'gvmd' ]; then
    . /etc/default/gvmd

    cat >"/foo" <<-EOF
	Config.System.Log.type=file
	Config.System.Log.verbosity=3
	Config.System.Log=/dev/stdout
	EOF
fi

exec "$@"
