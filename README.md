# CloudCTL
Cloud Deployment Administrative Services & Utilities

```
This repo sets up a deployment & administrative actions Kubernetes Pod Yaml defined 
container pod centered around ssh capable ContainerOne with capabilities including
additional container services such as docker registry:2, nginx artifact delivery, etc.
```

# Getting Started
####  1. Install Dependencies
```
On Fedora 32+
  sudo dnf install -y curl ansible python3 python3-pip

On Ubuntu 20.04+
  sudo apt install -y curl ansible python3 python3-pip

On CentOS 8+
  sudo dnf install -y curl python3 python3-pip
  sudo pip3 install --global ansible
```
####  2. Clone Repo
```
git clone https://github.com/containercraft/CloudCTL.git ~/.ccio/Git/cloudctl ; cd ~/.ccio/Git/cloudctl/ansible
```
####  3. Run Ansible
```
./run.yml
```
####  4. Review pod status
```
podman ps -a
podman pod ps
podman log one
```
####  5. Exec or SSH into CloudCtl pod ContainerOne
  > Exec from container host

```
podman exec -it one connect
```
  > SSH (EG from a different host)

```
ssh -p 2022 root@{IP_ADDR}
```
####  6. Disconnect from ContainerOne console
```
quit
```
####  7. Disconnect from ContainerOne console
```
podman pod rm --force cloudctl
```
