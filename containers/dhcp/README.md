![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/cloudctl/dhcp/dhcp/main?label=GH%20Actions&style=plastic) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cloudctl/dhcp?label=Size&style=plastic) ![Docker Pulls](https://img.shields.io/docker/pulls/cloudctl/dhcp?label=DockerHub%20Pulls&style=plastic)
    
Find on [Quay.io] or [DockerHub]
# TPDK [ISC DHCP] Container
```
git clone https://github.com/cloudctl/dhcp.git && cd dhcp
```
```sh
podman run -d --name dhcp \
    --net=host --cap-add=NET_ADMIN \
    --publish 172.10.0.3:67:67/udp \
    --volume ./config/dhcp:/etc/dhcp:z \
    --volume ./config/leases:/tmp/leases:z \
    --volume ./config/defaults:/etc/defaults:z \
  docker.io/cloudctl/dhcp:micro
```
[DockerHub]:https://hub.docker.com/r/cloudctl/dhcp
[Quay.io]:https://quay.io/repository/cloudctl/dhcp
[ISC DHCP]:https://www.isc.org/dhcp
