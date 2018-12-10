#!/usr/bin/env bash 

EXECUTABLE="forksum"
if [ ! -e $EXECUTABLE ] ; then
	echo "Compiling forksum.c"
	cc -O -o forksum forksum.c -lm
fi


if [ "$SYSTEMROOT" = "C:\Windows" ] ; then
	result=$(./forksum.exe 0 13500)
else
	result=$(./${EXECUTABLE} 0 13500)
fi
printf "%s,%s\n" "$(date +%s)" "$result" #sum
