#!/usr/bin/env bash

# only build docker image if it does not exist
docker build -t nginx-static-serve .

# make sure the container is not already running
docker stop nginx && docker rm nginx

# run the image
docker run -p 8080:80 -d --name=nginx nginx-static-serve

exit 0