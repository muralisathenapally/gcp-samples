module "vpc_perimeter" {
  source              = "./modules"
  org_id              = var.org_id
  policy_name         = var.policy_name
  perimeter_name      = var.perimeter_name
  description         = var.description
  resources           = var.resources
  restricted_services = var.restricted_services
  ingress_policies    = var.ingress_policies
  egress_policies     = var.egress_policies

  access_level_name = var.access_level_name
  members           = var.access_level_members
  regions           = var.access_level_regions
  ip_subnetworks    = var.access_level_ip_subnetworks

  folder_id = var.folder_id
}
