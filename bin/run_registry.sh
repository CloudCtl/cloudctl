#!/bin/bash -x
start () {
  registry serve /etc/docker/registry/config.yml 2>&1 1>/dev/null &
}
start
