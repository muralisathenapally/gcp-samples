module "block-ssh-rdp-http" {
  source = "../../modules/"

  for_each      = var.firewall_details
  project       = each.value.project
  firewall_name = each.value.firewall_name
  ports = each.value.ports_to_block
  network       = each.value.network
}