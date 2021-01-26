![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/cloudctl/koffer/koffer/main?style=plastic) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cloudctl/koffer?style=plastic) ![Docker Pulls](https://img.shields.io/docker/pulls/cloudctl/koffer?style=plastic)
    
# Koffer | Artifact Rake & Bundle Appliance
## About
Koffer is an automation runtime for raking in various artifacts required to
deploy Kubernetes Infrastructure, Pipelines, and applications into airgaped 
environments. Koffer is strictly an ansible consumer and requires run against
external repo volume cloned or mounted inside the container at `/root/koffer`.

## Creates
Koffer produces a standardized tarball of all artifacts ready for transport

## Supports
Compatibile Artifact Types:
  - git repos
  - terraform codebases 
    - performs terraform init at time of capture
  - docker images
    - Pulls & hydrates built in docker registry service to persistent local path
    - high side is served with generic docker registry:2 container
  - capability to add more artifact types with custom collector plugins

## How To
### 1. Create Koffer Bundle Directory
```
mkdir -p ~/bundle
```
### 2.a Run Koffer
  - Example: [collector-ocp](https://github.com/CodeSparta/collector-ocp) plugin
```
podman run -it --rm --pull always \
    --volume ${HOME}/bundle:/root/bundle:z \
  docker.io/cloudctl/koffer bundle \
        --config https://codectl.io/docs/config/stable/sparta.yml
```
### 2.b Run Koffer with nested container build support
  - Example: [collector-operators](https://github.com/CodeSparta/collector-operators) plugin
  - Depends: `dnf install fuse-overlayfs`
```
sudo podman run -it --rm \
    --env BUNDLE=false \
    --env OPERATORS='cluster-logging,rhsso-operator,servicemeshoperator' \
    --volume ${HOME}/operators:/root/operators:z \
    --volume ${HOME}/bundle:/root/bundle:z \
    --privileged --device /dev/fuse \
  quay.io/cloudctl/koffer:extra bundle \
    --plugin collector-operators
```
### 3. Verify Bundle
```
 sudo du -sh ~/bundle/*
```
