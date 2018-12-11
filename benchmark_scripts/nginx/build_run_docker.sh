#!/usr/bin/env bash

# only build docker image if it does not exist
docker build -t nginx-static-serve . >/dev/null

# make sure the container is not already running
docker stop nginx 2>/dev/null && docker rm nginx 2>/dev/null

# run the image
docker run -P -d --name=nginx nginx-static-serve >/dev/null

# grab the connected port accessible to test script
echo $(docker port nginx | sed 's/.*:\([0-9]*\)/\1/p' | tail -n 1)

exit 0