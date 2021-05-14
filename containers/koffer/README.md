# CloudCtl | Koffer
## Artifact Rake & Bundle Utility
![Docker Pulls](https://img.shields.io/docker/pulls/cloudctl/koffer?label=DockerHub%20Pulls)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/cloudctl/cloudctl/koffer?label=GH%20Actions)    
Find on [Docker.io](https://hub.docker.com/r/cloudctl/koffer)  &  [Quay.io](https://quay.io/repository/cloudctl/koffer)    
Find on [GitHub](https://github.com/cloudctl/cloudctl)    
    
    
Koffer is an ansible automation runtime for declarative artifact rake
and bundle tasks in support of Declarative Software Supply Chain and
airgap operations. Current capabilities include support for dependencies
required to deploy [Red Hat] [UPI] [OpenShift] Infrastructure, Pipelines,
and applications into airgaped environments. Koffer is driven from a
yaml spec engine and is designed to run against compliant external collector
plugin repos.    
    
## Dependencies
  - [Install Podman]
  - Alternate: may work with docker in most cases

## Artifact Types:
  - Git Repos
  - Terraform IaC
    - Performs terraform init at time of capture
  - Container Images
    - Pulls & hydrates built in docker registry service to persistent local path
    - High side is served with generic docker registry:2 container
  - Extensible support for other ansible, python, go, and bash based tasks

## Output:
Koffer produces a standardized tarball of all artifacts on the host filesystem at `bundle/koffer-bundle.*.tar`

## Example Usage
  - Example run in unattended mode
  - Example run with local koffer.yml config
  - Example run from [Sparta](https://github.com/CodeSparta/sparta) collector/site.yml 
    
### 1. Copy & Paste your [Pull Secret] (registry credentials)
  - Koffer will use the registry credentials for container image downloads
```sh
vi ${HOME}/pull-secret.json
```
### 3. Create Koffer Bundle Directory
```sh
mkdir ${HOME}/bundle
```
    
### 3. Download Koffer Config
```sh
curl --output ./koffer.yml -L https://codectl.io/docs/config/stable/sparta.yml
```
    
### 3. Run Koffer
```sh
podman run -it --rm --pull always \
    --volume ${HOME}/bundle:/root/bundle:z \
    --volume ${HOME}/koffer.yml:/root/.koffer/config.yml:z \
    --volume ${HOME}/pull-secret.json:/root/.docker/config.json:z \
  quay.io/cloudctl/koffer:latest bundle --silent
```

### 4. Verify Bundle
```sh
du -sh ${HOME}/bundle/*
```
    
[UPI]:https://www.openshift.com/blog/deploying-a-upi-environment-for-openshift-4-1-on-vms-and-bare-metal
[Red Hat]:https://www.redhat.com
[OpenShift]:https://www.openshift.com
[Pull Secret]:https://cloud.redhat.com/openshift/install/metal/user-provisioned
[Pod]:https://kubernetes.io/docs/concepts/workloads/pods/pod
[UBI8]:https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image
[(IaC)]:https://www.ibm.com/cloud/learn/infrastructure-as-code
[CloudCtl]:https://github.com/containercraft/CloudCTL
[Podman]:https://docs.podman.io/en/latest
[Install Podman]:https://podman.io/getting-started/installation
[Fedora]:https://getfedora.org
[Ubuntu]:https://ubuntu.com/download
[CentOS]:https://www.centos.org/download
[RedHat]:https://access.redhat.com/downloads
[Fedora CoreOS]:https://getfedora.org/en/coreos?stream=stable
[RedHat CoreOS]:https://coreos.com/
