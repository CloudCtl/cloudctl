podman pull docker.io/containercraft/konductor:latest
podman save --output bundle/image-konductor-latest.tar --format oci-archive docker.io/containercraft/konductor:latest
podman image prune --all --force
