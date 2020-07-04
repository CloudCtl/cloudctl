# Coffer | Artifact Rake & Bundle Appliance
## 1. Create base ArtifactBundle asset images & directories
```
mkdir -p ${HOME}/coffer
```
## 2. Launch ContainerOne Point of Origin Container
```
sudo podman run \
    --entrypoint=/bin/bash                 \
    -qit --rm --pull=always                \
    -h coffer --name coffer                \
    --volume ${HOME}/coffer:/root/deploy:z \
  quay.io/containercraft/coffer
```
# Demo:
  - Building the bundle    
![bundle](./web/bundle.svg)
