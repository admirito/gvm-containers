FROM ubuntu:23.04
MAINTAINER kShuttle <contact@kshuttle.io>

RUN set -ex; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
              gnupg ospd-openvas openvas-scanner; \
    sed -i 's|/var/log/gvm/openvas.log|/dev/stdout|g' /etc/openvas/openvas_log.conf; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /tmp/*


# Add Tini
ARG TINI_VERSION="v0.19.0"
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

VOLUME /var/lib/openvas \
       /run/redis

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/tini", "--", "bash", "/usr/local/bin/docker-entrypoint.sh" ]

CMD ["ospd-openvas", "-l/dev/stdout", "-LINFO", "-f"]
