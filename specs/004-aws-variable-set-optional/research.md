# Research: Optional AWS Variable Set

## Decision 1: Introduce `aws.enabled` toggle with default true
- **Decision**: Add `aws.enabled` to root variable schema and default it to `true`.
- **Rationale**: Enables opt-out behavior while preserving existing consumers and defaults.
- **Alternatives considered**:
  - Default to false: rejected because it breaks existing behavior.
  - Separate top-level flag outside `aws`: rejected as less cohesive.

## Decision 2: Gate AWS variable set module with `count`
- **Decision**: Add `count = var.aws.enabled ? 1 : 0` for `module.aws_credentials_variable_set`.
- **Rationale**: Canonical Terraform approach for optional module instantiation.
- **Alternatives considered**:
  - Keep always-on module and skip variable payloads: rejected because resource still exists.
  - Use `for_each` map toggle: rejected as unnecessary complexity for single toggle.

## Decision 3: Add root `moved {}` state migration blocks
- **Decision**: Add `moved {}` entries in root `moved.tf` from non-indexed module address to indexed `[0]` address.
- **Rationale**: Prevents destroy/recreate when introducing `count` on existing module.
- **Alternatives considered**:
  - Manual `terraform state mv`: rejected because migration should be codified and reproducible.
  - Accept recreation: rejected due to avoidable operational risk.

## Decision 4: Keep non-AWS variable set behavior untouched
- **Decision**: Limit changes strictly to AWS variable set creation path.
- **Rationale**: Minimizes regression risk and keeps blast radius narrow.
- **Alternatives considered**:
  - Broader variable-set refactor: rejected as out of scope.
