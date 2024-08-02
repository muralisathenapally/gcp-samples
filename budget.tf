################################################################

resource "google_billing_budget" "budget" {
  billing_account = data.google_billing_account.account.id
  display_name    = "MyBudget"

  budget_filter {
    projects               = []
    credit_types_treatment = "EXCLUDE_ALL_CREDITS"
  }

  amount {
    last_period_amount = true
  }

  threshold_rules {
    threshold_percent = 0.7
    spend_basis       = "CURRENT_SPEND"
  }
  threshold_rules {
    threshold_percent = 0.8
    spend_basis       = "CURRENT_SPEND"
  }
  threshold_rules {
    threshold_percent = 0.9
    spend_basis       = "CURRENT_SPEND"
  }
  all_updates_rule {
    monitoring_notification_channels = [
      google_monitoring_notification_channel.notification_channel.id,
    ]
    disable_default_iam_recipients = true
  }
}
