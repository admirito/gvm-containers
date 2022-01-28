#!/bin/bash

set -e

if [ "${1:0:1}" = '-' ]; then
    set -- gvmd "$@"
fi

if [ "$1" = 'gvmd' ]; then
    gvm-manage-certs -q -a &> /dev/null || true

    # workaround for gsad problem when opening "reports" section
    # https://github.com/admirito/gvm-containers/issues/26
    mkdir -p /var/lib/gvm/gvmd/report_formats || true
    chmod 755 /var/lib/gvm/gvmd/report_formats || true

    if [ -z "${SKIP_WAIT_DB}" ]; then
	echo "waiting for the database..."
	while ! psql -q "${GVMD_POSTGRESQL_URI}" < /dev/null &> /dev/null; do
	    sleep 1;
	done
    fi

    if [ "${FORCE_DB_INIT}" = "1" ] || [ ! -e /var/lib/gvm/.db-init ]; then
	echo "running db initializion script..."
	psql -f/usr/share/dbconfig-common/data/gvmd-pg/install-dbadmin/pgsql "${GVMD_POSTGRESQL_URI}"

	echo "migrating the database..."
	gvmd --migrate

	touch /var/lib/gvm/.db-init
    elif [ "${NO_DB_MIGRATION}" != "1" ]; then
	echo "migrating the database to make sure it is up-to-date..."
	gvmd --migrate || true
    fi

    if [ -n "${GVMD_USER}" ] && ! gvmd --get-users | grep -q "${GVMD_USER}"; then
	echo "creating ${GVMD_USER} user..."
	gvmd --create-user="${GVMD_USER}" --role="${GVMD_USER_ROLE:-Admin}"
	gvmd --user="${GVMD_USER}" --new-password="${GVMD_PASSWORD:-${GVMD_USER}}"
    elif [ -n "${GVMD_PASSWORD}" ]; then
	gvmd --user="${GVMD_USER:-admin}" --new-password="${GVMD_PASSWORD}" || true
    fi

    ADMIN_UUID=$(gvmd --get-users --verbose | grep "^${GVMD_USER:-admin}" | sed "s/${GVMD_USER:-admin}\s*//") || true
    [ -n "$ADMIN_UUID" ] && gvmd --modify-setting 78eceaec-3385-11ea-b237-28d24461215b --value $ADMIN_UUID || true

    echo "setting up msmtp...."
    echo -e "# managed by docker-entrypoint.sh" > /etc/msmtprc
    echo -e "account default" >> /etc/msmtprc
    printenv | grep "^MSMTP_" | while read var; do
      key=$(echo "$var" | cut -f1 -d= | cut -f2- -d_ | sed -e 's/\(.*\)/\L\1/')
      val=$(echo "$var" | cut -f2- -d=)
      echo "$key $val" >> /etc/msmtprc
    done

fi

exec "$@"
