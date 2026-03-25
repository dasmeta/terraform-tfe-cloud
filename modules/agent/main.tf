resource "tfe_agent_pool" "this" {
  name         = var.name
  organization = var.tfc_organization
}

resource "tfe_agent_token" "this" {
  agent_pool_id = tfe_agent_pool.this.id
  description   = local.agent_token_description
}

resource "kubernetes_manifest" "agent_namespace" {
  count = var.helm.create_namespace ? 1 : 0

  manifest = {
    apiVersion = "v1"
    kind       = "Namespace"
    metadata = {
      name = var.helm.namespace
    }
  }
}

resource "kubernetes_secret_v1" "agent_token" {
  metadata {
    name      = local.agent_token_secret_name
    namespace = var.helm.namespace
  }

  data = {
    (local.agent_token_secret_key) = tfe_agent_token.this.token
  }

  type = "Opaque"

  depends_on = [kubernetes_manifest.agent_namespace]
}

resource "helm_release" "agent" {
  name       = var.name
  repository = var.helm.chart_repository
  chart      = var.helm.chart_name
  version    = var.helm.chart_version

  namespace        = var.helm.namespace
  create_namespace = var.helm.create_namespace

  atomic = var.helm.atomic
  wait   = var.helm.wait

  # Optional: append extra Helm values after module-generated values.
  # Helm merges values in order; later entries can override earlier keys.
  values = compact([
    yamlencode({
      replicaCount = var.replicas
      resources    = var.helm.resources

      image = {
        repository = var.helm.image_repository
        tag        = var.helm.image_tag
      }

      # Avoid exposing the agent behind a Service by default.
      service = {
        enabled = false
      }

      # base chart expects env vars in `config` (map).
      config = {
        TFC_AGENT_NAME        = var.name
        TFC_AGENT_AUTO_UPDATE = var.helm.auto_update
      }

      # Read agent token from Kubernetes Secret rather than inline values.
      secrets = [
        {
          TFC_AGENT_TOKEN = {
            from = kubernetes_secret_v1.agent_token.metadata[0].name
            key  = local.agent_token_secret_key
          }
        }
      ]
    }),
    var.extra_config == null ? null : yamlencode(var.extra_config)
  ])

  depends_on = [kubernetes_secret_v1.agent_token]
}
