#!/bin/bash
project="init"
dir_bundle="$(pwd)/images"
IMPORT_LIST="$(ls ${dir_bundle})"

# Stage SSH Credentials
sudo rm -rf /tmp/.ssh
sudo cp -rf ~/.ssh /tmp/

# Load cloudctl seed images
if [[ ! -z "${IMPORT_LIST}" ]]; then

  # Clean/Prep
  podman pod rm --force cloudctl 2>/dev/null
  podman image prune --all --force

  # Pull images from local tar files
  for IMG in ${IMPORT_LIST}; do
      echo ">> Loading Konductor Image from ${IMG}"
      podman load --input ${dir_bundle}/${IMG}
  done
else

    # Pull from public internet if tar not found 
    echo ">> Pulling Konductor Image from DockerHub Repo"
    podman pull quay.io/cloudctl/konductor:latest
fi

# Run konductor image
time sudo podman run -it --rm --pull never \
    -h ${project} --name ${project}               \
    --entrypoint ./site.yml --privileged          \
    --volume /tmp/.ssh:/root/.ssh:z               \
    --workdir /root/platform/iac/cloudctl         \
    --volume $(pwd):/root/platform/iac/cloudctl:z \
  quay.io/cloudctl/konductor:latest
