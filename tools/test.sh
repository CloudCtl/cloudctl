#!/bin/bash
podman pod rm --force $(cat ~/.ccio/run/cloudctlPod.id)
rm -rf ~/.ccio/run/cloudctlPod.id
