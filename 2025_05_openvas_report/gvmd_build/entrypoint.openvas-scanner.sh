#!/bin/bash
set -e

echo "[+] Preparing runtime directories"
mkdir -p /var/run/openvas
mkdir -p /var/lib/openvas/plugins

echo "[+] Starting Redis"
redis-server --daemonize yes

redis-cli ping
echo "[+] Redis is ready"

echo "[+] Starting openvas-scanner"

exec openvas