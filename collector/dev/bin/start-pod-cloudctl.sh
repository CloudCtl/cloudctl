#!/bin/bash
#set -x

## Purge running cloudctl containers & pod
run_purge () {
listPurge=$(podman ps -a | grep -v CONTAINER | awk '/one|registry|nginx/{print $1}')
for container in ${listPurge}; do
  podman rm --force ${container};
done
podman pod rm --force cloudctl
}; run_purge

clear;
set -e

start_pod () {
# Start CloudCtl Pod
podman pod create \
 --publish 80:8080 \
 --publish 2022:2022 \
 --publish 5000:5000 \
 --name cloudctl 1>/dev/null 
}

start_container_one () {
# Start ContainerOne
podman run \
    --detach --quiet \
    --pod cloudctl \
    --restart always \
    --workdir /root/platform \
    --entrypoint entrypoint \
    --name one --hostname one \
    --volume /root/platform/:/root/platform:z \
  docker.io/containercraft/one:nightlies 1>/dev/null \
  && sleep 2 \
  && printf '       ' &&  podman exec -it one /bin/bash -c 'env | grep varVerOpenshift'
}

start_container_registry () {
# Start Docker Registry
podman run \
    --detach \
    --pod cloudctl \
    --restart always \
    --name registry --hostname registry \
    --volume /root/platform/mirror:/root/platform/mirror \
    --volume /root/platform/secrets/registry/ssl:/etc/docker/registry/ssl:ro \
    --volume /root/platform/secrets/registry/auth:/etc/docker/registry/auth:ro \
    --volume /root/platform/mirror/config.yml:/etc/docker/registry/config.yml:ro \
  docker.io/library/registry:2.7.0 1>/dev/null \
  && sleep 2 \
  && printf '       ' && curl -u cloudctl:cloudctl -k https://localhost:5000/v2/_catalog
}

start_container_nginx () {
podman run \
    --detach \
    --pod cloudctl \
    --restart always \
    --name nginx --hostname nginx \
    --volume /root/platform/nginx:/usr/share/nginx/html:ro \
  docker.io/library/nginx:latest 1>/dev/null 
}

write_kube_pod_yml () {
# Stash pod config
podman generate kube cloudctl > /tmp/pod-cloudctl.yml
podman generate systemd cloudctl > /tmp/systemd-cloudctl.service
}

run_core () {
echo "  >> Starting CloudCtl Pod" \
  && start_pod;
echo "  >> Starting Container One" \
  && start_container_one;
echo "  >> Starting Container Registry" \
  && start_container_registry;
echo "  >> Starting Container Nginx" \
  && start_container_nginx;

cat <<EOF 
  >> Writing Kube Pod Startup Assets:

       Kube Pod Yaml   - /tmp/pod-cloudctl.yml
       Systemd Service - /tmp/systemd-cloudctl.service

EOF
  write_kube_pod_yml;

podman pod ps;
podman ps;
echo;
}

run_core
