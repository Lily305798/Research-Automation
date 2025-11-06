#!/usr/bin/env bash
set -euo pipefail
echo "[entrypoint] start-gvmd.sh starting..."

# Optional environment variables
GVMD_USER="${GVMD_USER:-admin}"
GVMD_PASSWORD="${GVMD_PASSWORD:-adminpassword}"
SOCKET_DIR="${SOCKET_DIR:-/run/gvmd}"
SOCKET_PATH="${SOCKET_PATH:-${SOCKET_DIR}/gvmd.sock}"

mkdir -p "${SOCKET_DIR}"
chown --recursive root:root "${SOCKET_DIR}" || true
chmod 700 "${SOCKET_DIR}" || true

# 1) Try feed syncs if the utilities exist
if command -v greenbone-nvt-sync >/dev/null 2>&1; then
  echo "[entrypoint] Running greenbone-nvt-sync ..."
  greenbone-nvt-sync || echo "[entrypoint] greenbone-nvt-sync failed (non-critical)"
fi

if command -v greenbone-scapdata-sync >/dev/null 2>&1; then
  echo "[entrypoint] Running greenbone-scapdata-sync ..."
  greenbone-scapdata-sync || echo "[entrypoint] greenbone-scapdata-sync failed (non-critical)"
fi

if command -v greenbone-certdata-sync >/dev/null 2>&1; then
  echo "[entrypoint] Running greenbone-certdata-sync ..."
  greenbone-certdata-sync || echo "[entrypoint] greenbone-certdata-sync failed (non-critical)"
fi

# 2) Initialize gvmd user if gvmd provides CLI to do so (try safely)
if command -v gvmd >/dev/null 2>&1; then
  echo "[entrypoint] gvmd binary found."

  # If the GVMD DB is empty, create initial admin user (try tolerant)
  # NOTE: command names can vary by gvmd version. Adjust if necessary.
  if gvmd --create-user 2>/dev/null | grep -qi 'unknown'; then
    echo "[entrypoint] gvmd --create-user not supported in this build; skip."
  else
    # create admin user if it does not exist
    echo "[entrypoint] Ensuring admin user exists (might print error if already exists)..."
    gvmd --create-user="${GVMD_USER}" --password="${GVMD_PASSWORD}" || true
  fi
else
  echo "[entrypoint] gvmd binary not found in image; please inspect image and edit this script."
fi

# 3) Start gvmd (attempt common invocation; if fails, print a hint)
echo "[entrypoint] Starting gvmd..."
if gvmd --listen="${SOCKET_PATH}" 2>/dev/null; then
  echo "[entrypoint] gvmd started (background?). Tailing syslog not available; sleeping to keep container alive."
  # if gvmd forks, keep container alive
  tail -f /dev/null
else
  echo "[entrypoint] Direct gvmd --listen failed or not supported. Trying 'gvmd' in foreground."
  if command -v gvmd >/dev/null 2>&1; then
    exec gvmd
  else
    echo "[entrypoint] gvmd not available. Please exec into the container to inspect and adapt startup commands."
    tail -f /dev/null
  fi
fi
