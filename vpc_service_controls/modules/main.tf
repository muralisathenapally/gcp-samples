provider "google" {
}

module "org_policy" {
  source      = "terraform-google-modules/vpc-service-controls/google"
  parent_id   = var.org_id
  policy_name = var.policy_name
}

module "regular_service_perimeter_1" {
  source         = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  policy         = module.org_policy.policy_id
  perimeter_name = var.perimeter_name
  description    = var.description
  resources      = var.resources

  restricted_services = var.restricted_services

  ingress_policies = var.ingress_policies
  egress_policies  = var.egress_policies
}