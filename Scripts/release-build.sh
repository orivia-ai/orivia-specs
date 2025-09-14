#!/usr/bin/env bash
set -euo pipefail

# Usage: ./Scripts/release-build.sh 1.5.0
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>"
  exit 1
fi
VERSION="$1"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Release build for version: ${VERSION}"
echo "Repository root: ${REPO_ROOT}"

found=0

# Iterate over all Ruby podspecs under <PodName>/<VERSION>/<PodName>.podspec
while IFS= read -r -d '' SPEC; do
  if [[ $found -eq 0 ]]; then
    echo "Found podspec file(s):"
  fi
  echo " - $SPEC"
  found=$((found+1))

  SPEC_DIR="$(dirname "$SPEC")"
  SPEC_NAME="$(basename "$SPEC")"
  JSON_PATH="${SPEC_DIR}/${SPEC_NAME%.podspec}.podspec.json"

  echo
  echo "=== Processing: ${SPEC} ==="

  echo "1) Linting spec..."
  if ! pod spec lint "$SPEC" --allow-warnings --sources="https://cdn.cocoapods.org/" ; then
    echo "!!! WARNING: lint failed for ${SPEC}, continuing anyway"
  fi

  echo "2) Generating JSON..."
  if ! pod ipc spec "$SPEC" > "$JSON_PATH"; then
    echo "ERROR: Failed to generate JSON for ${SPEC}"
    continue
  fi

  if [[ ! -s "$JSON_PATH" ]]; then
    echo "ERROR: Generated JSON is empty: ${JSON_PATH}"
    continue
  fi

  echo "3) Removing Ruby spec..."
  rm -f "$SPEC"

  echo "OK: ${JSON_PATH}"
done < <(find "${REPO_ROOT}" -type f -path "*/${VERSION}/*.podspec" -print0)

if [[ $found -eq 0 ]]; then
  echo "ERROR: No .podspec files found under */${VERSION}/"
  exit 1
fi

echo
echo "All specs processed for version ${VERSION}."
