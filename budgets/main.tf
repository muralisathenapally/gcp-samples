data "google_project" "project" {
  for_each = { for project in var.projects : project.project_id => project }

  project_id = each.key
}

resource "google_billing_budget" "budget" {
  for_each = { for project in var.projects : project.project_id => project }

  billing_account = data.google_billing_account.account.id
  display_name    = each.value.budget_display_name

  budget_filter {
    projects               = ["projects/${data.google_project.project[each.key].number}"]
    credit_types_treatment = each.value.credit_types_treatment
  }

  amount {
    last_period_amount = true
  }

  dynamic "threshold_rules" {
    for_each = each.value.threshold_percentages
    content {
      threshold_percent = threshold_rules.value
      spend_basis       = "CURRENT_SPEND"
    }
  }

  all_updates_rule {
    monitoring_notification_channels = [
      google_monitoring_notification_channel.notification_channel.id,
    ]
    disable_default_iam_recipients = true
  }
}





