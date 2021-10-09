# syntax=docker/dockerfile:1
FROM registry.access.redhat.com/ubi8/ubi-minimal AS builder
USER root
LABEL maintainer="Flowto Cloud Team"

# Update image
RUN microdnf update -y && \ 
    microdnf install -y \
        curl \
        ca-certificates \
        # shadow-utils \
        # unzip \
    --nodocs \ 
    --disableplugin=subscription-manager && rm -rf /var/cache/microdnf

COPY packer-installer.sh ./packer-installer.sh

RUN  bash packer-installer.sh

FROM registry.access.redhat.com/ubi8/ubi-minimal

WORKDIR /root/

COPY --from=builder /usr/local/bin /usr/local/bin

CMD ["packer", "--version"]

ENTRYPOINT ["/usr/local/bin/packer"]
