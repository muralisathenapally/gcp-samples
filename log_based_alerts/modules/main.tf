resource "google_monitoring_alert_policy" "workflows" {
  display_name = var.policy_name
  project = var.project_id
  combiner     = "OR"
  conditions {
    display_name = var.condition_name
    condition_matched_log {
      filter = var.filter
    }
  }

  notification_channels = var.notification_channels
  alert_strategy {
    notification_rate_limit {
      period = var.notification_period
    }
  }
}