#!/bin/sh

# Find Pid
SIDEKIQ_PID=$(ps aux | grep sidekiq | grep busy | awk '{ print $2 }')

set -e

if [ -z "$SIDEKIQ_PID" ]; then
    printf "Not running";
    exit 1
else
    printf "Running"
    exit 0
fi
