notification_channels = {
  "psyched-circuit-405312" = ["projects/psyched-circuit-405312/notificationChannels/15836166878221809443"]
  "project-vm-312320"      = ["projects/project-vm-312320/notificationChannels/4003887468376990216"]
}

alert_policies = [
  {
    policy_name    = "vm-activity-alert"
    condition_name = "VM Instance Created or Deleted or Stopped"
    filter         = "protoPayload.methodName=\"beta.compute.instances.insert\" OR protoPayload.methodName=\"compute.instances.insert\" OR protoPayload.methodName=\"v1.compute.instances.insert\" OR protoPayload.methodName=\"beta.compute.instances.delete\" OR protoPayload.methodName=\"compute.instances.delete\" OR protoPayload.methodName=\"v1.compute.instances.delete\" OR protoPayload.methodName=\"beta.compute.instances.stop\" OR protoPayload.methodName=\"compute.instances.stop\" OR protoPayload.methodName=\"v1.compute.instances.stop\""

  },
  {
    policy_name    = "vpc-activity-alert"
    condition_name = "VPC/Subnets Created or Deleted"
    filter         = "protoPayload.methodName=\"beta.compute.networks.insert\" OR protoPayload.methodName=\"compute.networks.insert\" OR protoPayload.methodName=\"v1.compute.networks.insert\" OR protoPayload.methodName=\"beta.compute.networks.delete\" OR protoPayload.methodName=\"compute.networks.delete\" OR protoPayload.methodName=\"v1.compute.networks.delete\" OR protoPayload.methodName=\"beta.compute.subnetworks.insert\" OR protoPayload.methodName=\"compute.subnetworks.insert\" OR protoPayload.methodName=\"v1.compute.subnetworks.insert\" OR protoPayload.methodName=\"beta.compute.subnetworks.delete\" OR protoPayload.methodName=\"compute.subnetworks.delete\" OR protoPayload.methodName=\"v1.compute.subnetworks.delete\""
  },
  {
    policy_name    = "firewall-activity-alert"
    condition_name = "Firewall Rule Created or Deleted"
    filter         = "protoPayload.methodName=\"beta.compute.firewalls.insert\" OR protoPayload.methodName=\"compute.firewalls.insert\" OR protoPayload.methodName=\"v1.compute.firewalls.insert\" OR protoPayload.methodName=\"beta.compute.firewalls.delete\" OR protoPayload.methodName=\"compute.firewalls.delete\" OR protoPayload.methodName=\"v1.compute.firewalls.delete\""
  }
]