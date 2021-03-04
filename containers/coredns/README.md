![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/cloudctl/coredns/coredns/main?label=GH%20Actions&style=plastic) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cloudctl/coredns?label=Size&style=plastic) ![Docker Pulls](https://img.shields.io/docker/pulls/cloudctl/coredns?label=DockerHub%20Pulls&style=plastic)

Find on [Quay.io] or [DockerHub]
# TPDK CoreDNS Container
```sh
podman run -d --rm \
    --name haproxy \
    --publish 53:5353 \
    --volume ./config.json:/CoreFile:z \
    --volume ./core.db:/root/core.db:z \
  docker.io/cloudctl/coredns
```
[CoreDNS]:https://coredns.io
[ubi-minimal]:https://catalog.redhat.com/software/containers/ubi8/ubi-minimal/5c359a62bed8bd75a2c3fba8
[DockerHub]:https://hub.docker.com/r/cloudctl/coredns
[Quay.io]:https://quay.io/repository/cloudctl/coredns
