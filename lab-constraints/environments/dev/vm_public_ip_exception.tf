resource "google_project_organization_policy" "prj_allow_public_ip" {
  for_each   = var.allowed_external_ip_vms
  project    = each.key
  constraint = "constraints/compute.vmExternalIpAccess"

  list_policy {
    allow {
      values = each.value.vm_list
    }
  }
}