#!/usr/bin/env bash

# check if static serve file has been generated
if [ ! -f file.dat ]; then
    echo "No static serve file 'file.dat' available. Run 'gen_serve_file.sh'!"
    exit 1
fi

# install nginx
sudo apt-get update
sudo apt-get install -yq nginx

exit 0
