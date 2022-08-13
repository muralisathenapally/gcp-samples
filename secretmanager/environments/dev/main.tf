module "secret_manager" {
  source   = "../../modules/secret_manager"
  for_each = var.secret_details

  project_id       = each.value.project_id
  secret_id        = each.value.secret_id
  accessors        = each.value.secret_accessors
  replication      = each.value.replication
  rotation_details = each.value.rotation_details
}
