# ERA Agents Ops

Specialized AI sub-agents for ERA Estate projects, business operations, and mission orchestration.

## Quick Start

```bash
# Triage a task (via Fabric)
echo "Build a property listing API with MLS integration" | fabric -p era_agent_triage

# Triage with guardrails (strict format + safe fallback)
chmod +x scripts/era-triage-safe.sh
echo "Build a property listing API with MLS integration" | scripts/era-triage-safe.sh

# Plan a full mission (via Fabric)
echo "Launch a biogas digester SaaS platform for EU market" | fabric -p era_mission_planner

# Plan a spec-driven mission (Spec Kit/OpenSpec aware)
echo "Design and implement a tenant portal with strict specs first" | fabric -p era_sdd_triage

# Build a monetization execution plan
echo "Launch workflows, apps, ecommerce and websites that generate revenue" | fabric -p era_revenue_builder

# Build an options trading research-to-paper-trading mission plan
echo "Build a risk-controlled options strategy operation from my knowledge base" | fabric -p era_options_trading_builder

# Install agents globally for Codex
cp agents/**/*.toml ~/.codex/agents/

# Or install to a specific project
cp agents/domain/real-estate-specialist.toml /your/project/.codex/agents/
```

## Invocation Names

| Name | Agent | Purpose |
|------|-------|---------|
| `era-ops` | Master Orchestrator | Multi-agent mission planning and coordination |
| `era-agent` | Quick Dispatcher | Single-agent routing for simple tasks |
| `sdd-spec-orchestrator` | SDD Orchestrator | Spec-driven planning with approval gates (spec-kit/OpenSpec) |
| `agency-orchestrator` | Agency Orchestrator | Multi-function business orchestration from curated Agency library |
| `agency-security-engineer` | Agency Security | Threat modeling and security remediation |
| `agency-growth-operator` | Agency Growth | Funnel planning, experiments, KPI-driven growth loops |
| `agency-product-strategist` | Agency Product | Scope, roadmap and product strategy handoff |
| `agency-options-trading-operator` | Agency Trading Ops | Options research-to-paper-trading operating model with risk gates |
| `revenue-ops-orchestrator` | Revenue Ops | Monetization-first planning and execution roadmap |
| `options-trading-quant` | Trading Quant | Options strategy research, backtesting, and paper-trading validation |
| `real-estate-specialist` | Domain | Property tech, valuations, MLS, compliance |
| `biogas-engineer` | Domain | Biogas digester design, sustainability |

### Usage Examples

```
"Use era-ops to plan which agents should handle building the EU-Land portal"
"Use era-agent to figure out who should handle this database migration"
"Use the options-trading-quant to convert trading ideas into backtested paper-trading playbooks"
"Use the real-estate-specialist to design the property valuation API"
"Use the biogas-engineer to calculate digester sizing for 50 cattle"
```

## Structure

```
era-agents-ops/
├── agents/
│   ├── core/              # Development agents (backend, frontend, etc.)
│   ├── business/          # Business & product agents
│   ├── trading/           # Quant/trading strategy agents
│   ├── domain/            # ERA Estate domain specialists
│   │   ├── real-estate-specialist.toml
│   │   └── biogas-engineer.toml
│   ├── quality/           # Security, testing, review agents
│   └── orchestration/     # Coordinators and dispatchers
│       ├── era-ops.toml   # Master orchestrator
│       └── era-agent.toml # Quick dispatcher
├── fabric-patterns/
│   ├── era_agent_triage/  # Fabric pattern: task → agent routing
│   ├── era_mission_planner/ # Fabric pattern: idea → phased mission plan
│   └── era_options_trading_builder/ # Fabric pattern: options mission planning
├── templates/
│   ├── agent-template.toml # Template for creating new agents
│   └── mcp-settings.template.json # MCP security/settings template (placeholders)
├── demos/
│   └── microcloud-replitt/ # Containerized stakeholder demo (dashboard + workspace + orchestrator)
└── docs/
```

## Fabric Integration

Two custom Fabric patterns provide automated agent triage:

### `era_agent_triage`
Analyzes a prompt and outputs which agent(s) to invoke, with exact commands.

```bash
# Install the pattern
cp -r fabric-patterns/era_agent_triage ~/.config/fabric/patterns/
cp -r fabric-patterns/era_mission_planner ~/.config/fabric/patterns/
cp -r fabric-patterns/era_sdd_triage ~/.config/fabric/patterns/
cp -r fabric-patterns/era_revenue_builder ~/.config/fabric/patterns/
cp -r fabric-patterns/era_options_trading_builder ~/.config/fabric/patterns/

# Use it
echo "Review the auth module for security vulnerabilities" | fabric -p era_agent_triage
# Output: QUICK DELEGATION → security-auditor

echo "Build a property management platform with tenant portal" | fabric -p era_agent_triage
# Output: MISSION PLAN → 5 agents across 3 phases
```

### `era_mission_planner`
Converts high-level business ideas into phased, agent-driven execution plans.

```bash
echo "Launch an online biogas digester design tool for EU farmers" | fabric -p era_mission_planner
# Output: MISSION BRIEF with phases, agents, timelines, decision points
```

### `era_sdd_triage`
Routes work into spec-first workflows and maps tasks to `spec-kit` and `OpenSpec` when SDD is beneficial.

```bash
echo "Build an API, but enforce SDD and approval gates" | fabric -p era_sdd_triage
```

### `era_revenue_builder`
Creates a monetization-first plan across workflows/agencies/apps/ecommerce/websites.

```bash
echo "Build revenue streams across agency services and productized apps" | fabric -p era_revenue_builder
```

### `era_options_trading_builder`
Creates an options strategy mission plan with simulation/paper-trading gates, risk limits, and verification.

```bash
echo "Turn my options strategy ideas into a paper-trading mission plan with strict risk controls" | fabric -p era_options_trading_builder
```

## SDD Consolidation

`era-agents-ops` now includes local mirrors for SDD frameworks:

- `third_party/spec-kit` (`github/spec-kit`)
- `third_party/OpenSpec` (`Fission-AI/OpenSpec`)

See `docs/sdd-consolidation.md` for integration details and `docs/sdd-tooling-inventory.md` for the installed SDD inventory.

## Agency-Agents Consolidation

- Upstream mirror: `third_party/agency-agents`
- Curated ERA library: `agents/agency-library`
- Consolidation notes: `docs/agency-agents-consolidation.md`
- Revenue playbook: `docs/revenue-workflows-playbook.md`

## MCP Security Baseline

Use `templates/mcp-settings.template.json` as the starting point for local MCP setup. Baseline requirements:

1. GitHub MCP includes private-repository access for `era-agents-ops`
2. Secrets are injected at runtime (no committed tokens/keys)
3. Playwright MCP is registered for browser-flow validation

## Creating New Agents

1. Copy `templates/agent-template.toml`
2. Fill in name, description, model, sandbox_mode, and instructions
3. Place in the appropriate `agents/` category folder
4. Copy to `~/.codex/agents/` to activate globally

## Architecture

```
User Prompt
    │
    ▼
┌─────────────────┐
│  Fabric Triage   │  ← era_agent_triage pattern
│  (identifies     │     analyzes prompt, outputs plan
│   which agents)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   era-ops /      │  ← Codex orchestrator agent
│   era-agent      │     coordinates execution
└────────┬────────┘
         │
    ┌────┼────┐
    ▼    ▼    ▼
  Agent Agent Agent   ← Specialist sub-agents
  (parallel or sequential execution)
         │
         ▼
┌─────────────────┐
│   Verify Agent   │  ← Read-only reviewer/auditor
└─────────────────┘
```

## Related

- [VoltAgent/awesome-codex-subagents](https://github.com/VoltAgent/awesome-codex-subagents) — Upstream reference (136 agents)
- [danielmiessler/fabric](https://github.com/danielmiessler/fabric) — AI prompt framework powering the triage patterns
