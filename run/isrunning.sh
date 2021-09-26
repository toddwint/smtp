#!/usr/bin/env bash
running=$(docker ps | grep smtp | wc -l)
if [ $running -eq 1 ]
then
    echo "Yes. It is running. Look:  "
    docker ps | grep smtp
else
    echo "He's dead Jim."
fi
