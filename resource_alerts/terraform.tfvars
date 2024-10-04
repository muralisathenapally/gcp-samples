notification_channels = {
  "psyched-circuit-405312" = ["projects/psyched-circuit-405312/notificationChannels/15836166878221809443"]
  "project-vm-312320"      = ["projects/project-vm-312320/notificationChannels/4003887468376990216"]
}

alert_policies = [
  {
    policy_name    = "network-error-alert"
    condition_name = "Network Error"
    filter         = "jsonPayload.message=~\"Unavailable desc = error reading from server\""
  }
]
