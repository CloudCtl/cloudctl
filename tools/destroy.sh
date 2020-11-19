#!/bin/bash -x
echo "THIS WILL DESTROY THE CLOUDCTL POD"
sleep 1
echo 5
sleep 1
echo 4
sleep 1
echo 3
sleep 1
echo 2
sleep 1
echo 1
sleep 1
echo "Goodbye"

podman pod kill cloudctl
podman pod rm cloudctl
podman image prune --all --force
