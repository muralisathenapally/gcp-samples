provider "googleworkspace" {
  customer_id = "A01b123xz"
  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.group",
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/apps.groups.settings",
    "https://www.googleapis.com/auth/admin.directory.group.readonly"
  ]
}

resource "googleworkspace_group" "group" {
  email       = "example@example.com"
  name        = "example"
  description = "example Group"
}
