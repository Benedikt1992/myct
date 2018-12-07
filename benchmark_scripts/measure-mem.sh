#!/bin/bash
EXECUTABLE="memsweep"
if [ ! -e $EXECUTABLE ] ; then
	echo "Compiling memsweep.c"
	cc -O -o memsweep memsweep.c -lm
fi
ROUNDS=4
VALUES=()

for i in $(seq 1 $ROUNDS); do
    if [ "$SYSTEMROOT" = "C:\Windows" ] ; then
        VALUES+=($(./memsweep.exe | cut -d " " -f 5))
    else
        VALUES+=($(./memsweep | cut -d " " -f 5))
    fi
done

#sort array of results
IFS=$'\n' SORTED_V=($(sort <<<"${VALUES[*]}"))
unset IFS

#print median
nel=${#SORTED_V[@]}
if (( $nel % 2 == 1 )); then     # Odd number of elements
    val="${SORTED_V[ $(($nel/2)) ]}"
    printf "%s,%s\n" "$(date +%s)" "$val" # seconds
else                            # Even number of elements
    j=$nel/2
    k=$j-1
    printf "%s,%s\n" "$(date +%s)" "$(awk '{printf("%.2f",($1+$2)/2)}' <<<"${SORTED_V[$j]} ${SORTED_V[$k]}")" # seconds
fi
