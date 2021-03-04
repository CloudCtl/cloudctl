#!/bin/bash -x
run_registry () {
  unset REGISTRY_AUTH_FILE
  registry serve /etc/docker/registry/config.yml $@ &
}
run_registry $@

