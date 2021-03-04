![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/cloudctl/tftp/tftp/main?label=GH%20Actions&style=plastic) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cloudctl/tftp?label=Size&style=plastic) ![Docker Pulls](https://img.shields.io/docker/pulls/cloudctl/tftp?label=DockerHub%20Pulls&style=plastic)
        
Find on [Quay.io] or [DockerHub]
# TPDK [Tftpd] Container
```
git clone https://github.com/cloudctl/tftp.git && cd tftp
```
```sh
mkdir -p /tmp/tftp && \
podman run -d --name tftp \
    --publish 172.10.0.3:69:69/tcp \
    --volume /tmp/tftp:/var/lib/tftpboot:z \
  docker.io/cloudctl/tftp
```
[DockerHub]:https://hub.docker.com/r/cloudctl/tftp
[Quay.io]:https://quay.io/repository/cloudctl/tftp
[Tftpd]:https://mirrors.edge.kernel.org/pub/software/network/tftp/tftp-hpa/
