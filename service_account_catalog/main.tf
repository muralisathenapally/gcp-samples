module "service_account" {
  source       = "./modules/service_account"
  account_id   = var.account_id
  display_name = var.display_name
  description  = var.description
  project_id      = var.project_id
  roles        = var.roles
  allowed_roles = var.allowed_roles
}