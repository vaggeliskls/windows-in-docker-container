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

RUN curl -O https://releases.hashicorp.com/vagrant/2.2.19/vagrant_2.2.19_x86_64.deb && \
    dpkg -i vagrant_2.2.19_x86_64.deb && \
    vagrant plugin install vagrant-libvirt && \
    vagrant box add --provider libvirt peru/windows-server-2022-standard-x64-eval && \
    vagrant init peru/windows-server-2022-standard-x64-eval

ENV PRIVILEGED=true
ENV INTERACTIVE=true

COPY Vagrantfile /Vagrantfile.tmp
COPY startup.sh /
RUN chmod +x startup.sh
RUN rm -rf /Vagrantfile

ENTRYPOINT ["/startup.sh"]
CMD ["/bin/bash"]