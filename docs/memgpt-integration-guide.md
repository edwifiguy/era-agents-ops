# MemGPT (Letta) Integration Guide for ERA Agents Ops

MemGPT paper reference: https://arxiv.org/abs/2310.08560  
Upstream project (renamed): https://github.com/cpacker/MemGPT

## Install locally

```bash
# CLI runtime
npm install -g @letta-ai/letta-code

# Optional Python client for integrations
pip install letta-client
```

## Configure runtime

```bash
cp templates/memgpt.env.template ~/.config/era-agents-ops/memgpt.env
# fill API keys in your secret manager or shell, not in git
```

## Beginner quick setup (copy/paste)

```bash
chmod +x templates/setup-mempalace.sh
./templates/setup-mempalace.sh

# or manual setup:
mkdir -p ~/.config/era-agents-ops
cp templates/memgpt.env.template ~/.config/era-agents-ops/memgpt.env

# Edit only what you know; defaults are already valid for local start
${EDITOR:-nano} ~/.config/era-agents-ops/memgpt.env

# Load env for current shell
set -a && source ~/.config/era-agents-ops/memgpt.env && set +a

# Confirm MemGPT/Letta tools are available
letta --help | head -n 10
python -c "import letta_client; print('letta-client OK')"
```

If you only want one key configured initially, set `OPENAI_API_KEY` and leave the others blank.

Key repo config:
- `mempalace.yaml`: memory topology + backend defaults
- `AGENTS.md`: global routing + memory policy
- `.github/copilot-instructions.md`: Copilot-specific policy mirror

## Cross-IDE usage policy

All adapters should follow the same behavior:
1. Discover targets dynamically (`agents/**/*.toml`, `fabric-patterns/*/system.md`)
2. Select the smallest accurate/cost-efficient chain
3. Attach memory read/write steps by default for `era-agent` and `era-ops` flows
4. End multi-step runs with verification

## Minimal validation

```bash
letta --help
python -c "import letta_client; print('letta-client OK')"
```
