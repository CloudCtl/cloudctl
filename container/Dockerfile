FROM centos:latest as rpm
FROM registry:2 as registry
FROM registry.access.redhat.com/ubi8/ubi:latest as ubi8
FROM registry.access.redhat.com/ubi8/ubi:latest as ubi
FROM registry.access.redhat.com/ubi8/ubi:latest
#################################################################################
# OCP Version set in src/ocp
ARG varVerOpenshift="${varVerOpenshift}"
ARG varVerTerraform="${varVerTerraform}"
ARG varVerHelm="${varVerHelm}"
ARG varVerJq="${varVerJq}"

# OC Download Urls
ARG varUrlGit="${varUrlGit}"
ARG urlOC="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${varVerOpenshift}/openshift-client-linux.tar.gz"
ARG urlOCINST="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${varVerOpenshift}/openshift-install-linux.tar.gz"

# Binary Artifact URLS
ARG varUrlGcloud="https://sdk.cloud.google.com"
ARG varUrlHelm="https://get.helm.sh/helm-v${varVerHelm}-linux-amd64.tar.gz"
ARG urlRelease="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/release.txt"
ARG varUrlTerraform="https://releases.hashicorp.com/terraform/${varVerTerraform}/terraform_${varVerTerraform}_linux_amd64.zip"
ARG varUrlOsInst="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${varVerOpenshift}/openshift-install-linux.tar.gz"
ARG varUrlOpenshift="https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/${varVerOpenshift}/openshift-client-linux.tar.gz"
ARG varUrlJq="https://github.com/stedolan/jq/releases/download/jq-${varVerJq}/jq-linux64"

# Build Variables
ARG listManifest="/var/lib/koffer/release.list"

#################################################################################
# Package Lists
ARG varListRpms="\
             git \
             tree \
             tmux \
             pigz \
             rsync \
             skopeo \
             bsdtar \
             openssl \
             httpd-tools \
             python3-pip \
             openssh-clients \
             "
ARG varListPip="\
             ansible \
             passlib \
             "

#################################################################################
# Load Artifacts

# From Repo
COPY bin/entrypoint /usr/bin/entrypoint
COPY bin/run_registry.sh /usr/bin/run_registry.sh
COPY conf/registry-config.yml /etc/docker/registry/config.yml
COPY conf/registries.conf /etc/containers/registries.conf

# From Registry:2
COPY --from=registry /bin/registry  /bin/registry

# From CentOS
COPY --from=rpm /etc/pki/ /etc/pki
COPY --from=rpm /etc/yum.repos.d/ /etc/yum.repos.d

# From CentOS (aux testing)
COPY --from=rpm /etc/os-release /etc/os-release
COPY --from=rpm /etc/redhat-release /etc/redhat-release
COPY --from=rpm /etc/system-release /etc/system-release
#################################################################################
# Create Artifact Directories
#RUN set -ex                                                                     \
#     && microdnf install -y dnf                                                 \
#    && echo
   ; echo
RUN set -ex                                                                     \
     && mkdir -p /var/lib/koffer/                                               \
     && curl -sL ${urlRelease}                                                  \
      | awk -F'[ ]' '/Pull From:/{print $3}'                                    \
      | sed 's/quay.io\///g'                                                    \
      | tee -a ${listManifest}                                                  \
     && curl -sL ${urlRelease}                                                  \
      | grep -v 'Pull From'                                                     \
      | awk '/quay.io\/openshift-release/{print $2}'                            \
      | sed 's/quay.io\///g'                                                    \
      | tee -a ${listManifest}                                                  \
   ; echo
RUN set -ex                                                                     \
     && dnf update -y --setopt=tsflags=nodocs                                   \
   ; echo
RUN set -ex                                                                     \
     && dnf install -y ${varListRpms}                                           \
   ; echo
RUN set -ex                                                                     \
     && pip3 install ${varListPip}                                              \
   ; echo
RUN set -ex                                                                     \
     && dnf install -y bsdtar tar                                               \
   ; echo
RUN set -ex                                                                     \
     && curl -L ${varUrlOpenshift}                                              \
          | tar xzvf - --directory /bin kubectl oc                              \
     && /bin/oc version                                                         \
     && curl -L ${varUrlOsInst}                                                 \
          | tar xzvf - --directory /bin openshift-install                       \
     && curl -L ${varUrlHelm}                                                   \
          | tar xzvf - --directory /tmp linux-amd64/helm                        \
     && mv /tmp/linux-amd64/helm   /bin/                                        \
     && curl -L ${varUrlTerraform}                                              \
          | bsdtar -xvf- -C /bin                                                \
     && curl -L ${varUrlJq}                                                     \
             -o /bin/jq                                                         \
   ; echo
RUN set -ex                                                                     \
     && chmod +x /bin/{oc,kubectl,openshift-install,helm,terraform,jq}          \
     && chmod +x /usr/bin/entrypoint                                            \
     && mkdir /root/.bak && mv                                                  \
          /root/original-ks.cfg                                                 \
          /root/anaconda-ks.cfg                                                 \
          /root/anaconda-post-nochroot.log                                      \
          /root/anaconda-post.log                                               \
          /root/buildinfo                                                       \
        /root/.bak/                                                             \
    && rm -rf                                                                   \
        /var/cache/*                                                            \
        /var/log/dnf*                                                           \
        /var/log/yum*                                                           \
     && mkdir -p /root/deploy/{mirror,images}                                   \
     && mkdir -p /root/bundle                                                   \
   ; echo
#    && git clone ${varUrlGit} /root/koffer                                     \

#################################################################################
# ContainerOne | Cloud Orchestration Tools - Point of Origin
ENV varVerOpenshift="${varVerOpenshift}" varUrlGit="${varUrlGit}"
LABEL VENDOR="containercraft.io"                                                \
      NAME="Koffer"                                                             \
      BUILD_DATE="${varRunDate}"                                                \
      OpenShift="${varVerOpenshift}"                                            \
      maintainer="ContainerCraft.io"                                            \
      License=GPLv3 
ENTRYPOINT ["/usr/bin/bash"]
CMD /usr/bin/entrypoint
WORKDIR /root/koffer
