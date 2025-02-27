resource "google_iam_deny_policy" "deny_all_except_exceptions" {
  name   = "deny_resource_deletion"
  parent = urlencode("cloudresourcemanager.googleapis.com/organizations/${var.org_id}")

  rule {
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
        expression  = "resource.matchTag('organization/Environment', 'Prod') || resource.matchTag('organization/Environment', 'Stage')"
        title       = "Deny All Except Excluded in Prod and Stage Environments"
        description = "Blocks all access unless explicitly excluded when the Environment tag is 'Prod' or 'Stage'."
      }
    }
  }
}
