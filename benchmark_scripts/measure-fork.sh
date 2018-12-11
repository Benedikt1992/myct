#!/usr/bin/env bash 

EXECUTABLE="forksum"
ARGS="0 12800"
if [ ! -e $EXECUTABLE ] ; then
	echo "Compiling forksum.c"
	cc -O -o forksum forksum.c -lm
fi


if [ "$SYSTEMROOT" = "C:\Windows" ] ; then
	result=$(./forksum.exe $ARGS 2>/dev/null)
else
	result=$(./${EXECUTABLE} $ARGS 2>/dev/null)
fi
printf "%s,%s\n" "$(date +%s)" "$result" #sum

