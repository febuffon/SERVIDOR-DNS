#!/bin/sh
set -euo pipefail

UNBOUND_DIR="/opt/unbound/etc/unbound"

echo "==> Generating root key for DNSSEC..."
unbound-anchor -a "${UNBOUND_DIR}/root.key" || true

echo "==> Running root hints update..."
sh "${UNBOUND_DIR}/scripts/update-root-hints.sh"

echo "==> Checking configuration..."
unbound-checkconf "${UNBOUND_DIR}/unbound.conf"

echo "==> Setup complete!"
echo "    Start the server with: unbound -d"
echo "    Or via systemd:        systemctl start unbound"
