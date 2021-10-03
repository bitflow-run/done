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
        unzip \
    --nodocs \ 
    --disableplugin=subscription-manager && rm -rf /var/cache/microdnf

COPY terraform-installer.sh ./terraform-installer.sh
RUN  bash terraform-installer.sh

FROM registry.access.redhat.com/ubi8/ubi-minimal

WORKDIR /root/

COPY --from=builder /usr/local/bin /usr/local/bin

CMD [ "terraform", "--version" ]

ENTRYPOINT ["/usr/local/bin/terraform"]
