FROM ubuntu:bionic
MAINTAINER Mohammad Razavi <mrazavi64@gmail.com>

RUN set -ex; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends gnupg; \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3C453D244AA450E0; \
    echo "deb http://ppa.launchpad.net/mrazavi/gvm/ubuntu bionic main" > /etc/apt/sources.list.d/mrazavi-ubuntu-gvm-bionic.list; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends ospd-openvas openvas python3-pkg-resources rsync wget openvas-smb nmap; \
    sed -i 's|/var/log/gvm/openvas.log|/dev/stdout|g' /etc/openvas/openvas_log.conf; \
    sed -i 's/if \[ "`id -u`" -eq "0" \]/if fasle \&\& [ "`id -u`" -eq "0" ]/' /usr/bin/greenbone-nvt-sync; \
    rm -rf /var/lib/apt/lists/*

VOLUME /var/lib/openvas \
       /var/run/redis

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["ospd-openvas", "-l/dev/stdout", "-f"]
