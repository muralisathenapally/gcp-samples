resource "google_cloud_identity_group_membership" "members" {
  for_each = toset(var.members)
  provider = google-beta
  group    = var.group_id

  preferred_member_key { id = each.key }
  roles { name = "MEMBER" }
}