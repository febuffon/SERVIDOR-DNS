Place your custom zone files and blocklists here.

For blocklists in RPZ format, add lines like:
  local-zone: "domain.com." redirect
  local-data: "domain.com. IN A 0.0.0.0"

Or use a file include in the main config:
  include: /opt/unbound/etc/unbound/local-data/blocklist.conf
