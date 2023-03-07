vpc_perimeter_details = {
  "perimeter_1" = {
    org_id              = "organizations/123456789"
    policy_name         = "storage_perimeter_1_policy"
    perimeter_name      = "storage_perimeter_1"
    description         = "storage vpc perimeter"
    resources           = ["united-lane-354904"]
    restricted_services = ["storage.googleapis.com"]
    ingress_policies    = []
    egress_policies     = []    
    folder_id           = "give folder id"
  },
  "perimeter_2" = {
    org_id              = "organizations/123456789"
    policy_name         = "bq_perimeter_1_policy"
    perimeter_name      = "bq_perimeter_1"
    description         = "bigquery vpc perimeter"
    resources           = ["united-lane-354904"]
    restricted_services = ["bigquery.googleapis.com"]
    ingress_policies    = []
    egress_policies     = []
    folder_id           = "give folder id"
  }
}

