locals {
  groups = { for group in var.groups : group.email => group }
}

resource "googleworkspace_group" "group" {
  for_each    = local.groups
  email       = each.key
  name        = lookup(each.value, "name", null)
  description = lookup(each.value, "description", null)
}