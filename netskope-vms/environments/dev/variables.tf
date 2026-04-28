variable "vms" {
  description = "List of GCE VM configurations"
  type = list(object({
    instance_name    = string
    gce_machine_type = string
    gce_zone         = string
    gce_labels       = map(string)
    gce_tags         = list(string)
    project_id       = string

    image     = string
    disk_size = number

    subnetwork         = string
    subnetwork_project = optional(string, null)
    ip_address         = optional(string, "")

    additional_subnetwork         = string
    additional_subnetwork_project = optional(string, null)
    additional_ip_address         = optional(string, "")

    service_account = string
  }))
}
