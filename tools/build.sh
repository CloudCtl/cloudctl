#!/bin/bash -x

varrundate=$(date +%y%m%d%I%M%S)
varverhelm=$(curl -sL https://api.github.com/repos/helm/helm/releases/latest | jq -r '.tag_name' | sed 's/v//g')
varverjq=$(curl -sL https://api.github.com/repos/stedolan/jq/releases/latest | jq -r '.tag_name' | sed 's/jq-//g')
varvergrpcurl=$(curl -sL https://api.github.com/repos/fullstorydev/grpcurl/releases/latest | jq -r '.tag_name' | sed 's/v//g')
varverterraform=$(curl -sL https://api.github.com/repos/hashicorp/terraform/releases/latest | jq -r '.tag_name' | sed 's/v//g')
varveropm=$(curl -sL https://api.github.com/repos/operator-framework/operator-registry/releases/latest | jq -r '.tag_name' | sed 's/v//g')
varveropenshift=$(curl --silent https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/release.txt | awk '/  Version/{print $2}')

sudo podman build \
    -f Dockerfile.test \
    --build-arg varVerJq=${varverjq} \
    --build-arg varVerOpm=${varveropm} \
    --build-arg varVerHelm=${varverhelm} \
    --build-arg varRunDate=${varrundate} \
    --build-arg varVerGrpcurl=${varvergrpcurl} \
    --build-arg varVerTerraform=${varverterraform} \
    --build-arg varVerOpenshift=${varveropenshift} \
    -t localhost/koffer:${varveropenshift}

