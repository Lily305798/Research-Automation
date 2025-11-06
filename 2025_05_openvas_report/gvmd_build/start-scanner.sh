#!/usr/bin/env bash
set -euo pipefail
echo "[entrypoint] start-scanner.sh starting..."

# Try to sync scanner feeds if possible
if command -v greenbone-nvt-sync >/dev/null 2>&1; then
  echo "[entrypoint] Running greenbone-nvt-sync..."
  greenbone-nvt-sync || echo "[entrypoint] greenbone-nvt-sync failed (non-critical)"
fi

# Attempt to start the scanner service (common names vary)
if command -v ospd-openvas >/dev/null 2>&1; then
  echo "[entrypoint] Starting ospd-openvas (foreground)..."
  exec ospd-openvas --foreground
elif command -v openvassd >/dev/null 2>&1; then
  echo "[entrypoint] Starting openvassd..."
  exec openvassd -f
else
  echo "[entrypoint] No known scanner binary found (ospd-openvas/openvassd). Exec into container to inspect."
  tail -f /dev/null
fi
