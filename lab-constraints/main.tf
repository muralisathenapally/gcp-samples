resource "google_folder_organization_policy" "deny_public_ip" {
  folder     = var.folder_id
  constraint = "constraints/compute.vmExternalIpAccess"

  list_policy {
    deny {
      all = true
    }
  }
}


resource "google_folder_organization_policy" "disable_default_network" {
  folder     = var.folder_id
  constraint = "constraints/compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = true
  }
}