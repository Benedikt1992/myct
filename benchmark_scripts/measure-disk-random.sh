#!/bin/bash

# test random read and write operations
VALUE=$( fio --name=random-rw --rw=randrw --size=1m --directory=/tmp/ --output-format=normal --runtime=18 --time_based | sed -En 's/.*IOPS=([0-9.]+).*/\1/p' | awk '{sum+=$1} END {print sum}')
rm -f /tmp/random-rw*

printf "%s,%s\n" "$(date +%s)" "$VALUE" # IOPS
