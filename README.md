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
  - Example: [collector-infra](https://github.com/codesparta/collector-infra) plugin

### 1. Create Koffer Bundle Directory
```
mkdir -p ~/bundle
```
### 2. Run Koffer
```
sudo podman run -it --rm --pull always \
    --volume $(pwd)/bundle:/root/deploy/bundle:z \
  docker.io/codesparta/koffer bundle \
        --config https://git.io/JUzf0
```
### 3. Verify Bundle
```
 sudo du -sh ~/bundle/*
```
