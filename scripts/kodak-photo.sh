#!/usr/bin/env bash
# kodak-photo.sh — Apply Kodachrome color grading to photos
#
# Usage:
#   ./kodak-photo.sh photo.jpg                        # output to current dir
#   ./kodak-photo.sh --output /dest *.jpg              # multiple files
#   ./kodak-photo.sh --output /dest archive.zip        # unzips first
#
# Kodachrome look: warm golden highlights, lifted blacks, punchy saturation

set -euo pipefail

OUTPUT_DIR="."

usage() {
  echo "Usage: $(basename "$0") [--output DIR] FILE [FILE...]"
  echo "  FILE can be .jpg/.png image files or a .zip archive"
  exit 1
}

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output|-o) OUTPUT_DIR="$2"; shift 2 ;;
    --help|-h) usage ;;
    *) break ;;
  esac
done

[[ $# -eq 0 ]] && usage

mkdir -p "$OUTPUT_DIR"

KODACHROME_FILTER="
  curves=r='0/0.05 0.15/0.18 0.5/0.58 0.85/0.92 1/1':g='0/0.03 0.5/0.50 1/0.97':b='0/0.02 0.3/0.26 0.5/0.44 1/0.85',
  eq=saturation=1.3:contrast=1.05:brightness=0.02,
  colortemperature=temperature=5800,
  unsharp=3:3:0.3
"

process_photo() {
  local input="$1"
  local name
  name=$(basename "$input")
  local output="${OUTPUT_DIR}/${name}"

  echo -n "Processing $name... "
  ffmpeg -y -i "$input" -vf "$KODACHROME_FILTER" -q:v 3 "$output" 2>/dev/null
  local size
  size=$(du -h "$output" | cut -f1)
  echo "done ($size)"
}

# Collect files — expand zips to a temp dir
FILES=()
TMPDIR_CLEANUP=""

for arg in "$@"; do
  if [[ "$arg" == *.zip ]]; then
    TMPDIR_CLEANUP=$(mktemp -d)
    echo "Extracting: $arg"
    unzip -o -j "$arg" -d "$TMPDIR_CLEANUP" > /dev/null
    for f in "$TMPDIR_CLEANUP"/*.jpg "$TMPDIR_CLEANUP"/*.jpeg "$TMPDIR_CLEANUP"/*.png; do
      [[ -f "$f" ]] && FILES+=("$f")
    done
  elif [[ -f "$arg" ]]; then
    FILES+=("$arg")
  else
    echo "Warning: skipping '$arg' (not found)"
  fi
done

[[ ${#FILES[@]} -eq 0 ]] && { echo "No image files found."; exit 1; }

echo "Processing ${#FILES[@]} photo(s) → $OUTPUT_DIR"
echo ""

for f in "${FILES[@]}"; do
  process_photo "$f"
done

# Cleanup temp dir from zip extraction
[[ -n "$TMPDIR_CLEANUP" ]] && rm -rf "$TMPDIR_CLEANUP"

echo ""
echo "All done. ${#FILES[@]} photo(s) processed."
