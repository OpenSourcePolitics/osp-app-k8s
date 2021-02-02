#!/bin/sh

curl -i -s 0.0.0.0:3000 > /dev/null
PUMA_STATUS=$?

set -e

if [ $PUMA_STATUS -eq 0 ]; then
    printf "Running"
    exit 0
else
    printf "Not running";
    exit 1
fi
