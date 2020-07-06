# Koffer | Artifact Rake & Bundle Appliance
### 1. Create Koffer Bundle Directory
```
mkdir -p /tmp/koffer
```
### 2. Run Koffer
```
sudo podman run \
    --rm -qit -h koffer --name koffer              \
    --volume /tmp/koffer:/root/deploy/koffer:z     \
    --pull=always --entrypoint=/usr/bin/entrypoint \
  docker.io/containercraft/koffer:nightlies
```
  - optional: volume mount quay pull secret from host    
    `--volume ~/.docker/config.json:/root/.docker/config.json`
### 3. Check Bundle
```
du -h /tmp/koffer/koffer-bundle.*.tar
```
### 4. Move Koffer Bundle to target host /tmp directory
### 5. Aquire root & unpack tarball
```
sudo -i
```
```
tar -xv -C /root -f /tmp/koffer-bundle.*.tar
```
### 6. Run CloudCtl stand up script
```
 . ./start-cloudctl.sh
```
# [Developer Docs & Utils](./dev)
# Demo
![bundle](./web/bundle.svg)
