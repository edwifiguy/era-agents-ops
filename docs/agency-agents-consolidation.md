# Agency-Agents Consolidation into ERA Agents Ops

## What was done

1. Cloned upstream into:
   - `third_party/agency-agents`
2. Added curated ERA-aligned library in its own folder:
   - `agents/agency-library/`
3. Added hardened agents for immediate use:
    - `agency-orchestrator`
    - `agency-security-engineer`
    - `agency-growth-operator`
    - `agency-product-strategist`
    - `agency-options-trading-operator`
    - `agency-technical-support-engineer`
    - `agency-mysql-dba`

## Why this is better than a raw copy

- Upstream remains intact for updates.
- ERA-specific quality/security/approval conventions are baked in.
- Stable invocation names improve triage reliability.
- Lower operational risk versus importing all 51+ personas unfiltered.

## Suggested usage

```bash
# Install curated agency library
cp agents/agency-library/*.toml ~/.codex/agents/

# Route complex business missions
echo "Build and launch an AI property lead-gen engine" | fabric -p era_sdd_triage
```

## Recommendation

This is high-value for `era-agents-ops`: Agency-Agents expands business-function coverage substantially. The best approach is curated adoption (as implemented), not wholesale unfiltered import.
