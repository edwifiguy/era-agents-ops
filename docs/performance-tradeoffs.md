# Performance Trade-Offs: Local vs Cloud Inference
**Benchmarked:** 2026-04-12 | **System:** Intel i7-4650U, 7.2GB RAM, no discrete GPU

---

## Benchmark Results (era_agent_triage pattern)

All tests used the same prompt: *"Review auth module for vulnerabilities"*

| Provider | Model | Wall Time | Output Quality | Cost/Query |
|----------|-------|-----------|---------------|------------|
| **Gemini** | gemini-2.5-flash | **2.9s** | Correct QUICK DELEGATION | ~$0.0002 |
| **Anthropic** | claude-haiku-4-5 | **2.5s** | Correct QUICK DELEGATION, more detailed | ~$0.005 |
| **Ollama** | qwen2.5-coder:3b (minimal prompt) | **20s** | Responds correctly | $0 |
| **Ollama** | qwen2.5-coder:3b (triage pattern) | **>120s** | Timeout on this hardware | $0 |
| **Ollama** | llama3.1:8b (triage pattern) | **>120s** | Timeout on this hardware | $0 |

### Why Ollama Is Slow on This Machine

| Factor | This System | Minimum Recommended |
|--------|------------|-------------------|
| CPU | i7-4650U (2013, 4 threads, 1.7GHz) | Modern i5/Ryzen 5 (8+ threads) |
| RAM | 7.2GB total (2.8GB available) | 16GB+ (8GB+ available) |
| GPU | Intel integrated (no CUDA) | NVIDIA GPU with 6GB+ VRAM |
| Model loading | ~19s from disk to RAM | ~2s with SSD + enough RAM |
| Inference (simple) | ~1s for "Say yes" | ~0.1s with GPU |
| Inference (complex) | >120s for triage pattern | ~5-15s with GPU |

**Root cause:** The era_agent_triage pattern has a ~2,000 token system prompt. On a 2013 CPU with no GPU, processing this + generating a structured response exceeds 2 minutes. The model also competes with system processes for the limited 7.2GB RAM.

---

## Trade-Off Matrix

### Speed

| Workflow | Gemini Flash | Claude Haiku | Ollama (this CPU) | Ollama (with GPU) |
|----------|-------------|-------------|-------------------|-------------------|
| Quick triage (single agent) | 2-4s | 2-4s | >120s | ~5-10s |
| Mission planning (multi-agent) | 5-15s | 5-10s | Impractical | ~30-60s |
| YouTube analysis | 3-8s | 3-8s | Impractical | ~20-40s |
| Code review | 5-15s | 5-15s | Impractical | ~15-30s |
| Simple Q&A | 1-3s | 1-3s | ~20s | ~2-5s |

### Quality

| Workflow | Gemini Flash | Claude Haiku | Ollama 3B | Ollama 8B |
|----------|-------------|-------------|-----------|-----------|
| Agent triage | Very good | Excellent | Poor (too small) | Good |
| Structured output | Good | Excellent | Inconsistent | Good |
| Complex reasoning | Good | Very good | Poor | Moderate |
| Code generation | Good | Very good | Moderate | Good |
| Following format | Good | Excellent | Unreliable | Good |

### Cost (estimated monthly at 50 queries/day)

| Provider | Model | Monthly Cost | Annual Cost |
|----------|-------|-------------|-------------|
| Ollama | Any local model | $0 | $0 |
| OpenRouter | Free tier models | $0 | $0 |
| Gemini | gemini-2.5-flash | ~$3 | ~$36 |
| Anthropic | claude-haiku-4-5 | ~$7.50 | ~$90 |
| Anthropic | claude-sonnet-4-5 | ~$75 | ~$900 |

### Privacy & Availability

| Factor | Ollama | Gemini | Anthropic | OpenRouter Free |
|--------|--------|--------|-----------|----------------|
| Data leaves machine | No | Yes | Yes | Yes |
| Works offline | Yes | No | No | No |
| Rate limits | None | 1500 RPD free | Per API key | Aggressive |
| Data retention | None | Per Google policy | Per Anthropic policy | Per provider |
| GDPR control | Full | Shared | Shared | Shared |

---

## Recommendations by Workflow

### Agent Triage (era_agent_triage)
**Use: Gemini Flash** (default) or **Claude Haiku** (when accuracy matters)
- Triage requires structured output format adherence — small local models struggle with this
- 2-4s response time is acceptable for planning workflows
- Cost: negligible at ~$0.0002/query
- **Ollama verdict: Not viable on this hardware** for triage patterns

### Mission Planning (era_mission_planner)
**Use: Claude Haiku** (best structured output) or **Gemini Flash** (cost-conscious)
- Complex multi-phase output needs strong instruction-following
- Claude Haiku produces the most consistent structured mission briefs
- **Ollama verdict: Not viable** — prompt too large, output too complex

### YouTube Video Analysis
**Use: Gemini Flash** (best value) → Anthropic for deep analysis
- Transcripts are large (3,000-10,000 tokens input)
- Gemini Flash handles these well at near-zero cost
- **Ollama verdict: Not viable** — input too large for CPU inference window

### Code Review & Security Audit
**Use: Claude Haiku/Sonnet** (quality-critical) or **Gemini Flash** (routine)
- Security findings need high accuracy — false negatives are costly
- Claude models produce the most actionable security output
- **Ollama verdict: Only for non-critical review** with a GPU-equipped machine

### Simple Research & Q&A
**Use: Gemini Flash** (daily) or **Ollama** (offline/private)
- Ollama is viable for simple questions when not time-constrained
- ~20s for a short answer is tolerable for learning/exploration
- **Ollama verdict: Viable** for short, simple prompts only

---

## Optimal Provider Strategy for This Hardware

```
┌─────────────────────────────────────────────────┐
│           ERA Agent Ops Provider Routing         │
├─────────────────────────────────────────────────┤
│                                                  │
│  Simple Q&A / Learning    → Ollama (free, 20s)  │
│  Daily triage & planning  → Gemini Flash (2-4s) │
│  Quality-critical work    → Claude Haiku (2-4s) │
│  Deep reasoning           → Claude Sonnet (5s)  │
│  Offline / private        → Ollama (slow but    │
│                             works for simple)    │
│                                                  │
│  ⚠ Ollama NOT recommended for:                  │
│    - era_agent_triage pattern (>120s timeout)    │
│    - era_mission_planner pattern (>120s timeout) │
│    - YouTube analysis (input too large)          │
│    - Any structured output requiring format      │
│      adherence from models ≤8B parameters        │
│                                                  │
└─────────────────────────────────────────────────┘
```

## Hardware Upgrade Impact Projections

| Upgrade | Cost | Ollama Speedup | Makes Viable |
|---------|------|---------------|-------------|
| 16GB RAM (replace/add) | ~$30 | 1.5-2x (less swapping) | Simple triage with 8B models |
| Used NVIDIA GTX 1060 6GB | ~$80 | 10-15x | Most workflows except mission planning |
| Used NVIDIA RTX 3060 12GB | ~$200 | 20-30x | All workflows including triage |
| New machine + RTX 4060 | ~$800+ | 30-50x | Everything, competitive with cloud |

**Break-even analysis:** At ~$7/month cloud costs, a $200 GPU pays for itself in ~28 months. But if privacy/offline capability is a requirement, the GPU investment is justified immediately.

---

*Benchmarked on: Intel i7-4650U, 7.2GB RAM, Intel HD 5000 integrated graphics, Ubuntu Linux*
*All timings are wall-clock time including model loading, not just inference*
