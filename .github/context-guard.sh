#!/usr/bin/env bash
set -euo pipefail

# Context Guard: Lean repo hygiene & forbidden pattern scan
# Goals:
# 1. Ensure only canonical files (context-manifest.json) + allowed generated paths exist.
# 2. Detect empty directories (except explicitly allowed). 
# 3. Scan for forbidden patterns (regex) defined in manifest.
# 4. Provide actionable, concise output with remediation hints.
# 5. Exit non-zero on violations; zero if clean or only warnings in INFO mode.

MANIFEST=".github/context-manifest.json"
ALLOW_EMPTY_DIRS=(".github/prompts")
INFO_MODE=${INFO_MODE:-0}
REFERENCE_DIR="AI_RedTeaming/reference/upstream_sample"


fail() { echo "[FAIL] $*" >&2; exit 1; }
warn() { echo "[WARN] $*" >&2; }
info() { echo "[INFO] $*" >&2; }

[[ -f "$MANIFEST" ]] || fail "Manifest $MANIFEST missing"

# Extract canonical file list
mapfile -t CANONICAL < <(jq -r '.canonical_files[].path' "$MANIFEST" | sort)
CANON_SET=$(printf '%s\n' "${CANONICAL[@]}" | sort)

# 1. Orphan file detection
ORPHANS=()
REFERENCE_WRITES=()
while IFS= read -r -d '' f; do
  rel=${f#./}
  # Skip git internals
  [[ $rel == .git/* ]] && continue
  # Track reference directory modifications (excluding sentinel)
  if [[ $rel == $REFERENCE_DIR/* ]] && [[ $rel != $REFERENCE_DIR/DO_NOT_EDIT_REFERENCE.txt ]]; then
    REFERENCE_WRITES+=("$rel")
  fi
  # Skip manifest itself if not listed (should be listed though)
  if ! grep -Fxq "$rel" <(printf '%s\n' "${CANONICAL[@]}"); then
    ORPHANS+=("$rel")
  fi
done < <(find . -type f -print0)

# 2. Empty directory detection
EMPTY_DIRS=()
while IFS= read -r -d '' d; do
  rel=${d#./}
  skip=0
  for allowed in "${ALLOW_EMPTY_DIRS[@]}"; do
    [[ $rel == "$allowed" ]] && skip=1 && break
  done
  [[ $skip -eq 1 ]] && continue
  # Check directory content count (excluding .DS_Store or similar)
  count=$(find "$d" -mindepth 1 -maxdepth 1 ! -name '.DS_Store' | wc -l | xargs)
  [[ $count -eq 0 ]] && EMPTY_DIRS+=("$rel")
done < <(find . -type d -print0)

# 3. Forbidden pattern scan
FORBIDDEN_MATCHES=()
while IFS= read -r regex; do
  [[ -z $regex ]] && continue
  # grep -R -n without binary
  while IFS= read -r line; do
    FORBIDDEN_MATCHES+=("$regex :: $line")
  done < <(grep -RIn --exclude-dir=.git -E "$regex" . || true)
done < <(jq -r '.forbidden_patterns[].regex' "$MANIFEST")

STATUS=0
if ((${#ORPHANS[@]})); then
  echo "Orphan files detected (not in manifest):" >&2
  printf '  - %s\n' "${ORPHANS[@]}" >&2
  STATUS=1
fi
if ((${#REFERENCE_WRITES[@]})); then
  echo "Reference directory modifications detected (should remain read-only):" >&2
  printf '  - %s\n' "${REFERENCE_WRITES[@]}" >&2
  STATUS=1
fi
if ((${#EMPTY_DIRS[@]})); then
  echo "Empty directories detected:" >&2
  printf '  - %s\n' "${EMPTY_DIRS[@]}" >&2
  STATUS=1
fi
if ((${#FORBIDDEN_MATCHES[@]})); then
  echo "Forbidden pattern matches:" >&2
  printf '  - %s\n' "${FORBIDDEN_MATCHES[@]}" >&2
  STATUS=1
fi

if [[ $STATUS -ne 0 ]]; then
  echo "--- Remediation Hints ---" >&2
  [[ ${#ORPHANS[@]} -gt 0 ]] && echo "Add to .github/context-manifest.json canonical_files or delete" >&2
  [[ ${#REFERENCE_WRITES[@]} -gt 0 ]] && echo "Move changes outside reference directory; create project-specific variant instead" >&2
  [[ ${#EMPTY_DIRS[@]} -gt 0 ]] && echo "Remove empty directories or add to ALLOW_EMPTY_DIRS in context-guard.sh if intentional" >&2
  [[ ${#FORBIDDEN_MATCHES[@]} -gt 0 ]] && echo "Remove secrets / replace with placeholders; if intentional examples add comment '# allow-patterns' above the block and adjust guard logic (future enhancement)" >&2
fi

if [[ $STATUS -eq 0 ]]; then
  info "Repository hygiene check passed."
fi

if [[ $INFO_MODE -eq 1 ]]; then
  exit 0
fi

exit $STATUS
