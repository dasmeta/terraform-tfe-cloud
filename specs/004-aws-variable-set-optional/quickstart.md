# Quickstart: Optional AWS Variable Set

## Goal

Make AWS credentials variable set creation configurable while preserving default enabled behavior and safe state migration.

## Usage

### Default behavior (enabled)

Do not set `aws.enabled` (or set it to `true`).

### Disable AWS variable set

Set:

```hcl
aws = {
  enabled = false
}
```

## Migration Safety

1. Ensure root `moved.tf` includes move from `module.aws_credentials_variable_set` to `module.aws_credentials_variable_set[0]`.
2. Run plan and confirm no destroy/recreate for AWS variable set in default-enabled path.
3. Apply and re-apply to confirm idempotency.
