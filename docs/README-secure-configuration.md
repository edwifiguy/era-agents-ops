# Secure Configuration README (Fabric + Hermes)
This guide documents the secure, non-plaintext setup for API keys using Varlock + Proton Pass.
It is scoped to active runtimes only: Fabric and Hermes.

## 1) Goal
- Keep secrets out of `.env` plaintext files.
- Resolve secrets at runtime from Proton Pass through Varlock.
- Validate configuration before running tools.

## 2) Active keys in scope
- `ERA_OPENROUTER_API_KEY`
- `ERA_ANTHROPIC_API_KEY`
- `ERA_GEMINI_API_KEY`
- `ERA_FAL_KEY` (Hermes image generation)
- Optional fallback (if enabled in schema): `ERA_OPENROUTER_API_KEY_FALLBACK`

## 3) Proton Pass item convention
- Vault: `Login`
- Item type: `Login` (current working standard)
- Item title: exact mapped title (example: `ERA_OPENROUTER_API_KEY`)
- Secret value location: `password` field
- Optional username: `varlock`
- Notes field: metadata block (owner, system, rotation dates, etc.)

## 4) Varlock schema references
### Fabric (`~/.config/fabric/.env.schema`)
- `ANTHROPIC_API_KEY=protonPass(pass://Login/ERA_ANTHROPIC_API_KEY/password)`
- `GEMINI_API_KEY=protonPass(pass://Login/ERA_GEMINI_API_KEY/password)`
- `OPENROUTER_API_KEY=protonPass(pass://Login/ERA_OPENROUTER_API_KEY/password)`

### Hermes (`~/.hermes/.env.schema`)
- `OPENROUTER_API_KEY=protonPass(pass://Login/ERA_OPENROUTER_API_KEY/password)`
- `OPENROUTER_API_KEY_FALLBACK=protonPass(pass://Login/ERA_OPENROUTER_API_KEY_FALLBACK/password)` (optional)
- `FAL_KEY=protonPass(pass://Login/ERA_FAL_KEY/password, allowMissing=true)` (optional but required for FAL-backed image tools)

## 5) Login + validation flow
### Proton Pass login
Preferred (opens web flow):
```bash
pass-cli login 2>&1 || true
```

Verify session:
```bash
pass-cli info
```

### Validate Varlock resolution
```bash
varlock load --path ~/.config/fabric
varlock load --path ~/.hermes
```

## 6) Run secure commands
### Fabric (Varlock-backed wrapper)
```bash
~/.local/bin/fabric-secure -V OpenRouter -m openrouter/free -p summarize_prompt
```

### Hermes (Varlock-backed wrapper alias)
Use `hermes-ai` if alias is mapped to `hermes-secure`, or call wrapper directly:
```bash
~/.local/bin/hermes-secure --help
```

## 7) Verify active model/vendor in Fabric
```bash
varlock load --path ~/.config/fabric --format env | grep -E '^(DEFAULT_VENDOR|DEFAULT_MODEL)='
```

Expected:
- `DEFAULT_VENDOR="OpenRouter"`
- `DEFAULT_MODEL="openrouter/free"`

## 8) Strict mode option (remove fallback key)
If you want strict required-key configuration, remove `OPENROUTER_API_KEY_FALLBACK` blocks from:
- `~/.config/fabric/.env.schema`
- `~/.hermes/.env.schema`

Then re-run:
```bash
varlock load --path ~/.config/fabric
varlock load --path ~/.hermes
```

## 9) Troubleshooting
### `pass-cli login --interactive ...` fails with `422 Unprocessable Entity`
- Use web login flow instead:
```bash
pass-cli login 2>&1 || true
```

### Varlock fails with Proton Pass auth/session errors
- Re-authenticate:
```bash
pass-cli login
pass-cli info
```
- Re-validate:
```bash
varlock load --path ~/.config/fabric
varlock load --path ~/.hermes
```

### `grep` does not show values from `varlock load`
- Use `--format env`:
```bash
varlock load --path ~/.config/fabric --format env | grep -E '^(DEFAULT_VENDOR|DEFAULT_MODEL)='
```

### Varlock fails with `Could not find item with name ERA_FAL_KEY`
- Create the missing Login item in Proton Pass with exact title `ERA_FAL_KEY`.
- Put the key value in the `password` field.
- Re-run:
```bash
varlock load --path ~/.hermes
```

## 10) Security guardrails
- Do not store live secrets directly in `.env`.
- Keep secret values only in Proton Pass.
- Keep `.env` secret values blank.
- Validate with `varlock load` before runtime operations.

## 11) Final verified Hermes runtime steps (OpenRouter)
Use this exact sequence for a clean, repeatable runtime check.

1. Ensure the secret exists in Proton Pass:
   - Item title: `ERA_OPENROUTER_API_KEY`
   - Field used by schema: `password`

2. Ensure Hermes schema points to the shared reference:
```bash
grep -n 'OPENROUTER_API_KEY=protonPass(pass://Login/ERA_OPENROUTER_API_KEY/password)' ~/.hermes/.env.schema
```

3. Avoid overriding Varlock with a blank `.env` value:
   - In `~/.hermes/.env`, do **not** leave an active blank assignment:
   - Bad: `OPENROUTER_API_KEY=`
   - Good: `# OPENROUTER_API_KEY=` (commented) or remove the line

4. Authenticate Proton Pass CLI and validate resolution:
```bash
pass-cli login 2>&1 || true
pass-cli info
varlock load --path ~/.hermes
```

5. Run a one-shot Hermes runtime verification:
```bash
hermes-ai chat -q "Reply with TEST_OK only." --provider openrouter -m openrouter/free -Q
```

Expected success signal:
- Output contains `TEST_OK`
- Command exits with code `0`

## 12) Final verified Hermes image-key steps (FAL)
Use this sequence to validate `ERA_FAL_KEY` wiring for image generation.

1. Create a new Proton Pass Login item:
   - Item title: `ERA_FAL_KEY` (exact)
   - Field used by schema: `password`

2. Ensure Hermes schema includes:
```bash
grep -n 'FAL_KEY=protonPass(pass://Login/ERA_FAL_KEY/password, allowMissing=true)' ~/.hermes/.env.schema
```

3. Validate env resolution and key visibility:
```bash
varlock load --path ~/.hermes
hermes-ai status
```

Expected status signal:
- `FAL` shows as set (`✓`) under API Keys.

4. Run an image-generation verification:
```bash
hermes-ai chat -q "Generate a simple 512x512 image of a blue circle on white background and save it to /tmp/hermes_fal_test2.png. Then reply DONE with the exact file path." --provider openrouter -m openrouter/free -Q
file /tmp/hermes_fal_test2.png
```

Expected success signal:
- Output includes `DONE` and `/tmp/hermes_fal_test2.png`
- `file` reports a valid PNG image
