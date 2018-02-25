#!/bin/bash

set -e
set -x

CRONDB=crondb
CRONUSER=cronuser
CRONPASSWORD=cronpassword

DOCKERDATA=pgdata
DOCKERNAME=pgdb
DOCKERNETWORK=pgnet
POSTGRES_VERSION='10.2'
POSTGRES_PASSWORD=apassword

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Create the docker volume if it doesn't exist
if docker volume ls | grep $DOCKERDATA; then
  echo "docker volume pgdata already created"
else
  docker volume create $DOCKERDATA
fi

# Create the docker network if it doesn't exist
if docker network ls | grep $DOCKERNETWORK; then
  echo "docker network ${DOCKERNETWORK} already created"
else
  docker network create --driver bridge $DOCKERNETWORK
fi

# Pull the correct postgres version
docker pull "postgres:${POSTGRES_VERSION}"

# Start up postgres
docker run --rm -d --name $DOCKERNAME --network=$DOCKERNETWORK -e "POSTGRES_PASSWORD=$POSTGRES_PASSWORD" -v "${DOCKERDATA}:/var/lib/postgresql/data" postgres

# Create the user
read -r -d '' CREATE_USER_IF_NOT_EXISTS << EOM
DO
\$body\$
BEGIN
  IF NOT EXISTS (
    SELECT
      FROM pg_catalog.pg_user
     WHERE username = '$CRONUSER'
  ) THEN
    CREATE USER ${CRONUSER} WITH ENCRYPTED PASSWORD '${CRONPASSWORD}' CREATEDB;
  END IF;
END
\$body\$;
EOM
docker run --rm --network=$DOCKERNETWORK -e "PGPASSWORD=$POSTGRES_PASSWORD" postgres psql -h $DOCKERNAME -U postgres -c "${CREATE_USER_IF_NOT_EXISTS}"

# Create the database
docker run --rm --network=$DOCKERNETWORK -e "PGPASSWORD=${CRONPASSWORD}" posgres psql -h $DOCKERNAME -U $CRONUSER -c "CREATE DATABASE ${CRONDB};"
