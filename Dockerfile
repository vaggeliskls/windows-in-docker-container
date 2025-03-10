# syntax=docker/dockerfile:1
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

RUN apt-get update -y && \
    apt-get install -y \
    qemu-kvm \
    build-essential \
    libvirt-daemon-system \
    libvirt-clients \
    libvirt-dev \
    ebtables \
    openssh-server \
    curl \
    net-tools \
    gettext-base \
    kmod \
    rsync \
    samba \
    jq && \
    apt-get autoremove -y && \
    apt-get clean

# Installation of vagrant
ARG VAGRANT_VERSION=2.4.3
ARG VAGRANT_BOX=peru/windows-server-2022-standard-x64-eval
RUN wget https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}-1_amd64.deb && \
    apt install ./vagrant_${VAGRANT_VERSION}-1_amd64.deb && \
    rm -rf ./vagrant_${VAGRANT_VERSION}-1_amd64.deb
# Installtion of vagrant plugins
RUN vagrant plugin install vagrant-libvirt
# Installtion of vagrant box
RUN vagrant box add --provider libvirt ${VAGRANT_BOX} && \
    vagrant init ${VAGRANT_BOX}

ENV PRIVILEGED=true
ENV INTERACTIVE=true
ENV VAGRANT_BOX=$VAGRANT_BOX

WORKDIR /app
COPY --chmod=755 startup.sh Vagrantfile /app/

ENTRYPOINT []
CMD ["/app/startup.sh"]