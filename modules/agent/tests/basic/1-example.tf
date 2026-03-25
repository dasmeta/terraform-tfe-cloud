module "this" {
  source = "../../"

  tfc_organization = var.tfc_organization
}

/* Verification (manual):
   1) Apply this configuration.
   2) Confirm Terraform Cloud agent pool + token are created.
   3) Confirm Kubernetes pods are running (Helm release installed in the module namespace).
   4) Confirm the enrolled agents become available in Terraform Cloud.
*/
