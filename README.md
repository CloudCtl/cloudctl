# Coffer | Artifact Rake & Bundle Appliance
## 1. Create base ArtifactBundle asset images & directories
```
mkdir -p ${HOME}/coffer
```
## 2. Launch ContainerOne Point of Origin Container
```
sudo podman run \
    --rm -qit -h coffer --name coffer              \
    --pull=always --entrypoint=/usr/bin/entrypoint \
    --volume ${HOME}/.docker:/root/.docker:z       \
    --volume ${HOME}/coffer:/root/deploy/coffer:z  \
    --volume /tmp/mirror:/root/deploy/mirror       \
    --volume /tmp/images:/root/deploy/images       \
  docker.io/containercraft/coffer
```
# Demo:
  - Building the bundle    
![bundle](./web/bundle.svg)
