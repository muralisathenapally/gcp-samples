notification_channels = {
  "psyched-circuit-405312" = ["projects/psyched-circuit-405312/notificationChannels/15836166878221809443"]
  "project-vm-312320"      = ["projects/project-vm-312320/notificationChannels/4003887468376990216"]
}

alert_policies = [
  {
    policy_name    = "vm-creation-alert"
    condition_name = "VM Instance Created"
    filter         = "protoPayload.methodName=\"beta.compute.instances.insert\" OR protoPayload.methodName=\"compute.instances.insert\" OR protoPayload.methodName=\"v1.compute.instances.insert\""

  },
  {
    policy_name    = "vpc-creation-alert"
    condition_name = "VPC/Subnets Created"
    filter         = "protoPayload.methodName=\"beta.compute.networks.insert\" OR protoPayload.methodName=\"compute.networks.insert\" OR protoPayload.methodName=\"v1.compute.networks.insert\""
  },
  {
    policy_name    = "firewall-creation-alert"
    condition_name = "Firewall Rule Created"
    filter         = "protoPayload.methodName=\"beta.compute.firewalls.insert\" OR protoPayload.methodName=\"compute.firewalls.insert\" OR protoPayload.methodName=\"v1.compute.firewalls.insert\""
  }
]
