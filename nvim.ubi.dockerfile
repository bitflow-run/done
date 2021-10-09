# syntax=docker/dockerfile:1
FROM registry.access.redhat.com/ubi8/ubi-minimal AS builder
LABEL maintainer="Flowto Cloud Team"

ARG BUILD_DEPS=" libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip patch gettext curl git"
ARG TARGET=stable

RUN microdnf update -y && \
    microdnf install -y ${BUILD_DEPS} \
    # ninja-build \
    --nodocs \ 
    --disableplugin=subscription-manager && \
    rm -rf /var/cache/microdnf && \
    git clone https://github.com/neovim/neovim && \
    cd neovim && git checkout tags/${TARGET} && \
    git cherry-pick -n 38145b919d160ea63c2547533595e761b40cfe45 && \
    make CMAKE_BUILD_TYPE=Release && \
    make CMAKE_INSTALL_PREFIX=/usr/local install && \
    strip /usr/local/bin/nvim

#######################################################

FROM registry.access.redhat.com/ubi8/ubi-minimal

ENV EDITOR nvim

ARG FINAL_DEPS="git gcc-c++"

COPY --from=builder /usr/local /usr/local/

RUN true # see: https://github.com/moby/moby/issues/37965

RUN microdnf update -y && \
    microdnf install -y ${FINAL_DEPS} \ 
        --nodocs \ 
        --disableplugin=subscription-manager && \
    rm -rf /var/cache/microdnf && \
    git clone https://github.com/NvChad/NvChad /root/.config/nvim && \
    nvim --headless +PackerCompile +qa 2>> /root/nvim.error.log && \
    nvim --headless +PackerSync +sleep30 +UpdateRemotePlugins +qa  2>> /root/nvim.error.log && \
    nvim --headless +sleep30 +qa 2>> /root/nvim.error.log

WORKDIR /data

CMD ["/usr/local/bin/nvim"]

# packages
#   ninja-build 
#       epel-release-latest-8.noarch.rpm
#       --set-enabled powertools
