#!/bin/bash
project="init"
dir_seed="$(pwd)/images"
IMPORT_LIST="$(ls ${dir_seed})"
dir_bundle="$(pwd)/bundle"
EXTRACT_LIST="$(ls ${dir_bundle}/*.tar.xz 2>/dev/null)"

# For now, konductor operator collector must be run as root for cross os/release support
if (( $EUID != 0  )); then
  echo ">> Please run as root"
  exit 1
else

# konductor builds the cloudctl pod on the localhost over ansible ssh connection 
  ready=$(ssh root@localhost whoami ; echo $?)
  if [[ ! ${ready} == '0' ]] && \
     [[ ! ${ready} == '255' ]] && \
     [[ -f "/root/.ssh/id_rsa" ]]; then
        echo ">> Host ssh connection discovered successfully"
  else
        echo ">> Host ssh connection not found"
        echo ">> Configuring host for cni ssh connection"
        [[ -f ${HOME}/.ssh/id_rsa ]] \
        || ssh-keygen -f ${HOME}/.ssh/id_rsa -t rsa -N ''
        cat ${HOME}/.ssh/id_rsa.pub >> ${HOME}/.ssh/authorized_keys
        chmod 0644 ${HOME}/.ssh/authorized_keys
        
        sed -i 's/PermitRootLogin no/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
        systemctl restart sshd && sleep 2
        
        ready=$(ssh root@localhost whoami ; echo $?)
        if [[ ! ${ready} == 0 ]]; then
              echo ">> Host ssh connection configured successfully"
        else
              echo ">> Failed to configure localhost ssh connection."
              exit 1 
        fi
  fi
fi

mkdir -p /tmp/konductor
cp -rf ~/.ssh /tmp/konductor/.ssh

if [[ ! -z "${IMPORT_LIST}" ]]; then
  for i in ${EXTRACT_LIST}; do
    tar xvf ${i} -C /root
  done
fi

if [[ ! -z "${IMPORT_LIST}" ]]; then

  podman pod rm --force cloudctl 2>/dev/null
  podman image prune --all --force

  for IMG in ${IMPORT_LIST}; do
      echo ">> Loading Konductor Image from ${IMG}"
      podman load --input ${dir_seed}/${IMG}
  done
else
    echo ">> Pulling Konductor Image from DockerHub Repo"
    podman pull quay.io/cloudctl/konductor:latest
fi

sudo podman run -it --rm --pull never \
    -h ${project} --name ${project}               \
    --entrypoint bash --privileged                \
    --volume /tmp/konductor/.ssh:/root/.ssh:z     \
    --workdir /root/platform/iac/cloudctl         \
    --volume $(pwd):/root/platform/iac/cloudctl:z \
  quay.io/cloudctl/konductor:latest
