# Data Model: Optional AWS Variable Set

## Entities

- **AWS Config Input**
  - Root input object under `aws`.
  - Fields:
    - `enabled` (bool, default `true`)
    - `variable_set_name` (string, optional)
    - credential/value fields (existing)

- **AWS Credentials Variable Set Module Instance**
  - Optional module instance created when `aws.enabled = true`.
  - Addressing model:
    - Pre-change: `module.aws_credentials_variable_set`
    - Post-change with count: `module.aws_credentials_variable_set[0]`

- **State Move Mapping**
  - Root-level mapping in `moved.tf` from old to new addresses.
  - Purpose: preserve state continuity and avoid recreation.

## Validation / Rules

- If `aws.enabled` is omitted, effective value is `true`.
- If `aws.enabled = false`, AWS variable set module is not instantiated.
- Existing state must migrate via `moved {}` blocks when count-based indexing is introduced.
- Non-AWS variable set modules/resources remain unaffected.
