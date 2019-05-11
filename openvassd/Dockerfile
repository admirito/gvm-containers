FROM ubuntu:bionic
MAINTAINER Mohammad Razavi <mrazavi64@gmail.com>

RUN set -ex; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends gnupg; \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3C453D244AA450E0; \
    echo "deb http://ppa.launchpad.net/mrazavi/gvm/ubuntu bionic main" > /etc/apt/sources.list.d/mrazavi-ubuntu-gvm-bionic.list; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends openvas-scanner rsync wget openvas-smb; \
    sed -i 's|/var/log/gvm/openvassd.log|/dev/stdout|g' /etc/openvas/openvassd_log.conf; \
    rm -rf /var/lib/apt/lists/*

VOLUME /var/lib/openvas \
       /var/run/redis

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["openvassd", "-f"]
