#!/bin/bash
set -e

# Ensure runtime dir exists
mkdir -p /var/run/ospd
chmod 755 /var/run/ospd

# Start redis (required for scanner)
redis-server --daemonize yes

# Verify redis is up
redis-cli ping

# Start ospd-openvas
exec /usr/local/bin/ospd-openvas \
    --socket-path=/var/run/ospd/ospd-openvas.sock \
    --log-file=/var/log/ospd-openvas.log \
    --log-level=INFO \
    --pid-file=/var/run/ospd/ospd-openvas.pid \
    --unix-socket-mode=0o777 \
    --scanner-ca-file=/usr/local/var/lib/gvm/CA/cacert.pem \
    --scanner-key-file=/usr/local/var/lib/gvm/private/CA/clientkey.pem \
    --scanner-cert-file=/usr/local/var/lib/gvm/CA/clientcert.pem
