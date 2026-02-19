#!/usr/bin/env bash
# Sync durable markdown files between Storj and local workspace.
# Usage: storj-sync.sh pull|push
# Requires: STORJ_ACCESS_GRANT and STORJ_BUCKET env vars

set -euo pipefail

BUCKET="${STORJ_BUCKET:-marcus-workspace}"
PREFIX="${STORJ_PREFIX:-workspace}"
LOCAL_DIR="${OPENCLAW_WORKSPACE:-/home/node/.openclaw/workspace}"

# Files/dirs to sync (durable state only)
SYNC_PATHS=(
  "MEMORY.md"
  "SOUL.md"
  "USER.md"
  "TOOLS.md"
  "AGENTS.md"
  "IDENTITY.md"
  "HEARTBEAT.md"
  "memory/"
)

if [ -z "${STORJ_ACCESS_GRANT:-}" ]; then
  echo "[storj-sync] No STORJ_ACCESS_GRANT set, skipping sync"
  exit 0
fi

case "${1:-}" in
  pull)
    echo "[storj-sync] Pulling durable files from sj://$BUCKET/$PREFIX/"
    for path in "${SYNC_PATHS[@]}"; do
      if [[ "$path" == */ ]]; then
        # Directory sync
        uplink cp --recursive "sj://$BUCKET/$PREFIX/$path" "$LOCAL_DIR/$path" 2>/dev/null || true
      else
        uplink cp "sj://$BUCKET/$PREFIX/$path" "$LOCAL_DIR/$path" 2>/dev/null || true
      fi
    done
    echo "[storj-sync] Pull complete"
    ;;
  push)
    echo "[storj-sync] Pushing durable files to sj://$BUCKET/$PREFIX/"
    for path in "${SYNC_PATHS[@]}"; do
      local_path="$LOCAL_DIR/$path"
      if [[ "$path" == */ ]]; then
        [ -d "$local_path" ] && uplink cp --recursive "$local_path" "sj://$BUCKET/$PREFIX/$path" 2>/dev/null || true
      else
        [ -f "$local_path" ] && uplink cp "$local_path" "sj://$BUCKET/$PREFIX/$path" 2>/dev/null || true
      fi
    done
    echo "[storj-sync] Push complete"
    ;;
  *)
    echo "Usage: storj-sync.sh pull|push"
    exit 1
    ;;
esac
