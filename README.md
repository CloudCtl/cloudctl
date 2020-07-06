# Koffer | Artifact Rake & Bundle Appliance
### 1. Create Koffer Bundle Directory
  - example with [koffer-openshift] ansible automation
```
git clone https://github.com/containercraft/koffer-openshift.git /tmp/koffer
```
### 2. Run Koffer
```
sudo podman run \
    --rm -qit -h koffer --name koffer              \
    --volume /tmp/koffer:/root/deploy/koffer:z     \
    --pull=always --entrypoint=/usr/bin/entrypoint \
    --volume ~/.docker:/root/.docker               \
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
[koffer-openshift]:https://github.com/containercraft/koffer-openshift
