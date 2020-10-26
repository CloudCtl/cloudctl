#!/bin/bash
project="init"
dir_bundle="$(pwd)/bundle"
import_list="$(ls ${dir_bundle}/*.tar)"

# Stage SSH Credentials
sudo rm -rf /tmp/.ssh
sudo cp -rf ~/.ssh /tmp/

# Load konductor image
if [[ -f ${OFFLINE_KONDUCTOR} ]]; then

  # Clean/Prep
  podman pod rm --force cloudctl
  podman image prune --all --force

  # Pull images from local tar files
  for IMG in ${import_list}; do
      echo ">> Loading Konductor Image from ${IMG}"
      podman load --input ${IMG}
  done
else

    # Pull from public internet if tar not found 
    echo ">> Pulling Konductor Image from DockerHub Repo"
    podman pull docker.io/containercraft/konductor:latest
fi

# Run konductor image
time sudo podman run -it --rm --pull never \
    -h ${project} --name ${project}               \
    --entrypoint ./site.yml --privileged          \
    --volume /tmp/.ssh:/root/.ssh:z               \
    --workdir /root/platform/iac/cloudctl         \
    --volume $(pwd):/root/platform/iac/cloudctl:z \
  docker.io/containercraft/konductor:latest
