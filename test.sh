#!/bin/bash -x
podman run -d --rm --name nginx --pod cloudctl  \
    --volume /root/platform/nginx/html:/var/www/html:z \
    --volume /root/platform/nginx/nginx.conf:/etc/nginx/nginx.conf:z \
    --volume /root/platform/secrets/cloudctl/certs/ssl/server/cloudctl.crt:/nginx.crt \
    --volume /root/platform/secrets/cloudctl/certs/ssl/server/cloudctl.pem:/nginx.key \
  docker.io/containercraft/nginx
