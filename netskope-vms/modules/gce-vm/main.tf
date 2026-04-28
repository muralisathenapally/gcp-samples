resource "google_compute_instance" "gce-vm" {

  name         = var.instance_name
  machine_type = var.gce_machine_type
  zone         = var.gce_zone
  labels       = var.gce_labels
  tags         = var.gce_tags
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = var.image
      type  = "pd-ssd"
      size  = var.disk_size
    }
  }

  # Primary network interface
  network_interface {
    subnetwork         = var.subnetwork
    subnetwork_project = coalesce(var.subnetwork_project, var.project_id)
    network_ip         = var.ip_address
  }

  # Additional network interface
  network_interface {
    subnetwork         = var.additional_subnetwork
    subnetwork_project = coalesce(var.additional_subnetwork_project, var.project_id)
    network_ip         = var.additional_ip_address != "" ? var.additional_ip_address : null

  }

  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true
}
