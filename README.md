# Pocketbase custom docker build

Personal Project for building customized pocketbase docker images. This repository is for reference purposes as the code is not ideal for public use, but may be useful as a pattern to follow for anyone wanting to build a customized pocketbase docker image

## How to use

Delete existing `go.mod` and `go.sum` to rebuild the project from the `main.go` file.

Init project to download updated dependencies / modules / pkgs

```sh
# Example - replace myapp with any app name
go mod init myapp && go mod tidy
```

To update a single package use the `go get -u <pkg>@<version>` command

```sh
# Example module
go get github.com/bankole2000/pocketbase

# Example specifying version
go get github.com/bankole2000/pocketbase@1.04
```

Build the image

```sh
# docker build -t <username>/<imagename>:<version>
docker build -t bankole2000/custom-pocketbase:latest .
```

Run container to test / try

```sh
# docker run --name <containername> --p 8090:8090 <imagename>:<version>
docker run --name custom-pb-container -p 8090:8090 bankole2000/custom-pocketbase
```

## Optional

### Push to dockerhub or wherever

```sh
# docker push <username>/<imagename>:<version>
docker push bankole2000/custom-pocketbase
```

### Using in docker compose

```yml
version: '3.8'
services: 
  custom-pocketbase: 
    image: bankole2000/custom-pocketbase
    container_name: custom-pocketbase
    restart: 'always'
    ports:
      - 8090:8090
    environment:
      # change the host OR URL depending on where your rabbitmq is running
      # - RABBITMQ_URL=amqp://host.docker.internal:5672?connection_attempts=5&retry_delay=5
      - RABBITMQ_URL=amqp://localhost:5672?connection_attempts=5&retry_delay=5
      - RABBITMQ_EXCHANGE=CUSTOM_APP
```