#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="gluetun"

if ! command -v docker >/dev/null 2>&1; then
  echo "[WARN] Docker CLI is not installed on this host; skipping resolv.conf check." >&2
  exit 0
fi

if ! docker ps --format '{{.Names}}' | grep -qx "${CONTAINER_NAME}"; then
  echo "[WARN] Container '${CONTAINER_NAME}' is not running; skipping resolv.conf check." >&2
  exit 0
fi

docker exec "${CONTAINER_NAME}" sh -eu -c '
resolv_file="/etc/resolv.conf"

if awk "BEGIN {count=0; other=0} /^[[:space:]]*nameserver[[:space:]]+/ {count++; if (\$2 != \"127.0.0.1\") other=1} END {exit !(count==1 && other==0)}" "$resolv_file"; then
  grep -Eq "^[[:space:]]*nameserver[[:space:]]+192\\.168\\.1\\.192([[:space:]]|$)" "$resolv_file" || echo "nameserver   192.168.1.192" >> "$resolv_file"
  grep -Eq "^[[:space:]]*nameserver[[:space:]]+1\\.1\\.1\\.1([[:space:]]|$)" "$resolv_file" || echo "nameserver   1.1.1.1" >> "$resolv_file"
fi
'
