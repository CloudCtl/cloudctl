FROM quay.io/cloudctl/konductor:latest

## Build Variables
ARG varRunDate="${varRunDate}"
ARG varVerCode="${varVerCode}"
ARG varVerCode="3.9.3"

#################################################################################
# Package List
ARG urlCodeRpm="https://github.com/cdr/code-server/releases/download/v${varVerCode}/code-server-${varVerCode}-amd64.rpm"
ARG DNF_LIST="\
  ${urlCodeRpm} \
"
#################################################################################
# Load Entrypoint from Cradle
COPY ./bin/code.entrypoint /bin/entrypoint

#################################################################################
# DNF Install Packages
ARG DNF_FLAGS="\
  -y \
  --setopt=tsflags=nodocs \
  --setopt=install_weak_deps=false \
"
# DNF Update & Install Packages
RUN set -ex                                                                     \
     && dnf install ${DNF_FLAGS} ${DNF_LIST}                                    \
     && code-server --install-extension vscodevim.vim                           \
     && code-server --install-extension esbenp.prettier-vscode                  \
     && code-server --install-extension zhuangtongfa.Material-theme             \
     && dnf clean all                                                           \
     && rm -rf                                                                  \
          /root/*                                                               \
          /var/cache/*                                                          \
          /var/log/dnf*                                                         \
          /var/log/yum*                                                         \
    && echo

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
  license=GPLv3                                                                 \
  name="konductor:code"                                                         \
  version="${varVerTpdk}"                                                       \
  distribution-scope="public"                                                   \
  io.openshift.tags="tpdk konductor"                                            \
  io.k8s.display-name="tpdk-konductor-${varVerTpdk}"                            \
  summary="Konductor, iac runtime engine & cloud control userspace."            \
  description="Konductor, iac runtime engine & cloud control userspace."        \
  io.k8s.description="Konductor, iac runtime engine & cloud control userspace."
