#!/usr/bin/env bash
set -euo pipefail

# Generate sanitized API Markdown for the md-doc branch (md-docs/).
# Raw vitepress output is written to build/docs/vitepress-raw/ (gitignored).

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

RAW_OUTPUT_DIR="build/docs/vitepress-raw"
RAW_API_DIR="${RAW_OUTPUT_DIR}/api"
OUTPUT_DIR="md-docs"
SAMPLE_FILE="${OUTPUT_DIR}/airwallex/Airwallex.md"
LOG="$(mktemp)"

cleanup() {
  rm -f "$LOG"
}
trap cleanup EXIT

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

require_path() {
  local path="$1"
  local label="$2"
  if [ ! -e "$path" ]; then
    fail "${label} not found at ${path}."
  fi
}

echo "== API reference markdown =="
echo "Output: ${OUTPUT_DIR}/"
echo

flutter pub get

echo "Installing dartdoc_vitepress 1.2.1..."
dart pub global activate dartdoc_vitepress 1.2.1

# dartdoc_vitepress 1.2.1 is missing lib/resources/vitepress/.gitignore in the
# published package, which aborts generation before api/ is written.
VITEPRESS_PKG="$(find "${HOME}/.pub-cache/hosted/pub.dev" -maxdepth 1 -name 'dartdoc_vitepress-*' | sort -V | tail -1)"
if [ -n "${VITEPRESS_PKG}" ]; then
  mkdir -p "${VITEPRESS_PKG}/lib/resources/vitepress"
  touch "${VITEPRESS_PKG}/lib/resources/vitepress/.gitignore"
else
  fail "Could not locate dartdoc_vitepress in pub cache."
fi

rm -rf "${RAW_OUTPUT_DIR}" "${OUTPUT_DIR}"

echo "Generating Markdown..."
if ! dart pub global run dartdoc_vitepress \
  --format vitepress \
  --output "${RAW_OUTPUT_DIR}" 2>&1 | tee "$LOG"; then
  fail "dartdoc_vitepress exited with an error. See output above."
fi

if grep -Eiq 'failed:|PathNotFoundException|Unhandled exception' "$LOG"; then
  fail "dartdoc_vitepress reported errors in log. See output above."
fi

require_path "$RAW_API_DIR" "Raw API output directory"

echo "Sanitizing Markdown..."
if ! dart run .github/scripts/customise-md-docs.dart "${RAW_API_DIR}" "${OUTPUT_DIR}"; then
  fail "Markdown sanitization failed."
fi

require_path "$SAMPLE_FILE" "Sanitized sample API page"

echo
echo "Done."
echo "  Output: ${OUTPUT_DIR}/"
echo "  Sample: ${SAMPLE_FILE}"
