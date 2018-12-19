#!/usr/bin/env bash

EXECUTABLE="forksum"
ARGS="0 12000"
if [ ! -e $EXECUTABLE ] ; then
	echo "Compiling forksum.c"
	cc -O -o forksum forksum.c -lm
fi


if [ "$SYSTEMROOT" = "C:\Windows" ] ; then
	result=$(time (./forksum.exe $ARGS >/dev/null 2>&1) 2>&1)
else
	result=$(time (./${EXECUTABLE} $ARGS >/dev/null 2>&1) 2>&1)
fi
result=$(echo ${result} | grep real | cut -f 2 | awk '{gsub(",", ".", $0); split($0, a, "m|s"); printf("%.3f\n", a[1]*60+a[2])}')
printf "%s,%s\n" "$(date +%s)" "$result" #sum

