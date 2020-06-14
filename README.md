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
####  4. Exec into CloudCtl ContainerOne
```
podman exec -it one connect
```
####  5. Disconnect from ContainerOne console
```
quit
```
####  6. Disconnect from ContainerOne console
```
podman pod rm --force cloudctl
```
