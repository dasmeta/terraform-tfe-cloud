# Quickstart: Workspace Settings Migration

## Goal

Migrate workspace execution behavior and agent-pool affinity management to supported settings resources while preserving current behavior.

## Steps

1. Capture baseline behavior for target workspace(s) before migration (effective execution mode and affinity).
2. Apply configuration using migrated settings controls.
3. Validate effective execution behavior and agent-pool affinity after apply.
4. Compare post-migration behavior against baseline; differences should be only explicitly requested changes.
5. Remove or unset execution-mode input in a controlled scenario and verify explicit migration rule behavior.
6. Re-apply unchanged configuration and confirm no unexpected updates.

## Verification Checklist

- Deprecated direct workspace execution/affinity controls are no longer relied upon.
- Workspace-level and organization-default precedence behaves as documented.
- Unset execution mode does not silently drift into unmanaged unexpected state.
- Idempotency holds for unchanged input.
