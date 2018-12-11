#!/usr/bin/env bash

# check if static serve file has been generated
if [ ! -f file.dat ]; then
    echo "No static serve file 'file.dat' available. Run 'gen_serve_file.sh'!"
    exit 1
fi

# install nginx
sudo apt-get update
sudo apt-get install -yq nginx
sudo apt-get clean

# static file to serve (must be generated first)
cp ./docker/file.dat /var/www/html

exit 0
