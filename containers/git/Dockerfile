FROM quay.io/cloudctl/ubi:minimal

ARG GIT_VERSION="${GIT_VERSION}"
ENV GIT_VERSION="${GIT_VERSION}"
ARG gh_uri="https://github.com/cli/cli/releases/download/v${GIT_VERSION}/gh_${GIT_VERSION}_linux_amd64.rpm"

COPY entrypoint /entrypoint
USER root

ARG RPM_PKGS="\
            git \
"
RUN set -ex \
     && dnf install -y ${RPM_PKGS} \
     && dnf clean all \
     && rm -rf /var/cache/yum \
     && git version || exit 1 \
    && echo

RUN set -ex \
     && curl -L ${gh_uri} --output /tmp/gh_${GIT_VERSION}_linux_amd64.rpm \
     && rpm -i /tmp/gh_${GIT_VERSION}_linux_amd64.rpm \
     && gh version || exit 1 \
     && rm -rf /tmp/gh_${GIT_VERSION}_linux_amd64.rpm \
    && echo

WORKDIR /clone
ENTRYPOINT ["/entrypoint"]
LABEL name="CloudCtl Git" \
      vendor="ContainerCraft.io" \
      maintainer="emcee@containercraft.io" \
      version="${GIT_VERSION}" \
      summary="Red Hat Ubi8 Minimal Git GH CLI" \
      description="UBI Minimal Git & GH CLI"
