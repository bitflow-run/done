
# Portable Operations Stack

aka > **POS**

---

> this are our regular tools to debug, troubleshoot and reproduce scenarios across the cloud and local services.

## Matrix

| image                                               | base distro  | status |
| --------------------------------------------------- | ------------ | ------ |
| ansible                                             |              |        |
| aws-cli                                             |              |        |
| k9s                                                 |              |        |
| minio                                               |              |        |
| [nvim](https://github.com/neovim/neovim)            | alpine - ubi | done   |
| packer                                              |              |        |
| [sop](https://github.com/mozilla/sops/releases)     |              |        |
| [terraform](https://github.com/hashicorp/terraform) |              |        |



## How to use

### Scenario:

```
❯ podman --version
    podman version 3.2.2

❯ buildah --version
    buildah version 1.23.1 (image-spec 1.0.1-dev, runtime-spec 1.0.2-dev)
```


### Creating an Image

> for each client that you need create an image, change ghe 

```

buildah bud -f <CLIETN-NAME>.dockerfile  -t flowto-cloud/pos-<CLIETN-NAME>:<VERSION>


# Example
buildah bud -f minio-client.dockerfile  -t flowto-cloud/pos-mino-client
podman run --rm -it localhost/flowto-cloud/pos-mino-client --help
```

### Running an Image

```
# Run a container from the image:
podman run --rm -it localhost/flowto-cloud/pos-nvim --version

podman run --rm -it -v $(pwd):/data flowto-cloud/pos-alpine-nvim nvim name-of-file.md

# Run a container from the image:
podman run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/id_rsa flowto-cloud/mino-client bash

# Run a container from the image:
podman run --detach --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro flowto-cloud/ansible:latest

# Run a container from the image:
podman exec --tty [container_id] env TERM=xterm ansible --version
podman exec --tty [container_id] env TERM=xterm ansible-playbook /path/to/ansible/playbook.yml --syntax-check
```


### Easy aliases pointer

```
# VI
alias vi.='podman run --rm -it -v $(pwd):/data flowto-cloud/pos-alpine-nvim nvim'

# TF
alias tf.='podman run --rm -it localhost/flowto-cloud/pos-terraform:1.0.7'

# AWS
alias aws.='podman run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws localhost/flowto-cloud/pos-aws-cli'

# AWS:2.0.6
alias aws.='podman run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws localhost/flowto-cloud/pos-aws-cli:2.0.6'

# k9s
alias k9s.='podman run --rm -it -v ~/.kube/config:/root/.kube/config localhost/flowto-cloud/pos-alpine-k9s'

```

### Portable Details

> create an pos-<IMAGENAME>.tar and place it on destination, then load the image.


```
# ORIGIN
# example: podman save pos-<IMAGENAME>:latest -o pos-<IMAGENAME>.tar
# example: podman save pos-<IMAGENAME>:latest | gzip > pos-<IMAGENAME>.tar.gz

podman save localhost/flowto-cloud/pos-nvim:latest | gzip > pos-nvim.tar.gz


# DESTINATION
# example: podman load -i pos-<IMAGENAME>.tar
# example: gunzip -c pos-<IMAGENAME>.tar.gz | podman load
```



## Building on git submodule

> In case the project have a reasonable Dockerfile it's included as **git submodule**

### example

```
# building k9s image 
cd k9s

# load the latest version on kubectl KUBECTL_VERSION
KUBECTL_VERSION=$(make kubectl-stable-version 2>/dev/null)

# build it
buildah bud --build-arg KUBECTL_VERSION=${KUBECTL_VERSION} -t flowto-cloud/pos-alpine-k9s .


```

 
