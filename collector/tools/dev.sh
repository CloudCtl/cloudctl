#!/bin/bash -x
clear
project="collector-cloudctl"
cp -fr ~/.gitconfig ~/.ssh ~/.bashrc /tmp/
sudo podman run -it --rm --pull always \
    --name ${project} -h ${project} \
    --volume $(pwd):/root/koffer:z \
    --volume /tmp/.ssh:/root/.ssh:z \
    --volume /tmp/.bashrc:/root/.bashrc:z \
    --volume /tmp/.gitconfig:/root/.gitconfig:z \
    --entrypoint bash --workdir /root/koffer \
  quay.io/cloudctl/koffer:latest

#   --volume $(pwd)/aws/:/root/.aws/:z \
