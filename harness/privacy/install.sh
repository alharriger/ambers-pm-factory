#!/usr/bin/env bash
#
# Install the privacy pre-commit gate. Run once per clone:
#   bash harness/privacy/install.sh
#
# Points git at harness/privacy/ as the hooks directory (tracked, so the
# hook travels with the repo) and seeds a local deny-list from the example
# if none exists yet.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

git config core.hooksPath harness/privacy
chmod +x harness/privacy/pre-commit

if [ ! -f harness/privacy/deny-list.txt ]; then
  cp harness/privacy/deny-list.example.txt harness/privacy/deny-list.txt
  echo "Seeded harness/privacy/deny-list.txt from the example — EDIT IT with your real terms."
  echo "(It is gitignored; it will never be committed.)"
else
  echo "harness/privacy/deny-list.txt already exists — left untouched."
fi

echo "Installed: core.hooksPath -> harness/privacy. The privacy gate is active."
