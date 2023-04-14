module "service_account" {
  source       = "./modules/service_account"
  for_each     = var.service_accounts
  account_id   = each.value.account_id
  display_name = each.value.display_name
  description  = each.value.description
  project_id   = each.value.project_id
  roles        = each.value.roles
}
