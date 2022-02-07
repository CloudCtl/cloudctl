FROM quay.io/cloudctl/registry                  as registry
FROM quay.io/cloudctl/koffer-go                 as entrypoint
FROM quay.io/cloudctl/ansible:latest
USER root

#################################################################################
# Package List
ARG DNF_LIST="\
  sqlite \
  skopeo \
"

ARG varRunPath="$varRunPath"
ENV varRunPath="$varRunPath"
ENV URL_WALLE="https://raw.githubusercontent.com/redhat-cop/openshift-disconnected-operators/master/mirror-operator-catalogue.py"

#################################################################################
# Load Entrypoint from Cradle
ADD ./rootfs /
COPY --from=entrypoint /root/koffer  /usr/bin/koffer
COPY --from=registry   /bin/registry /usr/bin/registry

#################################################################################
# DNF Install Packages
ARG DNF_FLAGS="\
  -y \
  --setopt=tsflags=nodocs \
  --exclude container-selinux \
  --setopt=install_weak_deps=false \
"
# DNF Update & Install Packages
RUN set -ex                                                                     \
     && dnf install ${DNF_FLAGS} ${DNF_LIST}                                    \
     && dnf clean all                                                           \
     && curl -L ${URL_WALLE} -o /bin/wall-e                                     \
     && chmod +x /bin/wall-e                                                    \
     && sed -i '/sudo/,+3d' /bin/wall-e                                         \
     && rm -rf                                                                  \
          /root/*                                                               \
          /var/cache/*                                                          \
          /var/log/dnf*                                                         \
          /var/log/yum*                                                         \
     && git config --global http.sslVerify false                                \
    && echo

# --nobest \
# --nogpgcheck \
# --allowerasing \
# --disablerepo="ubi-8-baseos" \
# --disablerepo "ubi-8-appstream" \
# --disablerepo="ubi-8-codeready-builder" \

#################################################################################
# Install helm cli
ARG varVerHelm="${varVerHelm}"
ARG varUrlHelm="https://get.helm.sh/helm-v${varVerHelm}-linux-amd64.tar.gz"
RUN set -ex                                                                     \
     && curl -L ${varUrlHelm}                                                   \
        | tar xzvf - --directory /tmp linux-amd64/helm                          \
     && mv /tmp/linux-amd64/helm /bin/helm                                      \
     && rm -rf /tmp/linux-amd64                                                 \
     && chmod +x /bin/helm                                                      \
     && /bin/helm version                                                       \
    && echo

# Add Pulumi binary
RUN set -ex \
     && export urlPulumiRelease="https://api.github.com/repos/pulumi/pulumi/releases/latest"             \
     && export urlPulumiVersion="$(curl -s ${urlPulumiRelease} | awk -F '["v,]' '/tag_name/{print $5}')" \
     && export urlPulumiBase="https://github.com/pulumi/pulumi/releases/download"                        \
     && export urlPulumiBin="pulumi-v${urlPulumiVersion}-linux-x64.tar.gz"                               \
     && export urlPulumi="${urlPulumiBase}/v${urlPulumiVersion}/${urlPulumiBin}"                         \
     && curl -L ${urlPulumi}                                                                             \
        | tar xzvf - --directory /tmp                                                                    \
     && mv /tmp/pulumi/* /usr/local/bin/                                                                 \
     && rm -rf /tmp/pulumi                                                                               \
     && pulumi version                                                                                   \
    && echo

#################################################################################
# Install kuma cli 'kumactl'
#ARG varVerKuma="${varVerKuma}"
#ARG varUrlKuma="https://download.konghq.com/mesh-alpine/kuma-${varVerKuma}-rhel-amd64.tar.gz"
#RUN set -ex                                                                     \
#     && curl --output /tmp/kumactl.tar.gz -L ${varUrlKuma}                      \
#     && cd /tmp && tar xzvf /tmp/kumactl.tar.gz                                 \
#     && mv /tmp/kuma-${varVerKuma}/bin/kumactl /bin/kumactl                     \
#     && rm -rf /tmp/kumactl.tar.gz /tmp/kuma-${varVerKuma}                      \
#     && chmod +x /bin/kumactl                                                   \
#     && /bin/kumactl version                                                    \
#    && echo

#################################################################################
# Install openshift client "oc"
ARG varVerOpenshift="${varVerOpenshift}"
ARG varUrlOpenshift="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux-${varVerOpenshift}.tar.gz"
RUN set -ex                                                                     \
     && curl -L ${varUrlOpenshift}                                              \
        | tar xzvf - --directory /bin oc kubectl                                \
     && chmod +x /bin/oc /bin/kubectl                                           \
     && /bin/oc version --client                                                \
    && echo

# Install virtctl
ARG varVerKubevirt="${varVerKubevirt}"
ARG varUrlKubevirt="https://github.com/kubevirt/kubevirt/releases/download/v${varVerKubevirt}/virtctl-v${varVerKubevirt}-linux-amd64"
RUN set -ex                                                                     \
     && curl -L ${varUrlKubevirt} -o /bin/virtctl                               \
     && chmod +x /bin/virtctl                                                   \
     && /bin/virtctl version --client                                           \
    && echo

# Install jq
ARG varVerJq="${varVerJq}"
ARG varUrlJq="https://github.com/stedolan/jq/releases/download/jq-${varVerJq}/jq-linux64"
RUN set -ex                                                                     \
     && curl -L ${varUrlJq} -o /bin/jq                                          \
     && chmod +x /bin/jq                                                        \
     && /bin/jq --version                                                       \
    && echo

# Install yq
ARG varVerYq="${varVerYq}"
ARG varUrlYq="https://github.com/mikefarah/yq/releases/download/v${varVerYq}/yq_linux_amd64"
RUN set -ex \
     && curl -L ${varUrlYq} -o /bin/yq                                          \
     && chmod +x /bin/yq                                                        \
     && /bin/yq --version                                                       \
   && echo

# Install grpcurl
ARG varVerGrpcurl="${varVerGrpcurl}"
ARG varUrlGrpcurl="https://github.com/fullstorydev/grpcurl/releases/download/v${varVerGrpcurl}/grpcurl_${varVerGrpcurl}_linux_x86_64.tar.gz"
RUN set -ex                                                                     \
     && curl -L ${varUrlGrpcurl}                                                \
        | tar xzvf - --directory /bin grpcurl                                   \
     && chmod +x /bin/grpcurl                                                   \
     && /bin/grpcurl --version                                                  \
    && echo

# Install OPM
ARG varVerOpm="${varVerOpm}"
ARG varUrlOpm="https://github.com/operator-framework/operator-registry/releases/download/v${varVerOpm}/linux-amd64-opm"
RUN set -ex                                                                     \
     && curl -L ${varUrlOpm} -o /bin/opm                                        \
     && chmod +x /bin/opm                                                       \
     && /bin/opm version                                                        \
    && echo

# Install Terraform
ARG varVerTerraform="${varVerTerraform}"
ARG varUrlTerraform="https://releases.hashicorp.com/terraform/${varVerTerraform}/terraform_${varVerTerraform}_linux_amd64.zip"
RUN set -ex                                                                     \
     && curl -L ${varUrlTerraform}                                              \
        | bsdtar -xvf- -C /bin                                                  \
     && chmod +x /bin/terraform                                                 \
     && /bin/terraform version                                                  \
    && echo

#################################################################################
# Finalize
ENTRYPOINT ["/usr/bin/koffer"]
WORKDIR /root/koffer

ARG varVerTpdk="${varVerOpenshift}"
ARG varVerOpenshift="${varVerOpenshift}"
ENV \
  GIT_SSL_NO_VERIFY=true \
  varVerTpdk="${varVerOpenshift}" \
  varVerOpenshift="${varVerOpenshift}" \
  REGISTRY_AUTH_FILE='/root/.docker/config.json' \
  PATH="/root/platform/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

LABEL \
  name="koffer"                                                                 \
  license=GPLv3                                                                 \
  version="${varVerTpdk}"                                                       \
  distribution-scope="public"                                                   \
  io.openshift.tags="tpdk koffer"                                               \
  io.k8s.display-name="tpdk-koffer-${varVerTpdk}"                               \
  summary="Koffer agnostic artifact collection engine."                         \
  description="Koffer is an automation runtime for delarative enterprise artifact supply chain."\
  io.k8s.description="Koffer delarative enterprise artifact supply chain collection engine."
