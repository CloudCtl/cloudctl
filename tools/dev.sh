#!/bin/bash -x
clear
rm -rf /tmp/.ssh /tmp/.gitconfig /tmp/.bashrc
cp -rf ~/.ssh ~/.gitconfig ~/.bashrc /tmp/
sudo podman run -it --rm --pull always \
    -h konductor --name konductor \
    --entrypoint bash --privileged \
    --volume /tmp/.ssh:/root/.ssh:z \
    --volume /tmp/.bashrc:/root/.bashrc:z \
    --volume /tmp/.gitconfig:/root/.gitconfig:z \
    --volume $(pwd):/root/platform/iac/cloudctl:z \
    --workdir /root/platform/iac/cloudctl \
  docker.io/codesparta/konductor:latest
