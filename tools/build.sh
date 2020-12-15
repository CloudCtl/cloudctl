#!/bin/bash

fetch_vars () {
echo ">> Collecting run variables"
varrundate=$(date +%y%m%d%I%M%S)
varverhelm=$(curl -sL https://api.github.com/repos/helm/helm/releases/latest | jq -r '.tag_name' | sed 's/v//g')
varverjq=$(curl -sL https://api.github.com/repos/stedolan/jq/releases/latest | jq -r '.tag_name' | sed 's/jq-//g')
varvergrpcurl=$(curl -sL https://api.github.com/repos/fullstorydev/grpcurl/releases/latest | jq -r '.tag_name' | sed 's/v//g')
varverterraform=$(curl -sL https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r '.tag_name' | sed 's/v//g')
varveropm=$(curl -sL https://api.github.com/repos/operator-framework/operator-registry/releases/latest | jq -r '.tag_name' | sed 's/v//g')
varveropenshift=$(curl --silent https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/release.txt | awk '/  Version/{print $2}')
cat <<EOF
>> Detected:
      RunDate:            $varrundate
      JQ Version:         $varverjq
      Helm Version:       $varverhelm
      OPM Version:        $varveropm
      GrpCurl Version:    $varvergrpcurl
      Terraform Version:  $varverterraform
      OpenShift Version:  $varveropenshift
EOF
}

pull_images () {
PULL_LIST="\
docker.io/library/centos:latest
quay.io/cloudctl/registry:latest
quay.io/cloudctl/koffer-go:latest
registry.access.redhat.com/ubi8/ubi:latest
quay.io/openshift/origin-operator-registry:latest
"

for i in ${PULL_LIST}; do
  echo ">>  Pulling image: $i"
  sudo podman pull $i
done
}

run_build () {
  sudo podman build \
    -f Dockerfile \
    --build-arg varVerJq=${varverjq} \
    --build-arg varVerOpm=${varveropm} \
    --build-arg varVerHelm=${varverhelm} \
    --build-arg varRunDate=${varrundate} \
    --build-arg varVerGrpcurl=${varvergrpcurl} \
    --build-arg varVerTerraform=${varverterraform} \
    --build-arg varVerOpenshift=${varveropenshift} \
    -t localhost/koffer:${varveropenshift}
}

main () {
  fetch_vars
  pull_images
  run_build
}

main
