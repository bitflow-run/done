# syntax=docker/dockerfile:1
FROM alpine:latest AS builder
LABEL maintainer="FlowtoCloud Team"

ARG TARGET_VERSION=v0.9.3

RUN apk add curl tar

RUN curl -OL "https://github.com/ahmetb/kubectx/releases/download/${TARGET_VERSION}/kubectx_${TARGET_VERSION}_linux_x86_64.tar.gz" \
    && tar zxf kubectx_${TARGET_VERSION}_linux_x86_64.tar.gz \
    && mv kubectx /usr/local/bin

RUN curl -OL "https://github.com/ahmetb/kubectx/releases/download/${TARGET_VERSION}/kubens_${TARGET_VERSION}_linux_x86_64.tar.gz" \
    && tar zxf kubens_${TARGET_VERSION}_linux_x86_64.tar.gz \
    && mv kubens /usr/local/bin

#######################################################

FROM alpine:latest

LABEL maintainer="FlowtoCloud Team"

COPY --from=builder /usr/local/bin /usr/local/bin

RUN true # see: https://github.com/moby/moby/issues/37965

