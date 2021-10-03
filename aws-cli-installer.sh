#!/bin/bash

###################################
# VARIABLES  ######################
###################################

set -e

AWS_VERSION=2.0.30

###################################
# COMMON ##########################
###################################

mkdir -p .downloads
mkdir -p /usr/local/bin

###################################
# BUILDS ##########################
###################################

# Installing aws-cli
if [ ! -d /usr/local/bin/aws-cli ]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_VERSION}.zip" -o ".downloads/awscliv2.zip"
    unzip .downloads/awscliv2.zip -d .downloads
    .downloads/aws/install -i /usr/local/bin/aws-cli -b /usr/local/bin
fi

