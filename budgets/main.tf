data "google_project" "project" {
  for_each = { for project in var.projects : project.project_id => project }

  project_id = each.value.project_id
}

resource "google_monitoring_notification_channel" "notification_channels" {
  project = var.project_id
  for_each = toset(var.notification_channel_emails)

  type         = "email"
  display_name = "Budget Alert Notification for ${each.value}"
  labels = {
    email_address = each.value
  }
}

resource "google_billing_budget" "budget" {
  for_each = { for project in var.projects : project.project_id => project }

  billing_account = each.value.billing_account_id
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
      for nc in google_monitoring_notification_channel.notification_channels : nc.id
    ]
    disable_default_iam_recipients = true
  }
}
