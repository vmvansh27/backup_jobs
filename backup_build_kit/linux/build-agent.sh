#!/usr/bin/env bash
set -euo pipefail
cd linux/src/backup-agent
if ! command -v go >/dev/null 2>&1; then echo "Go toolchain required"; exit 1; fi
GOOS=linux GOARCH=amd64 go build -o ../../agent/bin/linux-x64/backup-agent
echo "Built linux agent at linux/agent/bin/linux-x64/backup-agent"
