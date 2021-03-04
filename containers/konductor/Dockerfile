FROM quay.io/cloudctl/konductor-go AS entrypoint
FROM quay.io/cloudctl/koffer:extra

## Build Variables
ARG varVerTpdk="${varVerOpenshift}"
ARG varVerOpenshift="${varVerOpenshift}"

#################################################################################
# Package List
ARG DNF_LIST="\
  xz \
  vim \
  file \
  wget \
  tree \
  tmux \
  which \
  iputils \
  findutils \
  azure-cli \
  procps-ng \
  net-tools \
  nmap-ncat \
  bind-utils \
  httpd-tools \
  openssh-server \
  libvarlink-util \
  bash-completion \
"

#################################################################################
# Load Entrypoint from Cradle
COPY --from=entrypoint /root/konductor /bin/konductor
COPY ./bin/connect         /bin/
COPY ./bin/entrypoint      /bin/
COPY ./bin/run_registry.sh /bin/
ADD ./rootfs /

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
	 && rpm --import https://packages.microsoft.com/keys/microsoft.asc      \
     && dnf install ${DNF_FLAGS} ${DNF_LIST}                                    \
     && ln /usr/bin/vim /usr/bin/vi                                             \
     && dnf clean all                                                           \
     && rm -rf                                                                  \
          /root/*                                                               \
          /var/cache/*                                                          \
          /var/log/dnf*                                                         \
          /var/log/yum*                                                         \
    && echo

# --nobest \
# --nogpgcheck \
# --allowerasing \
# --disablerepo="ubi-8-baseos" \
# --disablerepo "ubi-8-appstream" \
# --disablerepo="ubi-8-codeready-builder" \

#################################################################################
# Finalize

ENTRYPOINT ["/bin/entrypoint"]
WORKDIR /root/platform
USER root

ENV \
 varVerTpdk=${varVerOpenshift} \
 varVerOpenshift=${varVerOpenshift} \
 varVerKonductor=${varVerOpenshift} \
 REGISTRY_AUTH_FILE=/root/.docker/config.json \
 BUILDAH_ISOLATION=chroot \
 PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/platform/bin"

LABEL \
  name="konductor"                                                              \
  license=GPLv3                                                                 \
  version="${varVerTpdk}"                                                       \
  distribution-scope="public"                                                   \
  io.openshift.tags="tpdk konductor"                                            \
  io.k8s.display-name="tpdk-konductor-${varVerTpdk}"                            \
  summary="Konductor, iac runtime engine & cloud control userspace."            \
  description="Konductor, iac runtime engine & cloud control userspace."        \
  io.k8s.description="Konductor, iac runtime engine & cloud control userspace."
