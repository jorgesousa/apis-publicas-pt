#!/usr/bin/env bash
# Builds dist/<skill>.zip for every skill, ready to upload to claude.ai
# (the skill folder sits at the root of each zip).
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p dist
for dir in skills/*/; do
  name=$(basename "$dir")
  rm -f "dist/$name.zip"
  (cd skills && zip -rq "../dist/$name.zip" "$name" -x '*.DS_Store')
  echo "dist/$name.zip"
done
