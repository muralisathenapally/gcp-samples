resource "google_iam_deny_policy" "default" {
  parent       = urlencode("cloudresourcemanager.googleapis.com/organizations/ADD_ORG_ID")
  name         = "deny-sa-create-delete"
  display_name = "Block SA Create and Delete"
  rules {
    deny_rule {
      denied_principals = ["principalSet://goog/public:all"]
      denied_permissions = [
        "iam.googleapis.com/serviceAccounts.create",
        "iam.googleapis.com/serviceAccounts.delete"
      ]
      exception_principals = [
        "principal://iam.googleapis.com/projects/-/serviceAccounts/ADD_SA_EMAIL"
      ]
    }
  }
}