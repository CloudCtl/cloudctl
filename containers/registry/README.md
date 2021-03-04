![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/cloudctl/registry/registry/main?label=GH%20Actions&style=plastic) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cloudctl/registry?label=Size&style=plastic) ![Docker Pulls](https://img.shields.io/docker/pulls/cloudctl/registry?label=DockerHub%20Pulls&style=plastic)    
Find on [Quay.io] or [DockerHub]
# TPDK Docker Registry Container
### Simple Docker Registry running in [ubi-minimal] 8.x
```sh
mkdir -p /tmp/registry/images && \
podman run -d --rm \
    --publish 5000:5000 \
    --volume /tmp/registry/images:/var/lib/registry:z \
  docker.io/cloudctl/registry
```
# About    
This [Red Hat UBI] 8.x based [Docker Registry] Container represents
a completely backwards compatible docker registry and can be used 
interchangeably with the upstream image `docker.io/library/registry`

[ubi-minimal]:https://catalog.redhat.com/software/containers/ubi8/ubi-minimal/5c359a62bed8bd75a2c3fba8
[DockerHub]:https://hub.docker.com/r/cloudctl/registry
[Quay.io]:https://quay.io/repository/cloudctl/registry
[Docker Registry]:https://hub.docker.com/_/registry
[Red Hat UBI]:https://developers.redhat.com/products/rhel/ubi
