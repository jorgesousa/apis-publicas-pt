#!/usr/bin/env bash
# Gera dist/apis-publicas-pt.zip para carregar no claude.ai (a pasta da skill fica na raiz do zip).
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p dist
rm -f dist/apis-publicas-pt.zip
(cd skills && zip -rq ../dist/apis-publicas-pt.zip apis-publicas-pt -x '*.DS_Store')
echo "dist/apis-publicas-pt.zip criado"
