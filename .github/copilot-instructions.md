# Copilot Instructions for ERA Agents Ops

## Build, test, and lint commands
This repository does not define a package-level build/lint/test pipeline (no `package.json`, `Makefile`, `pyproject.toml`, etc.).

Use Fabric command-level smoke tests instead:

```bash
# Install local assets used by this repo
cp agents/**/*.toml ~/.codex/agents/
cp -r fabric-patterns/era_agent_triage ~/.config/fabric/patterns/
cp -r fabric-patterns/era_mission_planner ~/.config/fabric/patterns/
cp -r fabric-patterns/era_options_trading_builder ~/.config/fabric/patterns/

# Full-pattern smoke test (triage)
echo "Review the auth module for security vulnerabilities" | fabric -p era_agent_triage

# Single test invocation (one prompt through one pattern)
echo "Build a property listing API with MLS integration" | fabric -p era_agent_triage

# Mission-planner smoke test
echo "Launch an online biogas digester design tool for EU farmers" | fabric -p era_mission_planner

# Options planner smoke test
echo "Create a paper-trading validation plan for an options wheel strategy" | fabric -p era_options_trading_builder
```

## High-level architecture
This repo is a prompt-and-agent operations toolkit, not an application runtime.

Flow:
1. **Fabric patterns** in `fabric-patterns/*/system.md` convert user input into structured outputs (routing plans, mission briefs, audits, etc.).
2. **Orchestrator agents** in `agents/orchestration/` (`era-ops`, `era-agent`) decide delegation strategy.
3. **Specialist agents** in `agents/core`, `agents/business`, `agents/domain`, and `agents/quality` execute bounded roles.
4. **Verification step** is expected at the end of multi-agent plans (explicit in triage/orchestration instructions).

Important patterns currently include:
- `era_agent_triage`: task-to-agent routing (single-agent quick delegation or multi-agent mission plan)
- `era_mission_planner`: strategic phased planning with explicit human decision points
- `era_env_security_audit`: structured `.env` security scanning and remediation output
- `era_yt_to_obsidian`: YouTube transcript to structured Obsidian note pipeline
- `era_options_trading_builder`: options strategy planning with paper-trading and risk gates

## Key conventions
- **Agent definitions are TOML files** with a stable schema: `name`, `description`, `model`, `model_reasoning_effort`, `sandbox_mode`, `developer_instructions`.
- **Sandbox mode signals execution intent**:
  - `read-only` for planners/auditors/orchestrators
  - `workspace-write` for implementation/setup agents
- **Fabric patterns must be machine-parseable**: `system.md` files follow explicit sections like `IDENTITY and PURPOSE`, `STEPS`, `OUTPUT FORMAT`, and end with `# INPUT`.
- **Output format strictness is intentional**: many patterns instruct "output ONLY in the structured format" to keep downstream chaining reliable.
- **Delegation phrasing is standardized**: prompts and outputs consistently use `Use the [agent-name] to ...` for handoff clarity.
- **Model/provider portability is first-class**: workflows are designed to run with Fabric `-m` and `-V` overrides rather than depending on one provider.
- **Install path convention** from repo docs: agent TOMLs are copied to `~/.codex/agents/`; Fabric patterns are copied to `~/.config/fabric/patterns/`.

## Dynamic orchestration policy (global)
- Do not hard-wire sub-agents or patterns at startup.
- Always discover candidate execution targets from:
  - `agents/**/*.toml`
  - `fabric-patterns/*/system.md`
- Route with an objective function: **faithful completion first**, then **accuracy/risk control**, then **lowest practical cost/latency**, then **concision**.
- Use agent-only, pattern-only, or hybrid chains as needed; choose the smallest chain that still completes the request.
- Always include an explicit verify/review step for multi-step missions.

Karpathy-style principles to preserve across all orchestrators:
- Keep interfaces simple and machine-parseable.
- Prefer retrieval/memory over stuffing ever-larger prompts.
- Compose small reliable steps instead of one giant brittle prompt.
- Keep loops tight: plan -> execute -> verify -> adapt.

## Persistent memory policy (MemGPT/Letta)
- Use MemGPT architecture (virtual context management with main-context + external-context tiers; arXiv:2310.08560) for long-horizon tasks.
- Current upstream runtime is **Letta (formerly MemGPT)**: https://github.com/cpacker/MemGPT.
- Treat `mempalace.yaml` as the repo memory topology contract.
- Default memory backend should run locally when possible; keep credentials in environment variables only.
- Any workflow requiring continuity across sessions should include a memory read/write step.
- When user intent invokes `era-agent` or `era-ops`, include MemGPT/Letta memory behavior by default (not opt-in).

## MCP servers
- Configure **GitHub MCP** with access to the `era-agents-ops` repository and ensure **private repository access is enabled**.
- Ensure MCP configuration for this repo has **secrets enabled** so required tokens are injected securely at runtime (never hardcode or commit credentials).
- Configure **Playwright MCP** for browser automation checks when validating generated web flows, UI prompts, or docs-linked pages.
- Use `templates/mcp-settings.template.json` as the baseline checklist/template for expected MCP security settings (placeholders only; no committed credentials).
