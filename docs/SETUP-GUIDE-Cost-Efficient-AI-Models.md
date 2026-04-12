# ERA Agents Ops — Cost-Efficient AI Model Setup Guide
**Version:** 1.0 | **Date:** 2026-04-12 | **Print-ready**

---

## Table of Contents

1. Overview — What This Guide Covers
2. API Key Acquisition Links
3. Step 1 — Configure Warp BYOK (Gemini Free Tier)
4. Step 2 — Configure Fabric Providers
5. Step 3 — Configure OpenRouter Free Models
6. Step 4 — Verify All Providers Work
7. Step 5 — Add Shell Aliases for Quick Switching
8. Cost Comparison Summary
9. Troubleshooting

---

## 1. Overview

This guide configures your AI tools to minimize costs:

- **Warp/Oz** → Google Gemini via BYOK (free tier, 0 Warp credits)
- **Fabric** → Gemini Flash default (near-free) + OpenRouter free fallback
- **Offline** → Ollama local models (already configured)

**Estimated monthly cost after setup: $0–3/month** (down from ~$7+)

---

## 2. API Key Acquisition Links

Get these keys BEFORE starting setup:

### Required

| Provider | URL | Cost | Purpose |
|----------|-----|------|---------|
| **Google Gemini** | https://aistudio.google.com/apikey | Free (1,500 req/day) | Warp BYOK + Fabric default |
| **OpenRouter** | https://openrouter.ai/keys | Free (rate-limited) | 24 free cloud models via Fabric |

### Optional

| Provider | URL | Cost | Purpose |
|----------|-----|------|---------|
| **Anthropic** | https://console.anthropic.com/settings/keys | Paid (~$0.005/query) | Premium quality when needed |
| **OpenAI** | https://platform.openai.com/api-keys | Paid | GPT models in Warp (optional) |

### Security Reminders

- Rotate any keys that were previously exposed in plain text
- After creating keys, restrict by IP in Google Cloud Console
- Never commit keys to git (git-secrets is installed to prevent this)

---

## 3. Step 1 — Configure Warp BYOK

This routes Warp/Oz through your Google API key → 0 Warp credits consumed.

### 3.1 Open Settings

```
Settings → AI → API Keys
```

Or use Command Palette: `Cmd+Shift+P` → search "API Keys"

### 3.2 Add Google Gemini Key

1. Click **Add Key** next to Google
2. Paste your Gemini API key
3. Key is stored **locally only** — never sent to Warp servers

### 3.3 Select Gemini Model

1. Click the **model name** in Warp's input bar (bottom of terminal)
2. Look for models with a **key icon** (🔑) — these use YOUR key
3. Select **Gemini 3.1 Pro** with the key icon
4. This model now uses your Google free tier — 0 Warp credits

### 3.4 Verify

- Run a simple prompt in Warp
- Check the credit footer — should show "0 credits used"
- Check Google AI Studio dashboard for usage confirmation

### Fallback Configuration (Optional)

If you want Warp to fall back to Warp credits when your key has issues:

```
Settings → AI → API Keys → Enable "Warp credit fallback"
```

Recommended: **Leave fallback OFF** to stay cost-free. If Gemini errors, just retry.

---

## 4. Step 2 — Configure Fabric Providers

Fabric already defaults to Gemini Flash. This step rotates your keys securely.

### 4.1 Edit Fabric Config

Open the config file:

```bash
nano ~/.config/fabric/.env
```

### 4.2 Update Keys

Replace with your new (rotated) keys:

```bash
# Near-free default (1,500 requests/day free)
GEMINI_API_KEY=YOUR_NEW_GEMINI_KEY_HERE

# Premium fallback (paid, use sparingly)
ANTHROPIC_API_KEY=YOUR_NEW_ANTHROPIC_KEY_HERE

# Free cloud models (24 models, rate-limited)
OPENROUTER_API_KEY=YOUR_NEW_OPENROUTER_KEY_HERE

# Free local (already configured)
OLLAMA_API_URL=http://localhost:11434

# Default — uses Gemini Flash (cheapest cloud option)
DEFAULT_MODEL=gemini-2.5-flash
DEFAULT_VENDOR=Gemini
```

### 4.3 Save and Verify

```bash
# Clear model cache to pick up new keys
rm -f ~/.config/fabric/models_cache.json

# Verify Gemini works
echo "test" | fabric -p raw_query -m gemini-2.5-flash -V Gemini

# Verify OpenRouter free works (after adding key)
echo "test" | fabric -p raw_query -m google/gemma-4-31b-it:free -V OpenRouter

# Verify Ollama works (local, free)
echo "test" | fabric -p raw_query -m deepseek-coder:latest -V Ollama
```

---

## 5. Step 3 — Configure OpenRouter Free Models

OpenRouter gives you 24 completely free models including some very large ones.

### 5.1 Get Free API Key

1. Go to https://openrouter.ai/keys
2. Sign up (free)
3. Create a new API key
4. Copy the key (starts with `sk-or-v1-...`)

### 5.2 Add to Fabric

```bash
# Replace the placeholder in ~/.config/fabric/.env
sed -i 's/OPENROUTER_API_KEY=.*/OPENROUTER_API_KEY=YOUR_KEY_HERE/' ~/.config/fabric/.env
```

### 5.3 Best Free Models for ERA Agent Triage

| Model | Size | Best For | Command Flag |
|-------|------|----------|-------------|
| openai/gpt-oss-120b:free | 120B | Complex reasoning | `-m openai/gpt-oss-120b:free` |
| nvidia/nemotron-3-super-120b-a12b:free | 120B MoE | Efficient reasoning | `-m nvidia/nemotron-3-super-120b-a12b:free` |
| meta-llama/llama-3.3-70b-instruct:free | 70B | General purpose | `-m meta-llama/llama-3.3-70b-instruct:free` |
| google/gemma-4-31b-it:free | 31B | Structured output | `-m google/gemma-4-31b-it:free` |
| qwen/qwen3-coder:free | — | Code tasks | `-m qwen/qwen3-coder:free` |

### 5.4 Usage

```bash
# Free agent triage (cloud, fast)
echo "task description" | fabric -p era_agent_triage -m google/gemma-4-31b-it:free -V OpenRouter

# Free mission planning (large model, slower)
echo "business idea" | fabric -p era_mission_planner -m openai/gpt-oss-120b:free -V OpenRouter
```

---

## 6. Step 4 — Verify All Providers

Run this verification script to confirm everything works:

```bash
echo "=== Provider Verification ==="

echo "[1/4] Gemini Flash (default, near-free)..."
echo "say ok" | timeout 15 fabric -p raw_query -m gemini-2.5-flash -V Gemini && echo "✅ Gemini OK" || echo "❌ Gemini FAILED"

echo "[2/4] OpenRouter Free..."
echo "say ok" | timeout 15 fabric -p raw_query -m google/gemma-4-31b-it:free -V OpenRouter && echo "✅ OpenRouter OK" || echo "❌ OpenRouter FAILED"

echo "[3/4] Ollama Local..."
echo "say ok" | timeout 60 fabric -p raw_query -m deepseek-coder:latest -V Ollama && echo "✅ Ollama OK" || echo "❌ Ollama FAILED (slow on CPU is normal)"

echo "[4/4] Anthropic (premium fallback)..."
echo "say ok" | timeout 15 fabric -p raw_query -m claude-haiku-4-5 -V Anthropic && echo "✅ Anthropic OK" || echo "❌ Anthropic FAILED"

echo "=== Verification Complete ==="
```

---

## 7. Step 5 — Shell Aliases for Quick Switching

Add these to `~/.bashrc` for instant provider switching:

```bash
# === ERA Agent Ops — Provider Aliases ===

# Fabric provider shortcuts
alias fabric-free='fabric -m gemini-2.5-flash -V Gemini'
alias fabric-free-cloud='fabric -m google/gemma-4-31b-it:free -V OpenRouter'
alias fabric-free-local='fabric -m deepseek-coder:latest -V Ollama'
alias fabric-premium='fabric -m claude-haiku-4-5 -V Anthropic'

# ERA Agent triage shortcuts
alias era-triage='fabric -p era_agent_triage -m gemini-2.5-flash -V Gemini'
alias era-triage-free='fabric -p era_agent_triage -m google/gemma-4-31b-it:free -V OpenRouter'
alias era-mission='fabric -p era_mission_planner -m gemini-2.5-flash -V Gemini'

# YouTube pipeline
alias era-yt='fabric -p era_yt_to_obsidian -m gemini-2.5-flash -V Gemini'

# Security audit
alias era-security='fabric -p era_env_security_audit -m gemini-2.5-flash -V Gemini'
```

Apply immediately:

```bash
source ~/.bashrc
```

---

## 8. Cost Comparison Summary

### Before This Setup

| Tool | Provider | Monthly Cost |
|------|----------|-------------|
| Warp/Oz | Warp credits | ~$20/month in credits |
| Fabric | Anthropic Claude | ~$7/month |
| **Total** | | **~$27/month** |

### After This Setup

| Tool | Provider | Monthly Cost |
|------|----------|-------------|
| Warp/Oz | BYOK Google Gemini 3.1 Pro | $0 (free tier) |
| Fabric default | Gemini 2.5 Flash | ~$1-3/month |
| Fabric fallback | OpenRouter free | $0 |
| Fabric offline | Ollama local | $0 |
| Fabric premium | Anthropic (rare use) | ~$1/month |
| **Total** | | **$1-4/month** |

### Savings: ~$23/month ($276/year)

---

## 9. Troubleshooting

### Gemini returns 503 errors
- Temporary overload — wait 10 seconds and retry
- Do NOT fall back to paid models automatically
- Use OpenRouter free as alternate: `-m google/gemma-4-31b-it:free -V OpenRouter`

### OpenRouter models not appearing
```bash
rm -f ~/.config/fabric/models_cache.json
fabric -L | grep OpenRouter | head -5
```

### Ollama models timeout
- Normal on CPU (i7-4650U, no GPU) — expect 20-60s for simple tasks
- Use Ollama only for simple offline queries
- For agent triage patterns, use Gemini Flash instead

### Warp still consuming credits
- Verify you selected a model with the **key icon** 🔑
- Auto models always consume credits — select a specific Gemini model
- Check: Settings → AI → API Keys → confirm Google key is present

### API key security
- Keys stored locally only (never on Warp servers)
- git-secrets pre-commit hooks prevent accidental commits
- Run security audit: `era-security` alias

---

## Quick Reference Card

```
╔══════════════════════════════════════════════════╗
║          ERA AGENTS OPS — COST GUIDE             ║
╠══════════════════════════════════════════════════╣
║                                                  ║
║  WARP/OZ:  Select Gemini 3.1 Pro (🔑 key icon)  ║
║  FABRIC:   Defaults to Gemini Flash (no flags)   ║
║  FREE:     era-triage-free (OpenRouter)          ║
║  OFFLINE:  fabric-free-local (Ollama)            ║
║  PREMIUM:  fabric-premium (Anthropic, rare)      ║
║                                                  ║
║  ALIASES:                                        ║
║    era-triage    → agent triage (Gemini)         ║
║    era-mission   → mission plan (Gemini)         ║
║    era-yt        → YouTube → Obsidian            ║
║    era-security  → .env audit                    ║
║                                                  ║
║  API KEY LINKS:                                  ║
║    Gemini:    aistudio.google.com/apikey          ║
║    OpenRouter: openrouter.ai/keys                ║
║    Anthropic: console.anthropic.com/settings/keys ║
║                                                  ║
╚══════════════════════════════════════════════════╝
```

---

*ERA Agents Ops | https://github.com/edwifiguy/era-agents-ops*
*Generated 2026-04-12 | Print with: pandoc or browser print (Ctrl+P)*
