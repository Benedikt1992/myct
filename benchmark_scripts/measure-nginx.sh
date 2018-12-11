#!/bin/bash

# The time measured by the script includes the startup time of curl and network latency.
# Since all tests run on the same host and only on virtual networks this shouldn't compromise comparability.
THREADS=2


host_port=$1
VALUES=()

for i in $(seq 1 $THREADS); do
    VALUES+=($((time curl http://$host_port/file.dat &>/dev/null) 2>&1 | grep real | cut -f 2 | awk '{gsub(",", ".", $0); split($0, a, "m|s"); printf("%.3f\n", a[1]*60+a[2])}' &))
done
wait

printf '%s\n' "${VALUES[@]}"

#sort array of results
IFS=$'\n' SORTED_V=($(sort <<<"${VALUES[*]}"))
unset IFS

#print median
nel=${#SORTED_V[@]}
if (( $nel % 2 == 1 )); then     # Odd number of elements
    val="${SORTED_V[ $(($nel/2)) ]}"
    printf "%s\n" "$val" # seconds
else                            # Even number of elements
    j=$nel/2
    k=$j-1
    printf "%s\n" "$(awk '{printf("%.3f",($1+$2)/2)}' <<<"${SORTED_V[$j]} ${SORTED_V[$k]}")" # seconds
fi
