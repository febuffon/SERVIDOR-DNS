#!/bin/sh
# Update root hints file from IANA
# Run weekly via cron: 0 3 * * 1 /opt/unbound/etc/unbound/scripts/update-root-hints.sh

ROOT_HINTS_URL="https://www.internic.net/domain/named.cache"
ROOT_HINTS_FILE="/opt/unbound/etc/unbound/root.hints"

echo "[$(date)] Downloading root hints from ${ROOT_HINTS_URL}..."
if wget -q -O "${ROOT_HINTS_FILE}.tmp" "${ROOT_HINTS_URL}"; then
    mv "${ROOT_HINTS_FILE}.tmp" "${ROOT_HINTS_FILE}"
    echo "[$(date)] Root hints updated successfully"
else
    echo "[$(date)] Failed to download root hints"
    rm -f "${ROOT_HINTS_FILE}.tmp"
    exit 1
fi
