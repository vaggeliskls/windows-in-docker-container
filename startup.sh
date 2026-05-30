#!/bin/bash
set -eou pipefail

# Allow libvirt access to KVM device when present
[ -e /dev/kvm ] && chown root:kvm /dev/kvm

# Start libvirt services. Direct daemon logs to a file we can tail at the end.
mkdir -p /var/log/libvirt
LIBVIRT_LOG_OUTPUTS="1:file:/var/log/libvirt/libvirtd.log" libvirtd --daemon
virtlogd --daemon

# Wait for libvirtd to accept connections before driving it
for _ in $(seq 1 30); do
    virsh -c qemu:///system version >/dev/null 2>&1 && break
    sleep 1
done

# Fall back to qemu if KVM acceleration is unavailable
if kvm-ok 2>&1 | grep -q "KVM acceleration can NOT be used"; then
    export LIBVIRT_DRIVER="qemu"
    echo "--> KVM acceleration is not available, falling back to qemu"
fi

# Boot the Vagrant VM
vagrant up --provider=libvirt

# Show running domains
virsh list --all

# Gracefully power off the VM when the container is asked to stop (docker stop -> SIGTERM).
# Without this the VM is hard-killed, risking a dirty shutdown / corrupt disk image.
shutdown() {
    echo "--> Stopping VM..."
    vagrant halt || virsh shutdown --domain "$(virsh list --name)" || true
    exit 0
}
trap shutdown SIGTERM SIGINT

# Keep the container alive, surfacing libvirt logs. Run in the background (not exec)
# so the trap above can fire on shutdown.
touch /var/log/libvirt/libvirtd.log
tail -F /var/log/libvirt/libvirtd.log &
wait $!
