#!/bin/bash

# test random read and write operations
VALUE=$( fio --name=random-rw --rw=randrw --size=1m --directory=/tmp/ --output-format=normal --runtime=9 --time_based )
fioVersion=$(fio --version)

if [[ ${fioVersion} == "fio-2.16" ]]; then
	echo "old fio: ${fioVersion}, falling back to old fio output parser" >&2
	VALUE=$( echo ${VALUE} | sed -En 's/.*iops=([0-9]+).*/\1/p' | tail -n 1 )
else
	VALUE=$( echo ${VALUE} | sed -En 's/.*avg=([0-9]+).*/\1/p' | tail -n 1 )
fi
rm -f /tmp/random-rw*

printf "%s,%s\n" "$(date +%s)" "$VALUE" # IOPS
