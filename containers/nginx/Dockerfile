FROM quay.io/cloudctl/ubi:minimal
COPY entrypoint /entrypoint

USER root
ARG RPM_PKGS="\
  nginx \
  findutils \
"
RUN set -ex \
     && dnf install -y ${RPM_PKGS} \
     && dnf clean all \
     && rm -rf /var/cache/yum \
     && /usr/sbin/nginx -v || exit 1 \
     && mkdir /var/cache/nginx \
     && chown -R nginx:0 \
                  /var/log/nginx/ \
                  /var/cache/nginx \
                  /usr/share/nginx \
     && chmod -R g=u \
                  /var/log/nginx/ \
                  /var/cache/nginx \
                  /usr/share/nginx \
     && mkdir /licenses \
     && cp /usr/share/doc/nginx*/* /licenses \
    ; echo

#USER nginx
WORKDIR /
EXPOSE  8443 8080
ENTRYPOINT ["/entrypoint"]
LABEL name="CloudCtl Nginx" \
      vendor="ContainerCraft.io" \
      maintainer="emcee@containercraft.io" \
      version="1.14.1" \
      summary="Red Hat Ubi8 Simple Nginx Service" \
      description="UBI Based Nginx Container"
