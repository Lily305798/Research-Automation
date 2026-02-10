#!/bin/bash
set -euo pipefail

echo "Switching system to VirtualBox mode"

# Stop libvirt services
systemctl stop libvirtd virtlogd 2>/dev/null || true

# Unload KVM modules
modprobe -r kvm_intel kvm_amd kvm 2>/dev/null || true

echo "KVM modules unloaded. VirtualBox can now run."
