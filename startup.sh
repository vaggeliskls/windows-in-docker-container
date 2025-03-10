#!/bin/bash
set -eou pipefail
pwd
# Start services
[ -e /dev/kvm ] && chown root:kvm /dev/kvm
# dbus-daemon --system --fork
libvirtd --daemon
virtlogd --daemon
if kvm-ok 2>&1 | grep -q "KVM acceleration can NOT be used"; then
    export LIBVIRT_DRIVER="qemu"
    echo "--> KVM acceleration can NOT be used"
fi
# smbd --daemon
# Start vagrant box
# Debug: --debug
vagrant up --provider=libvirt
# Display running boxes
virsh list --all
# Keep container running
exec tail -f /dev/null