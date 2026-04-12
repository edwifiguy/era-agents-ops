# Provider Swap Guide — ERA Agents Ops

How to switch between AI model providers for cost control, privacy, and offline operation.

## Available Providers (Configured)

| Provider | Type | Cost | Speed | Best For |
|----------|------|------|-------|----------|
| **Ollama** | Local | Free | Slow (CPU) | Privacy, offline, learning, testing |
| **OpenRouter Free** | Cloud | Free | Medium | Free cloud models, experimentation |
| **Gemini Flash** | Cloud | Near-free | Fast | Default daily driver, high volume |
| **Anthropic Claude** | Cloud | Paid | Fast | Deep reasoning, complex tasks |

## Gemini Flash Availability

| Provider | Available? | Notes |
|----------|-----------|-------|
| Gemini API (direct) | **Yes** — gemini-2.5-flash | Your default, works great |
| OpenRouter | **Yes** — google/gemini-2.0-flash (paid) | Not free tier |
| Ollama | **No** | Google doesn't release Gemini as open weights |
| LM Studio | **No** | Same reason — proprietary model |

**Free alternatives to Gemini Flash on Ollama:** llama3.1:8b, deepseek-coder, qwen2.5-coder:3b

## Fabric Provider Swap Commands

### Quick Swap (per-command)

```bash
# FREE LOCAL — Ollama (offline, private, slow on CPU)
echo "your prompt" | fabric -p era_agent_triage -m llama3.1:8b -V Ollama

# FREE LOCAL — Ollama with reasoning model
echo "your prompt" | fabric -p era_agent_triage -m deepseek-r1:8b -V Ollama

# FREE CLOUD — OpenRouter free tier (needs API key)
echo "your prompt" | fabric -p era_agent_triage -m google/gemma-3-27b-it:free -V OpenRouter

# CHEAP CLOUD — Gemini Flash (your default, near-free)
echo "your prompt" | fabric -p era_agent_triage -m gemini-2.5-flash -V Gemini

# PREMIUM — Anthropic Claude (best quality, costs money)
echo "your prompt" | fabric -p era_agent_triage -m claude-haiku-4-5 -V Anthropic

# PREMIUM — Anthropic Claude Sonnet (heavy reasoning)
echo "your prompt" | fabric -p era_agent_triage -m claude-sonnet-4-5 -V Anthropic
```

### Change Default Provider

Edit `~/.config/fabric/.env`:

```bash
# For cost-free operation (local)
DEFAULT_MODEL=llama3.1:8b
DEFAULT_VENDOR=Ollama

# For balanced cost/speed (recommended daily driver)
DEFAULT_MODEL=gemini-2.5-flash
DEFAULT_VENDOR=Gemini

# For maximum quality
DEFAULT_MODEL=claude-sonnet-4-5
DEFAULT_VENDOR=Anthropic
```

### Shell Aliases (add to ~/.bashrc)

```bash
# Quick aliases for different cost tiers
alias fabric-free='fabric -m llama3.1:8b -V Ollama'
alias fabric-cheap='fabric -m gemini-2.5-flash -V Gemini'
alias fabric-premium='fabric -m claude-haiku-4-5 -V Anthropic'
alias fabric-best='fabric -m claude-sonnet-4-5 -V Anthropic'

# ERA Agent Ops shortcuts
alias era-triage='fabric -p era_agent_triage'
alias era-mission='fabric -p era_mission_planner'

# Combined: free local triage
alias era-triage-free='fabric -p era_agent_triage -m llama3.1:8b -V Ollama'
alias era-triage-fast='fabric -p era_agent_triage -m gemini-2.5-flash -V Gemini'
```

## Model Comparison for Agent Triage

| Model | Provider | Cost | Triage Quality | Speed |
|-------|----------|------|---------------|-------|
| llama3.1:8b | Ollama | $0 | Good for simple | ~30-60s (CPU) |
| deepseek-r1:8b | Ollama | $0 | Good reasoning | ~45-90s (CPU) |
| gemma-3-27b-it:free | OpenRouter | $0 | Good | ~5-10s |
| gemini-2.5-flash | Gemini | ~$0.001 | Very good | ~3-5s |
| claude-haiku-4-5 | Anthropic | ~$0.01 | Excellent | ~3-5s |
| claude-sonnet-4-5 | Anthropic | ~$0.05 | Best | ~5-10s |

## Recommended Strategy

```
Development/Testing → Ollama (free, private)
Daily Triage       → Gemini Flash (fast, near-free)  
Complex Missions   → Claude Haiku (quality, affordable)
Critical Decisions → Claude Sonnet (best reasoning)
```

## YouTube Analysis Provider Routing

```bash
# Free analysis of YouTube videos (local)
fabric -y "https://youtu.be/VIDEO_ID" -p extract_wisdom -m llama3.1:8b -V Ollama

# Fast analysis (cheap cloud)
fabric -y "https://youtu.be/VIDEO_ID" -p extract_wisdom -m gemini-2.5-flash -V Gemini

# Deep analysis (premium)
fabric -y "https://youtu.be/VIDEO_ID" -p extract_wisdom -m claude-haiku-4-5 -V Anthropic
```

## OpenRouter Free Setup

1. Get a free API key at https://openrouter.ai/keys
2. Edit `~/.config/fabric/.env`:
   ```
   OPENROUTER_API_KEY=sk-or-v1-your-key-here
   ```
3. Use free models:
   ```bash
   echo "task" | fabric -p era_agent_triage -m google/gemma-3-27b-it:free -V OpenRouter
   echo "task" | fabric -p era_agent_triage -m meta-llama/llama-3.3-70b-instruct:free -V OpenRouter
   echo "task" | fabric -p era_agent_triage -m openai/gpt-oss-120b:free -V OpenRouter
   ```

## Troubleshooting

### Ollama models not showing in `fabric -L`
```bash
# Ensure correct env var (API_URL not API_BASE_URL)
grep OLLAMA ~/.config/fabric/.env
# Should show: OLLAMA_API_URL=http://localhost:11434

# Clear cache and retry
rm ~/.config/fabric/models_cache.json
fabric -L | grep Ollama
```

### Ollama slow on CPU
Normal — 8B models take 30-60s on CPU. Options:
- Use smaller models: `deepseek-coder:latest` (776MB) or `qwen2.5-coder:3b` (1.9GB)
- Add a GPU for 10-20x speedup
- Use Ollama for testing only, Gemini Flash for production triage

### YouTube transcript extraction warning
The "No supported JavaScript runtime" warning is cosmetic — transcripts still work. Node.js at `/usr/bin/node` handles it.

### Ollama timing expectations (benchmarked on this system)
See [performance-tradeoffs.md](performance-tradeoffs.md) for full benchmarks.
- Simple Q&A: ~20s (viable)
- Agent triage pattern: >120s (not viable on CPU-only)
- Recommendation: Use Ollama only for simple prompts; Gemini Flash for agent workflows
