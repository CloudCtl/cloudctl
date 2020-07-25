# CloudCTL
DevOps Deployment Services & Utilities Container [Pod] Infrastructure as Code [(IaC)] toolkit.
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
####  0. Install Dependencies
```
On Fedora 32+
  sudo dnf install -y curl ansible python3 python3-pip

On Ubuntu 20.04+
  sudo apt install -y curl ansible python3 python3-pip

On CentOS 8+
  sudo dnf install -y curl python3 python3-pip
  sudo pip3 install --global ansible
```
####  1. Install Dependencies
```
sudo -i
```
####  2. Clone Repo
```
git clone https://github.com/redshiftofficial/CloudCTL.git ~/.ccio/cloudctl ; cd ~/.ccio/cloudctl/ansible
```
####  3. Execute Ansible Playbook
```
./run.yml
```
####  4. Review pod status
```
sudo podman ps --all
sudo podman pod ps --all
sudo podman logs one
```
####  5. Exec or SSH into CloudCtl pod Konductor
  > Exec from container host

```
podman exec -it one connect
```
 > SSH example from localhost 

```
cat ~/.ssh/id_rsa.pub >> ~/.ccio/.secrets.d/ssh/user/authorized_keys
ssh -p 2022 root@localhost
```
####  6. Disconnect from Konductor console
```
quit
```
####  7. Remove & Cleanup
```
sudo podman rm --force one
sudo podman pod rm --force cloudctl
sudo rm -rf ~/.ccio/cloudctl
```
```
for i in $(sudo podman images | awk '/one|pause/{print $3}'); do podman rmi --force $i; done
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
