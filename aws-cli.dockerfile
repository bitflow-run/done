# syntax=docker/dockerfile:1
FROM registry.access.redhat.com/ubi8/ubi-minimal AS builder
USER root
LABEL maintainer="Flowto Cloud Team"

# Update image

RUN microdnf update -y && \ 
    microdnf install -y \
        curl \
        ca-certificates \
        shadow-utils \
        unzip \
    --nodocs \ 
    --disableplugin=subscription-manager && rm -rf /var/cache/microdnf

COPY aws-cli-installer.sh ./aws-cli-installer.sh

RUN  bash aws-cli-installer.sh

FROM registry.access.redhat.com/ubi8/ubi-minimal

WORKDIR /root/

COPY --from=builder /usr/local/bin /usr/local/bin

CMD ["/usr/local/bin/aws", "--verison"]

ENTRYPOINT ["aws"]

