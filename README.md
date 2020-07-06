# Koffer | Artifact Rake & Bundle Appliance
## About
Koffer is an ansible automation runtime for raking in various artifacts required 
to deploy Kubernetes Infrastructure, Pipelines, and applications into airgaped 
environments. Koffer is strictly an ansible consumer and requires run against an 
external repo volume mounted to /root/koffer.

Compatibile Types:
  - git
  - terraform 
    - performs terraform init at time of capture
  - docker images
    - hydrates built in docker registry service to host local path
    - high side is served with generic docker registry:2 container
  - capability to add more artifact types with custom external ansible

## Run
### 1. Create Koffer Bundle Directory
  - example with [koffer-openshift](https://github.com/containercraft/koffer-openshift) ansible automation
```
git clone https://github.com/containercraft/koffer-openshift.git /tmp/koffer
```
### 2. Run Koffer
```
sudo podman run \
    --rm -qit -h koffer --name koffer              \
    --pull=always --entrypoint bash                \
    --volume ~/.docker:/root/.docker               \
    --volume /tmp/koffer:/root/deploy/koffer:z     \
  docker.io/containercraft/koffer:latest
```
  - optional: volume mount quay pull secret from host    
    `--volume ~/.docker:/root/.docker/`
### 3. Move Koffer Bundle to target host /tmp directory
### 4. Aquire root & unpack tarball
```
sudo -i
```
```
tar -xv -C /root -f /tmp/koffer-bundle.*.tar
```
### 5. Run CloudCtl stand up script
```
 ./start-cloudctl.sh
```
#### 6. Exec into CloudCtl
```
 podman exec -it cloudctl-one connect
```
# [Developer Docs & Utils](./dev)
# Demo
![bundle](./web/bundle.svg)

