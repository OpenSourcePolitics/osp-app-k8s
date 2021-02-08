#!/bin/sh

APP_STATUS=$(curl -s 0.0.0.0:3000/app_health_check/all.json | jq ".healthy")

set -e

if [ $APP_STATUS ]; then
    printf "Running"
    exit 0
else
    printf "Not running";
    exit 1
fi
