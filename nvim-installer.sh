#!/bin/bash

###################################
# VARIABLES  ######################
###################################

set -e

NVIM_VERSION=v0.5.1

###################################
# COMMON ##########################
###################################

mkdir -p .downloads
mkdir -p /usr/local/bin

###################################
# BUILDS ##########################
###################################

# Installing nvim
if [ ! -f /usr/local/bin/nvim ]; then
    git clone https://github.com/neovim/neovim
    # cd neovim && git checkout stable && make -j4
    cd neovim && git checkout stable
    make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/usr/local/bin/nvim"
    make install
fi

