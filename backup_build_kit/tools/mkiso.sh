#!/usr/bin/env bash
set -euo pipefail
OUT="${1:-out/backup-jeos.iso}"
WORK="$(mktemp -d)"
mkdir -p "$(dirname "$OUT")"
echo "Backup JeOS placeholder $(date -u)" > "$WORK/README.txt"
if command -v genisoimage >/dev/null 2>&1; then
  genisoimage -quiet -V "BACKUP_JEOS" -o "$OUT" "$WORK"
else
  echo "genisoimage not found. Creating text placeholder instead."
  echo "This is a placeholder. Build real ISO in CI with genisoimage or xorriso." > "$OUT"
fi
