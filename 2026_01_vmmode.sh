#!/bin/bash
set -euo pipefail

echo "Switching system to VM mode (Debian 12)"

# --- Stop Docker stack completely ---
echo "Stopping Docker services..."
systemctl stop docker docker.socket containerd 2>/dev/null || true

# Ensure Docker cannot auto-restart
systemctl is-active --quiet docker && {
  echo "ERROR: Docker is still running"
  exit 1
}

# --- Reset KVM kernel modules ---
echo "Resetting KVM kernel modules..."

modprobe -r kvm_intel kvm_amd kvm 2>/dev/null || true

modprobe kvm

if modprobe kvm_intel 2>/dev/null; then
  echo "Loaded kvm_intel"
elif modprobe kvm_amd 2>/dev/null; then
  echo "Loaded kvm_amd"
else
  echo "ERROR: Failed to load KVM CPU module"
  exit 1
fi

# --- Verify /dev/kvm ---
if [ ! -e /dev/kvm ]; then
  echo "ERROR: /dev/kvm does not exist"
  exit 1
fi

KVM_GROUP=$(stat -c "%G" /dev/kvm)
if [ "$KVM_GROUP" != "kvm" ]; then
  echo "WARNING: /dev/kvm group is '$KVM_GROUP', expected 'kvm'"
fi

# --- Start libvirt stack in correct order ---
echo "Starting libvirt services..."
systemctl restart virtlogd.socket
systemctl restart libvirtd.socket
systemctl restart libvirtd-ro.socket

# --- Verification ---
echo "Verifying libvirt..."
if ! virsh list --all >/dev/null 2>&1; then
  echo "ERROR: libvirt failed to initialize"
  journalctl -u libvirtd -n 50 --no-pager
  exit 1
fi

echo "VM mode active"
echo "You can now start virtual machines safely"
