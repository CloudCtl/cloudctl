# CloudCTL
DevOps Services & Utilities Container [Pod] Infrastructure as Code [(IaC)] toolkit.
## Problem
Infrastructure deployment requires a wide set of user enablement & automation 
utilities, network services, and Infrastructure as Code resources. These can 
become difficult & inconsistent to maintain and support.
## Solution
CloudCtl provides a [Podman] container [Pod] based "Point of Origin" 
Infrastructure as Code [(IaC)] toolkit for deployment operations tasks 
with core features delivered via [UBI8] based [Konductor] as primary 
orchestration base capable of dynamically allocating additional pod 
contained services.
##### Core Features
  - stateful
  - dynamic
  - portable 
  - consistent
##### Supported Distributions
  - [Fedora] 32+
  - [CentOS] 8.0+
  - [RedHat] 8.0+
  - [Ubuntu] 20.04+
----------------------
# Getting Started
####  1. Install Dependencies
```
On Fedora 32+
  sudo dnf install -y git podman

On RHEL/CentOS 8+
  sudo dnf install -y git podman

On Ubuntu 20.04+
  sudo apt install -y git podman
```
####  2. Clone Repo
```
  git clone https://github.com/containercraft/CloudCTL.git ~/cloudctl ; cd ~/cloudctl
```
####  3. Execute Ansible Playbook
```
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
./konductor.sh
```
####  4. Review pod status
```
sudo podman pod ps
sudo podman ps --all
sudo podman logs registry
```
####  5. Exec CloudCtl Konductor
```
podman exec -it konductor connect
```
####  6. Disconnect from Konductor console
```
quit
```
####  7. Remove & Cleanup
```
sudo podman pod rm --force cloudctl
sudo podman container prune -f
sudo podman image prune -f
sudo rm -rf ~/cloudctl
```
[Pod]:https://kubernetes.io/docs/concepts/workloads/pods/pod
[UBI8]:https://www.redhat.com/en/blog/introducing-red-hat-universal-base-image
[(IaC)]:https://www.ibm.com/cloud/learn/infrastructure-as-code
[Konductor]:https://github.com/redshiftofficial/Konductor
[Podman]:https://docs.podman.io/en/latest
[Install Podman]:https://podman.io/getting-started/installation
[Fedora]:https://getfedora.org
[Ubuntu]:https://ubuntu.com/download
[CentOS]:https://www.centos.org/download
[RedHat]:https://access.redhat.com/downloads
[Fedora CoreOS]:https://getfedora.org/en/coreos?stream=stable
[RedHat CoreOS]:https://coreos.com/
