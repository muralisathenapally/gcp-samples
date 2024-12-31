module "secret_manager" {
  source   = "../../modules/secret_manager"
  for_each = { for secret in var.secrets : secret.secret_id => secret }

  project_id           = each.value.project_id
  secret_id            = each.value.secret_id
  accessors            = each.value.secret_accessors
  replication          = each.value.replication
  rotation_details     = each.value.rotation_details
  setup_secret_manager = each.value.setup_secret_manager
}
