# syntax=docker/dockerfile:1

FROM alpine:latest AS builder

ARG BUILD_DEPS="autoconf automake cmake curl g++ gettext gettext-dev git libtool make ninja openssl pkgconfig unzip binutils"

ARG TARGET=stable

RUN apk add --no-cache ${BUILD_DEPS} && \

  git clone https://github.com/neovim/neovim.git /tmp/neovim && \

  cd /tmp/neovim && \

	git checkout tags/${TARGET} && \

  # Patch bug in build script on stable

  # see https://github.com/neovim/neovim/commit/38145b919d160ea63c2547533595e761b40cfe45

  # git cherry-pick -n 38145b919d160ea63c2547533595e761b40cfe45 && \

  make CMAKE_BUILD_TYPE=Release && \

  make CMAKE_INSTALL_PREFIX=/usr/local install && \

  strip /usr/local/bin/nvim

#######################################################

FROM golang:alpine3.15

LABEL maintainer="Anibal Aguila"

ENV \
   TZ="Europe/Madrid" \
   LANG="en_US.UTF-8" \
   LC_ALL="en_US.UTF-8" \
   TERM="xterm-256color" \
   EDITOR="nvim" \
   WORKSPACE="/mnt/workspace" \
   LANG="en_US.UTF-8"

ARG FINAL_DEPS="git ripgrep g++ xclip"

COPY --from=builder /usr/local /usr/local/

RUN true # see: https://github.com/moby/moby/issues/37965

# Required shared libraries

COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/

COPY --from=builder /usr/lib/libgcc_s.so.1 /usr/lib/

COPY --from=builder /usr/lib/libintl.so.8 /usr/lib/

RUN apk add --no-cache ${FINAL_DEPS} && \
    git clone https://github.com/levelup-ac/NvChad.git /root/.config/nvim && \
    nvim --headless +PlugInstall +qa 2>> /root/nvim.error.log && \
    nvim --headless +PackerCompile +qa 2>> /root/nvim.error.log && \
    nvim --headless +PackerSync +sleep30 +UpdateRemotePlugins +qa  2>> /root/nvim.error.log && \
    nvim --headless +sleep5 +'LspInstall gopls' +sleep60 +qa 2>> /root/nvim.error.log && \
    nvim --headless +sleep30 +qa 2>> /root/nvim.error.log

VOLUME ${WORKSPACE}

WORKDIR ${WORKSPACE}

CMD ["/usr/local/bin/nvim"]
