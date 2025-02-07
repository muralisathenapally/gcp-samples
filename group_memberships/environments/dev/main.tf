module "groups_members" {
  for_each = var.group_memberships
  source   = "../../module/"
  group_id = each.key
  members  = each.value.members
}
