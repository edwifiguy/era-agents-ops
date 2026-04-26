# ENV Security Audit Report
**Scan date:** 2026-04-12
**Source:** YouTube analysis (Varlock / Syntax podcast) + local scan
**Video:** https://youtu.be/M5IkdUunf8g

---

## Summary

| Metric | Count |
|--------|-------|
| Files scanned | 6 active .env files |
| CRITICAL findings | 2 |
| HIGH findings | 3 |
| MEDIUM findings | 2 |
| LOW findings | 2 |

---

## CRITICAL FINDINGS

**[C1] FILE: ~/.config/fabric/.env**
- TYPE: Anthropic API Key
- KEY: ANTHROPIC_API_KEY
- VALUE: sk-ant-...iAAA [REDACTED]
- RISK: Plain-text API key readable by any process, AI agent, or malware on this machine. This key has billing access to Anthropic API.
- ACTION: Rotate at https://console.anthropic.com/settings/keys. Move to a secrets manager or use environment variable injection.

**[C2] FILE: ~/.config/fabric/.env**
- TYPE: Google Gemini API Key
- KEY: GEMINI_API_KEY
- VALUE: AIza...nsq8 [REDACTED]
- RISK: Plain-text Google API key. Could be used for unauthorized Gemini API calls billed to your account.
- ACTION: Rotate at https://aistudio.google.com/apikey. Consider restricting key by IP/referrer in Google Cloud Console.

## HIGH FINDINGS

**[H1] FILE: ~/.config/fabric/.env**
- TYPE: OpenRouter API Key
- KEY: OPENROUTER_API_KEY
- VALUE: Still placeholder {{OPENROUTER_API_KEY}} — no immediate risk, but will contain a real key once configured
- ACTION: When adding real key, use env var injection instead of plain text

**[H2] FILE: ~/git/cloned/reference/sim/.env**
- TYPE: Database credentials + auth secrets
- KEYS: POSTGRES_PASSWORD, BETTER_AUTH_SECRET, ENCRYPTION_KEY
- RISK: Database password and encryption keys in plain text. If this repo is ever pushed or shared, all secrets are exposed.
- ACTION: Move to .env.local (gitignored) or secrets manager. Verify .gitignore covers .env (confirmed: 6 entries, good)

**[H3] FILE: ~/.codex/auth.json**
- TYPE: Authentication tokens
- RISK: Codex auth tokens stored in plain text JSON. Any process can read these.
- ACTION: Ensure file permissions are 600 (owner-only). Currently correct.

## MEDIUM FINDINGS

**[M1] ~/.config/fabric/ has NO .gitignore**
- RISK: If this directory were ever version-controlled, .env with all API keys would be committed
- ACTION: Create ~/.config/fabric/.gitignore with `.env` entry

**[M2] ~/Projects/active/internal/ProbeCodeAI/ has NO .gitignore for .env**
- RISK: .env file exists but no .gitignore was found in the project directory
- ACTION: Add .env to project's .gitignore immediately

## LOW FINDINGS

**[L1] ProbeCodeAI .env has placeholder values (your_*_here)**
- No real secrets exposed, but indicates incomplete setup
- ACTION: Clean up or remove unused placeholder entries

**[L2] Archived .env files still exist in ~/Projects/archive/**
- Old .env files from archived projects still contain potential secrets
- ACTION: Audit and securely delete if no longer needed

---

## REMEDIATION PLAN — Status Updated 2026-04-12

### IMMEDIATE
1. ⏳ **Rotate Anthropic API key** — fixes [C1]
   - **MANUAL ACTION REQUIRED:** Go to https://console.anthropic.com/settings/keys
   - Generate new key → update ~/.config/fabric/.env → delete old key
2. ⏳ **Rotate Gemini API key** — fixes [C2]
   - **MANUAL ACTION REQUIRED:** Go to https://aistudio.google.com/apikey
   - Generate new key → restrict by IP in Google Cloud Console → update ~/.config/fabric/.env
3. ✅ **Add .gitignore to ~/.config/fabric/** — fixes [M1] — DONE
   - Created with .env, .env.*, models_cache.json exclusions

### SHORT-TERM
4. ✅ **Add .env to ProbeCodeAI .gitignore** — fixes [M2] — DONE
   - Created .gitignore with .env, node_modules, IDE exclusions
5. ✅ **Audit archived .env files** — fixes [L2] — DONE
   - Scanned all archived .env files: only placeholders found, no real secrets
6. ✅ **Install git-secrets pre-commit hook** — DONE
   - Installed git-secrets v1.3.0 system-wide
   - Added patterns: Anthropic (sk-ant-*), Google (AIza*), OpenRouter (sk-or-*),
     OpenAI (sk-*), GitHub (ghp_*, gho_*), Slack (xoxb-*), Stripe (sk_live_*), AWS
   - Hooks installed on: era-agents-ops, EU-Land, Archon

### COMPLETED
7. ✅ **Verified ~/.codex/auth.json permissions** — fixes [H3] — DONE
   - Confirmed 600 (owner read/write only)
8. ✅ **Created .env.schema template** (Varlock-inspired) — DONE
   - Available at templates/env.schema.template
   - JSDoc-style annotations: @type, @required, @sensitivity, @rotate-url
9. ✅ **Created env-security-auditor agent** — DONE
   - Available for recurring audits via Codex or Fabric
10. ✅ **Created era_env_security_audit Fabric pattern** — DONE
    - Installed to ~/.config/fabric/patterns/

### REMAINING MANUAL ACTIONS
- ⏳ Rotate Anthropic API key [C1]
- ⏳ Rotate Gemini API key [C2]
- ⏳ Get OpenRouter free API key and replace placeholder [H1]
- 📋 Investigate Varlock for full schema-driven migration
- 📋 Consider 1Password CLI for runtime secrets injection

## RECOMMENDED TOOLING

| Tool | Purpose |
|------|---------|
| **Varlock** | Schema-driven .env management with validation and redaction |
| **git-secrets** | Pre-commit hook to prevent committing secrets |
| **trufflehog** | Scan git history for previously committed secrets |
| **1Password CLI** | Inject secrets at runtime without plain text storage |
| **Proton Pass CLI + Varlock plugin** | Pull secrets via `pass://` references using Proton Pass CLI |
| **era_env_security_audit** | Fabric pattern for recurring audits |
| **env-security-auditor** | ERA agent for comprehensive security review |

## How to Run This Audit Again

```bash
# Quick scan using Fabric pattern
find ~/ -maxdepth 5 -name ".env" ! -name "*.example" 2>/dev/null | \
  xargs grep -l "KEY\|SECRET\|PASSWORD\|TOKEN" 2>/dev/null | \
  xargs cat 2>/dev/null | \
  fabric -p era_env_security_audit

# Or delegate to the subagent in Codex
# "Use the env-security-auditor to scan all .env files in my home directory"
```
