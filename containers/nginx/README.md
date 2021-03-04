![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/cloudctl/nginx/nginx/main?label=GH%20Actions&style=plastic) ![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/cloudctl/nginx?label=Size&style=plastic) ![Docker Pulls](https://img.shields.io/docker/pulls/cloudctl/nginx?label=DockerHub%20Pulls&style=plastic)

Find on [Quay.io] or [DockerHub]
# TPDK Nginx Container
### Simple [Nginx] service running on [ubi-minimal] 8.x
```sh
podman run -d --rm --name nginx \
    --publish 8082:8080 --publish 8843:8843 \
    --volume ./html:/var/www/html:z \
    --volume ./service.crt:/nginx.crt \
    --volume ./service.key:/nginx.key \
    --volume ./nginx.conf:/etc/nginx/nginx.conf:z \
  docker.io/cloudctl/nginx
```
[Nginx]:https://www.nginx.com/
[ubi-minimal]:https://catalog.redhat.com/software/containers/ubi8/ubi-minimal/5c359a62bed8bd75a2c3fba8
[DockerHub]:https://hub.docker.com/r/cloudctl/nginx
[Quay.io]:https://quay.io/repository/cloudctl/nginx
