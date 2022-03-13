#!/bin/bash
set -e
set -o pipefail

# install speedtest cli
wget -O speedtest.pm https://raw.githubusercontent.com/mad-ady/smokeping-speedtest/master/speedtest.pm
wget -O speedtestcli.pm https://raw.githubusercontent.com/mad-ady/smokeping-speedtest/master/speedtestcli.pm

# make smoke ping directories
mkdir -p /home/dlp0mts/smokeping/config
mkdir -p /home/dlp0mts/smokeping/data

cp Targets /home/dlp0mts/smokeping/config
cp Probes /home/dlp0mts/smokeping/config

# start the smokeping container
docker run \
  -d \
  --name=smokeping-speedtest \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -p 80:80 \
  -v /home/dlp0mts/smokeping/config:/config \
  -v /home/dlp0mts/smokeping/data:/data \
  --restart unless-stopped \
  linuxserver/smokeping

docker stop smokeping-speedtest

docker cp speedtest.pm smokeping-speedtest:/usr/share/perl5/vendor_perl/Smokeping/probes
docker cp speedtestcli.pm smokeping-speedtest:/usr/share/perl5/vendor_perl/Smokeping/probes

docker start smokeping-speedtest
docker exec smokeping-speedtest apk add speedtest-cli