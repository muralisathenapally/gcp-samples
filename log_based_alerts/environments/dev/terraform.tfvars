alert_policies = {
    "vm-activity" = {
        project_id = "psyched-circuit-405312"
        policy_name = "vm-activity-alert"
        condition_name = "VM Instance Created or Deleted or Stopped"
        filter = "protoPayload.methodName=\"beta.compute.instances.insert\" OR protoPayload.methodName=\"compute.instances.insert\" OR protoPayload.methodName=\"v1.compute.instances.insert\" OR protoPayload.methodName=\"beta.compute.instances.delete\" OR protoPayload.methodName=\"compute.instances.delete\" OR protoPayload.methodName=\"v1.compute.instances.delete\" OR protoPayload.methodName=\"beta.compute.instances.stop\" OR protoPayload.methodName=\"compute.instances.stop\" OR protoPayload.methodName=\"v1.compute.instances.stop\""
        notification_channels = ["projects/psyched-circuit-405312/notificationChannels/15836166878221809443"]
        notification_period = "300s"
    },
    "vpc-activity" = {
        project_id = "psyched-circuit-405312"
        policy_name = "vpc-activity-alert"
        condition_name = "VPC/Subnets Created or Deleted"
        filter = "protoPayload.methodName=\"beta.compute.networks.insert\" OR protoPayload.methodName=\"compute.networks.insert\" OR protoPayload.methodName=\"v1.compute.networks.insert\" OR protoPayload.methodName=\"beta.compute.networks.delete\" OR protoPayload.methodName=\"compute.networks.delete\" OR protoPayload.methodName=\"v1.compute.networks.delete\" OR protoPayload.methodName=\"beta.compute.subnetworks.insert\" OR protoPayload.methodName=\"compute.subnetworks.insert\" OR protoPayload.methodName=\"v1.compute.subnetworks.insert\" OR protoPayload.methodName=\"beta.compute.subnetworks.delete\" OR protoPayload.methodName=\"compute.subnetworks.delete\" OR protoPayload.methodName=\"v1.compute.subnetworks.delete\""
        notification_channels = ["projects/psyched-circuit-405312/notificationChannels/15836166878221809443"]
        notification_period = "300s"
    },
    "firewall-activity" = {
        project_id = "psyched-circuit-405312"
        policy_name = "firewall-activity-alert"
        condition_name = "Firewall Rule Created or Deleted"
        filter = "protoPayload.methodName=\"beta.compute.firewalls.insert\" OR protoPayload.methodName=\"compute.firewalls.insert\" OR protoPayload.methodName=\"v1.compute.firewalls.insert\" OR protoPayload.methodName=\"beta.compute.firewalls.delete\" OR protoPayload.methodName=\"compute.firewalls.delete\" OR protoPayload.methodName=\"v1.compute.firewalls.delete\""
        notification_channels = ["projects/psyched-circuit-405312/notificationChannels/15836166878221809443"]
        notification_period = "300s"
    }
}