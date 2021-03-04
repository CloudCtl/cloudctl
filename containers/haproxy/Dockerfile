FROM quay.io/cloudctl/ubi:minimal

ARG DNF_LIST="\
  rsyslog \
  haproxy \
"

RUN set -ex \
     && dnf install -y ${DNF_LIST} \
     && ln -sf /dev/stdout /var/log/haproxy.log \
     && dnf clean all \
     && rm -rf /var/cache/yum \
     && haproxy -v || exit 1 \
    && echo

ADD rootfs/ /

ENTRYPOINT ["/entrypoint"]
CMD        ["-f", "/haproxy.cfg"]
LABEL name="CloudCtl Haproxy" \
      vendor="ContainerCraft.io" \
      maintainer="emcee@containercraft.io" \
      summary="Red Hat Ubi8 Minimal Haproxy" \
      description="UBI8 Minimal Haproxy"
