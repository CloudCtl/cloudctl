## Prepare Developer Environment
    1. Create persistence directories
```
mkdir /tmp/{koffer,mirror,images,docker}
```
    2. Stash pull secret
>  - Copy Quay.io Pull Secret
>  - https://cloud.redhat.com/openshift/install/metal/user-provisioned
>  - Save in config.json
>

```
vim /tmp/docker/config.json
```
#### A. To run with persistent image storage for faster run times
```
sudo time podman run \
    --pull=always --entrypoint=/usr/bin/entrypoint \
    --rm -it -h koffer --name koffer               \
    --volume /tmp/.docker:/root/.docker:z          \
    --volume /tmp/koffer:/root/deploy/koffer:z     \
    --volume /tmp/mirror:/root/deploy/mirror       \
    --volume /tmp/images:/root/deploy/images       \
  docker.io/containercraft/koffer:nightlies
```

#### B. To Exec into container
```
sudo podman run \
    --pull=always --entrypoint=/bin/bash       \
    --rm -it -h koffer --name koffer           \
    --volume /tmp/.docker:/root/.docker:z      \
    --volume /tmp/koffer:/root/deploy/koffer:z \
    --volume /tmp/mirror:/root/deploy/mirror   \
    --volume /tmp/images:/root/deploy/images   \
  docker.io/containercraft/koffer:nightlies
```
  - Then start the rake process
```
 ./usr/bin/entrypoint
```
## Remove / Purge / Cleanup
```
sudo podman rm --force koffer
sudo podman rmi --force koffer:nightlies
sudo rm -rf /tmp/{koffer,mirror,images,docker}
```
