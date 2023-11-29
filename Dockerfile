# syntax=docker/dockerfile:1.5
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color

RUN apt-get update -y && \
    apt-get install -y \
    qemu-kvm \
    build-essential \
    libvirt-daemon-system \
    libvirt-dev \
    openssh-server \
    curl \
    net-tools \
    gettext-base \
    jq && \
    apt-get autoremove -y && \
    apt-get clean

# Installation of vagrant
RUN wget https://releases.hashicorp.com/vagrant/2.4.0/vagrant_2.4.0-1_amd64.deb && \
    apt install ./vagrant_2.4.0-1_amd64.deb && \
    rm -rf ./vagrant_2.4.0-1_amd64.deb
# Installtion of vagrant plugins
RUN vagrant plugin install vagrant-libvirt
# Installtion of vagrant box
RUN vagrant box add --provider libvirt peru/windows-server-2022-standard-x64-eval && \
    vagrant init peru/windows-server-2022-standard-x64-eval

ENV PRIVILEGED=true
ENV INTERACTIVE=true

COPY Vagrantfile /Vagrantfile.tmp
COPY startup.sh /
RUN chmod +x startup.sh
RUN rm -rf /Vagrantfile

ENTRYPOINT ["/startup.sh"]
CMD ["/bin/bash"]