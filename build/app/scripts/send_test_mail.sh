#!/usr/bin/env bash
set -x
echo "Subject: test mail message" | sendmail -v test@"$DOMAINNAME"
