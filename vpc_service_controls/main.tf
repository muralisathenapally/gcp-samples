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
  folder_id           = var.folder_id
}