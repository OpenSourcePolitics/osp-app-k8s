#!/bin/sh

# Find Pid
SIDEKIQ_STATUS=$(curl -s 0.0.0.0:7433/sidekiq_health_check)

set -e

if [ "$SIDEKIQ_STATUS" = "Alive!" ]; then
    printf "Running"
    exit 0
else
    printf "Not running";
    exit 1
fi
