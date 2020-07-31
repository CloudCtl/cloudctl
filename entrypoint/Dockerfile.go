FROM docker.io/ocpredshift/red-gotools
WORKDIR /root/dev
RUN set -ex \
     && ./build.sh \
    && echo
