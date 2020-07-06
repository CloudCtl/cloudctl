#!/bin/bash -x
originPwd=${OLDPWD}
clear
rm -rf /tmp/koffer
set -ex

# Requires jq
[[ $(which jq 2>&1 1>/dev/null ; echo $?) == 0 ]] || exit 1

# Static Variables
BRANCH="nightlies"
git clone https://github.com/containercraft/Koffer.git /tmp/koffer && cd /tmp/koffer
git checkout nightlies;

# Dynamic Variables
varUrlGit=$(git config --get remote.origin.url)
varVerOpenshift="$(curl --silent https://mirror.openshift.com/pub/openshift-v4/clients/ocp/candidate/release.txt | awk '/  Version/{print $2}')"
varVerTerraform="$(curl -sL https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r '.tag_name' | sed 's/v//g')"
varVerHelm="$(curl -sL https://api.github.com/repos/helm/helm/releases/latest | jq -r '.tag_name' | sed 's/v//g')"
varVerJq="$(curl -sL https://api.github.com/repos/stedolan/jq/releases/latest | jq -r '.tag_name' | sed 's/jq-//g')"

# Build
ls -lah /tmp/koffer
ln /tmp/koffer/container/Dockerfile /tmp/koffer/Dockerfile
cd /tmp/koffer
ls -lah Dockerfile
pwd
podman build \
    --file /tmp/koffer/Dockerfile \
    --build-arg varVerJq=${varVerJq} \
    --build-arg varUrlGit=${varUrlGit} \
    --build-arg varVerHelm=${varVerHelm} \
    --build-arg varVerTerraform=${varVerTerraform} \
    --build-arg varVerOpenshift=${varVerOpenshift} \
    --tag docker.io/containercraft/koffer:nightlies

rm -rf /tmp/koffer
cd ${originPwd}
podman images | grep 'koffer:latest'
