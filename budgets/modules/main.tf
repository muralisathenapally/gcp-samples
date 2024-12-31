resource "google_project_service" "cloudbilling" {
  project = var.project_id
  service = "cloudbilling.googleapis.com"
}

resource "google_project_service" "billingbudgets" {
  project = var.project_id
  service = "billingbudgets.googleapis.com"
}

data "google_project" "project" {
  project_id = var.project_id
}

#Notification Channels#
resource "google_monitoring_notification_channel" "notification_channels" {
  project  = var.project_id
  for_each = toset(var.notification_channel_emails)

  type         = "email"
  display_name = each.value
  labels = {
    email_address = each.value
  }
}

#Budget#
resource "google_billing_budget" "budget" {
  billing_account = var.billing_account_id
  display_name    = var.budget_display_name

  budget_filter {
    projects               = ["projects/${data.google_project.project.number}"]
    credit_types_treatment = var.credit_types_treatment
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = var.budget_amount
    }
  }

  dynamic "threshold_rules" {
    for_each = var.threshold_percentages
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
