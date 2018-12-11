#!/usr/bin/env bash

# ! run script as root user !

# install nginx
apt-get update
apt-get install -yq nginx
apt-get clean

# don't daemonize and disable autostart
echo "" >> /etc/nginx/nginx.conf
echo "daemon off;" >> /etc/nginx/nginx.conf
systemctl disable nginx
systemctl stop nginx

# static file to serve (must be generated first)
if [ ! -f docker/file.dat ]; then
    echo "No static serve file 'file.dat' available. Run 'gen_serve_file.sh'!"
    exit 1
fi
cp docker/file.dat /var/www/html/

exit 0
