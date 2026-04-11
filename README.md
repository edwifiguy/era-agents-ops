# ERA Agents Ops

Specialized AI sub-agents for ERA Estate projects, business operations, and mission orchestration.

## Quick Start

```bash
# Triage a task (via Fabric)
echo "Build a property listing API with MLS integration" | fabric -p era_agent_triage

# Plan a full mission (via Fabric)
echo "Launch a biogas digester SaaS platform for EU market" | fabric -p era_mission_planner

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
| `real-estate-specialist` | Domain | Property tech, valuations, MLS, compliance |
| `biogas-engineer` | Domain | Biogas digester design, sustainability |

### Usage Examples

```
"Use era-ops to plan which agents should handle building the EU-Land portal"
"Use era-agent to figure out who should handle this database migration"
"Use the real-estate-specialist to design the property valuation API"
"Use the biogas-engineer to calculate digester sizing for 50 cattle"
```

## Structure

```
era-agents-ops/
├── agents/
│   ├── core/              # Development agents (backend, frontend, etc.)
│   ├── business/          # Business & product agents
│   ├── domain/            # ERA Estate domain specialists
│   │   ├── real-estate-specialist.toml
│   │   └── biogas-engineer.toml
│   ├── quality/           # Security, testing, review agents
│   └── orchestration/     # Coordinators and dispatchers
│       ├── era-ops.toml   # Master orchestrator
│       └── era-agent.toml # Quick dispatcher
├── fabric-patterns/
│   ├── era_agent_triage/  # Fabric pattern: task → agent routing
│   └── era_mission_planner/ # Fabric pattern: idea → phased mission plan
├── templates/
│   └── agent-template.toml # Template for creating new agents
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
