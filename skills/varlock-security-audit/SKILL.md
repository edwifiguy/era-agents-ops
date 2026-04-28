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
   - provider key secret references (example: `OPENROUTER_API_KEY=protonPass(pass://Login/ERA_OPENROUTER_API_KEY/password)`)
   - pin provider selection where needed (example: `HERMES_INFERENCE_PROVIDER=openrouter`)
4. Migrate required plaintext secrets to the secret manager first:
   - capture from backup/source without printing values
   - create or update corresponding Proton Pass items
5. Sanitize legacy plaintext key values:
   - keep key names, clear values (or remove assignment if resolved by schema)
   - avoid leaving required variables unresolved after cleanup
6. Validate:
   - verify command paths (`varlock`, secure wrappers)
   - run `varlock load --path <context>`
   - verify no non-empty secret assignments remain in targeted `.env` files
7. Report:
   - summarize trade-offs, migration status, and remaining manual steps

# Hermes secure remediation pattern (reference implementation)
Use this exact sequence when required secrets are still present in `.env`:
1. Back up both `.env` and `.env.schema` with timestamped copies.
2. Add schema-based secret references for required runtime secrets, for example:
   - `SUDO_PASSWORD=protonPass(pass://Login/ERA_SUDO_PASSWORD/password, allowMissing=true)`
   - `EMAIL_PASSWORD=protonPass(pass://Login/ERA_EMAIL_PASSWORD/password, allowMissing=true)`
3. Remove direct plaintext assignments from `.env` for those keys.
4. Run `varlock load --path ~/.hermes` and inspect redacted output.
5. If validation fails because secret items are missing, create/update those Proton Pass items (without printing values), then re-run validation.
6. Final state must have:
   - no plaintext secret assignments in `.env`
   - successful `varlock load` for Hermes
   - redacted evidence showing the variables resolve via schema.

# Security trade-off guidance
- Varlock-only (recommended): strongest consistency, lower operational ambiguity.
- Varlock + dotenvx: useful only for legacy compatibility; avoid dual-primary ownership.
- Secret-manager references beat encrypted-at-rest plaintext for long-term maintainability.

# Guardrails
- Do not commit live secrets.
- Do not delete old files without backup or commit history.
- Keep one canonical secret reference path per provider key across contexts.
- Do not leave required secrets empty after plaintext cleanup; either provision secret-manager items or mark schema entries optional intentionally.
- If plugin authentication is missing, report the exact unblock step (for example `pass-cli login`) and stop short of unsafe fallback.

# Verification checklist
- [ ] Backup created before modification
- [ ] provider key references are shared and consistent
- [ ] Provider pinning set where required
- [ ] Target `.env` files contain no non-empty sensitive values
- [ ] Runtime command (`hermes-ai` / secure wrapper) resolves
- [ ] Validation command output captured (redacted)
- [ ] Secret-manager items created/updated for any required missing variables
- [ ] `varlock load --path ~/.hermes` passes after migration

