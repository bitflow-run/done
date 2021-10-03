

buildah bud -t flowto-cloud/ansible:2.11.5
buildah bud -f ansible.dockerfile  -t flowto-cloud/ansible:2.11.5


podman run --rm -it localhost/flowto-cloud/opstools aws --version
podman run --rm -it localhost/flowto-cloud/ansible:4.6.0 ansible --version




docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/id_rsa nickkostov/ansibleautomation bash



Pull this image from Docker Hub: docker pull strusfr/docker-ubi7-ansible:latest (or use the image you built earlier, e.g. ubi7-ansible:latest).
Run a container from the image: docker run --detach --privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro strusfr/docker-ubi7-ansible:latest (to test my Ansible roles, I add in a volume mounted from the current working directory with --volume=`pwd`:/etc/ansible/roles/role_under_test:ro).
Use Ansible inside the container: a. docker exec --tty [container_id] env TERM=xterm ansible --version b. docker exec --tty [container_id] env TERM=xterm ansible-playbook /path/to/ansible/playbook.yml --syntax-check