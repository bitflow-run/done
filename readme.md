
# OPS Tools
---

> this is our regular tools to use debug, troubleshoot and reproduce scenarios across the cloud and local services.

## Index Images

+   Ansible
+   AWS
+   Minio
+   Packer
+   Terraform *


## How to use

### Build Sources:

```
❯ podman --version
    podman version 3.2.2

❯ buildah --version
    buildah version 1.23.1 (image-spec 1.0.1-dev, runtime-spec 1.0.2-dev)
```


### Creating an Image

> for each client that you need create an image, change ghe 

```

buildah bud -f <CLIETN-NAME>.podmanfile  -t flowto-cloud/<CLIETN-NAME>:<VERSION>


# Example
buildah bud -f minio-client.podmanfile  -t flowto-cloud/mino-client
podman run --rm -it localhost/flowto-cloud/mino-client --help
```

### Running an Image

```
# Run a container from the image:
podman run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/id_rsa flowto-cloud/mino-client bash

# Run a container from the image:
podman run --detach --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro strusfr/podman-ubi7-ansible:latest

# Run a container from the image:
podman exec --tty [container_id] env TERM=xterm ansible --version
podman exec --tty [container_id] env TERM=xterm ansible-playbook /path/to/ansible/playbook.yml --syntax-check
```