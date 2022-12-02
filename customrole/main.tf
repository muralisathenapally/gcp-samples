module "customrole" {
  source = "./custom_iam_role"

  role_id      = var.role_id
  title        = var.title
  permissions  = var.permissions
  description  = var.description
  target_id    = var.target_id
  target_level = var.target_level
}