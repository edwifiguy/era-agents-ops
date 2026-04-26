# Agency Library (Consolidated)

Curated and ERA-aligned subset of `third_party/agency-agents` for practical use in `era-agents-ops`.

## Source
- Upstream mirror: `../../third_party/agency-agents`
- Upstream repo: `https://github.com/msitarzewski/agency-agents`

## Why this folder exists
- Keep upstream content untouched in `third_party/`.
- Provide a **hardened, mission-focused subset** with stable invocation names.
- Align instructions with ERA guardrails (verification, explicit outputs, approval gates).

## Included curated agents
1. `agency-orchestrator`
2. `agency-security-engineer`
3. `agency-growth-operator`
4. `agency-product-strategist`
5. `agency-options-trading-operator`
6. `agency-technical-support-engineer`
7. `agency-mysql-dba`

## Install
```bash
cp agents/agency-library/*.toml ~/.codex/agents/
```
