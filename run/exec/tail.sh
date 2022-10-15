#!/usr/bin/env bash
APPNAME=smtp
source "$(dirname "$(dirname "$(realpath $0)")")"/config.txt
docker exec -it -w /opt/"$APPNAME"/scripts "$HOSTNAME" ./tail.sh
