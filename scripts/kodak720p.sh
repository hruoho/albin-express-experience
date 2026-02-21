#!/usr/bin/env bash
# kodak720p.sh — Downscale videos to 720p with Kodachrome color grading
#
# Usage:
#   ./kodak720p.sh video.mp4                       # output to current dir
#   ./kodak720p.sh --output /dest *.mp4             # multiple files
#   ./kodak720p.sh --output /dest archive.zip       # unzips first
#   ./kodak720p.sh --duration 8 --output /dest *.mp4  # custom clip length
#
# Kodachrome look: warm golden highlights, lifted blacks, punchy saturation

set -euo pipefail

OUTPUT_DIR="."
DURATION=5

usage() {
  echo "Usage: $(basename "$0") [--output DIR] [--duration SECS] FILE [FILE...]"
  echo "  FILE can be .mp4 video files or a .zip archive"
  exit 1
}

# Parse flags
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output|-o) OUTPUT_DIR="$2"; shift 2 ;;
    --duration|-d) DURATION="$2"; shift 2 ;;
    --help|-h) usage ;;
    *) break ;;
  esac
done

[[ $# -eq 0 ]] && usage

mkdir -p "$OUTPUT_DIR"

KODACHROME_FILTER="
  scale=1280:720:force_original_aspect_ratio=increase,
  crop=1280:720,
  curves=r='0/0.05 0.15/0.18 0.5/0.58 0.85/0.92 1/1':g='0/0.03 0.5/0.50 1/0.97':b='0/0.02 0.3/0.26 0.5/0.44 1/0.85',
  eq=saturation=1.3:contrast=1.05:brightness=0.02,
  colortemperature=temperature=5800,
  unsharp=3:3:0.3
"

process_video() {
  local input="$1"
  local name
  name=$(basename "$input" .mp4)
  local output="${OUTPUT_DIR}/${name}.mp4"

  echo "Processing: $(basename "$input") → $output"
  ffmpeg -y -i "$input" \
    -t "$DURATION" \
    -vf "$KODACHROME_FILTER" \
    -c:v libx264 -preset slow -crf 26 -profile:v high -pix_fmt yuv420p \
    -an -movflags +faststart \
    "$output" 2>/dev/null

  local size
  size=$(du -h "$output" | cut -f1)
  echo "  Done: $size"
}

# Collect files — expand zips to a temp dir
FILES=()
TMPDIR_CLEANUP=""

for arg in "$@"; do
  if [[ "$arg" == *.zip ]]; then
    TMPDIR_CLEANUP=$(mktemp -d)
    echo "Extracting: $arg"
    unzip -o -j "$arg" -d "$TMPDIR_CLEANUP" > /dev/null
    for f in "$TMPDIR_CLEANUP"/*.mp4; do
      [[ -f "$f" ]] && FILES+=("$f")
    done
  elif [[ -f "$arg" ]]; then
    FILES+=("$arg")
  else
    echo "Warning: skipping '$arg' (not found)"
  fi
done

[[ ${#FILES[@]} -eq 0 ]] && { echo "No video files found."; exit 1; }

echo "Processing ${#FILES[@]} video(s) → $OUTPUT_DIR (${DURATION}s clips)"
echo ""

for f in "${FILES[@]}"; do
  process_video "$f"
done

# Cleanup temp dir from zip extraction
[[ -n "$TMPDIR_CLEANUP" ]] && rm -rf "$TMPDIR_CLEANUP"

echo ""
echo "All done. ${#FILES[@]} video(s) processed."
