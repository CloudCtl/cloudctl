## Developer Guide
------------
#### 0. (OPTIONAL) Build Koffer Locally
Requires:     
  - podman    
  - git    
```
  curl -L https://git.io/JLmUA | bash
```
#### 1. Clone Project & Checkout desired branch
```
 git clone https://github.com/cloudctl/koffer.git /tmp/koffer
 git checkout feature-abc
```
#### 2. Prepare Developer Environment
  a. Create persistence directories for quicker subsequent runs
```
vim /tmp/docker/config.json
```
  b. Stash pull secret
>  - Copy Quay.io Pull Secret
>  - https://cloud.redhat.com/openshift/install/metal/user-provisioned
>  - Save in /tmp/config.json
>

```
mkdir -p /tmp/{docker,bundle,platform}
```
#### 3. Run Koffer
  - Option A. Run entrypoint with persistent image storage for faster run times
```
sudo podman run --pull always \
    --rm -it -h koffer --name koffer         \
    --volume /tmp/platform:/root/platform:z  \
    --volume $(pwd)/koffer:/root/koffer:z    \
    --volume /tmp/docker:/root/.docker:z     \
    --volume /tmp/bundle:/root/bundle:z      \
  quay.io/cloudctl/koffer
```

  - Option B. Exec into container for manual development
```
sudo podman run --pull always \
    --rm -it -h koffer --name koffer         \
    --volume /tmp/platform:/root/platform:z  \
    --volume /tmp/docker:/root/.docker:z     \
    --volume /tmp/bundle:/root/bundle:z      \
    --entrypoint bash                        \
  quay.io/cloudctl/koffer
```

  - Then manually run the koffer utility
```
  koffer bundle --plugin openshift-iac --plugin cloudctl --plugin collector-ocp
```
