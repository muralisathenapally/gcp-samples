locals {
  groups = { for group in var.groups : group.group_id => group }
}

resource "google_cloud_identity_group" "group" {
  for_each = local.groups
  group_key {
    id = each.key
  }
  parent       = var.parent
  display_name = lookup(each.value, "display_name", null)
  description  = lookup(each.value, "description", null)
  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
  }
}