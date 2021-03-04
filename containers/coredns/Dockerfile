FROM docker.io/coredns/coredns:latest as core
FROM quay.io/cloudctl/ubi:minimal

COPY --from=core /coredns /usr/local/bin/coredns
RUN set -ex \
     && /usr/local/bin/coredns -version || exit 1 \
    && echo

EXPOSE 53/tcp
EXPOSE 53/udp
EXPOSE 5353/tcp
EXPOSE 5353/udp

ENTRYPOINT ["/usr/local/bin/coredns"]
CMD ["-conf", "/CoreFile"]
LABEL name="CloudCtl CoreDNS" \
      vendor="ContainerCraft.io" \
      maintainer="emcee@containercraft.io" \
      summary="Red Hat Ubi8 Minimal CoreDNS" \
      description="UBI8 Minimal CoreDNS"
