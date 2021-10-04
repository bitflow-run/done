# syntax=docker/dockerfile:1
FROM registry.access.redhat.com/ubi8/ubi-minimal AS builder
USER root
LABEL maintainer="Flowto Cloud Team"

# Update image

RUN dnf update -y && \ 
    dnf install -y \
        # ninja-build \
        libtool \
        autoconf \
        automake \
        cmake \
        gcc \
        gcc-c++ \
        make \
        pkgconfig \
        unzip \
        patch \
        gettext \
        curl \
        git \ 
    --nodocs \ 
    --disableplugin=subscription-manager && rm -rf /var/cache/dnf

COPY nvim-installer.sh ./nvim-installer.sh
RUN  bash nvim-installer.sh

FROM registry.access.redhat.com/ubi8/ubi-minimal

WORKDIR /root/

COPY --from=builder /usr/local/bin /usr/local/bin

# CMD [ "nvim", "--version" ]

ENTRYPOINT ["/usr/local/bin/nvim/bin/nvim"]

# packages
#   ninja-build 
#       epel-release-latest-8.noarch.rpm
#       --set-enabled powertools
