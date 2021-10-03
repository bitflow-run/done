#!/bin/bash

###################################
# VARIABLES  ######################
###################################

set -e

TERRAFORM_VERSION=1.0.7

###################################
# COMMON ##########################
###################################

mkdir -p .downloads
mkdir -p /usr/local/bin

###################################
# BUILDS ##########################
###################################

# Installing terraform
if [ ! -f /usr/local/bin/terraform ]; then
    curl "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o ".downloads/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
    unzip .downloads/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d .downloads/terraform
    mv .downloads/terraform/terraform /usr/local/bin/terraform
    rm -rf .downloads/terraform
fi
