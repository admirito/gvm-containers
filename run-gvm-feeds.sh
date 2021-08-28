#!/bin/bash

set -ex

if docker ps --format '{{ .Names }}' | grep -q gvm-feeds; then
    docker stop -t2 gvm-feeds
fi
if docker ps -a --format '{{ .Names }}' | grep -q gvm-feeds; then
    docker rm -fv gvm-feeds
fi

docker run -d --name=gvm-feeds -p 1873:873 dakar.soc1.ir/gvm-feeds:funu

# FEEDSIP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' gvm-feeds)
HOSTIP=172.17.0.1

set +x

echo
echo Now run:
echo
echo docker-compose -fgvmd-data-sync.yml run -eCOMMUNITY_GVMD_DATA_RSYNC_FEED=rsync://$HOSTIP:1873/data-objects/gvmd/ gvmd-data-sync "&&" \
     docker-compose -fnvt-sync.yml run -eCOMMUNITY_NVT_RSYNC_FEED=rsync://$HOSTIP:1873/nvt-feed nvt-sync "&&" \
     docker-compose -fcert-sync.yml run -eCOMMUNITY_CERT_RSYNC_FEED=rsync://$HOSTIP:1873/cert-data cert-sync "&&" \
     docker-compose -fscap-sync.yml run -eCOMMUNITY_SCAP_RSYNC_FEED=rsync://$HOSTIP:1873/scap-data scap-sync
echo docker-compose up
