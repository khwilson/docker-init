#!/bin/bash

set -e
set -x

MOUNTPOINT=/mnt/ebs

test_docker () {
  if docker run hello-world; then
    echo 'Successful install!'
  else
    echo 'Something went wrong'
    exit 1
  fi
}

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update && apt-get install -y docker-ce

test_docker

service docker stop
mv /var/lib/docker "${MOUNTPOINT}/docker"
ln -s "${MOUNTPOINT}/docker" /var/lib/docker
service docker start

test_docker
