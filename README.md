# koffer | Artifact Rake & Bundle Appliance
## 1. Create base ArtifactBundle asset images & directories
```
mkdir -p ${HOME}/koffer
```
## 2. Launch ContainerOne Point of Origin Container
```
sudo time podman run \
    --rm -qit -h koffer --name koffer              \
    --pull=always --entrypoint=/usr/bin/entrypoint \
    --volume ${HOME}/koffer:/root/deploy/koffer:z  \
  docker.io/containercraft/koffer:nightlies
```
# Demo:
  - Building the bundle    
![bundle](./web/bundle.svg)
