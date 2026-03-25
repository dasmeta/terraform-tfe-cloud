# Research: Workspace Settings Migration

## Decision 1: Use supported settings resources for execution behavior
- **Decision**: Manage execution mode and agent-pool affinity through dedicated settings resources, not deprecated direct workspace fields.
- **Rationale**: Provider guidance deprecates direct controls and settings resources provide forward-compatible behavior.
- **Alternatives considered**:
  - Keep deprecated direct fields: rejected due to deprecation risk and future breakage.
  - Hybrid long-term approach: rejected because it preserves ambiguity and doubles maintenance burden.

## Decision 2: Define explicit unset execution-mode behavior
- **Decision**: Treat execution-mode unsetting as an explicit managed transition with deterministic behavior, not implicit provider fallback.
- **Rationale**: Current provider behavior leaves prior value unmanaged when unset; explicit handling prevents drift.
- **Alternatives considered**:
  - Rely on old implicit revert-to-remote behavior: rejected as no longer guaranteed.
  - Leave unset unmanaged silently: rejected due to non-deterministic state for operators.

## Decision 3: Preserve behavior-first migration
- **Decision**: During migration, preserve existing effective run behavior unless configuration explicitly changes.
- **Rationale**: Minimizes operational risk and prevents surprise workspace execution changes.
- **Alternatives considered**:
  - Force new defaults globally during migration: rejected due to high blast radius.
  - Require manual one-by-one migration with no compatibility path: rejected due to rollout friction.

## Decision 4: Keep precedence rules explicit
- **Decision**: Document and enforce precedence between workspace-level settings and organization defaults.
- **Rationale**: Clear ownership reduces misconfiguration and eases troubleshooting.
- **Alternatives considered**:
  - Implicit precedence only: rejected because behavior becomes harder to reason about.
  - Organization defaults always override workspace values: rejected as too restrictive.
