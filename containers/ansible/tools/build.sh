#!/bin/bash

fetch_vars () {
echo ">> Collecting run variables"
varrundate=$(date +%y%m%d%I%M%S)

cat <<EOF
>> Detected:
      RunDate:            $varrundate

EOF
}

pull_images () {
PULL_LIST="\
quay.io/cloudctl/ubi:builder \
"

for i in ${PULL_LIST}; do
  echo ">>  Pulling image: $i"
  sudo podman pull $i
  echo
done
}

run_build () {
  echo ">> Building Koffer"
  sudo podman build \
    -f Dockerfile \
    -t localhost/ansible:latest
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
