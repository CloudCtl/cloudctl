#################################################################################
# Builder Image
FROM quay.io/cloudctl/ubi:builder

#################################################################################
# DNF Package Install List
ARG DNF_LIST="\
  python3 \
"

ARG PIP_LIST="\
  k8s \
  boto \
  boto3 \
  awscli \
  passlib \  
  ansible \
  botocore \
  openshift \
  github3.py \
  kubernetes \
"

#################################################################################
# DNF Package Install Flags
ARG DNF_FLAGS="\
  -y \
  --releasever 8 \
"
ARG DNF_FLAGS_EXTRA="\
  --nodocs \
  --setopt=install_weak_deps=false \
  ${DNF_FLAGS} \
"

#################################################################################
# Install RPM Packages
RUN set -ex \
     && dnf install ${DNF_FLAGS_EXTRA} ${DNF_LIST} \
     && dnf clean all ${DNF_FLAGS} \
     && rm -rf \
           /var/cache/* \
    && echo

# Install Python PIP Packages & Ansible Galaxy Collections
ADD ./rootfs /
RUN set -ex                                                                     \
     && python3 -m pip install --upgrade pip                                    \
     && pip3 install --upgrade ${PIP_LIST}                                      \
     && ansible-galaxy collection install -r /root/.ansible/requirements.yml    \
    && echo

CMD /bin/sh
#################################################################################
# Finalize Image
MAINTAINER ContainerCraft.io
LABEL \
  license=GPLv3                                                                 \
  name="ansible"                                                                \
  distribution-scope="public"                                                   \
  io.openshift.tags="ansible"                                                   \
  io.k8s.display-name="ansible"                                                 \
  summary="CloudCtl Ansible Image | Micro Red Hat UBI Supportable Image"        \
  description="CloudCtl Base Image | Micro Red Hat UBI Supportable Image"       \
  io.k8s.description="CloudCtl Base Image | Micro Red Hat UBI Supportable Image"
