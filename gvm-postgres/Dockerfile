FROM postgres:14
MAINTAINER Mohammad Razavi <mrazavi64@gmail.com>

RUN set -ex; \
    #### Debian's dpkg does not support zstd compression prior to version 1.21.18
    #### Here we install an older version from Ubuntu focal repositories; albeit it has a patch
    #### that will fix "unknown compression for member 'control.tar.zst', giving up" error.
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 871920D1991BC93C; \
    echo "deb http://archive.ubuntu.com/ubuntu focal main" > /etc/apt/sources.list.d/focal.list; \
    echo "deb http://archive.ubuntu.com/ubuntu focal-updates main" > /etc/apt/sources.list.d/focal-updates.list; \
    apt update; \
    DEBIAN_FRONTEND=noninteractive apt install -y --allow-downgrades --no-install-recommends dpkg=1.19.7ubuntu3.2; \
    rm -f /etc/apt/sources.list.d/focal.list /etc/apt/sources.list.d/focal-updates.list; \
    #### END of installing Ubuntu focal dpkg
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 871920D1991BC93C; \
    echo "deb http://archive.ubuntu.com/ubuntu jammy main" > /etc/apt/sources.list.d/jammy.list; \
    echo "deb http://archive.ubuntu.com/ubuntu jammy-updates main" > /etc/apt/sources.list.d/jammy-updates.list; \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3C453D244AA450E0; \
    echo "deb http://ppa.launchpad.net/mrazavi/gvm/ubuntu jammy main" > /etc/apt/sources.list.d/mrazavi-ubuntu-gvm-jammy.list; \
    apt update; \
    echo en_US.UTF-8 UTF-8 > /etc/locale.gen; \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends libgvm-pg-server22 postgresql-14-gvm; \
    rm -rf /var/lib/apt/lists/*; \
    # Add jit = off according to this thread:
    # https://community.greenbone.net/t/everything-works-but-i-cant-see-any-report/5875/21
    # (The postgresql.conf.sample will be copied to
    # /var/lib/postgresql/data/postgresql.conf by the database initializer)
    printf "\n\n# Added for gvm-postgres\njit = off\n" >> /usr/share/postgresql/postgresql.conf.sample
