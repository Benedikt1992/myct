#!/bin/bash

# test random read and write operations
VALUE=$( fio --name=random-rw --rw=randrw --size=1m --directory=/tmp/ --output-format=normal --runtime=9 --time_based | sed -En 's/.*avg=([0-9]+).*/\1/p' | tail -n 1)
rm -f /tmp/random-rw*

printf "%s,%s\n" "$(date +%s)" "$VALUE" # IOPS
