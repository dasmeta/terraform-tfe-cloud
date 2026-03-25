variable "tfc_organization" {
  type        = string
  description = "Terraform Cloud organization name."
}

variable "name" {
  type        = string
  description = "Stable identity for the Terraform Cloud agent pool/token/agent-deployment and Kubernetes agent deployment."
  default     = "tfc-agent"
}

variable "replicas" {
  type        = number
  description = "Kubernetes deployment replica count (`replicaCount`)."
  default     = 1
}

variable "helm" {
  description = "Helm configuration for agent deployment (chart/image/pod resources + Helm install settings)."
  type = object({
    namespace        = optional(string, "meta-system")
    create_namespace = optional(bool, true)
    atomic           = optional(bool, true)
    wait             = optional(bool, true)

    # dasmeta/base chart source.
    chart_repository = optional(string, "https://dasmeta.github.io/helm")
    chart_name       = optional(string, "base")
    chart_version    = optional(string, "0.3.24")

    # Image settings for the Terraform Cloud agent container. By default we use custom image where we have aws cli installed.
    image_repository = optional(string, "public.ecr.aws/r0j4a4t3/dasmeta-general")
    image_tag        = optional(string, "tfc-agent-aws-cli-1")

    # Sets TFC_AGENT_AUTO_UPDATE. Typical values: minor, patch, disabled.
    auto_update = optional(string, "disabled")

    # Kubernetes resources for the agent pods. Defaults to requests/limits = 500m/512Mi.
    resources = optional(object({
      requests = optional(object({
        cpu    = optional(string, "500m")
        memory = optional(string, "512Mi")
      }), {})

      limits = optional(object({
        cpu    = optional(string, "500m")
        memory = optional(string, "512Mi")
      }), {})
    }), {})
  })

  default = {}
}

variable "extra_config" {
  description = "Additional Helm chart values appended at the end of the `helm_release.values` list."
  type        = any
  default     = null
}
