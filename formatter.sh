#!/bin/bash

set -e
set -x

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

exit 1  # Fix this line for the device name
DEVICE=/dev/xvdb
MOUNTPOINT=/mnt/ebs

mkfs -t ext4 $DEVICE
mkdir $MOUNTPOINT
mount $DEVICE $MOUNTPOINT
