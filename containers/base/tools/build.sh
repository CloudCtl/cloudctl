#!/bin/bash

fetch_vars () {
echo ">> Collecting run variables"
varrundate=$(date +%y%m%d%I%M%S)
varimgname=ubi

cat <<EOF
>> Detected:
      RunDate:            $varrundate
EOF
}

pull_images () {
PULL_LIST="\
registry.access.redhat.com/ubi8/ubi \
"

for i in ${PULL_LIST}; do
  echo ">>  Pulling image: $i"
  sudo podman pull $i
  echo
done
}

prep_project () {
  echo ">> Building project in /tmp/cloudctl"
  sudo rm -rf /tmp/cloudctl
  git clone https://github.com/CloudCtl/builder.git /tmp/cloudctl
  cd /tmp/cloudctl
}

run_build () {
  echo ">> Building Micro"
  sudo podman build \
    -f Dockerfile.micro \
    -t cloudctl/ubi:micro
  echo
  echo ">> Building Minimal"
  sudo podman build \
    -f Dockerfile.minimal \
    -t cloudctl/ubi:minimal
  echo
  echo ">> Building Builder"
  sudo podman build \
    -f Dockerfile.builder \
    -t cloudctl/ubi:builder
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
