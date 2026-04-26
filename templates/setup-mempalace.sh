#!/usr/bin/env bash
set -euo pipefail

echo "[1/4] Creating config directory"
mkdir -p "${HOME}/.config/era-agents-ops"

echo "[2/4] Installing MemGPT env template"
cp templates/memgpt.env.template "${HOME}/.config/era-agents-ops/memgpt.env"

echo "[3/4] Configure API keys"
if [ -t 1 ]; then
  echo "Opening editor for key setup (save and exit when done)"
  "${EDITOR:-nano}" "${HOME}/.config/era-agents-ops/memgpt.env"
else
  echo "Non-interactive shell detected; skipping editor."
  echo "Edit this file manually before production use:"
  echo "  ${HOME}/.config/era-agents-ops/memgpt.env"
fi

echo "[4/4] Verifying Letta + Python client"
set -a
source "${HOME}/.config/era-agents-ops/memgpt.env"
set +a
letta --help >/dev/null
python -c "import letta_client; print('letta-client OK')"

echo "MemPalace setup complete. Active topology: mempalace.yaml"
