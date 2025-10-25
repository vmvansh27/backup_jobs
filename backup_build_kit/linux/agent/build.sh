#!/usr/bin/env bash
set -euo pipefail
APP_VER="${APP_VER:-1.0.0}"
APP_ROOT="linux/agent/bin/linux-x64"
OUT="linux/agent/dist"
mkdir -p "$OUT"
if ! command -v fpm >/dev/null 2>&1; then echo "Install fpm (gem install fpm)"; exit 1; fi
mkdir -p pkgroot/usr/local/bin pkgroot/etc/systemd/system
cp -f "$APP_ROOT/backup-agent" pkgroot/usr/local/bin/backup-agent
cat > pkgroot/etc/systemd/system/backup-agent.service <<'EOF'
[Unit]
Description=Backup Agent
After=network-online.target
Wants=network-online.target
[Service]
ExecStart=/usr/local/bin/backup-agent
Restart=always
[Install]
WantedBy=multi-user.target
EOF
fpm -s dir -t deb -n backup-agent -v "$APP_VER" -C pkgroot   --description "Backup Agent"   --license "Proprietary"   --maintainer "YourCo"   usr/local/bin/backup-agent etc/systemd/system/backup-agent.service
mv *.deb "$OUT/" 2>/dev/null || true
fpm -s dir -t rpm -n backup-agent -v "$APP_VER" -C pkgroot   --description "Backup Agent"   --license "Proprietary"   --maintainer "YourCo"   usr/local/bin/backup-agent etc/systemd/system/backup-agent.service
mv *.rpm "$OUT/" 2>/dev/null || true
echo "Packages in $OUT"
