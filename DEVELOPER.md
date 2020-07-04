## A. To run with persistent image storage for faster run times
```
sudo time podman run \
    --pull=always --entrypoint=/usr/bin/entrypoint \
    --rm -qit -h koffer --name koffer              \
    --volume /tmp/.docker:/root/.docker:z          \
    --volume /tmp/koffer:/root/deploy/koffer:z     \
    --volume /tmp/mirror:/root/deploy/mirror       \
    --volume /tmp/images:/root/deploy/images       \
  docker.io/containercraft/koffer:nightlies
```

## B. To Exec into container
```
sudo time podman run \
    --pull=always --entrypoint=/bin/bash       \
    --rm -qit -h koffer --name koffer          \
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
