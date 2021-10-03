#!/bin/bash

###################################
# VARIABLES  ######################
###################################

set -e

PACKER_VERSION=1.7.5

###################################
# COMMON ##########################
###################################

mkdir -p .downloads
mkdir -p /usr/local/bin

###################################
# BUILDS ##########################
###################################

# Installing packer
if [ ! -f /usr/local/bin/packer ]; then
    curl "https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip" -o ".downloads/packer_${PACKER_VERSION}_linux_amd64.zip"
    unzip .downloads/packer_${PACKER_VERSION}_linux_amd64.zip -d .downloads/packer
    mv .downloads/packer/packer /usr/local/bin/packer
    rm -rf .downloads/packer
fi
