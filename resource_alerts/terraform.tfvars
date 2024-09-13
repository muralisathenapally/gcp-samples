notification_channels = {
  "psyched-circuit-405312" = ["projects/psyched-circuit-405312/notificationChannels/15836166878221809443"]
  "project-vm-312320"      = ["projects/project-vm-312320/notificationChannels/4003887468376990216"]
}

alert_policies = [
  {
    policy_name    = "bq-dataset-creation-alert"
    condition_name = "bigquery dataset is Created"
    filter         = "protoPayload.methodName=~\"google.cloud.bigquery.*.DatasetService.InsertDataset\""
  },
  {
    policy_name    = "bq-table-creation-alert"
    condition_name = "bigquery table is Created"
    filter         = "protoPayload.methodName=~\"tableservice.insert\""  
  },
  {
    policy_name    = "gke-cluster-creation-alert"
    condition_name = "gke cluster is Created"
    filter         = "protoPayload.methodName=~\"google.container.*.ClusterManager.CreateCluster\"" 
  },
  {
    policy_name    = "gke-nodepool-creation-alert"
    condition_name = "gke nodepool is Created"
    filter         = "protoPayload.methodName=~\"google.container.*.ClusterManager.CreateNodePool\"" 
  },
  {
    policy_name    = "bigtable-instance-creation-alert"
    condition_name = "bigtable instance is Created"
    filter         = "protoPayload.methodName=~\"google.bigtable.admin.*.BigtableInstanceAdmin.CreateInstance\"" 
  }
]
