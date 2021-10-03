#!/bin/bash

###################################
# VARIABLES  ######################
###################################

set -e

MINIOCLIENT_VER=RELEASE.2021-09-23T05-44-03Z
TARGETARCH=amd64

###################################
# COMMON ##########################
###################################

mkdir -p /usr/local/bin

###################################
# BUILDS ##########################
###################################

# Installing minio
if [ ! -f /usr/local/bin/mc ]; then

    curl -s -q "https://dl.minio.io/client/mc/release/linux-${TARGETARCH}/archive/mc.${MINIOCLIENT_VER}" -o "/usr/local/bin/mc"
    chmod +x /usr/local/bin/mc
fi

