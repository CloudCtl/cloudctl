FROM registry.access.redhat.com/ubi8/ubi:latest as base
FROM docker.io/library/centos                   as repos
FROM quay.io/cloudctl/koffer-go                 as entrypoint
FROM quay.io/cloudctl/registry                  as registry
FROM quay.io/openshift/origin-operator-registry as olm
FROM base

#################################################################################
# Build Variables
ARG varRunDate="${varRunDate}"

# Package versions
ARG varVerJq="${varVerJq}"
ARG varVerOpm="${varVerOpm}"
ARG varVerHelm="${varVerHelm}"
ARG varVerTpdk="${varVerOpenshift}"
ARG varVerGrpcurl="${varVerGrpcurl}"
ARG varVerOpenshift="${varVerOpenshift}"
ARG varVerTerraform="${varVerTerraform}"

# Binary Artifact URLS
ARG varUrlHelm="https://get.helm.sh/helm-v${varVerHelm}-linux-amd64.tar.gz"
ARG varUrlJq="https://github.com/stedolan/jq/releases/download/jq-${varVerJq}/jq-linux64"
ARG varUrlOpm="https://github.com/operator-framework/operator-registry/releases/download/v${varVerOpm}/linux-amd64-opm"
ARG varUrlTerraform="https://releases.hashicorp.com/terraform/${varVerTerraform}/terraform_${varVerTerraform}_linux_amd64.zip"
ARG varUrlGrpcurl="https://github.com/fullstorydev/grpcurl/releases/download/v${varVerGrpcurl}/grpcurl_${varVerGrpcurl}_linux_x86_64.tar.gz"

#################################################################################
# Package Lists
ARG DNF_LIST="\
  git \
  tar \
  tree \
  curl \
  tmux \
  pigz \
  rsync \
  unzip \
  skopeo \
  bsdtar \
  buildah \
  openssl \
  python3-pip \
  fuse-overlayfs \
"

ARG PIP_LIST="\
  ansible \
  passlib \
"

ARG YUM_FLAGS="\
  -y \
  --nobest \
  --nogpgcheck \
  --allowerasing \
  --setopt=tsflags=nodocs \
  --exclude container-selinux \
  --disablerepo="ubi-8-baseos" \
  --disablerepo "ubi-8-appstream" \
  --disablerepo="ubi-8-codeready-builder" \
"

#################################################################################
# Load Entrypoint from Cradle
COPY --from=entrypoint /root/koffer              /usr/bin/koffer

# Load CentOS 8 Repos
COPY --from=repos      /etc/pki/                 /etc/pki
COPY --from=repos      /etc/os-release           /etc/os-release
COPY --from=repos      /etc/yum.repos.d/         /etc/yum.repos.d
COPY --from=repos      /etc/redhat-release       /etc/redhat-release
COPY --from=repos      /etc/system-release       /etc/system-release

# Load Docker Registry:2 Binary
COPY --from=registry   /bin/registry             /bin/registry

# Configure Docker Registry:2 Service
COPY                   bin/run_registry.sh       /usr/bin/run_registry.sh
COPY                   conf/registries.conf      /etc/containers/registries.conf
COPY                   conf/registry-config.yml  /etc/docker/registry/config.yml

#################################################################################
# DNF Update & Install Packages
RUN set -ex                                                                     \
     && dnf update  ${YUM_FLAGS}                                                \
     && dnf install ${YUM_FLAGS} ${DNF_LIST}                                    \
     && dnf clean all                                                           \
     && rm -rf                                                                  \
          /var/cache/*                                                          \
          /var/log/dnf*                                                         \
          /var/log/yum*                                                         \
          /root/buildinfo                                                       \
          /root/original-ks.cfg                                                 \
          /root/anaconda-ks.cfg                                                 \
          /root/anaconda-post.log                                               \
          /root/anaconda-post-nochroot.log                                      \
     # Configure Buildah for Nested Image Builds
     && mkdir -p                                                                \
          /var/lib/shared/overlay-images \                                      \
          /var/lib/shared/overlay-layers \                                      \
     && touch /var/lib/shared/overlay-images/images.lock \                      \
     && touch /var/lib/shared/overlay-layers/layers.lock \                      \
     && sed -i                                                                  \
            -e 's|^#mount_program|mount_program|g'                              \
            -e '/additionalimage.*/a "/var/lib/shared",'                        \
          /etc/containers/storage.conf                                          \
    && echo

# Install jq
RUN set -ex                                                                     \
     && curl -L ${varUrlJq} -o /bin/jq                                          \
     && chmod +x /bin/jq                                                        \
     && /bin/jq --version                                                       \
    && echo

# Install grpcurl
RUN set -ex                                                                     \
     && curl -L ${varUrlGrpcurl}                                                \
        | tar xzvf - --directory /bin grpcurl                                   \
     && chmod +x /bin/grpcurl                                                   \
     && /bin/grpcurl --version                                                  \
    && echo

# Install OPM
RUN set -ex                                                                     \
     && curl -L ${varUrlOpm} -o /bin/opm                                        \
     && chmod +x /bin/opm                                                       \
     && /bin/opm version                                                        \
    && echo

# Install Terraform
RUN set -ex                                                                     \
     && curl -L ${varUrlTerraform}                                              \
        | bsdtar -xvf- -C /bin                                                  \
     && chmod +x /bin/terraform                                                 \
     && /bin/terraform version                                                  \
    && echo

# Install Helm
RUN set -ex                                                                     \
     && curl -L ${varUrlHelm}                                                   \
        | tar xzvf - --directory /tmp linux-amd64/helm                          \
     && mv /tmp/linux-amd64/helm /bin/helm                                      \
     && chmod +x /bin/helm                                                      \
     && rm -rf /tmp/linux-amd64                                                 \
     && /bin/helm version                                                       \
    && echo

# PIP Install Packages
RUN set -ex                                                                     \
     && pip3 install ${PIP_LIST}                                                \
    && echo

#################################################################################
# OLM Hack
#COPY --from=olm        /bin/registry-server      /usr/bin/registry-server
#COPY --from=olm        /bin/initializer          /usr/bin/initializer
#RUN set -ex                                                                     \
#    && mkdir -p /manifests                                                      \
#    && mkdir -p /db                                                             \
#    && touch /db/bundles.db                                                     \
#    && initializer                                                              \
#         --manifests /manifests/                                                \
#         --output /db/bundles.db                                                \
#   && echo

#################################################################################
# Finalize

ENV \
  varVerOpenshift="${varVerOpenshift}" \
  varVerTpdk="${varVerOpenshift}"

LABEL \
  name="koffer"                                                                 \
  license=GPLv3                                                                 \
  version="${varVerTpdk}"                                                       \
  vendor="ContainerCraft.io"                                                    \
  build-date="${varRunDate}"                                                    \
  maintainer="ContainerCraft.io"                                                \
  distribution-scope="public"                                                   \
  io.openshift.tags="tpdk koffer"                                               \
  io.k8s.display-name="tpdk-koffer-${varVerTpdk}"                               \
  summary="Koffer agnostic artifact collection engine."                         \
  description="Koffer is designed to automate delarative enterprise artifact supply chain."\
  io.k8s.description="Koffer is designed to automate delarative enterprise artifact supply chain."

ENTRYPOINT ["/usr/bin/koffer"]
WORKDIR /root/koffer
