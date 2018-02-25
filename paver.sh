#!/bin/bash

set -e
set -x

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

apt-get update && apt-get upgrade -y
