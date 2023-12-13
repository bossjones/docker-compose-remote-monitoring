#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root"
  exit 1
fi

echo "192.168.3.16 loki-gateway.scarlettlab.home loki-gateway" | sudo tee -a /etc/hosts

# cd ~/ || exit

wget https://github.com/grafana/loki/releases/download/v2.8.3/promtail_2.8.3_amd64.deb

dpkg -i promtail_2.8.3_amd64.deb

groupadd promtail

usermod -a -G systemd-journal promtail

usermod -a -G adm promtail

touch /tmp/positions.yaml

chown promtail:promtail /tmp/positions.yaml

systemctl cat promtail

# cp -a ../../promtail/host-promtail-gateway.yaml /etc/promtail/config.yml
cp -a ../../promtail/host-pve1-promtail-gateway.yaml /etc/promtail/config.yml
cp -a ../../promtail/host-boss-station-promtail-gateway.yaml /etc/promtail/config.yml

# ---------------------------------

# create a heredoc that writes to overrides.conf
mkdir -p /etc/systemd/system/promtail.service.d/ || true
cat <<EOF >/etc/systemd/system/promtail.service.d/overrides.conf
[Service]
User=root
Environment=NODENAME=$(hostname)
EOF

echo -e "\n"

cat /etc/systemd/system/promtail.service.d/overrides.conf

systemctl daemon-reload

# ---------------------------------

systemctl restart promtail
