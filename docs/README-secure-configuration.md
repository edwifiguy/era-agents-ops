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

## 10) Security guardrails
- Do not store live secrets directly in `.env`.
- Keep secret values only in Proton Pass.
- Keep `.env` secret values blank.
- Validate with `varlock load` before runtime operations.
