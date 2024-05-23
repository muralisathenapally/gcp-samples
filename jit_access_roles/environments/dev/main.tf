module "block-ssh-rdp-http" {
  source = "../../modules/"

  target_id    = var.target_id
  target_level = var.target_level
  members      = var.members
  roles        = var.roles
  condition    = var.condition
}