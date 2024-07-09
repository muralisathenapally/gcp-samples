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

module "gws_groups" {
  source = "./module/"
  groups = [
    {
      email       = "example_group@example.com"
      name        = "Example Group"
      description = "This is an example group."
    },
    {
      email       = "test_group@example.com"
      name        = "test Group"
      description = "This is an test group."
    }
  ]
}
