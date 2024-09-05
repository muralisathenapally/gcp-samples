variable "alert_policies" {
  description = "Common set of alert policies to be applied to all projects"
  type = list(object({
    policy_name    = string
    condition_name = string
    filter         = string
  }))
}

variable "notification_channels" {
  description = "Map of project IDs to lists of notification channels"
  type        = map(list(string))
}