#!/bin/bash

fetch_vars () {
echo ">> Collecting run variables"
varrundate=$(date +%y%m%d%I%M%S)
varverhelm=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | awk -F '["v,]' '/tag_name/{print $5}')
varverjq=$(curl -s https://api.github.com/repos/stedolan/jq/releases/latest | awk -F '["jq-]' '/tag_name/{print $7}')
varvergrpcurl=$(curl -s https://api.github.com/repos/fullstorydev/grpcurl/releases/latest | awk -F '["v,]' '/tag_name/{print $5}')
varverterraform=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | awk -F '["v,]' '/tag_name/{print $5}')
varveropenshift=$(curl --silent https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/release.txt | awk '/  Version/{print $2}')
varveropm=$(curl -s https://api.github.com/repos/operator-framework/operator-registry/releases/latest | awk -F '["v,]' '/tag_name/{print $5}')

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
docker.io/library/centos:latest \
quay.io/cloudctl/registry:latest \
quay.io/cloudctl/koffer-go:latest \
registry.access.redhat.com/ubi8/ubi:latest \
quay.io/openshift/origin-operator-registry:latest \
"

for i in ${PULL_LIST}; do
  echo ">>  Pulling image: $i"
  sudo podman pull $i
  echo
done
}

prep_project () {
  echo ">> Building project in /tmp/koffer"
  sudo rm -rf /tmp/koffer
  git clone https://github.com/CloudCtl/Koffer.git /tmp/koffer
  cd /tmp/koffer
}

run_build () {
  echo ">> Building Koffer"
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
  clear
  fetch_vars
  pull_images
  prep_project
  run_build
  cd $START_DIR
}

main
