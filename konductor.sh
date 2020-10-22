#!/bin/bash -x
project="konductor-init"

# Stage SSH Credentials
sudo rm -rf /tmp/.ssh
sudo cp -rf ~/.ssh /tmp/
sudo podman run -it --rm \
    -h ${project} --name ${project}               \
    --entrypoint ./site.yml --privileged          \
    --volume /tmp/.ssh:/root/.ssh:z               \
    --workdir /root/platform/iac/cloudctl         \
    --volume $(pwd):/root/platform/iac/cloudctl:z \
  docker.io/containercraft/konductor
