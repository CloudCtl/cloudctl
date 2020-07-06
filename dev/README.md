## Developer Guide
------------
#### 0. (OPTIONAL) Locally Build the Koffer image
  - DISCLAIMER [this script] may break intermitently
```
curl -L https://git.io/JJIBr | bash
```
#### 1. Prepare Developer Environment
  a. Create persistence directories
```
mkdir -p /tmp/{koffer,mirror,images,docker}
```
  b. Stash pull secret
>  - Copy Quay.io Pull Secret
>  - https://cloud.redhat.com/openshift/install/metal/user-provisioned
>  - Save in config.json
>

```
vim /tmp/docker/config.json
```
#### 2. Run Container
  - Option A. Run with persistent image storage for faster run times
```
sudo podman run \
    --entrypoint entrypoint                        \
    --rm -it -h koffer --name koffer               \
    --volume /tmp/docker:/root/.docker:z           \
    --volume /tmp/koffer:/root/deploy/koffer:z     \
    --volume /tmp/mirror:/root/deploy/mirror:z     \
    --volume /tmp/images:/root/deploy/images:z     \
  docker.io/containercraft/koffer:latest
```
  - Option B. Exec into container for manual development
```
sudo podman run \
    --entrypoint bash                          \
    --rm -it -h koffer --name koffer           \
    --volume /tmp/docker:/root/.docker:z       \
    --volume /tmp/koffer:/root/deploy/koffer:z \
    --volume /tmp/mirror:/root/deploy/mirror:z \
    --volume /tmp/images:/root/deploy/images:z \
  docker.io/containercraft/koffer:latest
```
  - Then manually exec the `/usr/bin/entrypoint` actions
```
 git pull;
 git checkout master;
 ./usr/bin/run_registry.sh
 ./tree.yml
 ./secrets.yml
 ./git.yml
 ./images.yml
 ./bundle.yml
 du -sh /root/deploy/koffer/koffer-bundle.*.tar
```
#### 3. Place bundle on CloudCtl Bastion host /tmp directory
```
rsync --progress -avzh $(ls /tmp/koffer/koffer-bundle.*.tar) \
  -e "ssh -i ~/.ssh/id_rsa" core@${bastion_address}:/tmp/
```
#### 4. Aquire root & unpack tarball
```
sudo -i
```
```
tar -xv -C /root -f /tmp/koffer-bundle.*.tar
```
#### 5. Run CloudCtl stand up script
```
 ./start-cloudctl.sh
```
#### 6. Exec into CloudCtl
```
 podman exec -it one connect
```
## Remove / Purge
#### Cleanup Koffer Artifacts
```
sudo podman rmi --force koffer:latest
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
[this script]:https://github.com/containercraft/Koffer/blob/master/dev/bin/build-local.sh
