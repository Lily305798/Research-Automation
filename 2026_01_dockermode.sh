#!/bin/bash
set -euo pipefail

echo "Switching system to Docker mode (Debian 12)"

# --- Stop libvirt stack ---
echo "Stopping libvirt services..."
systemctl stop libvirtd.socket libvirtd-ro.socket virtlogd.socket virtlockd.socket 2>/dev/null || true


# --- Start Docker stack ---
echo "Starting Docker services..."
systemctl start containerd
systemctl start docker

# --- Verification ---
echo "Verifying Docker..."
if ! docker info >/dev/null 2>&1; then
  echo "ERROR: Docker failed to start"
  journalctl -u docker -n 50 --no-pager
  exit 1
fi

echo "Docker mode active"
echo "You can now run containers safely"
