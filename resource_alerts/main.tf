locals {
  project_policies = flatten([
    for project_id, channels in var.notification_channels : [
      for policy in var.alert_policies : {
        policy_name           = policy.policy_name
        condition_name        = policy.condition_name
        filter                = policy.filter
        project_id            = project_id
        notification_channels = channels
        key                   = "${project_id}-${policy.condition_name}"
      }
    ]
  ])
}

resource "google_monitoring_alert_policy" "workflows" {
  for_each = { for policy in local.project_policies : policy.key => policy }

  project = each.value.project_id

  conditions {
    display_name = each.value.condition_name
    condition_matched_log {
      filter = each.value.filter
    }
  }

  display_name          = each.value.policy_name
  combiner              = "OR"
  notification_channels = each.value.notification_channels
  alert_strategy {
    notification_rate_limit {
      period = "300s"
    }
  }
}