service_accounts = {
  "mytest" = {
    account_id   = "mytestt"
    display_name = "My Test"
    description  = "created by terraform"
    project_id   = "united-lane-354904"
    roles        = ["roles/bigquery.user", "roles/container.admin"]
  },
  "mydemo" = {
    account_id   = "mydemo"
    display_name = "My Demo"
    description  = "created by terraform"
    project_id   = "united-lane-354904"
    roles        = ["roles/bigquery.user", "roles/container.admin"]
  }
}
