#!/bin/bash

# The time measured by the script includes the startup time of curl and network latency.
# Since all tests run on the same host and only on virtual networks this shouldn't compromise comparability.

host_port=$1

VALUES=()
VALUES+=($((time curl http://$host_port/file.dat &>/dev/null) 2>&1 | grep real | cut -f 2 | awk '{gsub(",", ".", $0); split($0, a, "m|s"); printf("%.3f\n", a[1]*60+a[2])}' &))
VALUES+=($((time curl http://$host_port/file.dat &>/dev/null) 2>&1 | grep real | cut -f 2 | awk '{gsub(",", ".", $0); split($0, a, "m|s"); printf("%.3f\n", a[1]*60+a[2])}' &))
# VALUES+=(echo 1 &)
# VALUES+=(echo 2 &)

wait
printf '%s\n' "${VALUES[@]}"




# EXECUTABLE="memsweep"
# if [ ! -e $EXECUTABLE ] ; then
# 	echo "Compiling memsweep.c"
# 	cc -O -o memsweep memsweep.c -lm
# fi
# ROUNDS=4
# VALUES=()

# for i in $(seq 1 $ROUNDS); do
#     if [ "$SYSTEMROOT" = "C:\Windows" ] ; then
#         VALUES+=($(./memsweep.exe | cut -d " " -f 5))
#     else
#         VALUES+=($(./memsweep | cut -d " " -f 5))
#     fi
# done

# #sort array of results
# IFS=$'\n' SORTED_V=($(sort <<<"${VALUES[*]}"))
# unset IFS

# #print median
# nel=${#SORTED_V[@]}
# if (( $nel % 2 == 1 )); then     # Odd number of elements
#     val="${SORTED_V[ $(($nel/2)) ]}"
#     printf "%s,%s\n" "$(date +%s)" "$val" # seconds
# else                            # Even number of elements
#     j=$nel/2
#     k=$j-1
#     printf "%s,%s\n" "$(date +%s)" "$(awk '{printf("%.2f",($1+$2)/2)}' <<<"${SORTED_V[$j]} ${SORTED_V[$k]}")" # seconds
# fi
