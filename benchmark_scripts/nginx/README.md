# nginx

## Run in docker container

First, execute the `gen_serve_file.sh` script, which will generate a dummy file named `file.dat` in this directory.

Execute the `build_run_docker.sh` script which will build the image from the `Dockerfile` in this directory,
run the resulting container, retrieve the port to connect to on localhost.

Usage example:
```bash
build_run_docker.sh
your_benchmark_script.sh --conn=127.0.0.1:8080
```

## Other platforms
