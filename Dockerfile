FROM quay.io/openshift/origin-operator-registry as olm
FROM quay.io/cloudctl/registry                  as registry
FROM quay.io/cloudctl/koffer-go                 as entrypoint

FROM quay.io/cloudctl/ansible:latest
USER root

#################################################################################
# Build Variables
ARG varVerTpdk="${varVerOpenshift}"

# Package versions
ARG varVerJq="${varVerJq}"
ARG varVerOpm="${varVerOpm}"
ARG varVerHelm="${varVerHelm}"
ARG varVerGrpcurl="${varVerGrpcurl}"
ARG varVerTerraform="${varVerTerraform}"
ARG varVerOpenshift="${varVerOpenshift}"

# Binary Artifact URLS
ARG varUrlHelm="https://get.helm.sh/helm-v${varVerHelm}-linux-amd64.tar.gz"
ARG varUrlJq="https://github.com/stedolan/jq/releases/download/jq-${varVerJq}/jq-linux64"
ARG varUrlOpm="https://github.com/operator-framework/operator-registry/releases/download/v${varVerOpm}/linux-amd64-opm"
ARG varUrlTerraform="https://releases.hashicorp.com/terraform/${varVerTerraform}/terraform_${varVerTerraform}_linux_amd64.zip"
ARG varUrlGrpcurl="https://github.com/fullstorydev/grpcurl/releases/download/v${varVerGrpcurl}/grpcurl_${varVerGrpcurl}_linux_x86_64.tar.gz"

#################################################################################
# Package Lists
ARG DNF_LIST="\
  skopeo \
"

ARG YUM_FLAGS="\
  -y \
  --setopt=tsflags=nodocs \
  --exclude container-selinux \
"
#  --nobest \
#  --nogpgcheck \
#  --allowerasing \
#  --disablerepo="ubi-8-baseos" \
#  --disablerepo "ubi-8-appstream" \
#  --disablerepo="ubi-8-codeready-builder" \

#################################################################################
# Load Entrypoint from Cradle
COPY --from=entrypoint /root/koffer              /usr/bin/koffer

# Load Docker Registry:2 Binary
COPY --from=registry   /bin/registry             /bin/registry

# Configure Docker Registry:2 Service
COPY                   bin/run_registry.sh       /usr/bin/run_registry.sh
COPY                   conf/registries.conf      /etc/containers/registries.conf
COPY                   conf/registry-config.yml  /etc/docker/registry/config.yml

#################################################################################
# DNF Update & Install Packages
ADD ./repos/centos/etc /etc/
RUN set -ex                                                                     \
     && dnf install ${YUM_FLAGS} ${DNF_LIST}                                    \
     && dnf clean all                                                           \
     && rm -rf                                                                  \
          /root/*                                                               \
          /var/cache/*                                                          \
          /var/log/dnf*                                                         \
          /var/log/yum*                                                         \
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

#################################################################################
# Finalize
ENV \
  varVerOpenshift="${varVerOpenshift}" \
  varVerTpdk="${varVerOpenshift}"

LABEL \
  name="koffer"                                                                 \
  license=GPLv3                                                                 \
  version="${varVerTpdk}"                                                       \
  distribution-scope="public"                                                   \
  io.openshift.tags="tpdk koffer"                                               \
  io.k8s.display-name="tpdk-koffer-${varVerTpdk}"                               \
  summary="Koffer agnostic artifact collection engine."                         \
  description="Koffer is designed to automate delarative enterprise artifact supply chain."\
  io.k8s.description="Koffer is designed to automate delarative enterprise artifact supply chain."

ENTRYPOINT ["/usr/bin/koffer"]
WORKDIR /root/koffer
