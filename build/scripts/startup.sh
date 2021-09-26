#!/usr/bin/env bash

## Run the commands to make it all work
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

echo $HOSTNAME > /etc/hostname
postconf -e "mydomain = $DOMAINNAME"
postconf -e "myhostname = $HOSTNAME"
postconf -e 'mydestination = $myhostname, $myhostname.$mydomain, localhost.$mydomain, localhost, $mydomain'
postconf -e "mynetworks = 0.0.0.0/0 [::]"
echo "@$DOMAINNAME root" > /etc/postfix/virtual
postmap /etc/postfix/virtual
postconf -e "virtual_alias_maps = hash:/etc/postfix/virtual"

service postfix stop
service postfix start
service postfix status

frontail -d -p $HTTPPORT /var/mail/root

# Keep docker running
bash
