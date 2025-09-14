#!/usr/bin/env bash
set -euo pipefail

# Usage: ./Scripts/release-prepare.sh 1.5.0
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>"
  exit 1
fi
VERSION="$1"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="${REPO_ROOT}/Templates"

if [[ ! -d "$TEMPLATES_DIR" ]]; then
  echo "ERROR: Templates/ directory not found at ${TEMPLATES_DIR}"
  exit 1
fi

shopt -s nullglob
TEMPLATE_FILES=( "${TEMPLATES_DIR}"/*.podspec "${TEMPLATES_DIR}"/*.podspec.template )
if [[ ${#TEMPLATE_FILES[@]} -eq 0 ]]; then
  echo "ERROR: no podspec templates found in ${TEMPLATES_DIR}"
  exit 1
fi

echo "Preparing release version: ${VERSION}"
echo "Templates found: ${#TEMPLATE_FILES[@]}"

for tpl in "${TEMPLATE_FILES[@]}"; do
  # Extract pod name from "s.name = 'Name'" (supports single/double quotes)
  if ! NAME_LINE=$(grep -E "^[[:space:]]*s\.name[[:space:]]*=" "$tpl" | head -n1); then
    echo "ERROR: cannot find s.name in template: $tpl"
    exit 1
  fi
  NAME=$(echo "$NAME_LINE" | sed -E "s/^[[:space:]]*s\.name[[:space:]]*=[[:space:]]*['\"]([^'\"]+)['\"].*$/\1/")
  if [[ -z "$NAME" ]]; then
    echo "ERROR: failed to parse pod name from $tpl"
    exit 1
  fi

  OUT_DIR="${REPO_ROOT}/Specs/${NAME}/${VERSION}"
  OUT_FILE="${OUT_DIR}/${NAME}.podspec"

  if [[ -e "$OUT_FILE" ]]; then
    echo "SKIP: ${OUT_FILE} already exists (not overwriting)."
    continue
  fi
  mkdir -p "$OUT_DIR"

  # 1) Replace all literal $VERSION with the provided version
  # 2) Force s.version = '<VERSION>' regardless of the template content
  perl -0777 -pe "
    s/\\\$VERSION/${VERSION}/g;
    s/^([ \\t]*s\\.version[ \\t]*=)[ \\t]*(['\"]).*?\\2/\\1 '${VERSION}'/m;
  " "$tpl" > "$OUT_FILE"

  echo "OK: ${OUT_FILE}"
done

echo "Done."
echo "Don't forget to open generated podspec files and fill in s.source :http => '...zip...'"
