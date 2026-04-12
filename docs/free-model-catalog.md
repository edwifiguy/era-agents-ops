# Free & Near-Free Model Catalog
**Updated:** 2026-04-12

## Tier 0: Your Default (Near-Free)
| Model | Provider | Cost | Best For |
|-------|----------|------|----------|
| **gemini-2.5-flash** | Gemini API | ~$0.0002/query | Default daily driver — fast, capable, cheapest cloud option |

## Tier 1: OpenRouter Free Models (Best Free Options)

### Top Picks for Agent Triage Workflows

| Model | Params | Quality | Speed | Best For |
|-------|--------|---------|-------|----------|
| **openai/gpt-oss-120b:free** | 120B | Excellent | Medium | Complex reasoning, mission planning |
| **nvidia/nemotron-3-super-120b-a12b:free** | 120B (12B active) | Very good | Fast | Efficient reasoning, code review |
| **meta-llama/llama-3.3-70b-instruct:free** | 70B | Very good | Medium | General-purpose, instruction following |
| **google/gemma-4-31b-it:free** | 31B | Good | Fast | Structured output, efficient |
| **qwen/qwen3-coder:free** | — | Good | Fast | Code-specific tasks |
| **qwen/qwen3-next-80b-a3b-instruct:free** | 80B (3B active) | Good | Very fast | Quick triage, simple tasks |
| **nousresearch/hermes-3-llama-3.1-405b:free** | 405B | Excellent | Slow | Deep analysis when speed doesn't matter |

### All 24 Free Models

| Model | Type | Notes |
|-------|------|-------|
| openai/gpt-oss-120b:free | General | OpenAI's open-source 120B model |
| openai/gpt-oss-20b:free | General | Smaller, faster OpenAI open model |
| nvidia/nemotron-3-super-120b-a12b:free | Reasoning | MoE — only 12B active per query |
| nvidia/nemotron-3-nano-30b-a3b:free | Fast | Ultra-efficient, 3B active |
| nvidia/nemotron-nano-12b-v2-vl:free | Vision+text | Can analyze images |
| nvidia/nemotron-nano-9b-v2:free | Fast | Lightweight general |
| meta-llama/llama-3.3-70b-instruct:free | General | Meta's best open model |
| meta-llama/llama-3.2-3b-instruct:free | Fast | Very small, very fast |
| google/gemma-4-31b-it:free | General | Latest Gemma 4 |
| google/gemma-4-26b-a4b-it:free | Efficient | MoE — 4B active |
| google/gemma-3-27b-it:free | General | Previous gen, still good |
| google/gemma-3-12b-it:free | Balanced | Good quality/speed ratio |
| google/gemma-3-4b-it:free | Fast | Small and fast |
| google/gemma-3n-e2b-it:free | Ultra-fast | Edge model, 2B |
| google/gemma-3n-e4b-it:free | Fast | Edge model, 4B |
| qwen/qwen3-coder:free | Code | Alibaba's code specialist |
| qwen/qwen3-next-80b-a3b-instruct:free | Efficient | MoE — 3B active, 80B total |
| nousresearch/hermes-3-llama-3.1-405b:free | Deep | Largest free model available |
| minimax/minimax-m2.5:free | General | MiniMax's latest |
| arcee-ai/trinity-large-preview:free | General | Arcee's merged model |
| cognitivecomputations/dolphin-mistral-24b-venice-edition:free | Uncensored | Venice's uncensored Mistral |
| liquid/lfm-2.5-1.2b-instruct:free | Ultra-fast | Tiny, instant responses |
| liquid/lfm-2.5-1.2b-thinking:free | Reasoning | Tiny with chain-of-thought |
| z-ai/glm-4.5-air:free | General | Zhipu AI's model |

## Qwen 4 vs Gemma 4 Comparison

Neither Qwen 4 nor Gemma 4 has been fully released as of this date. Based on available previews:

| Factor | Gemma 4 (Google) | Qwen 3.5/3.6 (Alibaba) |
|--------|-----------------|----------------------|
| **Free on OpenRouter** | Yes — gemma-4-31b-it:free | Not yet (qwen3-coder:free available) |
| **Architecture** | MoE (26B with 4B active) | MoE (various configs) |
| **Code quality** | Good | Excellent (Qwen-Coder series) |
| **Instruction following** | Very good | Good |
| **Structured output** | Very good | Good |
| **Multilingual** | Good | Excellent (Chinese + English) |
| **Best free option** | gemma-4-31b-it:free | qwen3-coder:free |
| **On Ollama** | Not yet | Yes (qwen2.5-coder:3b already installed) |

**Recommendation:** For agent triage, **Gemma 4** (gemma-4-31b-it:free) is the better choice because it excels at structured output format adherence. For **code-specific tasks**, Qwen3-Coder is stronger.

## Usage

```bash
# Best free general model
echo "task" | fabric -p era_agent_triage -m openai/gpt-oss-120b:free -V OpenRouter

# Best free code model
echo "task" | fabric -p era_agent_triage -m qwen/qwen3-coder:free -V OpenRouter

# Best free efficient model (fastest)
echo "task" | fabric -p era_agent_triage -m nvidia/nemotron-3-nano-30b-a3b:free -V OpenRouter

# Best free Google model
echo "task" | fabric -p era_agent_triage -m google/gemma-4-31b-it:free -V OpenRouter

# Largest free model (405B — use for complex missions)
echo "task" | fabric -p era_mission_planner -m nousresearch/hermes-3-llama-3.1-405b:free -V OpenRouter
```

**Note:** OpenRouter free tier requires an API key (free signup at https://openrouter.ai/keys) and has rate limits. Fall back to Gemini Flash when throttled.
