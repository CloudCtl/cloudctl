![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/cloudctl/haproxy/haproxy/main?label=GH%20Actions&style=plastic) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cloudctl/haproxy?label=Size&style=plastic) ![Docker Pulls](https://img.shields.io/docker/pulls/cloudctl/haproxy?label=DockerHub%20Pulls&style=plastic)    
Find on [Quay.io] or [DockerHub]
    
# TPDK [HAProxy] [Load Balancer] Container
```sh
sudo podman run -d --rm                    \
    --name     haproxy                     \
    --publish  172.10.0.3:80:8080          \
    --publish  172.10.0.3:443:8843         \
    --volume   haproxy.cfg:/haproxy.cfg:ro \
  docker.io/cloudctl/haproxy
```
[Podman]:https://podman.io
[HAProxy]:https://haproxy.org
[Load Balancer]:https://blog.openshift.com/an-open-source-load-balancer-for-openshift/
[Application Router]:https://blog.openshift.com/ocp-custom-routing/
[DockerHub]:https://hub.docker.com/r/cloudctl/haproxy
[Quay.io]:https://quay.io/repository/cloudctl/haproxy
