FROM quay.io/cloudctl/ubi:micro

ARG KUBECTL_VERSION="${KUBECTL_VERSION}"
ENV KUBECTL_VERSION="${KUBECTL_VERSION}"
ARG kubectl_url="https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

ADD ./rootfs /
USER root

#ARG RPM_PKGS="\
#            git \
#"

#RUN set -ex \
#    && dnf install -y ${RPM_PKGS} \
#    && dnf clean all \
#    && rm -rf /var/cache/yum \
#    && git version || exit 1 \
#   && echo

RUN set -ex \
     && curl -L ${kubectl_url} --output /bin/kubectl \
     && chmod +x /bin/kubectl \
#    && gh version || exit 1 \
    && echo

WORKDIR /tmp
ENTRYPOINT ["/entrypoint"]
LABEL name="CloudCtl Kubectl" \
      vendor="ContainerCraft.io" \
      maintainer="emcee@containercraft.io" \
      version="${KUBECTL_VERSION}" \
      summary="Red Hat Ubi8 Micro Kubectl CLI" \
      description="Red Hat Ubi8 Micro Kubectl CLI"
