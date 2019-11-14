FROM ubuntu:bionic
MAINTAINER Mohammad Razavi <mrazavi64@gmail.com>

RUN set -ex; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends gnupg; \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3C453D244AA450E0; \
    echo "deb http://ppa.launchpad.net/mrazavi/gvm/ubuntu bionic main" > /etc/apt/sources.list.d/mrazavi-ubuntu-gvm-bionic.list; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends gvmd-pg postgresql-client texlive-latex-base xsltproc gnutls-bin xmlstarlet zip python3 python3-lxml smbclient snmp gnupg openssh-client sshpass socat haveged rsync wget; \
    sed -i 's|/var/log/gvm/gvmd.log|/dev/stdout|g' /etc/gvm/gvmd_log.conf; \
    cd /; \
    apt download openvas; \
    dpkg --fsys-tarfile openvas_*.deb | tar xf - ./usr/bin/greenbone-nvt-sync; \
    sed -i 's/if \[ "`id -u`" -eq "0" \]/if fasle \&\& [ "`id -u`" -eq "0" ]/' /usr/bin/greenbone-nvt-sync; \
    rm -rf ./openvas_*.deb; \
    rm -rf /var/lib/apt/lists/*

ENV GVMD_POSTGRESQL_URI="postgresql://gvmduser:password@postgres:5432/gvmd?application_name=gvmd" \
    GVMD_USER=admin

VOLUME /var/lib/gvm/

EXPOSE 9390

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["gvmd", "-f", "--listen=0.0.0.0", "--port=9390"]
