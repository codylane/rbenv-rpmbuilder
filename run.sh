#!/bin/bash

CNAME='rpm-rbenv'

CID=$(docker ps -f name=$CNAME -q)

if [ -z "$CID" ]; then
  CID=$(docker ps -f name=$CNAME -f status=exited -q)

  [ -z $CID ] && docker run -dP --name rpm-rbenv rpmbuild-rbenv || docker start $CNAME
fi

PUBLISHED_PORT=$(docker inspect -f '{{(index (index .NetworkSettings.Ports "8080/tcp") 0).HostPort }}' $CNAME)

HOST_INFO=
if [ -n "$DOCKER_HOST" ]; then
  HOST_INFO="${DOCKER_HOST#tcp://}"
  HOST_INFO="${HOST_INFO%:*}"
else
  HOST_INFO=$(hostname -i)
fi

cat > rpm-rbenv.repo <<EOF
[rpm-rbenv]
name='rpm-rbenv helper repo for making installing rubies quicker'
baseurl=http://${HOST_INFO}:8080/
enabled=1
gpgcheck=0
EOF

echo "http://${HOST_INFO}:${PUBLISHED_PORT}"
