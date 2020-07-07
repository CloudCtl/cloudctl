## Developer Guide
------------
#### 0. (OPTIONAL) Build Locally
```
  curl https://git.io/JJtGZ | bash -x
```
#### 1. Clone codebase under development & checkout your branch
```
 git clone https://github.com/containercraft/koffer-openshift.git /tmp/koffe
 git checkout nightlies
```
#### 2. Prepare Developer Environment
  a. Stash pull secret
>  - Copy Quay.io Pull Secret
>  - https://cloud.redhat.com/openshift/install/metal/user-provisioned
>  - Save in config.json
>

```
vim /tmp/docker/config.json
```
  b. Create persistence directories for quicker subsequent runs
```
mkdir -p /tmp/{mirror,images,docker}
```
#### 3. Run Container
  - Option A. Run entrypoint with persistent image storage for faster run times
```
sudo podman run \
    --entrypoint entrypoint                        \
    --rm -it -h koffer --name koffer               \
    --volume /tmp/docker:/root/.docker:z           \
    --volume /tmp/koffer:/root/koffer:z            \
    --volume /tmp/mirror:/root/deploy/mirror:z     \
    --volume /tmp/images:/root/deploy/images:z     \
  docker.io/containercraft/koffer:nightlies
```

  - Option B. Exec into container for manual development
```
sudo podman run \
    --entrypoint bash                              \
    --rm -it -h koffer --name koffer               \
    --volume /tmp/docker:/root/.docker:z           \
    --volume /tmp/koffer:/root/koffer:z            \
    --volume /tmp/mirror:/root/deploy/mirror:z     \
    --volume /tmp/images:/root/deploy/images:z     \
  docker.io/containercraft/koffer:nightlies
```
  - Then manually exec the `/usr/bin/entrypoint` actions
```
 git pull;
 git checkout nightlies;
 ./usr/bin/run_registry.sh
 ./tree.yml
 ./secrets.yml
 ./git.yml
 ./images.yml
 ./bundle.yml
 du -sh /root/deploy/koffer/koffer-bundle.*.tar
```
#### 4. Place bundle on CloudCtl Bastion host /tmp directory
```
rsync --progress -avzh $(ls /tmp/koffer/koffer-bundle.*.tar) \
  -e "ssh -i ~/.ssh/id_rsa" core@${bastion_address}:/tmp/
```
#### 5. Aquire root & unpack tarball
```
sudo -i
```
```
tar -xv -C /root -f /tmp/koffer-bundle.*.tar
```
#### 5. Run CloudCtl stand up script
```  6
 ./start-cloudctl.sh
```
#### 7. Exec into CloudCtl
```
 podman exec -it one connect
```
## Remove / Purge
#### Cleanup Koffer Artifacts
```
sudo podman rmi --force koffer:nightlies
sudo rm -rf /tmp/koffer/koffer-bundle.*.tar
sudo rm -rf /root/{deploy,cloudctl.yml,start-cloudctl.sh,ArtifactsBundle.tar.xz.sha256,ArtifactsBundle.tar.xz}
sudo rm -rf /tmp/{koffer,mirror,images}
```
#### Cleanup CloudCtl Artifacts
```
sudo podman pod rm --force cloudctl
for container in $(sudo podman ps -a | grep -v CONTAINER | awk '/busybox|one|registry|nginx/{print $1}'); do sudo podman rm --force ${container}; done
for container in $(sudo podman images | grep -v CONTAINER | awk '/koffer|pause|busybox|one|registry|nginx/{print $3}'); do sudo podman rmi --force ${container}; done
```
[this script]:https://github.com/containercraft/Koffer/blob/nightlies/dev/bin/build-local.sh
