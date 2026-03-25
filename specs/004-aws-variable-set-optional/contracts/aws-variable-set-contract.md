# Contract: Optional AWS Variable Set

## Inputs

- Root `aws` object includes:
  - `enabled` (optional bool, default `true`)
  - existing AWS variable set fields

## Behavioral Contract

1. When `aws.enabled` is `true` or omitted, AWS credentials variable set is created.
2. When `aws.enabled` is `false`, AWS credentials variable set is not created.
3. Existing state for prior non-indexed module address must be migrated using root `moved {}` blocks.
4. Migration must not recreate AWS variable set when toggling to count-based addressing with default enabled.

## Backward Compatibility

- Existing callers that do not set `aws.enabled` retain current behavior.
- Non-AWS variable set behavior remains unchanged.
