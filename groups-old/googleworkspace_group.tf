provider "googleworkspace" {
  customer_id = "A01b123xz"
  credentials = "service-account-key.json"
  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.group",
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/admin.directory.userschema",
    "https://www.googleapis.com/auth/apps.groups.settings",
    "https://www.googleapis.com/auth/iam"
  ]
}

resource "googleworkspace_group" "group" {
  email       = "example@example.com"
  name        = "example"
  description = "example Group"
}
