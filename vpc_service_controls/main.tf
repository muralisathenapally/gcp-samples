resource "google_access_context_manager_access_policy" "access-policy" {
  parent = var.org_id
  title  = var.policy_name
  scopes = ["folders/${var.folder_id}"]
}

module "access_level" {
  source         = "./modules/access_level"
  policy         = google_access_context_manager_access_policy.access-policy.id
  name           = var.access_level_name
  members           = var.access_level_members
  regions           = var.access_level_regions
  ip_subnetworks    = var.access_level_ip_subnetworks
}

module "vpc_perimeter" {
  source         = "./modules/vpc_perimeter"
  policy         = google_access_context_manager_access_policy.access-policy.id
  perimeter_name = var.perimeter_name
  description    = var.description
  resources      = var.resources

  restricted_services = var.restricted_services

  access_levels = [module.access_level.name]

  ingress_policies = var.ingress_policies
  egress_policies  = var.egress_policies
}
