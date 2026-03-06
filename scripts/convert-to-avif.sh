#!/usr/bin/env bash
set -euo pipefail

# Convert JPG/JPEG/PNG images to AVIF and update Markdown references.
# Usage: scripts/convert-to-avif.sh [--dry-run] [--quality N] [--keep-originals]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

DRY_RUN=false
QUALITY=80
KEEP_ORIGINALS=false

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --quality)
      QUALITY="$2"
      shift 2
      ;;
    --keep-originals)
      KEEP_ORIGINALS=true
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: $0 [--dry-run] [--quality N] [--keep-originals]" >&2
      exit 1
      ;;
  esac
done

if $DRY_RUN; then
  echo "[DRY RUN] No files will be modified."
fi

# ---------------------------------------------------------------------------
# Verify ImageMagick is available
# ---------------------------------------------------------------------------
if ! command -v convert &>/dev/null; then
  echo "ERROR: 'convert' (ImageMagick) not found in PATH." >&2
  exit 1
fi

# ---------------------------------------------------------------------------
# Step 1: Convert images
# ---------------------------------------------------------------------------
IMAGES_CONVERTED=0
IMAGES_SKIPPED=0

mapfile -d '' IMAGES < <(
  find "$REPO_ROOT/content" "$REPO_ROOT/static" \
    -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) \
    -print0 2>/dev/null
)

for img in "${IMAGES[@]}"; do
  avif="${img%.*}.avif"

  if [[ -f "$avif" ]]; then
    echo "  SKIP  (avif exists): ${img#$REPO_ROOT/}"
    (( IMAGES_SKIPPED++ )) || true
    continue
  fi

  echo "  CONVERT: ${img#$REPO_ROOT/} -> ${avif#$REPO_ROOT/}"

  if ! $DRY_RUN; then
    if convert "$img" -auto-orient -quality "$QUALITY" "$avif"; then
      if ! $KEEP_ORIGINALS; then
        rm -f "$img"
      fi
      (( IMAGES_CONVERTED++ )) || true
    else
      echo "  ERROR: conversion failed for ${img#$REPO_ROOT/}" >&2
    fi
  else
    (( IMAGES_CONVERTED++ )) || true
  fi
done

# ---------------------------------------------------------------------------
# Step 2: Update .md references
# ---------------------------------------------------------------------------
MD_UPDATED=0

mapfile -d '' MD_FILES < <(
  find "$REPO_ROOT/content" -type f -name "*.md" -print0 2>/dev/null
)

for md in "${MD_FILES[@]}"; do
  # Check if file contains any jpg/jpeg/png reference (case-insensitive)
  if ! grep -qiE '\.(jpg|jpeg|png)' "$md"; then
    continue
  fi

  echo "  UPDATE md: ${md#$REPO_ROOT/}"

  if ! $DRY_RUN; then
    # Replace extensions in src="" attributes and Markdown image syntax
    # Uses perl for case-insensitive replacement without temp file dance
    LC_ALL=C perl -i -pe '
      s{(src=["'"'"'][^"'"'"']*)\.(jpg|jpeg|png)(["'"'"'])}{$1.avif$3}gi;
      s{(!\[[^\]]*\]\([^)]*)\.(jpg|jpeg|png)(\))}{$1.avif$3}gi;
      s{^(image:\s+(?!https?://).*)\.(jpg|jpeg|png)(\s*)$}{$1.avif$3}gi;
    ' "$md"
    (( MD_UPDATED++ )) || true
  else
    (( MD_UPDATED++ )) || true
  fi
done

# ---------------------------------------------------------------------------
# Step 3: Update config files (hugo.yaml, hugo.toml, config.yaml, etc.)
# ---------------------------------------------------------------------------
CONFIG_UPDATED=0

mapfile -d '' CONFIG_FILES < <(
  find "$REPO_ROOT" -maxdepth 2 -type f \
    \( -name "hugo.yaml" -o -name "hugo.toml" -o -name "config.yaml" -o -name "config.toml" \) \
    -print0 2>/dev/null
)

for cfg in "${CONFIG_FILES[@]}"; do
  if ! grep -qiE '\.(jpg|jpeg|png)' "$cfg"; then
    continue
  fi

  echo "  UPDATE config: ${cfg#$REPO_ROOT/}"

  if ! $DRY_RUN; then
    LC_ALL=C perl -i -pe '
      s{(\S+)\.(jpg|jpeg|png)(\s*)$}{$1.avif$3}gi;
    ' "$cfg"
    (( CONFIG_UPDATED++ )) || true
  else
    (( CONFIG_UPDATED++ )) || true
  fi
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo "=========================================="
if $DRY_RUN; then
  echo "DRY RUN summary (no changes made):"
else
  echo "Summary:"
fi
echo "  Images converted  : $IMAGES_CONVERTED"
echo "  Images skipped    : $IMAGES_SKIPPED (avif already exists)"
echo "  .md files updated : $MD_UPDATED"
echo "  Config files upd. : $CONFIG_UPDATED"
echo "=========================================="
