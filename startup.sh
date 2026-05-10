#!/bin/bash
set -eou pipefail

# Allow libvirt access to KVM device when present
[ -e /dev/kvm ] && chown root:kvm /dev/kvm

# Start libvirt services. Direct daemon logs to a file we can tail at the end.
mkdir -p /var/log/libvirt
LIBVIRT_LOG_OUTPUTS="1:file:/var/log/libvirt/libvirtd.log" libvirtd --daemon
virtlogd --daemon

# Fall back to qemu if KVM acceleration is unavailable
if kvm-ok 2>&1 | grep -q "KVM acceleration can NOT be used"; then
    export LIBVIRT_DRIVER="qemu"
    echo "--> KVM acceleration is not available, falling back to qemu"
fi

# Boot the Vagrant VM
vagrant up --provider=libvirt

# Show running domains, then keep the container alive by tailing libvirt logs
virsh list --all
touch /var/log/libvirt/libvirtd.log
exec tail -F /var/log/libvirt/libvirtd.log
