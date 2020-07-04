## A. To run with persistent image storage for faster run times
```
sudo time podman run \
    --rm -qit -h koffer --name koffer              \
    --pull=always --entrypoint=/usr/bin/entrypoint \
    --volume ${HOME}/.docker:/root/.docker:z       \
    --volume ${HOME}/koffer:/root/deploy/koffer:z  \
    --volume /tmp/mirror:/root/deploy/mirror       \
    --volume /tmp/images:/root/deploy/images       \
  docker.io/containercraft/koffer:nightlies
```

## B. To Exec into container
```
sudo time podman run \
    --rm -qit -h koffer --name koffer              \
    --pull=always --entrypoint=/bin/bash           \
    --volume ${HOME}/.docker:/root/.docker:z       \
    --volume ${HOME}/koffer:/root/deploy/koffer:z  \
    --volume /tmp/mirror:/root/deploy/mirror       \
    --volume /tmp/images:/root/deploy/images       \
  docker.io/containercraft/koffer:nightlies
```
  - Then start the rake process
```
 ./usr/bin/entrypoint
```
