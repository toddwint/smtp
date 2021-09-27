#!/usr/bin/env bash
source config.txt
cp template/webadmin.html.template webadmin.html
sed -i "s/IPADDR/$IPADDR:$HTTPPORT/g" webadmin.html
docker run -dit --rm \
    --name smtp \
    -h $HOSTNAME \
    -p $IPADDR:25:25 \
    -p $IPADDR:$HTTPPORT:$HTTPPORT \
    -v smtp:/var/mail \
    -e TZ=$TZ \
    -e HTTPPORT=$HTTPPORT \
    -e HOSTNAME=$HOSTNAME \
    -e DOMAINNAME=$DOMAINNAME \
    --cap-add=NET_ADMIN \
    toddwint/smtp
