#!/usr/bin/env bash
set -euo pipefail
# Cleanup transient JSON/output artifacts at repo root (idempotent)
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"
TARGETS=(
  account-set-subdomain.json
  account-update-full-clean.json
  account-update-full.json
  account-update.json
  acct-full.json
  acct-get.json
  acct-update.json
  create-project.out.json
  native-create.out.json
  project-create-min.json
  project-create-with-id.json
  project-create.json
  project-create.response.json
)
removed=0
for f in "${TARGETS[@]}"; do
  if [ -f "$f" ]; then
    rm -f -- "$f"
    echo "Removed $f"
    removed=$((removed+1))
  fi
done
echo "Cleanup complete. Files removed: $removed"
