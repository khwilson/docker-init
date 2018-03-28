#!/bin/bash

set -e
set -x

POSTGRES_VERSION='10'
POSTGRES_PASSWORD=apassword
DOCKERDATA=pgdata
DOCKERNETWORK=pgnet

DOCKER_IMAGE="mdillon/postgis:${POSTGRES_VERSION}"

docker pull "$DOCKER_IMAGE"

if ! docker volume list | grep $DOCKERDATA; then
  docker volume create $DOCKERDATA
fi

if ! docker network list | grep $DOCKERNETWORK; then
  docker network create $DOCKERNETWORK
fi

docker run --rm -d --name pgdb -e "POSTGRES_PASSWORD=${POSTGRES_PASSWORD}" --network "$DOCKERNETWORK" -v "$DOCKERDATA:/var/lib/postgresql/data" "$DOCKER_IMAGE"
