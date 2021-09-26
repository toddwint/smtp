# toddwint/smtp

## Info

<https://hub.docker.com/r/toddwint/smtp>

<https://github.com/toddwint/smtp>

`smtp` server docker image for simple lab smtp testing.

This image was created for lab setups where the need to verify email messages are being sent.

## Features

- Receive smtp messages from clients.
- View smtp messages in a web browser ([frontail](https://github.com/mthenw/frontail))
    - tail the file
    - pause the flow
    - search through the flow
    - highlight multiple rows
- SMTP messages are persistant if you map the directory `/var/mail`

## Sample `config.txt` file

```
TZ=UTC
IPADDR=127.0.0.1
HTTPPORT=9001
HOSTNAME=mailsrvr
DOMAINNAME=test.lab
```

## Sample docker run command

```
#!/usr/bin/env bash
source config.txt
cp template/webadmin.html.template webadmin.html
sed -i "s/IPADDR/$IPADDR:$HTTPPORT/g" webadmin.html
docker run -dit --rm \
    --name smtp \
    -p $IPADDR:25:25 \
    -p $IPADDR:$HTTPPORT:$HTTPPORT \
    -v smtp:/var/mail \
    -e TZ=$TZ \
    -e HTTPPORT=$HTTPPORT \
    -e HOSTNAME=$HOSTNAME \
    -e DOMAINNAME=$DOMAINNAME \
    --cap-add=NET_ADMIN \
    toddwint/smtp
```

## Sample webadmin.html.template file

See my github page (referenced above).


## Login page

Open the `webadmin.html` file.

Or just type in your browser `http://localhost` or the IP you set in the config.  

## Issues?

Make sure if you set an IP that machine has the same IP configured on an interface.

