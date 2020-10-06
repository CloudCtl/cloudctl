## Example

### Requires:
  - `~/.docker/config.json` configured with [quay pull secret](https://cloud.redhat.com/openshift/install/metal/user-provisioned)
    
-------------------------------------------------------------------------

### Run with upstream config (remote sparta.yml)
  1. Execute Koffer
```
cat <<EOF > run.sh && chmod +x run.sh && ./run.sh
#!/bin/bash -x
mkdir -p ~/bundle
sudo podman run -it --rm --pull always \
    --volume $(pwd)/bundle:/root/deploy/bundle:z \
    --volume ${HOME}/.docker:/root/.docker:z \
  docker.io/codesparta/koffer bundle --silent \
    --config https://codectl.io/docs/config/stable/sparta.yml
EOF
```

-------------------------------------------------------------------------

### Run with local config (volume mount sparta.yml)
  1. Write declarative Koffer Config
```
cat <<EOF > /tmp/sparta.yml
koffer:
  silent: true
  plugins:
    collector-infra:
      service: github.com
      organization: codesparta
      branch: master
      version: 4.5.11
EOF
```
  2. Execute Koffer
```
cat <<EOF > run.sh && chmod +x run.sh && ./run.sh
#!/bin/bash -x
mkdir -p ~/bundle
sudo podman run -it --rm --pull always \
    --volume $(HOME)/bundle:/root/deploy/bundle:z \
    --volume ${HOME}/.docker/config.json:/root/.docker/config.json:z \
    --volume /tmp/sparta.yml:/root/.koffer/config.yml:z \
  docker.io/codesparta/koffer bundle --silent
EOF
