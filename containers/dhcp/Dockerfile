#################################################################################
# Builder Image
FROM quay.io/cloudctl/ubi:minimal as rpm
FROM quay.io/cloudctl/ubi:minimal as builder

#################################################################################
# DNF Package Install List
ARG DNF_LIST="\
  dhcp-server \
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
RUN set -ex \
     && mkdir -p /rootfs \
     && dnf install ${DNF_FLAGS_EXTRA} ${DNF_LIST} \
     && dnf clean all ${DNF_FLAGS_EXTRA} \
     && rm -rf /rootfs/var/cache/* \
    && echo

#################################################################################
# Build Image from Rootfs
FROM scratch
COPY --from=builder /rootfs /
ENTRYPOINT ["/usr/sbin/dhcpd"]
CMD ["-f", "-cf", "/etc/dhcp/dhcpd.conf", "-lf", "/tmp/leases/dhcpd.leases", "-user", "root", "-group", "root", "--no-pid"]
EXPOSE 67

#################################################################################
# Finalize Image
LABEL \
  license=GPLv3                                                                 \
  name="isc-dhcp"                                                               \
  vendor="ContainerCraft.io"                                                    \
  distribution-scope="public"                                                   \
  io.openshift.tags="isc-dhcp"                                                  \
  io.k8s.display-name="isc-dhcp"                                                \
  maintainer="emcee@containercraft.io"                                          \
  summary="CloudCtl DHCP | Red Hat UBI Micro Supportable Image"                 \
  description="CloudCtl DHCP | Red Hat UBI Micro Supportable Image"             \
  io.k8s.description="CloudCtl DHCP | Red Hat UBI Micro Supportable Image"
