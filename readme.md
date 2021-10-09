
# Portable Operations Stack

aka > **POS**

---

> this are our regular tools to debug, troubleshoot and reproduce scenarios across the cloud and local services.

## Stack

| image                                                       | base distro      | status | sizes       |
| ----------------------------------------------------------- | ---------------- | ------ | ----------- |
| [ansible-runner](https://github.com/ansible/ansible-runner) |                  |        |             |
| [aws-cli](https://github.com/aws/aws-cli)                   |                  |        |             |
| k2s ([kubectx + kubens](https://github.com/ahmetb/kubectx)) | alpine           | done   | 36M  / 12M  |
| [k9s](https://github.com/derailed/k9s)                      | alpine           | done   | 122M / 36M  |
| [minio](https://github.com/minio/mc)                        |                  |        |             |
| [nvim](https://github.com/neovim/neovim)                    | **alpine** - ubi | done   | 293M / 125M |
| [packer](https://github.com/hashicorp/packer)               |                  |        |             |
| [sop](https://github.com/mozilla/sops/releases)             |                  |        |             |
| [terraform](https://github.com/hashicorp/terraform)         |                  |        |             |



## Portable

### Scenario:

```bash
❯ podman --version
    podman version 3.2.2

❯ buildah --version
    buildah version 1.23.1 (image-spec 1.0.1-dev, runtime-spec 1.0.2-dev)
```

### Export and Import Images

> create an pos-<IMAGENAME>.tar and place it on destination, then load the image.


```bash
# ORIGIN
# example: podman save pos-<IMAGENAME>:latest -o pos-<IMAGENAME>.tar
# example: podman save pos-<IMAGENAME>:latest | gzip > pos-<IMAGENAME>.tar.gz

podman save localhost/flowto-cloud/pos-nvim:latest | gzip > pos-nvim.tar.gz


# DESTINATION
# example: podman load -i pos-<IMAGENAME>.tar
# example: gunzip -c pos-<IMAGENAME>.tar.gz | podman load
```



## Usage

### k2s

```bash
# build
export
buildah bud --build-arg TARGET_VERSION=v0.9.4 -f k2s.alpine.dockerfile -t flowto-cloud/pos-alpine-k2s:v0.9.4 .

# run test
podman run -it --rm -v ~/.kube:/root/.kube localhost/flowto-cloud/pos-alpine-k2s:v0.9.4 kubens --help
podman run -it --rm -v ~/.kube:/root/.kube localhost/flowto-cloud/pos-alpine-k2s:v0.9.4 kubectx --help

# load alias
alias kux.='podman run -it --rm -v ~/.kube:/root/.kube localhost/flowto-cloud/pos-alpine-k2s:v0.9.4 kubectx.'
alias kns.='podman run -it --rm -v ~/.kube:/root/.kube localhost/flowto-cloud/pos-alpine-k2s:v0.9.4 kubens'

```

### k9s

> ​	this image is placed as a **git submodule** to download all the sub modules with
>
> `git submodule update --recursive --remote`

```bash
# load the latest version on kubectl KUBECTL_VERSION
KUBECTL_VERSION=$(make kubectl-stable-version 2>/dev/null)

# build
buildah bud --build-arg KUBECTL_VERSION=${KUBECTL_VERSION} -t flowto-cloud/pos-alpine-k9s .

# run test
podman run -it --rm -v ~/.kube:/root/.kube localhost/flowto-cloud/pos-alpine-k9s --help

# load alias
alias k9s.='podman run --rm -it -v ~/.kube/config:/root/.kube/config localhost/flowto-cloud/pos-alpine-k9s'
```
### nvim

```bash
# build
buildah bud -f nvim.alpine.dockerfile -t flowto-cloud/pos-alpine-nvim

# run test
podman run --rm -it -v $(pwd):/data flowto-cloud/pos-alpine-nvim nvim --help

# load alias
alias vim.='podman run --rm -it -v $(pwd):/data flowto-cloud/pos-alpine-nvim nvim'
```

### extras notes

```bash
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



