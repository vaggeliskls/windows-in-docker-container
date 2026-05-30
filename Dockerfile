# syntax=docker/dockerfile:1
FROM ubuntu:24.04

LABEL org.opencontainers.image.source="https://github.com/vaggeliskls/windows-in-docker-container" \
      org.opencontainers.image.description="Windows VM (Vagrant + libvirt) inside a Linux container"

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color

ARG VAGRANT_VERSION=2.4.3
ARG VAGRANT_BOX=peru/windows-server-2022-standard-x64-eval

RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        wget \
        curl \
        jq \
        kmod \
        gettext-base \
        openssh-server \
        qemu-kvm \
        libvirt-daemon-system \
        libvirt-clients \
        libvirt-dev \
        ebtables \
        cpu-checker \
        build-essential && \
    wget -q "https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}-1_amd64.deb" && \
    apt-get install -y "./vagrant_${VAGRANT_VERSION}-1_amd64.deb" && \
    rm -f "./vagrant_${VAGRANT_VERSION}-1_amd64.deb" && \
    vagrant plugin install vagrant-libvirt && \
    vagrant box add --provider libvirt "${VAGRANT_BOX}" && \
    vagrant init "${VAGRANT_BOX}" && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV VAGRANT_BOX=$VAGRANT_BOX

WORKDIR /app
COPY --chmod=755 startup.sh Vagrantfile /app/

ENTRYPOINT []
CMD ["/app/startup.sh"]
