#!/bin/bash -x
project="konductor-init"
OFFLINE_IMG="$(pwd)/bundle/image-konductor-latest.tar"

# Stage SSH Credentials
sudo rm -rf /tmp/.ssh
sudo cp -rf ~/.ssh /tmp/

# Load konductor image
if [[ -f ${OFFLINE_IMG} ]]; then
    # Pull image from local tar file
    echo ">> Loading Konductor Image from ${OFFLINE_IMAGE}"
    podman load --input $(pwd)/bundle/image-konductor-latest.tar
else
    # Pull from public internet if tar not found 
    echo ">> Loading Konductor Image from DockerHub Repo"
    podman pull docker.io/containercraft/konductor:latest
fi

# Detect and tag image to non-latest tag for offline support
IMG_SHA=$(podman images --format "{{.ID}} {{.Names}}" --no-trunc | awk -F'[ :]' '/konductor:latest/{print $2}' | head -n1)
podman tag ${IMG_SHA} docker.io/containercraft/konductor:init

# Run konductor image
time sudo podman run -it --rm \
    -h ${project} --name ${project}               \
    --entrypoint ./site.yml --privileged          \
    --volume /tmp/.ssh:/root/.ssh:z               \
    --workdir /root/platform/iac/cloudctl         \
    --volume $(pwd):/root/platform/iac/cloudctl:z \
  docker.io/containercraft/konductor:init
