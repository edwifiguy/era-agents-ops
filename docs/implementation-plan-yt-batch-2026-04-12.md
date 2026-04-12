# Implementation Plan — YouTube Batch Analysis (2026-04-12)

## Videos Analyzed

| # | Title | Key Topic | New Agent/Pattern Created |
|---|-------|-----------|--------------------------|
| 1 | How To Use Claude Code FREE Forever (Ollama Setup) | Local models + Claude Code | `claude-code-local-engineer` |
| 2 | The ULTIMATE AI Phone Assistant! (13 AGENTS) | Voice agent orchestration with N8N | `voice-agent-architect` |
| 3 | Andrej Karpathy Just 10x'd Everyone's Claude Code | LLM wikis + knowledge graphs | `knowledge-wiki-engineer` |
| 4 | Claude Code + Obsidian Just Changed AI Forever | Obsidian MCP + agent super-memory | `obsidian-mcp-integrator` |

## New Assets Created

### 4 New Agent TOMLs
- `claude-code-local-engineer` — Free Claude Code setup via Ollama/OpenRouter
- `voice-agent-architect` — Multi-agent voice/phone systems with N8N
- `knowledge-wiki-engineer` — Karpathy-style LLM wiki creation
- `obsidian-mcp-integrator` — Obsidian vault ↔ AI agent memory bridge

### 1 New Fabric Pattern
- `era_yt_to_obsidian` — Automated YouTube → Obsidian knowledge pipeline

### 4 Obsidian Transcripts
All saved to `~/Documents/Obsidian Hood/YT - Trans/` with full transcripts + Fabric wisdom analysis.

---

## Remediation & Implementation Priorities

### Phase 1 — Immediate (This Week)

**1A. Set up Claude Code with free local models (from Video 1)**
- Use `claude-code-local-engineer` agent
- Configure Claude Code to use Ollama (qwen2.5-coder:3b for speed, llama3.1:8b for quality)
- Set OpenRouter free tier as cloud fallback
- Test: simple code generation task through Claude Code → Ollama

**1B. Build YouTube → Obsidian automated pipeline (from Videos 3+4)**
- Use `era_yt_to_obsidian` Fabric pattern
- Pipeline command:
  ```bash
  fabric -y "YOUTUBE_URL" -p era_yt_to_obsidian -m gemini-2.5-flash -V Gemini \
    > ~/Documents/Obsidian\ Hood/YT\ -\ Trans/$(date +%Y-%m-%d)-output.md
  ```
- Process backlog of saved YouTube videos through this pipeline
- Agents: `knowledge-wiki-engineer` + `obsidian-mcp-integrator`

**1C. Apply Karpathy CLAUDE.md patterns (from Video 3)**
- Create optimized CLAUDE.md / AGENTS.md for each active project
- Structure: project context → coding standards → wiki references → agent roster
- Use `knowledge-wiki-engineer` to build project-specific knowledge wikis

### Phase 2 — Short Term (Next 2 Weeks)

**2A. Obsidian MCP server integration (from Video 4)**
- Install Obsidian MCP server for Claude Code / agent access
- Connect ERA agents to Obsidian vault as persistent memory
- Design vault structure:
  ```
  Obsidian Hood/
  ├── YT - Trans/           # YouTube analyses (already populated)
  ├── Projects/              # Project knowledge wikis
  ├── Agents/                # Agent documentation and learnings
  ├── Research/              # Domain research (real estate, biogas, EU)
  └── Daily/                 # Daily notes and decision logs
  ```
- Agent: `obsidian-mcp-integrator`

**2B. Voice agent prototype for ERA Estate (from Video 2)**
- Design a 3-agent phone system:
  1. Property inquiry handler (inbound calls)
  2. Showing scheduler (calendar integration)
  3. Tenant support assistant (maintenance requests)
- Use N8N for workflow orchestration
- Agent: `voice-agent-architect`

### Phase 3 — Medium Term (Month 2-3)

**3A. Full knowledge graph build-out**
- Process all YouTube analyses into interconnected wiki
- Add project documentation, meeting notes, research
- Create MOC (Maps of Content) index pages
- Goal: every ERA agent has access to project-specific super-memory

**3B. Voice agent production deployment**
- Expand from 3 to 8+ voice agents
- Add: sales qualifier, maintenance dispatcher, payment reminder, survey agent
- Integration with property management system

**3C. Claude Code + Obsidian workflow automation**
- Every code session automatically logs key decisions to Obsidian
- Agent learnings persist across sessions via Obsidian vault
- Project context auto-loads from wiki when entering project directory

---

## Agent Roster Update

**Total ERA agents: 17** (was 12, +5 new)

| Category | Agents | Count |
|----------|--------|-------|
| Orchestration | era-ops, era-agent, fabric-pattern-engineer, knowledge-wiki-engineer | 4 |
| Core | opencode-engineer, copilot-agent-engineer, docker-agent-engineer, claude-code-local-engineer, obsidian-mcp-integrator | 5 |
| Domain | real-estate-specialist, biogas-engineer, voice-agent-architect | 3 |
| Quality | opensec-analyst, env-security-auditor | 2 |
| Fabric Patterns | era_agent_triage, era_mission_planner, era_env_security_audit, era_yt_to_obsidian | 4 |

---

## Key Insight Across All 4 Videos

The common thread: **knowledge compounds**. Local models give you free iteration. Obsidian gives your agents persistent memory. Karpathy's wiki approach makes knowledge queryable. Voice agents extend your reach beyond the keyboard. The combination creates an agent team that learns and grows with every interaction — the prime directive in action.
