#!/bin/sh
set -euo pipefail

CERT_DIR="/opt/unbound/etc/unbound/tls"
SERVER_IP="${1:-127.0.0.1}"

if [ ! -f "${CERT_DIR}/server.pem" ]; then
    echo "==> Generating self-signed certificate for TLS (DoT)..."
    mkdir -p "${CERT_DIR}"

    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
        -keyout "${CERT_DIR}/server.key" \
        -out "${CERT_DIR}/server.pem" \
        -subj "/CN=dns-server" \
        -addext "subjectAltName=IP:${SERVER_IP}"

    chmod 600 "${CERT_DIR}/server.key"
    chmod 644 "${CERT_DIR}/server.pem"
    echo "==> Certificates created in ${CERT_DIR}"
else
    echo "==> Certificates already exist in ${CERT_DIR}"
fi

# After generating certs, enable TLS in unbound.conf:
#   tls-port: 853
#   tls-service-pem: /opt/unbound/etc/unbound/tls/server.pem
#   tls-service-key: /opt/unbound/etc/unbound/tls/server.key
