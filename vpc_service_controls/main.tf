module "vpc_perimeter" {
  source              = "./modules"
  for_each            = var.vpc_perimeter_details
  org_id              = each.value.org_id
  policy_name         = each.value.policy_name
  perimeter_name      = each.value.perimeter_name
  description         = each.value.description
  resources           = each.value.resources
  restricted_services = each.value.restricted_services
  ingress_policies    = each.value.ingress_policies
  egress_policies     = each.value.egress_policies
}