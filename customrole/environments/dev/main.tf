module "customrole" {
  source = "../../modules/custom_iam_role"

  for_each     = var.custom_iam_role
  role_id      = each.value.role_id
  title        = each.value.title
  permissions  = each.value.permissions
  description  = each.value.description
  target_id    = each.value.target_id
  target_level = each.value.target_level
}