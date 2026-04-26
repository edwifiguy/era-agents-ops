# Experience & Learning — Archon OpenRouter + Appwrite Runtime

Date: 2026-04-19  
Project: Archon (`/home/era-estate/git/cloned/tools/Archon`)

## Objective

Configure Archon runtime to use OpenRouter free models and provision an Appwrite Docker stack that can run alongside Archon services.

## What was implemented

1. Added OpenRouter provider support in Archon backend provider resolution and client factory.
2. Updated runtime defaults to OpenRouter free model path (`google/gemma-4-31b-it:free`).
3. Added OpenRouter key propagation in Docker Compose environments.
4. Added optional Appwrite stack compose file (`docker-compose.appwrite.yml`) using profile `appwrite`.
5. Added migration SQL for existing deployments (`migration/add_openrouter_runtime_defaults.sql`).
6. Added operational runbook (`docs/openrouter-appwrite-runtime.md`).

## Reusable patterns for future projects

1. **Provider abstraction first**: map API key + base URL by provider (`credential_service`) before touching call sites.
2. **OpenAI-compatible portability**: OpenRouter/Ollama/Google can share OpenAI SDK path when base URL and key are separated.
3. **Profile-gated infra add-ons**: use Compose profiles for optional stacks (e.g., Appwrite) to avoid impacting default startup.
4. **Dual-path rollout**: pair code changes with migration SQL and docs for both fresh installs and existing databases.

## Known operational dependency

Appwrite/Archon containers require Docker daemon availability.  
If daemon access is unavailable, config validation can pass but services cannot launch until daemon is restored.

