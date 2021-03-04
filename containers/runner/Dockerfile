FROM quay.io/cloudctl/ansible:latest
USER root

#################################################################################
# package install arguments
ARG RPM_PKGS="\
  gcc \
  bash \
  wget \
  unzip \
  nginx \
  bzip2 \
  openssh \
  python3 \
  supervisor \
  bubblewrap \
  python3-devel \
  python2-psutil \
  python3-psutil \
  python3-daemon  \
  openssh-clients \
  glibc-langpack-en \
  python3-setuptools \
  glibc-locale-source \
"
# python3-pexpect \

# Pip package list
ARG PIP_PKGS="\
  uwsgi \
  flask \
  psutil \
  PyYAML \
  netaddr \
  notario \
  ansible \
  docutils \
  pyOpenSSL \
  cryptography \
  flask-restful \
"
ARG YUM_FLAGS="\
    -y \
    --nobest \
    --allowerasing \
    --setopt=tsflags=nodocs \
"
#   --disablerepo="ubi-8-appstream" \
#   --disablerepo="ubi-8-codeready-builder" \
#   --disablerepo="ubi-8-baseos" \

ARG SERVICE_DIR="/root/ansible-runner-service"
#################################################################################
# Install RPM Dependencies
#    && sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/subscription-manager.conf \
RUN set -ex \
     && dnf install ${YUM_FLAGS} https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm \
     && dnf install ${YUM_FLAGS} ${RPM_PKGS} \
     && dnf clean all \
     && rm -rf /var/cache/yum \
    && echo

#################################################################################
# PIP Install Dependencies
RUN set -ex \
     && /usr/bin/python3 -m \
          pip install --upgrade ${PIP_PKGS} \
    && echo
RUN set -ex \
     && /usr/bin/python3 -m \
          pip install --no-cache-dir ansible-runner \
    && echo

#################################################################################
# Prepare folders for shared access and ssh
RUN set -ex \
     && mkdir -p \
          /root/.ssh \
          /etc/ansible-runner-service \
          /usr/share/ansible-runner-service/{artifacts,env,project,inventory,client_cert} \
     && localedef -c -i en_US -f UTF-8 en_US.UTF-8 \
    && echo

#################################################################################
# Install Ansible Runner
COPY ./ansible-runner-service/*.py           ${SERVICE_DIR}/
COPY ./ansible-runner-service/*.yaml         ${SERVICE_DIR}/
COPY ./ansible-runner-service/samples        ${SERVICE_DIR}/samples
COPY ./ansible-runner-service/runner_service ${SERVICE_DIR}/runner_service

# Load ansible-runner-service configuration files from git

# Nginx config
COPY ./ansible-runner-service/misc/nginx/nginx.conf          /etc/nginx/
# Ansible Runner Service nginx virtual server
COPY ./ansible-runner-service/misc/nginx/ars_site_nginx.conf /etc/nginx/conf.d
# Ansible Runner Service uwsgi settings
COPY ./ansible-runner-service/misc/nginx/uwsgi.ini           ${SERVICE_DIR}
# Supervisor start sequence
COPY ./ansible-runner-service/misc/nginx/supervisord.conf    ${SERVICE_DIR}

ADD ./rootfs /

CMD ["/usr/bin/supervisord", "-c", "/root/ansible-runner-service/supervisord.conf"]
WORKDIR /root
