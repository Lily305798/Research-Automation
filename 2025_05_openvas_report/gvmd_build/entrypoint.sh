#!/bin/bash
set -e

echo "[+] Starting Redis..."
redis-server --daemonize yes

echo "[+] Ensuring feed directories exist..."
mkdir -p /var/lib/openvas/plugins

echo "[+] Scanner plugins directory: /var/lib/openvas/plugins"

echo "[+] If you want to sync feeds manually, run:"
echo "      greenbone-feed-sync --type nvt"

# Keep container alive or pass-through commands
exec "$@"
