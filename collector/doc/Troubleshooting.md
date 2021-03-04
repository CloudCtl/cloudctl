## Manual Troubleshooting path:
  - Requires: `podman`
```
# git clone
git clone https://github.com/CodeSparta/devkit-vpc.git && cd devkit-vpc

# Set variables
vi variables.tf

# Execute into IaC engine runtime
source tools/dev.sh

# Execute IaC Playbook with required variables
./site.yml -vvv -e aws_cloud_region=us-gov-west-1 \
  -e aws_access_key=AKXXXXXXXXXXXXXXNEU \
  -e aws_secret_key=NasXXXXXXXXXXXXXXXXB6vK

# If failure observed, attempt to run terraform directly
terraform apply -var-file=global.tfvars

```
