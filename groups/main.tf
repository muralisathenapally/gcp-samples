resource "google_cloud_identity_group" "group" {
  group_key {
    id = "example_group@example.com"
  }
  parent = "your domain name"
  display_name = "Example Group"
  description  = "This is an example group."
}
