# Koffer | Artifact Rake & Bundle Appliance
Koffer is an all in one Kubernetes deployment dependenciesi package, image, & artifact 
capture utility designed to standardize the collection of all assets required to
successfully deploy a full Kubernetes environment, operators, pipeline, and 
applications in restricted or fully air-gapped environments. This capability
also eases the strain on low bandwidth connections where deployment may benefit
from local caching of initial deployment and operation dependencies.

# Get Started:
### 1. Create base ArtifactBundle asset images & directories
```
mkdir -p /tmp/koffer
```
### 2. Launch ContainerOne Point of Origin Container
```
sudo time podman run \
    --rm -qit -h koffer --name koffer              \
    --volume /tmp/koffer:/root/deploy/koffer:z     \
    --pull=always --entrypoint=/usr/bin/entrypoint \
  docker.io/containercraft/koffer:latest
```
## Demo:
  - Building the bundle    
![bundle](./web/bundle.svg)
