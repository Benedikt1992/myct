#!/usr/bin/env bash

# only build docker image if it does not exist
docker build -t mocc-benchmark .

# make sure the container is not already running
docker stop mocc && docker rm mocc

# run the image
docker run -p 8080:80 -d --name=mocc mocc-benchmark

exit 0