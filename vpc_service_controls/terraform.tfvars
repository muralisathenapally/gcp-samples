    org_id              = "organizations/123456789"
    policy_name         = "storage_perimeter_1_policy"
    perimeter_name      = "storage_perimeter_1"
    description         = "storage vpc perimeter"
    resources           = ["united-lane-354904"]
    restricted_services = ["storage.googleapis.com"]
    ingress_policies    = [{
      "from" = {
        "sources" = {
          "resources" = [
            "projects/GIVE_PROTECTED_PROJECT_NUMBER"
          ],
        },
        "identity_type" = ""
        "identities"    = ["GIVE_TEST_VM_SERVICE_ACCOUNT"]
      }
      "to" = {
        "resources" = [
            "projects/GIVE_OTHER_PROJECT_NUMBER"
          ],
        "operations" = {
          "storage.googleapis.com" = {
            "methods" = [
              "*"
            ]
          }
        }
      }
    }]
    egress_policies     = [{
    "from" = {
     "identity_type" = ""
     "identities"    = ["GIVE_CLOUD_STORAGE_SERVICE_ACCOUNT"]
   },
    "to" = {
     "resources" = [
            "projects/GIVE_OTHER_PROJECT_NUMBER"
          ],
     "operations" = {
       "storage.googleapis.com" = {
         "methods" = [
           "*"
         ]
       }
     }
   }
 }]    
    folder_id           = 2341245346
