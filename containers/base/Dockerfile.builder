#################################################################################
# Builder Image
FROM quay.io/cloudctl/ubi:minimal

#################################################################################
# DNF Package Install List
ARG DNF_LIST="\
  git \
  tar \
  pigz \
  bash \
  curl \
  rsync \
  unzip \
  bsdtar \
  skopeo \
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
# Build Rootfs
RUN set -ex \
     && dnf -y install 'dnf-command(copr)' \
     && dnf -y copr enable rhcontainerbot/container-selinux \
     && curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo \
     && dnf update ${DNF_FLAGS_EXTRA} \
     && dnf install ${DNF_FLAGS_EXTRA} ${DNF_LIST} \
     && dnf clean all ${DNF_FLAGS} \
     && rm -rf \
           ${BUILD_PATH}/var/cache/* \
    && echo


CMD /bin/sh
#################################################################################
# Finalize Image
MAINTAINER ContainerCraft.io
LABEL \
  license=GPLv3                                                                 \
  name="cloudctl-base"                                                          \
  distribution-scope="public"                                                   \
  io.openshift.tags="cloudctl-base"                                             \
  io.k8s.display-name="cloudctl-base"                                           \
  summary="CloudCtl Base Image | Micro Red Hat UBI Supportable Image"           \
  description="CloudCtl Base Image | Micro Red Hat UBI Supportable Image"       \
  io.k8s.description="CloudCtl Base Image | Micro Red Hat UBI Supportable Image"
