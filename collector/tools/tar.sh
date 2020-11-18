#!/bin/bash -e

# Offline Image Table
declare -A img_table=(\
  ['pause']="k8s.gcr.io/pause" \
  ['runner']="quay.io/cloudctl/runner" \
  ['registry']="quay.io/cloudctl/registry" \
  ['konductor']="quay.io/cloudctl/konductor" \
)
dir_bundle="$(pwd)/bundle"
mkdir -p {dir_bundle}
rm -rf ${dir_bundle}/*.tar

# Check for & remove pre-existing cloudctl pod and images
cloudctl_pod=$(podman pod ps --no-trunc | awk '/cloudctl/{print $1}')
if [[ ! -z ${cloudctl_pod} ]]; then
  podman pod rm --force ${cloudctl_pod}
fi

# Purge old images
podman image prune --all --force

# Pull & Save Images to Tar Files
for img in "${!img_table[@]}"; do

  # Pull IMG
  echo ">> Pulling ${img} Image" 
  podman pull -q "${img_table[$img]}":latest

  # Save IMG
  echo ">> Saving ${img} Image" 
  podman save \
   --output ${dir_bundle}/image-${img}-latest.tar \
   --format oci-archive "${img_table[$img]}":latest

  # Report Img size on Console
  echo ">> File Saved: $(du -sh ${dir_bundle}/image-${img}-latest.tar)" 

done

# Remove cached images
podman image prune --all --force
