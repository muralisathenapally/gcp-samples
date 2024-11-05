module "binary_auth" {
  for_each         = var.binary_autorization
  source           = "../../modules"
  project_id       = each.value.project_id
  attestor_name    = each.value.attestor_name
  allowed_patterns = each.value.allowed_patterns
}