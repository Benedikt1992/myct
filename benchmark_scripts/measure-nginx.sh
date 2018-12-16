#!/bin/bash

# The time measured by the script includes the startup time of curl and network latency.
# Since all tests run on the same host and only on virtual networks this shouldn't compromise comparability.
THREADS=2
host_port=${1:-localhost:8080}
pipe=/tmp/measure-nginx-pipe

if [[ -e $pipe ]]; then
    rm -f $pipe
fi
trap "rm -f $pipe" EXIT
mkfifo $pipe

function foo() {
    time_output=$( (time curl http://${host_port}/file.dat >/dev/null 2>/dev/null) 2>&1 )
    echo ${time_output} | grep real | cut -f 2 | awk '{gsub(",", ".", $0); split($0, a, "m|s"); printf("%.3f\n", a[1]*60+a[2])}' > $pipe
}

for i in $(seq 1 $THREADS); do
    foo &
done

# keep pipe open for reads as file descriptor fd3
exec 3< $pipe
values=()
while true; do
    if read line <&3; then
        values+=($line)
        if [[ ${#values[@]} -eq $THREADS ]]; then
            break
        fi
    fi
done
exec 3<&-

# sort array of results
IFS=$'\n' SORTED_V=($(sort -g <<<"${values[*]}"))
unset IFS

#print median
nel=${#SORTED_V[@]}
if (( $nel % 2 == 1 )); then     # Odd number of elements
    val="${SORTED_V[ $(($nel/2)) ]}"
    printf "%s,%s\n" "$(date +%s)" "$val" # seconds
else                            # Even number of elements
    j=$nel/2
    k=$j-1
    printf "%s,%s\n" "$(date +%s)" "$(awk '{printf("%.3f",($1+$2)/2)}' <<<"${SORTED_V[$j]} ${SORTED_V[$k]}")" # seconds
fi

exit 0
