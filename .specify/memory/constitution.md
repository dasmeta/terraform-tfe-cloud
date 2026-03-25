<!--
Sync Impact Report
- Version change: 1.0.0 -> 1.1.0
- Modified principles:
  - Added VI. Feature Numbering Source of Truth
- Added sections: None
- Removed sections: None
- Templates requiring updates:
  - ✅ updated: .specify/scripts/bash/create-new-feature.sh
  - ✅ updated: .specify/templates/spec-template.md
  - ✅ reviewed/no change required: .specify/templates/plan-template.md
  - ✅ reviewed/no change required: .specify/templates/tasks-template.md
  - ⚠ pending (path not present): .specify/templates/commands/*.md
- Follow-up TODOs: None
-->
# Dasmeta Terraform-TFE Cloud Constitution

## Core Principles

### I. Terraform Module Standards First
Every repository change MUST be evaluated against the internal Terraform module standards (variables, outputs, file layout, naming, and docs/examples/tests alignment) as defined by the centralized `terraform-module-developer` skill.
Rationale: keep module responsibilities coherent and prevent drift into ad-hoc Terraform root configuration.

### II. Focused Scope and Responsibility Boundaries
Changes MUST stay within the coherent module responsibility boundary for the affected submodule (typically within `modules/*`) and repository automation files in the same repository scope.
Do not mix long-lived and high-churn responsibilities unless the request explicitly requires coupling.
Rationale: reduces blast radius for interface changes and avoids entangling unrelated concerns.

### III. Interface Discipline (Variables/Outputs)
Expose only the most commonly changed module inputs/outputs; add descriptions for every variable and output; keep Terraform identifiers aligned with the internal standards (e.g. underscores for Terraform identifiers; lowercase where possible).
Rationale: makes module interfaces understandable and reduces breaking changes.

### IV. Requirements-Validated Examples and Tests
When behavior or interface changes materially, examples and tests MUST be updated to match the live module interface.
Prefer a stable tests/examples layout and ensure examples and tests stay in sync.
Rationale: Terraform modules are hard to reason about without executable examples and assertions.

### V. Breaking Change and Conflict Approval Gates
If a requested change would be breaking, interface-widening, or conflicts with internal standards or repository scope rules, the workflow MUST stop and request explicit approval before editing.
When governance source conflicts exist, cross-repository governance from the constitution repository is authoritative.
Rationale: ensures safety when standards or governance disagree.

### VI. Feature Numbering Source Of Truth
Feature numeric prefixes MUST be allocated from existing `specs/<NNN>-*` directories only.
Branch-name availability, remote branch scans, and local branch scans MUST NOT be used as
the authoritative source for the next feature number.
Rationale: repository specs are the durable planning record; numbering must remain stable and
deterministic even when branches are deleted, renamed, or out of sync across remotes.

## Additional Constraints

- Module file conventions:
  - keep providers in `providers.tf`
  - keep version expectations explicit in `versions.tf`
  - use trailing newline in text files
- Resource block conventions:
  - keep tags near the end of the real arguments, followed by `depends_on` and `lifecycle` only when needed
- Documentation expectations:
  - `README.md` must focus on how the module works and include copy-pasteable examples

## Development Workflow

- Planning requirements (mandatory for pre-change plans):
  - include current repository module state
  - list gaps versus bundled internal standards
  - list proposed file changes
  - identify potential breaking changes
  - identify conflicts requiring approval
- Fallback guidance order (only when internal standards leave gaps):
  1. bundled internal references
  2. official Terraform/OpenTofu documentation
  3. community conventions
- Git operations are not assumed as part of the `terraform-module-developer` workflow unless explicitly directed for the task.

## Governance

This constitution supersedes ad-hoc practices for Terraform module development in `dasmeta/terraform-tfe-cloud`.
Amendments require:
1) updating this file with a semver version bump,
2) documenting the changed principles/guidance,
3) ensuring subsequent planning and implementation steps reference the updated gates.

**Version**: 1.1.0 | **Ratified**: 2026-03-20 | **Last Amended**: 2026-03-24
