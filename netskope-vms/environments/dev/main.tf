module "gce_vms" {
  source   = "../../modules/gce-vm"
  for_each = { for vm in var.vms : vm.instance_name => vm }

  # Instance
  instance_name    = each.value.instance_name
  gce_machine_type = each.value.gce_machine_type
  gce_zone         = each.value.gce_zone
  gce_labels       = each.value.gce_labels
  gce_tags         = each.value.gce_tags
  project_id       = each.value.project_id

  # Boot disk
  image     = each.value.image
  disk_size = each.value.disk_size

  # Primary network interface
  subnetwork         = each.value.subnetwork
  subnetwork_project = each.value.subnetwork_project
  ip_address         = each.value.ip_address

  # Additional network interface
  additional_subnetwork         = each.value.additional_subnetwork
  additional_subnetwork_project = each.value.additional_subnetwork_project
  additional_ip_address         = each.value.additional_ip_address

  # Service account
  service_account = each.value.service_account
}
