#!/bin/bash

docker-compose down --rmi local --remove-orphans --volumes
docker image rm shortpoet/vite
