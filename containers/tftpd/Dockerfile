FROM quay.io/cloudctl/ubi:minimal

ARG RPM_LIST="\
         tftp-server \
"
ARG YUM_FLAGS="\
    -y \
    --nobest \
    --allowerasing \
    --setopt=tsflags=nodocs \
    --disablerepo 'ubi-8-appstream' \
    --disablerepo='ubi-8-codeready-builder' \
    --disablerepo='ubi-8-baseos' \
"

RUN set -ex \
     && dnf install ${YUM_FLAGS} ${RPM_LIST} \
     && dnf clean all \
     && rm -rf /var/cache/yum \
     && /usr/sbin/in.tftpd --version \
          || exit 1 \
    && echo

EXPOSE 69
ENTRYPOINT ["/usr/sbin/in.tftpd"]
CMD ["-c", "-p", "-vvvvv", "--foreground", "-s", "/var/lib/tftpboot"]
LABEL name="CloudCtl TFTP" \
      vendor="ContainerCraft.io" \
      maintainer="emcee@containercraft.io" \
      summary="Red Hat Ubi8 Minimal ISC DHCP Server" \
      description="UBI8 Minimal ISC DHCP Server"
