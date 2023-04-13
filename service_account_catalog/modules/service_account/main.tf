locals {
  allowed_roles_set = toset(var.allowed_roles)
}

resource "google_project_iam_member" "project" {
  for_each = { for r in var.roles : r => r if contains(local.allowed_roles_set, r) }
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.service_accounts.email}"
}

resource "google_service_account" "service_accounts" {
  account_id   = var.account_id
  display_name = var.display_name
  description  = var.description
  project      = var.project_id
}