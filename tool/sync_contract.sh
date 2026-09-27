#!/usr/bin/env bash
# Copies the backend's API contract into this repo's tests.
#
# The contract (routes, error codes, request/response fixtures) is generated
# by RankeBE (`make contract`) and lives in RankeBE/contract. Run this after
# every backend API change, then `flutter test` — test/contract fails on any
# shape the app can no longer send or parse.
#
# Usage: tool/sync_contract.sh [path/to/RankeBE]   (default: ../RankeBE)
set -euo pipefail

cd "$(dirname "$0")/.."
be="${1:-../RankeBE}"
src="$be/contract"
dst="test/contract/fixtures"

if [[ ! -f "$src/routes.json" ]]; then
  echo "error: no contract at $src (pass the RankeBE path as the first argument)" >&2
  exit 1
fi

mkdir -p "$dst"
rsync -a --delete --exclude README.md "$src/" "$dst/"
echo "Synced $src -> $dst"
git status --short -- "$dst" || true
