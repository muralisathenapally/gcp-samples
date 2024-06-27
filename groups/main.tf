module "groups" {
  source = "./modules"
  parent = "customers/example.com"
  groups = [
    {
      group_id     = "example_group@example.com"
      display_name = "Example Group"
      description  = "This is an example group."
    },
    {
      group_id     = "test_group@example.com"
      display_name = "test Group"
      description  = "This is an test group."
    }
  ]
}