provider "googleworkspace" {
  customer_id = "A01b123xz"
}

resource "googleworkspace_group" "group" {
  email       = "example@example.com"
  name        = "example"
  description = "example Group"
}
