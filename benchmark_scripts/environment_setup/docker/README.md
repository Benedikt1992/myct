# Docker Environment

## Installed Dependencies

Refer to `Dockerfile` to make sure.

* nginx
* curl
* build-essential
* gcc
* git
* fio

## Build and Run

First, execute the `../gen_serve_file.sh` script, which will generate a dummy file named `file.dat` in this (`.`) directory.

Execute the `build_run_docker.sh` script which will build the image from the `Dockerfile` in this directory,
and run the resulting container.
`docker ps` will confirm the new container (named `nginx`) is running.

The _nginx_ server running in the container is mapped to port `8080`.

Usage example; _nginx_-benchmark:
```bash
build_run_docker.sh
measure-nginx.sh 127.0.0.1:8080
```
