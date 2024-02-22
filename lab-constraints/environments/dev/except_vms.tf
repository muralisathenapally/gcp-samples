resource "google_project_organization_policy" "prj_deny_public_ip" {
  project    = "PROJECT_ID"
  constraint = "constraints/compute.vmExternalIpAccess"

  list_policy {
    allow {
      values = ["projects/PROJECT_ID/zones/ZONE/instances/INSTANCE"]
    }
  }
}