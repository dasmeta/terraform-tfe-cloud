# Workspace Module Shared Renderer Integration Plan

- inspect current workspace-module local rendering versus shared renderer
- switch generic rendering to `terraform-renderer-generic`
- preserve TFC-specific resources and linked-output behavior in the wrapper
- update tests only where the expected generated content changes
- rerun workspace validation examples/tests
