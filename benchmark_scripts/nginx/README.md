# nginx

## Run in docker container

Execute the `build_run_docker.sh` script which will build the image from the `Dockerfile` in this directory,
run the resulting container, retrieve the port to connect to on localhost.

Usage example:
```bash
port=$(./build_run_docker.sh)
your_benchmark_script.sh --ip=127.0.0.1 --port=port
```