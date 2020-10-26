#!/bin/bash -x
project="konductor-init"

# Check if offline konductor image available for import
OFFLINE_IMG="$(pwd)/bundle/image-konductor-latest.tar"
if [[ -f ${OFFLINE_IMG} ]]; then
    echo ">> Loading Konductor Image from ${OFFLINE_IMAGE}"
    podman load --input $(pwd)/bundle/image-konductor-latest.tar
    podman tag docker.io/containercraft/konductor:latest docker.io/containercraft/konductor:init
    podman images --format "{{.ID}}"
else
    echo ">> Loading Konductor Image from DockerHub Repo"
    podman pull docker.io/containercraft/konductor:latest
    podman tag docker.io/containercraft/konductor:latest \
               docker.io/containercraft/konductor:init
fi

# Stage SSH Credentials
sudo rm -rf /tmp/.ssh
sudo cp -rf ~/.ssh /tmp/
sudo podman run -it --rm \
    -h ${project} --name ${project}               \
    --entrypoint ./site.yml --privileged          \
    --volume /tmp/.ssh:/root/.ssh:z               \
    --workdir /root/platform/iac/cloudctl         \
    --volume $(pwd):/root/platform/iac/cloudctl:z \
  docker.io/containercraft/konductor:init
