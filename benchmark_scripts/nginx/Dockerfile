FROM debian:stretch

# install nginx
RUN apt-get update && apt-get install -yq nginx && apt-get clean

# don't daemonize - container dies otherwise
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

# internal port
EXPOSE 80

# static file to serve (must be generated first)
COPY ./file.dat /var/www/html

CMD ["/usr/sbin/nginx"]
