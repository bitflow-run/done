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

COPY minio-client-installer.sh ./minio-client-installer.sh

RUN  bash minio-client-installer.sh

FROM registry.access.redhat.com/ubi8/ubi-minimal

WORKDIR /root/

COPY --from=builder /usr/local/bin /usr/local/bin

CMD ["/usr/local/bin/mc", "--verison"]

ENTRYPOINT ["mc"]

# packages
#   shadow-utils
#       https://src.fedoraproject.org/rpms/shadow-utils/blob/rawhide/f/shadow-utils.spec
