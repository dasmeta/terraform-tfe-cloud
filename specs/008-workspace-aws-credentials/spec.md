# Optional shared AWS credentials per workspace

Workspace owners need to opt out of inherited AWS credentials when their workspace uses AWS federation. A top-level boolean `inherit_aws_credentials` defaults to true when omitted. Setting it to false excludes the module-managed AWS variable set while preserving explicitly selected variable sets. Workspace settings and rendering stay compatible.
