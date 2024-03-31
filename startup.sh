#!/bin/bash
# Username: Administrator, vagrant
# Password: vagrant
set -eou pipefail
# Replace environmental variable to Vagrandfile
export RANDOM_STR=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

if [ ! -f Vagrantfile ]
then
    envsubst \
    '${VAGRANT_BOX},${PRIVILEGED},${INTERACTIVE},${MEMORY},${CPU},${DISK_SIZE},${RANDOM_STR}' \
    < Vagrantfile.tmp > Vagrantfile
fi

chown root:kvm /dev/kvm

/usr/sbin/libvirtd --daemon
/usr/sbin/virtlogd --daemon

VAGRANT_DEFAULT_PROVIDER=libvirt vagrant up #--debug

exec "$@"