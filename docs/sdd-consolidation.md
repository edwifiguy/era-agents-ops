# SDD Consolidation Guide for ERA Agents Ops

This consolidation aligns `fabric`, `Awesome-Codex-Subagents`, `era-agents-ops`, `spec-kit`, and `OpenSpec` into one workflow.

## Consolidated flow

1. **Triage** with Fabric:
   - `fabric -p era_sdd_triage`
2. **Spec orchestration** with:
   - `sdd-spec-orchestrator` (agent)
3. **Execution** through existing ERA specialist agents (or imported subagents)
4. **Verification** using quality/security agents

## Where each component fits

- `fabric`: deterministic text-interface for triage and repeatable orchestration prompts.
- `spec-kit`: fast SDD loop and practical spec scaffolding.
- `OpenSpec`: stronger governance and spec rigor for complex/high-risk work.
- `Awesome-Codex-Subagents`: broad specialist roster you can selectively map into ERA plans.
- `era-agents-ops`: mission-aware coordinator and policy layer.

## Practical recommendation

- Use `sdd-lite` by default for product features.
- Switch to `sdd-full` for security, finance, infra, or multi-repo changes.
- Keep approval gates mandatory before implementation and before release.

## Can era-agents-ops work with SDD?

Yes. `era-agents-ops` already has routing/orchestration primitives; SDD slots in naturally as:
- an additional triage mode (`era_sdd_triage`)
- an orchestration role (`sdd-spec-orchestrator`)
- a stricter mission policy for spec/approval/verify sequencing.

