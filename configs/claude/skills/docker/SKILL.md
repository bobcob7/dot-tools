---
name: docker
description: Docker commands for containers, images, and compose
argument-hint: "[command or question]"
allowed-tools: Bash, Read
---

Help with Docker based on `$ARGUMENTS`.

## Images

```bash
# Build image
docker build -t myapp .
docker build -t myapp:v1.0 -f Dockerfile.prod .

# List images
docker images
docker image ls

# Pull image
docker pull nginx:alpine

# Remove image
docker rmi myapp
docker image prune          # Remove unused
docker image prune -a       # Remove all unused
```

## Containers

```bash
# Run container
docker run nginx
docker run -d nginx                    # Detached
docker run -p 8080:80 nginx            # Port mapping
docker run -v $(pwd):/app nginx        # Volume mount
docker run --name mycontainer nginx    # Named container
docker run -it ubuntu bash             # Interactive
docker run --rm nginx                  # Remove on exit
docker run -e VAR=value nginx          # Environment variable
docker run --env-file .env nginx       # Env file

# List containers
docker ps                   # Running
docker ps -a                # All

# Container operations
docker stop <container>
docker start <container>
docker restart <container>
docker rm <container>
docker rm -f <container>    # Force

# Logs
docker logs <container>
docker logs -f <container>  # Follow

# Execute in container
docker exec -it <container> bash
docker exec <container> ls /app

# Copy files
docker cp file.txt <container>:/path/
docker cp <container>:/path/file.txt .
```

## Docker Compose

```bash
# Start services
docker compose up
docker compose up -d        # Detached
docker compose up --build   # Rebuild

# Stop services
docker compose down
docker compose down -v      # Remove volumes

# View logs
docker compose logs
docker compose logs -f service_name

# Execute command
docker compose exec service_name bash

# Scale
docker compose up -d --scale web=3
```

## Dockerfile Patterns

```dockerfile
# Multi-stage build
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
```

## Cleanup

```bash
# Remove all stopped containers
docker container prune

# Remove unused data
docker system prune
docker system prune -a      # Include unused images

# Disk usage
docker system df
```
