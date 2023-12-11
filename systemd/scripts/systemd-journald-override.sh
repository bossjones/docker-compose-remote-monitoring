#!/usr/bin/env bash

# close script if you are not running as root id

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root"
  exit 1
fi

mkdir -p /etc/systemd/system/systemd-journald.service.d/ || true

# create a heredoc that writes to overrides.conf

cat <<EOF >/etc/systemd/system/systemd-journald.service.d/overrides.conf
# See https://issues.redhat.com/browse/LOG-3832
# This allows containers running rhel8 to read our journal
[Service]
# * $($SYSTEMD_JOURNAL_COMPACT) - Takes a boolean. If enabled, journal files are written
# in a more compact format that reduces the amount of disk space required by the
# journal. Note that journal files in compact mode are limited to 4G to allow use of
# 32-bit offsets. Enabled by default.
Environment=SYSTEMD_JOURNAL_COMPACT=0

# systemd-journald gained support for zstd compression of large fields
# in journal files. The hash tables in journal files have been hardened
# against hash collisions. This is an incompatible change and means
# that journal files created with new systemd versions are not readable
# with old versions. If the SYSTEMD_JOURNAL_KEYED_HASH boolean
# environment variable for systemd-journald.service is set to 0 this
# new hardening functionality may be turned off, so that generated
# journal files remain compatible with older journalctl
# implementations.
# SOURCE: If the SYSTEMD_JOURNAL_KEYED_HASH boolean
# environment variable for systemd-journald.service is set to 0 this
# new hardening functionality may be turned off, so that generated
# journal files remain compatible with older journalctl
# implementations.
Environment=SYSTEMD_JOURNAL_KEYED_HASH=0

# SYSTEMD_JOURNAL_COMPRESS - Takes a boolean, or one of the compression algorithms "XZ", "LZ4", and "ZSTD". If enabled, the default compression algorithm set at compile time will be used when opening a new journal file. If disabled, the journal file compression will be disabled. Note that the compression mode of existing journal files are not changed. To make the specified algorithm takes an effect immediately, you need to explicitly run journalctl --rotate.
Environment=SYSTEMD_JOURNAL_COMPRESS=LZ4
EOF

echo -e "\n"

cat /etc/systemd/system/systemd-journald.service.d/overrides.conf

systemctl daemon-reload
