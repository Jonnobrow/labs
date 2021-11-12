# Docker and Python Flask

## Inspecting the Dockerfile
The [Dockerfile](./Dockerfile) contains comments that explain each line.

## Building the Docker Image
```bash
docker build -t simple-docker-flaskapp:v1 .
```

- `-t`: Flag specifying the tag
- `simple-docker-flaskapp`: The image name
- `v1`: The image tag
- `.`: The path to the build context (location of the Dockerfile)

## Running the Docker Image
```bash
docker run -p 80:5000 -d simple-docker-flaskapp:v1
```

- `-p`: Flag specifying the port
- `80`: The port on the host
- `5000`: The port in the container
- `-d`: Detach the container (don't run in the foreground)
- `simple-docker-flaskapp`: The image name
- `v1`: The image tag

## Pushing the Image to Docker Hub
```bash
docker tag simple-docker-flaskapp:v1 jonnobrow/simple-docker-flaskapp:v1
```
- `simple-docker-flaskapp:v1`: Old image name and tag 
- `jonnobrow/simple-docker-flaskapp:v1`: New image name and tag including docker
  hub username

```bash
docker login
docker push jonnobrow/simple-docker-flaskapp:v1
```

