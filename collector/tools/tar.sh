#!/bin/bash -ex
declare -A img_table=(\
  ['konductor']="docker.io/containercraft/konductor" \
  ['runner']="docker.io/containercraft/ansible-runner-service" \
  ['registry']="docker.io/library/registry" \
  ['pause']="k8s.gcr.io/pause" \
)

for img in "${!img_table[@]}"; do
  echo ">> Pulling ${img} Image" 
  podman pull "${img_table[$img]}":latest
  echo ">> Saving ${img} Image" 
  podman save \
   --output bundle/image-${img}-latest.tar \
   --format oci-archive "${img_table[$img]}":latest
  echo ">> File Saved: $(du -sh ./bundle/image-${img}-latest.tar)" 
done

podman image prune --all --force
