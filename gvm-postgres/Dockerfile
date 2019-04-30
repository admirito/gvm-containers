FROM postgres:10
MAINTAINER Mohammad Razavi <mrazavi64@gmail.com>

RUN set -ex; \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3B4FE6ACC0B21F32; \
    echo "deb http://archive.ubuntu.com/ubuntu bionic main" > /etc/apt/sources.list.d/bionic.list; \
    echo "deb http://archive.ubuntu.com/ubuntu bionic-updates main" > /etc/apt/sources.list.d/bionic-updates.list; \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3C453D244AA450E0; \
    echo "deb http://ppa.launchpad.net/mrazavi/gvm/ubuntu bionic main" > /etc/apt/sources.list.d/mrazavi-ubuntu-gvm-bionic.list; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends libgvm-pg-server0; \
    rm -rf /var/lib/apt/lists/*
