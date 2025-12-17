#!/bin/bash
set -e

echo "[+] Preparing runtime directories"
mkdir -p /var/run/ospd /var/lib/redis
chmod 755 /var/run/ospd

echo "[+] Starting Redis"
redis-server --daemonize yes

# Wait for Redis to be ready
for i in {1..10}; do
  if redis-cli ping >/dev/null 2>&1; then
    echo "[+] Redis is ready"
    break
  fi
  sleep 1
done

echo "[+] Starting ospd-openvas"
exec /opt/ospd-venv/bin/ospd-openvas \
  --socket-path=/var/run/ospd/ospd-openvas.sock \
  --log-file=/var/log/ospd-openvas.log \
  --log-level=INFO \
  --pid-file=/var/run/ospd/ospd-openvas.pid \
  --unix-socket-mode=0o777
