#!/bin/bash -x
project="cloudctl"

# Prep SSH, Credentials, & Bash
rm -rf /tmp/.ssh /tmp/.gitconfig /tmp/.bashrc
cp -rf ~/.ssh ~/.gitconfig ~/.bashrc /tmp/
sudo podman run -it --rm --pull always \
    -h ${project} --name ${project} \
    --entrypoint bash --privileged \
    --volume /tmp/.ssh:/root/.ssh:z \
    --volume /tmp/.bashrc:/root/.bashrc:z \
    --volume /tmp/.gitconfig:/root/.gitconfig:z \
    --volume $(pwd):/root/platform/iac/${project}:z \
    --workdir /root/platform/iac/${project} \
  docker.io/codesparta/konductor:latest
