# Coffer | Artifact Rake & Bundle Appliance
## 1. Create base ArtifactBundle asset images & directories
```
mkdir -p ${HOME}/coffer
```
## 2. Launch ContainerOne Point of Origin Container
```
sudo time podman run \
    --rm -qit -h coffer --name coffer              \
    --pull=always --entrypoint=/usr/bin/entrypoint \
    --volume ${HOME}/coffer:/root/deploy/coffer:z  \
  docker.io/containercraft/coffer:nightlies
```
# Demo:
  - Building the bundle    
![bundle](./web/bundle.svg)
