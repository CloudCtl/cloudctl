#!/bin/bash -x
sudo podman run -it --rm --name go-build \
    --volume $(pwd)/bin:/tmp/bin:z \
    --entrypoint /root/dev/build.sh \
    --volume $(pwd)/entrypoint:/root/dev:z \
  docker.io/ocpredshift/red-gotools
    
