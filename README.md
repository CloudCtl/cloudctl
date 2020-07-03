# Coffer | Artifact Rake & Bundle Appliance
## 1. Create base ArtifactBundle asset images & directories
```
mkdir -p ${HOME}/coffer
```
## 2. Launch ContainerOne Point of Origin Container
```
sudo podman run \
    -qit --rm                            \
    -h coffer                            \
    --name coffer                        \
    --entrypoint=/bin/bash               \
    --volume ${HOME}/TRNO:/root/deploy:z \
  quay.io/containercraft/coffer
```
# Demo:
  - Building the bundle    
![bundle](./web/bundle.svg)
