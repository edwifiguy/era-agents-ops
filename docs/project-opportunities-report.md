# ERA Agents Ops — Project Opportunities Report
**Date:** 2026-04-12
**Repo:** https://github.com/edwifiguy/era-agents-ops

---

## Current State

### Agent Inventory (11 agents)

| Agent | Category | Status |
|-------|----------|--------|
| era-ops | Orchestration | ✅ Active |
| era-agent | Orchestration | ✅ Active |
| fabric-pattern-engineer | Orchestration | ✅ New |
| real-estate-specialist | Domain | ✅ Active |
| biogas-engineer | Domain | ✅ Active |
| opensec-analyst | Quality | ✅ New |
| opencode-engineer | Core | ✅ New |
| copilot-agent-engineer | Core | ✅ New |
| docker-agent-engineer | Core | ✅ New |
| era_agent_triage | Fabric Pattern | ✅ Tested |
| era_mission_planner | Fabric Pattern | ✅ Tested |

### Provider Stack

| Provider | Status | Models |
|----------|--------|--------|
| Ollama | ✅ Wired to Fabric | llama3.1:8b, deepseek-r1:8b, deepseek-coder, qwen2.5-coder:3b |
| Gemini | ✅ Default | gemini-2.5-flash (default), gemini-3-flash-preview |
| Anthropic | ✅ Working | claude-haiku-4-5, claude-sonnet-4-5 |
| OpenRouter | ⚠️ Needs API key | 20+ free models available |

---

## Opportunity Matrix

### Tier 1 — Immediate (This Week)

**1A. Install agents to Codex globally**
```bash
cp ~/Projects/active/internal/era-agents-ops/agents/**/*.toml ~/.codex/agents/
```
- Zero cost, instant productivity gain
- All 11 agents available in every Codex session

**1B. Get OpenRouter free API key**
- Visit https://openrouter.ai/keys → free signup
- Unlocks 20+ free cloud models (llama-3.3-70b, gemma-3-27b, gpt-oss-120b)
- Gives you fast free cloud triage without burning Gemini/Anthropic quotas

**1C. Add shell aliases to ~/.bashrc**
- `era-triage`, `era-mission`, `fabric-free`, `fabric-cheap`, `fabric-premium`
- Cuts command length from 60+ chars to <15

**1D. Test Ollama triage offline**
- Verify `era_agent_triage` works fully local with llama3.1:8b
- Confirms you can operate without any internet/API dependency

### Tier 2 — Short Term (Next 2 Weeks)

**2A. Build project-specific agents for EU-Land**
- Create `.codex/agents/` in the EU-Land project
- Agents: `eu-land-analyst`, `eu-property-law`, `cross-border-compliance`
- Immediately improves EU-Land development quality

**2B. Build project-specific agents for Reticulum Learning Academy**
- Create `.codex/agents/` in the RLA project
- Agents: `curriculum-designer`, `learning-assessment-engineer`, `content-pedagogy`

**2C. Convert key agents to Claude Code format**
- Use `opencode-engineer` agent to convert TOMLs → `.claude/agents/*.md`
- Gives you same agent team in Claude Code sessions

**2D. Convert key agents to Gemini CLI format**
- Same conversion → `.gemini/agents/*.md`
- Extends agent team to Gemini CLI

**2E. Create Fabric pattern: `era_agent_creator`**
- Pattern that takes a description and outputs a complete TOML agent definition
- Meta-agent: use Fabric to generate new agents automatically

### Tier 3 — Medium Term (1-3 Months)

**3A. Agent-as-a-Service for Real Estate**
- Package real-estate-specialist + property management agents
- Offer as consulting service to property tech companies
- Revenue: Setup fee + monthly retainer

**3B. Biogas Design Tool (from mission planner output)**
- The `era_mission_planner` already generated a full plan for this
- 12-week project, 8 agent team, codename "GreenDigest Launch"
- Revenue: SaaS subscription for EU farmers

**3C. Content Machine for ERA Estate**
- 10 agents handling: property descriptions, market reports, social posts, email campaigns
- Replicates the pattern from the YouTube video
- Revenue: Direct business value (lead generation, SEO)

**3D. Cross-Platform Agent Marketplace**
- Package ERA agents for all platforms (Codex, Claude Code, Gemini CLI, Copilot)
- Publish on GitHub as open-source with premium domain-specific packages
- Revenue: Freemium model — free core agents, paid domain specialists

### Tier 4 — Strategic (3-6 Months)

**4A. ERA Estate AI Platform**
- Combine all agents into a unified platform
- Property management + valuation + compliance + tenant screening
- White-label for property management companies
- Revenue: SaaS per-property pricing

**4B. Agent Training & Certification**
- Teach teams how to build, customize, and orchestrate AI agent teams
- Use ERA Agents Ops as the curriculum foundation
- Revenue: Course fees, certification

**4C. Fabric Pattern Library**
- Build 50+ ERA-specific Fabric patterns
- Cover: real estate analysis, biogas calculations, compliance checking, market research
- Revenue: Open-source community building → consulting pipeline

**4D. Docker-Containerized Agent Teams**
- Use `docker-agent-engineer` to containerize full agent teams
- One `docker-compose up` deploys a complete agent orchestration stack
- Includes Ollama + Fabric + MCP servers + agent configs
- Revenue: Enterprise licensing for turnkey agent deployments

---

## Growth Roadmap

```
Week 1-2:   Install agents, aliases, OpenRouter → Immediate productivity
Week 3-4:   Project-specific agents for EU-Land + RLA
Month 2:    Cross-platform conversion, content machine
Month 3:    Biogas design tool MVP, agent marketplace launch
Month 4-6:  ERA Estate AI platform, enterprise offerings
```

## Agent Growth Plan

```
Current:    11 agents (4 domain, 5 core/quality, 2 orchestration)
Month 1:    20 agents (add EU-Land, RLA, business specialists)
Month 3:    35 agents (add content, marketing, compliance)
Month 6:    50+ agents (full coverage across all business verticals)
```

## Cost Analysis

| Operation | Provider | Monthly Cost |
|-----------|----------|-------------|
| Daily triage (50 tasks) | Gemini Flash | ~$1.50 |
| Complex missions (10/month) | Claude Haiku | ~$3.00 |
| Deep reasoning (5/month) | Claude Sonnet | ~$2.50 |
| Testing & development | Ollama (local) | $0 |
| **Total estimated** | | **~$7/month** |

With OpenRouter free tier, testing costs drop to $0. Production triage via Gemini Flash is near-free at high volume.

---

## Key Risks

| Risk | Mitigation |
|------|-----------|
| API cost overrun | Default to Gemini Flash; Ollama for testing; monitor with `fabric --cost` |
| Agent quality drift | Version control all TOMLs; test patterns across models before deploying |
| Platform lock-in | Cross-platform design via `opencode-engineer`; all configs in Git |
| Ollama CPU slowness | GPU upgrade, or use Ollama only for testing; Gemini Flash for production |
| OpenRouter free tier limits | Rate limiting; fall back to Gemini Flash when throttled |

---

*Generated by ERA Agents Ops | Updated 2026-04-12*
