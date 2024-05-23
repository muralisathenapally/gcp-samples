locals {
  iam_bindings = flatten([
    for role in var.roles : [
      for member in var.members : {
        role   = role
        member = member
      }
    ]
  ])
}

resource "google_organization_iam_member" "org_members_with_roles" {
  for_each = var.target_level == "org" ? { for binding in local.iam_bindings : "${binding.role}-${binding.member}" => binding } : {}
  org_id   = var.target_id
  role     = each.value.role
  member   = each.value.member

  condition {
    title       = var.condition.title
    description = var.condition.description
    expression  = var.condition.expression
  }
}

resource "google_project_iam_member" "prj_members_with_roles" {
  for_each = var.target_level == "project" ? { for binding in local.iam_bindings : "${binding.role}-${binding.member}" => binding } : {}
  project  = var.target_id
  role     = each.value.role
  member   = each.value.member

  condition {
    title       = var.condition.title
    description = var.condition.description
    expression  = var.condition.expression
  }
}