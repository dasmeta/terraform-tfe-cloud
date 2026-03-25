# terraform-tfe-cloud/agent

This sub-module provisions exactly one Terraform Cloud agent pool + one Terraform Cloud agent token (via the `tfe` provider), and deploys Terraform Cloud agents into Kubernetes using the shared `dasmeta/base` Helm chart.

The generated token is stored in a Kubernetes Secret and then linked into the deployment via base chart secret wiring (instead of inline Helm values).

Agent scaling is controlled by `replicas`:
- `replicas` maps to the chart `replicaCount`

Pod resources for the agent pods are configured under:
- `helm.resources.requests` (default `cpu=500m`, `memory=512Mi`)
- `helm.resources.limits` (default `cpu=500m`, `memory=512Mi`)

## Usage

### Minimal Example

```hcl
module "this" {
  source = "dasmeta/cloud/tfe//modules/agent"
  # version = "x.y.z" # make sure you set some exact version to not have auto-upgrade and issues in future, check for latest version in registry

  tfc_organization = "your-tfc-org"
}
```

## Inputs (high level)

- `tfc_organization`: Terraform Cloud organization used by `tfe_agent_pool` / `tfe_agent_token`.
- `name` (required): stable identity used for pool/token + `TFC_AGENT_NAME`
- `replicas` (optional): deployment replica count (`replicaCount`, default `1`)
- `helm` (optional):
  - image settings: `image_repository`, `image_tag`
  - `auto_update`: sets `TFC_AGENT_AUTO_UPDATE` (`minor`, `patch`, or `disabled`; default `disabled`)
  - pod resources: `resources.requests/limits`
  - Helm install settings: `namespace`, `release_name`, `atomic`, `wait`, `chart_*`
- `extra_config` (optional): Additional Helm chart values appended at the end of the module-generated `values` list
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.40 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.38.0 |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.74.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.agent](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.agent_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_secret_v1.agent_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [tfe_agent_pool.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/agent_pool) | resource |
| [tfe_agent_token.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/agent_token) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_extra_config"></a> [extra\_config](#input\_extra\_config) | Additional Helm chart values appended at the end of the `helm_release.values` list. | `any` | `null` | no |
| <a name="input_helm"></a> [helm](#input\_helm) | Helm configuration for agent deployment (chart/image/pod resources + Helm install settings). | <pre>object({<br/>    namespace        = optional(string, "meta-system")<br/>    create_namespace = optional(bool, true)<br/>    atomic           = optional(bool, true)<br/>    wait             = optional(bool, true)<br/><br/>    # dasmeta/base chart source.<br/>    chart_repository = optional(string, "https://dasmeta.github.io/helm")<br/>    chart_name       = optional(string, "base")<br/>    chart_version    = optional(string, "0.3.24")<br/><br/>    # Image settings for the Terraform Cloud agent container. By default we use custom image where we have aws cli installed.<br/>    image_repository = optional(string, "public.ecr.aws/r0j4a4t3/dasmeta-general")<br/>    image_tag        = optional(string, "tfc-agent-aws-cli-1")<br/><br/>    # Sets TFC_AGENT_AUTO_UPDATE. Typical values: minor, patch, disabled.<br/>    auto_update = optional(string, "disabled")<br/><br/>    # Kubernetes resources for the agent pods. Defaults to requests/limits = 500m/512Mi.<br/>    resources = optional(object({<br/>      requests = optional(object({<br/>        cpu    = optional(string, "500m")<br/>        memory = optional(string, "512Mi")<br/>      }), {})<br/><br/>      limits = optional(object({<br/>        cpu    = optional(string, "500m")<br/>        memory = optional(string, "512Mi")<br/>      }), {})<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Stable identity for the Terraform Cloud agent pool/token/agent-deployment and Kubernetes agent deployment. | `string` | `"tfc-agent"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Kubernetes deployment replica count (`replicaCount`). | `number` | `1` | no |
| <a name="input_tfc_organization"></a> [tfc\_organization](#input\_tfc\_organization) | Terraform Cloud organization name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agent_namespace"></a> [agent\_namespace](#output\_agent\_namespace) | Kubernetes namespace where the Helm release is installed. |
| <a name="output_agent_release_name"></a> [agent\_release\_name](#output\_agent\_release\_name) | Helm release name for the Kubernetes agent deployment. |
| <a name="output_tfc_agent_pool_id"></a> [tfc\_agent\_pool\_id](#output\_tfc\_agent\_pool\_id) | Terraform Cloud agent pool ID created for the configured agent. |
| <a name="output_tfc_agent_pool_name"></a> [tfc\_agent\_pool\_name](#output\_tfc\_agent\_pool\_name) | Terraform Cloud agent pool name created for the configured agent. |
| <a name="output_tfc_agent_token_id"></a> [tfc\_agent\_token\_id](#output\_tfc\_agent\_token\_id) | Terraform Cloud agent token resource ID (token value is not output). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
