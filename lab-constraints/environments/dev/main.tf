module "constraints" {
  source                                         = "../../module/"
  for_each                                       = toset(var.target_ids)
  target_id                                      = each.value
  target_level                                   = var.target_level
  exclude_projects_block_vm_external_ip          = var.exclude_projects_block_vm_external_ip
  exclude_projects_skip_default_network_creation = var.exclude_projects_skip_default_network_creation
}