# Koffer | Artifact Rake & Bundle Appliance
## About
Koffer is an ansible automation runtime for raking in various artifacts required 
to deploy Kubernetes Infrastructure, Pipelines, and applications into airgaped 
environments. Koffer is strictly an ansible consumer and requires run against an 
external repo volume mounted to `/root/koffer`.

Compatibile Types:
  - git
  - terraform 
    - performs terraform init at time of capture
  - docker images
    - hydrates built in docker registry service to host local path
    - high side is served with generic docker registry:2 container
  - capability to add more artifact types with custom external ansible

## Result
Koffer produces a standardized tarball on the host at `/tmp/koffer/bundle/koffer-bundle.*.tar.xz`

## Run
### 1. Create Koffer Bundle Directory
  - example with [koffer-openshift](https://github.com/containercraft/koffer-openshift) ansible automation
```
git clone https://github.com/containercraft/koffer-openshift.git /tmp/koffer
```
### 2. Run Koffer
```
sudo podman run \
    --rm -qit -h koffer --name koffer     \
    --pull=always --entrypoint entrypoint \
    --volume ~/.docker:/root/.docker:z    \
    --volume /tmp/koffer:/root/koffer:z   \
  docker.io/containercraft/koffer:latest
```
  - optional: volume mount quay pull secret from host    
    `--volume ~/.docker:/root/.docker/`
### 3. Verify & Transport Bundle
```
 ls /tmp/koffer/bundle/
```
# [Developer Docs & Utils](./dev)
# Demo
![bundle](./web/bundle.svg)

