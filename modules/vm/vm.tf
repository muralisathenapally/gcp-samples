resource "google_compute_instance" "default" {
  name         = "vm-${var.instance_name}"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    device_name = "boot"
    auto_delete = true
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
  }
}

