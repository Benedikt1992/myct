FROM debian:stretch

# install deps
RUN apt-get update && apt-get install -yq nginx curl build-essential gcc git && apt-get clean

# install fio
RUN git clone https://github.com/axboe/fio.git && \
    cd fio && \
    ./configure && \
    make && \
    make install && \
    cd .. && rm -r fio

# don't daemonize - container dies otherwise
RUN echo "" >> /etc/nginx/nginx.conf && echo "daemon off;" >> /etc/nginx/nginx.conf

# internal port
EXPOSE 80

# static file to serve (must be generated first)
COPY ./file.dat /var/www/html

CMD ["/usr/sbin/nginx"]
