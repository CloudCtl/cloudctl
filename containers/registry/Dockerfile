FROM docker.io/library/registry:latest as docker
FROM quay.io/cloudctl/ubi:micro

COPY --from=docker /etc/docker    /etc/docker
COPY --from=docker /bin/registry  /bin/registry
COPY --from=docker /entrypoint.sh /entrypoint

RUN set -ex \
     && /bin/registry -v || exit 1 \
    && echo

EXPOSE 5000 5000/tcp
ENTRYPOINT ["/entrypoint"]
CMD ["serve", "/etc/docker/registry/config.yml"]
LABEL name="CloudCtl Registry" \
      vendor="ContainerCraft.io" \
      maintainer="emcee@containercraft.io" \
      summary="Red Hat Ubi8 Minimal Docker Registry" \
      description="UBI8 Minimal Docker Registry"
