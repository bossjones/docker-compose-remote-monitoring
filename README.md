# docker-compose-remote-monitoring
Companion repo for docker-compose-prometheus ... installs exporters on a system w/ minimal configuration


# NOTE: On promtail + systemd 247>

```
Hey DennisGlindhart thanks for reporting and posting the workaround.

This change in 252 may be responsible for the breaking of the journal target:

        * Journal files gained a new compatibility flag
          'HEADER_INCOMPATIBLE_COMPACT'. Files with this flag implement changes
          to the storage format that allow reducing size on disk. As with other
          compatibility flags, older journalctl versions will not be able to
          read journal files using this new format. The environment variable
          'SYSTEMD_JOURNAL_COMPACT=0' can be passed to systemd-journald to
          disable this functionality. It is enabled by default.
Source: lwn.net/Articles/913287

That said, it's just a guess. I will try to verify this by setting the env variable SYSTEMD_JOURNAL_COMPACT=0 in the Docker image.

Update: The env variable of course needs to be set on the host's systemd-journald.
```

`SYSTEMD_JOURNAL_COMPACT=0`

source: https://github.com/grafana/loki/issues/8163


# node-exporter

```
git clone https://github.com/carlocorradini/node_exporter_installer
cd node_exporter_installer
INSTALL_NODE_EXPORTER_SKIP_FIREWALL=1 INSTALL_NODE_EXPORTER_SKIP_SELINUX=1 INSTALL_NODE_EXPORTER_EXEC='--path.procfs=/proc --path.rootfs=/ --path.sysfs=/sys --collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)' ./install.sh
```
