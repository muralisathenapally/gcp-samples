resource "google_access_context_manager_access_policy" "access-policy" {
  parent = var.org_id
  title  = "Scoped Access Policy"
  scopes = ["folders/${var.folder_id}"]
}

module "regular_service_perimeter_1" {
  source         = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  policy         = google_access_context_manager_access_policy.access-policy.id
  perimeter_name = var.perimeter_name
  description    = var.description
  resources      = var.resources

  restricted_services = var.restricted_services

  ingress_policies = var.ingress_policies
  egress_policies  = var.egress_policies
}
