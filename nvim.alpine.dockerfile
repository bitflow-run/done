# syntax=docker/dockerfile:1
FROM alpine:latest AS builder
LABEL maintainer="FlowtoCloud Team"

ARG BUILD_DEPS="autoconf automake cmake curl g++ gettext gettext-dev git libtool make ninja openssl pkgconfig unzip binutils"
ARG TARGET=stable

RUN apk add --no-cache ${BUILD_DEPS} && \
  git clone https://github.com/neovim/neovim.git /tmp/neovim && \
  cd /tmp/neovim && \
	git checkout tags/${TARGET} && \
  # Patch bug in build script on stable
  # see https://github.com/neovim/neovim/commit/38145b919d160ea63c2547533595e761b40cfe45
  git cherry-pick -n 38145b919d160ea63c2547533595e761b40cfe45 && \
  make CMAKE_BUILD_TYPE=Release && \
  make CMAKE_INSTALL_PREFIX=/usr/local install && \
  strip /usr/local/bin/nvim

#######################################################

FROM alpine:latest

ENV EDITOR nvim

# ARG FINAL_DEPS="git nodejs ripgrep alpine-sdk"

ARG FINAL_DEPS="git ripgrep g++"

# gcc musl-dev libc-dev

COPY --from=builder /usr/local /usr/local/

RUN true # see: https://github.com/moby/moby/issues/37965

# Required shared libraries
COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/

RUN true

COPY --from=builder /usr/lib/libgcc_s.so.1 /usr/lib/

RUN true

COPY --from=builder /usr/lib/libintl.so.8 /usr/lib/

RUN apk add --no-cache ${FINAL_DEPS} && \
    git clone https://github.com/NvChad/NvChad /root/.config/nvim && \
    nvim --headless +PackerCompile +qa 2>> /root/nvim.error.log && \
    nvim --headless +PackerSync +sleep30 +UpdateRemotePlugins +qa  2>> /root/nvim.error.log && \
    nvim --headless +sleep30 +qa 2>> /root/nvim.error.log

WORKDIR /data

CMD ["/usr/local/bin/nvim"]


# ENV LANG en_US.UTF-8 \
#     LANGUAGE en_US:en \
#     TERM=xterm-256color \
#     HOME=/home/neo


# RUN adduser -S neo -u 1000 -G users

# USER neo


# ENTRYPOINT nvim
