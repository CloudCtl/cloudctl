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
contained services. All existing containerized services are delivered
as UBI & UBI Minimal containerized services. When bundled for airgap usage
the total payload to carry hovers around ~1.5G.
#### Core Features
  - Extensable
  - Portable 
  - Stateful
  - Dynamic
  - Consistent
  - Zero external dependencies (No yum/dnf rpm downloads)
  - Airgap Supported (with Koffer collector)
  - Behaves the same whether connected or disconnected from the internet
#### Supported Distributions
  - [Fedora] 32+
  - [CentOS] 8.0+
  - [RedHat] 8.0+
  - [Ubuntu] 20.04+
#### Supported Services
  - Konductor User Space Container
  - Ansible Runner Service API
  - Docker Image Registry
  - Nginx File Server
  - Haproxy TCP Load Balancer
  - CoreDNS
  - ISC-DHCP
  - Tftpd
----------------------
## Getting Started
>  Run as User: `root`
>    
    
####  0. Install Dependencies
```
On RHEL 8+ / CentOS 8+ / Fedora 32+
  dnf install -y podman

On Ubuntu 20.04+
  apt install -y podman
```
####  1. Clone Repo
```
 mkdir -p /root/cloudctl && \
 podman run -it --rm --volume /root/cloudctl:/clone:z \
   quay.io/cloudctl/git \
 https://github.com/CloudCtl/CloudCtl.git && \
 cd ~/cloudctl
```
####  2. Validate ability to ssh to self as root
```
[[ -f /root/.ssh/id_rsa ]] || ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chmod 0644 /root/.ssh/authorized_keys
ssh root@localhost whoami
```
####  3. Initialize CloudCtl Pod
```
./init.sh
```
####  4. Verify API Access
```
curl -ks \
    --key  /root/platform/secrets/cloudctl/certs/ssl/server/cloudctl.pem \
    --cert /root/platform/secrets/cloudctl/certs/ssl/server/cloudctl.crt \
  https://localhost:5001/api/v1/playbooks -X GET
```
>
>  sample output:
>
```
{"status": "OK", "msg": "0 playbook found", "data": {"playbooks": []}}
```
####  5. Review pod status
```
sudo podman pod ps
sudo podman ps --all
```
>
>  sample output:
>
```
36668681f233  Up 18 hours ago    coredns
596dbaa4520b  Up 18 hours ago    haproxy
44d434359e33  Up 18 hours ago    nginx
1efcd0fafb40  Up 18 hours ago    registry
3598bab7c7ed  Up 18 hours ago    runner
11305c527abe  Up 18 hours ago    konductor
fbf274723577  Up 18 hours ago    c7fc137831c8-infra
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
