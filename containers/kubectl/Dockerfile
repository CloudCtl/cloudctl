#################################################################################
# Builder Image
FROM registry.access.redhat.com/ubi8/ubi as builder

ARG BUILD_PATH='/rootfs'
ARG KUBECTL_VERSION="${KUBECTL_VERSION}"
ENV KUBECTL_VERSION="${KUBECTL_VERSION}"
ARG kubectl_url="https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"


#################################################################################
# DNF Package Install List
ARG DNF_LIST="\
  openssl \
  coreutils-single \
  glibc-minimal-langpack \
"

#################################################################################
# DNF Package Install Flags
ARG DNF_FLAGS="\
  -y \
  --releasever 8 \
  --installroot /rootfs \
"
ARG DNF_FLAGS_EXTRA="\
  --nodocs \
  --setopt=install_weak_deps=false \
  ${DNF_FLAGS} \
"

#################################################################################
# Build Rootfs
USER root
ADD ./rootfs /
RUN set -ex \
     && mkdir -p ${BUILD_PATH} \
     && dnf install ${DNF_FLAGS_EXTRA} ${DNF_LIST} \
     && dnf clean all ${DNF_FLAGS} \
     && cp -f /etc/yum.repos.d/ubi.repo ${BUILD_PATH}/etc/yum.repos.d/ubi.repo \
     && rm -rf \
           ${BUILD_PATH}/var/cache/* \
     && curl -L ${kubectl_url} --output /rootfs/bin/kubectl \
     && chmod +x /rootfs/bin/kubectl \
    && echo

#################################################################################
# Build Image from Rootfs
FROM scratch
COPY --from=builder /rootfs /
RUN set -ex \
     && kubectl version --client || exit 1 \
    && echo
CMD /bin/sh

#################################################################################
# Finalize Image
WORKDIR /tmp
ENTRYPOINT ["/entrypoint"]
MAINTAINER ContainerCraft.io
LABEL name="CloudCtl Kubectl" \
      vendor="ContainerCraft.io" \
      version="${KUBECTL_VERSION}" \
      io.openshift.tags="cloudctl-kubectl" \
      maintainer="emcee@containercraft.io" \
      io.k8s.display-name="cloudctl-kubectl" \
      summary="Red Hat Ubi8 Micro Kubectl CLI" \
      description="Red Hat Ubi8 Micro Kubectl CLI" \
      io.k8s.description="CloudCtl Kubectl Image | Micro Red Hat UBI Image"

