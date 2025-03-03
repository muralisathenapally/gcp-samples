resource "google_iam_deny_policy" "deny_all_except_exceptions" {
  name   = "deny-resource-deletion"
  parent = urlencode("cloudresourcemanager.googleapis.com/organizations/${var.org_id}")

  rules {
    deny_rule {
      denied_principals = [
        "principalSet://goog/public:all"
      ]

      exception_principals = var.exception_principals

      denied_permissions = [
        "compute.googleapis.com/instances.delete",
        "compute.googleapis.com/disks.delete",
        "container.googleapis.com/clusters.delete",
        "iam.googleapis.com/*.delete"
      ]

      denial_condition {
        expression  = "resource.matchTag('${var.org_id}/Environment', 'Dev')"
        title       = "Deny All Except Excluded in Dev Environment"
        description = "Blocks all access unless explicitly excluded when the Environment tag is 'Dev'."
      }
    }
  }
}
