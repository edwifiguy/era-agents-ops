---
name: varlock-security-audit
description: Use this skill whenever the user mentions Varlock schemas, secret references, env hardening, plaintext .env cleanup, or provider key integration (OpenRouter is one example).
---

# Purpose
Implement and maintain a secure, repeatable provider key integration using Varlock as the primary configuration and secret-resolution layer.

# Core policy
- Always back up existing files before modifying them.
- Never print or persist raw secret values in outputs.
- Prefer schema-driven configuration (`.env.schema`) over plaintext `.env` secrets.
- Use one canonical secret reference path for shared keys.

# Trigger conditions
Use this skill when the user asks to:
- set up or fix provider API keys (for example `OPENROUTER_API_KEY`)
- migrate from plaintext `.env` to a safer model
- integrate Hermes/Fabric with Varlock
- wire Proton Pass secret references
- validate key-loading and runtime command behavior

# Required outputs
1. Updated schema/config files with secure provider key handling.
2. Versioned backup artifacts (timestamped).
3. Verification evidence (command checks, no secret values).
4. A concise remediation summary and next steps.

# Standard workflow
1. Identify target files:
   - `.env.schema` for each runtime context (Hermes/Fabric/project)
   - wrapper scripts and shell aliases
   - legacy `.env` files that may contain plaintext secrets
2. Create timestamped backups:
   - `filename.bak-YYYYMMDD-HHMMSS`
3. Implement secure schema:
   - provider key secret references (example: `OPENROUTER_API_KEY=protonPass(pass://ERA/Shared/OPENROUTER_API_KEY)`)
   - pin provider selection where needed (example: `HERMES_INFERENCE_PROVIDER=openrouter`)
4. Sanitize legacy plaintext key values:
   - keep key names, clear values
5. Validate:
   - verify command paths (`varlock`, secure wrappers)
   - run `varlock load --path <context>`
   - verify no non-empty secret assignments remain in targeted `.env` files
6. Report:
   - summarize trade-offs, migration status, and remaining manual steps

# Security trade-off guidance
- Varlock-only (recommended): strongest consistency, lower operational ambiguity.
- Varlock + dotenvx: useful only for legacy compatibility; avoid dual-primary ownership.
- Secret-manager references beat encrypted-at-rest plaintext for long-term maintainability.

# Guardrails
- Do not commit live secrets.
- Do not delete old files without backup or commit history.
- Keep one canonical secret reference path per provider key across contexts.
- If plugin authentication is missing, report the exact unblock step (for example `pass-cli login`) and stop short of unsafe fallback.

# Verification checklist
- [ ] Backup created before modification
- [ ] provider key references are shared and consistent
- [ ] Provider pinning set where required
- [ ] Target `.env` files contain no non-empty sensitive values
- [ ] Runtime command (`hermes-ai` / secure wrapper) resolves
- [ ] Validation command output captured (redacted)

